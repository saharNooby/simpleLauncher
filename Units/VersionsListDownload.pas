unit VersionsListDownload;

interface

uses
  TypeTMinecraftVersions;

function GetRemoteVersionsList: TMinecraftVersions;

implementation

uses
  SysUtils, Classes, Windows,
  SuperObject,
  UnitLauncherForm,
  LauncherStrings, LauncherPaths, LauncherURLs, Downloader, Logging, Exceptions,
  LauncherSettings, DownloadableVersions;

procedure EasyDl(const AURL, APath: String);
var
  Data: TDownloadData;
begin
  FillChar(Data, SizeOf(Data), #0);
  with Data do
  begin
    WndHandle := LauncherForm.Handle;
    URL := AURL;
    FileName := APath;
    Notify := False;
  end;
  Download(Data);
end;

procedure ShowError(const Msg: string; const E: Exception);
begin
  MessageBox(
    LauncherForm.Handle,
    PWideChar(Msg + #10#10 + 'Текст ошибки: ' + E.Message),
    PWideChar('Не удалось получить список...'),
    MB_ICONERROR + MB_OK
  );
end;

function GetOldList: ISuperObject;
begin
  try
    Result := TSuperObject.ParseFile(Paths.Versions + 'versions.json', False)
  except
    Result := nil;
  end;
end;

function GetVanillaList: ISuperObject;
var
  VanillaPath: String;
begin
  VanillaPath := Paths.Versions + 'versions.json';
  try
    EasyDl(URLs.VersionsList, VanillaPath);
    Result := TSuperObject.ParseFile(VanillaPath, False);
  except
    on E: Exception do
    begin
      Result := nil;
      LogE(E);
      Log('Can''t download or parse vanilla versions list.');
      if E is EDownloadError then
        ShowError(StrDlgListDownloadError, E)
      else
        ShowError(StrDlgListParsingError, E);
    end;
  end;
end;

function GetOptiFineList: ISuperObject;
var
  OptiFinePath: String;
begin
  OptiFinePath := Paths.Versions + 'optifineversions.json';
  try
    EasyDl(URLs.OptiFineVersionsList, OptiFinePath);
    Result := TSuperObject.ParseFile(OptiFinePath, False);
  except
    on E: Exception do
    begin
      Result := SO('{"optifine": {}}');
      LogE(E);
      Log('Can''t download or parse OptiFine versions list.');
    end;
  end;
end;

function GetLiteLoaderList: ISuperObject;
var
  LiteLoaderPath: String;
begin
  LiteLoaderPath := Paths.Versions + 'liteloaderversions.json';
  try
    EasyDl(URLs.LiteLoaderVersionsList, LiteLoaderPath);
    Result := TSuperObject.ParseFile(LiteLoaderPath, False).O['versions'];
  except
    on E: Exception do
    begin
      Result := SO();
      LogE(E);
      Log('Can''t download or parse LiteLoader versions list.');
    end;
  end;
end;

procedure ShowNews(Old, New: ISuperObject);
const
  NewRel = 'Релиз %s';
  NewSnap = 'Снапшот %s';
  MsgText = 'С момента последнего обновления списка версий вышли следующие ве' +
    'рсии:'#10#10'%s'#10#10'Можно загрузить эти версии, перейдя на вкладку "З' +
    'агрузка версий"';
  MsgCaption = 'Вышли новые версии!';
var
  MessageText, NewText, OldS, OldR, NewS, NewR: String;
begin
  if not Assigned(Old) then
  begin
    Log('There is not old versions list file.');
    Exit;
  end;

  with Settings.Profile do
    if not B['AutoRefreshRemoteVersionsList'] or B['RefreshButtonClicked'] then
      Exit;

  NewText := '';

  OldS := Old.O['latest'].S['snapshot'];
  OldR := Old.O['latest'].S['release'];

  NewS := New.O['latest'].S['snapshot'];
  NewR := New.O['latest'].S['release'];

  if (OldS <> NewS) and Settings.Profile.B['ShowNewSnapshots'] then
    NewText := Format(NewSnap, [NewS]);
  if (OldR <> NewR) and Settings.Profile.B['ShowNewReleases'] then
    if NewText <> '' then
      NewText := NewText + ', ' +  Format(NewRel, [NewR])
    else
      NewText := Format(NewRel, [NewR]);
  if NewText = '' then
  begin
    Log('No new versions found.');
    Exit;
  end;
  MessageText := Format(MsgText, [NewText]);
  MessageBox(
    LauncherForm.Handle,
    PWideChar(MessageText),
    PWideChar(MsgCaption),
    MB_ICONINFORMATION + MB_OK
  );
end;

function GetList: ISuperObject;
var
  Old, Vanilla: ISuperObject;
begin
  ForceDirectories(Paths.Versions);

  Old := GetOldList;
  Vanilla := GetVanillaList;

  if Assigned(Vanilla) then
  begin
    Vanilla.Merge(GetOptiFineList);
    Vanilla.O['liteloader'] := GetLiteLoaderList;

    ShowNews(Old, Vanilla);
  end;

  Result := Vanilla;
end;

procedure AddLastVersion(const ID: String; const L: TStringList);
const
  LastString = 'Последний (%s)';
begin
  L.AddObject(Format(LastString, [ID]), TVanillaVersion.Create(ID));
end;

function ParseList(List: ISuperObject): TMinecraftVersions;
var
  StringList: TStringList;
  Id: String;
  I: Integer;
begin
  Result := TMinecraftVersions.Create;
  try
    if Assigned(List.O['latest']) then
      with List.O['latest'] do
      begin
        AddLastVersion(S['release'], Result.R);
        AddLastVersion(S['snapshot'], Result.S);
      end;
    for I := 0 to List.A['versions'].Length - 1 do
    begin
      Id := List.A['versions'].O[I].S['id'];
      StringList := Result.GetListByName(List.A['versions'].O[I].S['type']);
      if StringList <> nil then
      begin
        StringList.AddObject(Id, TVanillaVersion.Create(Id));

        // Добавление OptiFine-версии

        if Assigned(List.O['optifine'].O[Id]) then
          StringList.AddObject(Id + ' OptiFine',TOptiFineVersion.Create(Id));

        // Добавление версии с LiteLoader

        if Assigned(List.O['liteloader'].O[Id]) then
          StringList.AddObject(Id + ' LiteLoader',
            TLiteLoaderVersion.Create(Id,
            List
              .O['liteloader']
              .O[Id]
              .O['artefacts']
              .O['com.mumfrey:liteloader']
              .O['latest'])
          );

        // Добавление версии с LL о OF

        if (List.O['optifine'].O[Id] <> nil) and (List.O['liteloader'].O[Id] <> nil) then
          StringList.AddObject(Id + ' LiteLoader OptiFine',
            TOFLiteVersion.Create(Id,
              List
                .O['liteloader']
                .O[Id]
                .O['artefacts']
                .O['com.mumfrey:liteloader']
                .O['latest'])
          );
      end;
    end;
  except
    on E: Exception do
      ShowError(StrDlgListParsingError, E);
  end;
end;

function GetRemoteVersionsList: TMinecraftVersions;
var
  List: ISuperObject;
begin
  List := GetList;
  if Assigned(List) then
    Result := ParseList(List)
  else
    Result := nil;
end;

end.
