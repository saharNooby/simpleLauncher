unit DownloadableVersions;

interface

uses
  SuperObject;

type
  // Класс для взаимодействия с любыми версиями

  TLoadableVersion = class
  protected
    FId, FSourceId: String;
  public
    property Id: String read FId;
    procedure Download; virtual;
    constructor Create(const AId: String);
  end;

  TVanillaVersion = class(TLoadableVersion);

  TOptiFineVersion = class(TVanillaVersion)
  public
    procedure Download; override;
    constructor Create(const ASourceId: String);
  end;

  TLiteLoaderVersion = class(TVanillaVersion)
  private
    FArtefact: ISuperObject;
  public
    procedure Download; override;
    constructor Create(const ASourceId: String; const Artefact: ISuperObject);
  end;

  TOFLiteVersion = class(TVanillaVersion)
  private
    FArtefact: ISuperObject;
  public
    procedure Download; override;
    constructor Create(const ASourceId: String; const Artefact: ISuperObject);
  end;

implementation

uses
  SysUtils, Windows,
  UnitLauncherForm,
  LauncherPaths, LauncherURLs, LauncherStrings, Downloader, Logging,
  TypeTMinecraftLib;

function ErrorDlg(const Msg: string): Integer;
begin
  Result := MessageBox(LauncherForm.Handle, PChar(Msg),
    PChar('Ошибка загрузки'), MB_ICONERROR + MB_YESNO)
end;

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
    Notify := True;
  end;
  repeat
    try
      Download(Data);
      LogF('File "%s" downloaded!', [APath]);
      Break;
    except
      on E: Exception do
      begin
        LogE(E);
        LogF('File "%s" not downloaded!', [APath], 1);
      end;
    end;
  until ErrorDlg(Format(StrDlgDownloadError, [ExtractFileName(APath)])) <> idYes;
end;

{ TLoadableVersion }

constructor TLoadableVersion.Create(const AId: String);
begin
  if AId = '' then
    raise Exception.Create('Version ID is empty!');

  FId := AId;
  FSourceId := AId;
end;

procedure TLoadableVersion.Download;
begin
  ForceDirectories(Paths.Version(FId));

  EasyDl(URLs.VersionJson(FSourceId), Paths.json(FId));
  EasyDl(URLs.VersionJar(FSourceId), Paths.jar(FId));
end;

{ TOptiFineVersion }

constructor TOptiFineVersion.Create(const ASourceId: String);
begin
  inherited Create(ASourceId);
  FId := FId + '-OptiFine';
end;

procedure TOptiFineVersion.Download;
var
  Lib: TMinecraftLib;
  LibObj: ISuperObject;
  Obj: ISuperObject;
begin
  inherited;

  LibObj := SO(Format('{"name":"optifine:OptiFine:%s"}', [FSourceId]));

  // Загрузка библиотеки OptiFine
  Lib := TMinecraftLib.Create(LibObj);
  ForceDirectories(Lib.Dir);
  EasyDl(URLs.OptiFineLib(FSourceId), Lib.Path);
  FreeAndNil(Lib);

  Obj := TSuperObject.ParseFile(Paths.json(FId), False);
  with Obj do
  begin
    // Меняем id
    S['id'] := FId;
    // Добавляем tweakClass-аргумент
    S['minecraftArguments'] := S['minecraftArguments'] + ' --tweakClass optifine.OptiFineTweaker';
    // Добавляем имя библиотеки OptiFIne
    A['libraries'].Add(LibObj);
    // Добавляем имя библиотеки LaunchWrapper
    A['libraries'].Add(SO('{"name":"net.minecraft:launchwrapper:1.7"}'));
    // Меняем главный класс
    S['mainClass'] := 'net.minecraft.launchwrapper.Launch';
    SaveTo(Paths.json(FId), True);
  end;
end;

{ TLiteLoaderVersion }

constructor TLiteLoaderVersion.Create(const ASourceId: String; const Artefact: ISuperObject);
begin
  inherited Create(ASourceId);
  FArtefact := Artefact;
  FId := FId + '-LiteLoader-' + FArtefact.S['version'];
end;

procedure TLiteLoaderVersion.Download;
var
  Obj: ISuperObject;
  Lib: ISuperObject;
begin
  inherited;

  Lib := SO();
  Lib.S['name'] := 'com.mumfrey:liteloader:' + FSourceId;
  Lib.S['url'] := 'http://dl.liteloader.com/versions/';


  Obj := TSuperObject.ParseFile(Paths.json(FId), False);
  with Obj do
  begin
    // Меняем id
    S['id'] := FId;
    // Добавляем tweakClass-аргумент
    S['minecraftArguments'] := S['minecraftArguments'] + ' --tweakClass ' + FArtefact.S['tweakClass'];
    // Сливаем ванильные библиотеки с нужными
    if FArtefact.B['merge'] then
      O['libraries'].Merge(FArtefact.O['libraries'])
    else
      O['libraries'] := FArtefact.O['libraries'];
    // Добавляем библиотеку LiteLoader
    A['libraries'].Add(Lib);
    // Меняем главный класс
    S['mainClass'] := 'net.minecraft.launchwrapper.Launch';
    SaveTo(Paths.json(FId), True);
  end;
end;

{ TOFLiteVersion }

constructor TOFLiteVersion.Create(const ASourceId: String; const Artefact: ISuperObject);
begin
  inherited Create(ASourceId);
  FArtefact := Artefact;
  FId := FId + '-LiteLoader-' + FArtefact.S['version'] + '-OptiFine';
end;

procedure TOFLiteVersion.Download;
var
  Lib: TMinecraftLib;
  LibObj, LiteLib: ISuperObject;
  Obj: ISuperObject;
begin
  inherited;

  LiteLib := SO();
  LiteLib.S['name'] := 'com.mumfrey:liteloader:' + FSourceId;
  LiteLib.S['url'] := 'http://dl.liteloader.com/versions/';

  LibObj := SO(Format('{"name":"optifine:OptiFine:%s"}', [FSourceId]));

  // Загрузка библиотеки OptiFine
  Lib := TMinecraftLib.Create(LibObj);
  ForceDirectories(Lib.Dir);
  EasyDl(URLs.OptiFineLib(FSourceId), Lib.Path);
  FreeAndNil(Lib);

  Obj := TSuperObject.ParseFile(Paths.json(FId), False);
  with Obj do
  begin
    // Меняем id
    S['id'] := FId;
    // Добавляем tweakClass-аргумент
    S['minecraftArguments'] := S['minecraftArguments'] + ' --tweakClass com.mumfrey.liteloader.launch.LiteLoaderTweaker';
    // Сливаем ванильные библиотеки с нужными
    if FArtefact.B['merge'] then
      O['libraries'].Merge(FArtefact.O['libraries'])
    else
      O['libraries'] := FArtefact.O['libraries'];
    // Добавляем имя библиотеки OptiFIne
    A['libraries'].Add(LibObj);
    // Добавляем библиотеку LiteLoader
    A['libraries'].Add(LiteLib);
    // Меняем главный класс
    S['mainClass'] := 'net.minecraft.launchwrapper.Launch';
    SaveTo(Paths.json(FId), True);
  end;
end;

end.
