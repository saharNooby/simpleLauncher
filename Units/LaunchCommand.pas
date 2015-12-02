unit LaunchCommand;

interface

uses
  SuperObject;

type
  // Опции для составления команды
  TCommandOptions = packed record
    id,
    Memory,
    Arguments, MCArguments,
    Width, Height: WideString;
    Version, Parent: ISuperObject;
    MemChar: WideChar;
  end;

function GetLaunchCommand(Options: TCommandOptions): string;

implementation

uses
  SysUtils, TypeTMinecraftLib, BaseUtils, LauncherPaths, Windows, AuthUnit,
  LauncherSettings, UnitLauncherForm, NickValidator;

function Spaces(const S: string): string;
var
  C: Char;
begin
  Result := S;
  if S = '' then
    Exit;
  for C in S do
    if C = ' ' then
    begin
      Result := '"' + S + '"';
      Break;
    end;
end;

procedure Add(var S: string; const Adding: string);
begin
  if Adding <> '' then
    S := S + Adding + ' ';
end;

//------------------------------------------------------------------------------

function GetVarValue(const Options: TCommandOptions; const V: string): string;
var
  Access, UUID, UType, Session: String;
begin
  Result := V;

  if (V = '') or (V[1] <> '$') then
    Exit;

  if (Settings.Profile.I['LoginMode'] = 1) and Auth.LoggedIn then
  begin
    Access := Auth.AccessToken;
    UUID := Auth.UUID;
    Session := Auth.AccessToken;
    UType := Auth.UserType;
  end
  else
  begin
    Access := '0';
    UUID := '0';
    Session := '0';
    UType := 'mojang';
  end;

       if V = '${auth_player_name}'  then Result := (Auth.Nick)
  else if V = '${version_name}'      then Result := Spaces(Options.id)
  else if V = '${game_directory}'    then Result := Spaces(Paths.ClientWithoutSlash)
  else if V = '${game_assets}'       then Result := Spaces(Paths.Client + 'assets\virtual\legacy')
  else if V = '${assets_index_name}' then Result := (Options.Version.S['assets'])
  else if V = '${auth_uuid}'         then Result := (UUID)
  else if V = '${auth_access_token}' then Result := (Access)
  else if V = '${auth_session}'      then Result := (Session)
  else if V = '${user_properties}'   then Result := ('{}')
  else if V = '${user_type}'         then Result := (UType)
  else if V = '${assets_root}'       then
    if Options.Version.S['assets'] <> '' then
      Result := Spaces(Paths.Client + 'assets')
    else
      Result := Spaces(Paths.Client + 'assets\virtual\legacy');
end;

function ParseArguments(const Options: TCommandOptions): String;
var
  SubStr: String;
  Args: String;
begin
  Result := '';
  Args := Options.Version.S['minecraftArguments'];
  repeat
    SubStr := Copy(Args, 1, CstmPos(Args, ' ') - 1);
    Result := Result + GetVarValue(Options, SubStr) + ' ';
    Delete(Args, 1, Length(SubStr) + 1);
  until CstmPos(Args, ' ') = 0;
  Result := Result + GetVarValue(Options, Args);
end;

function GetLibsStr(const Options: TCommandOptions): string;
var
  I: integer;
  Lib: TMinecraftLib;
begin
  Result := '';
  if Options.Version.O['libraries'] <> nil then
    for I := 0 to Options.Version.A['libraries'].Length - 1 do
    begin
      Lib := TMinecraftLib.Create(Options.Version.A['libraries'].O[I].Clone);
      if Lib.IsForWindows then
        if Lib.Natives = 0 then
          Result := Result + Lib.Path + ';'
        else
          Lib.ExtractNatives(Options.id);
      FreeAndNil(Lib);
    end;
end;

function GetCommand(const Options: TCommandOptions): string;
var
  Cmd, JarId: String;
begin
  Cmd := '';

  Add(Cmd, Spaces(Paths.Java));
  if Options.Memory <> '' then
    Add(Cmd, Options.Memory + Options.MemChar);
  Add(Cmd, Options.Arguments);
  Add(Cmd, Spaces('-Djava.library.path=' + Paths.Natives(Options.id)));
  Add(Cmd, '-cp');
  if Options.Version.S['jar'] <> '' then
    JarId := Options.Version.S['jar']
  else
    JarId := Options.id;
  Add(Cmd, Spaces(GetLibsStr(Options) + Paths.jar(JarId)));
  Add(Cmd, Options.Version.S['mainClass']);
  Add(Cmd, ParseArguments(Options));

  if Options.Width  <> '' then Add(Cmd, '--width '  + Options.Width);
  if Options.Height <> '' then Add(Cmd, '--height ' + Options.Height);

  Add(Cmd, Options.MCArguments);

  Result := Cmd;
end;

procedure ShowMessage(const msg: String);
const
  Capt = 'Ошибка запуска';
begin
  MessageBox(LauncherForm.Handle, PChar(msg), PChar(Capt), MB_ICONERROR);
end;

function GetLaunchCommand(Options: TCommandOptions): string;
const
  ErrorMessage = 'Не могу запустить версию %s, файл "%s", возможно, ' +
    'повреждён. Попробуйте загрузить версию заново.';
var
  Inherits: String;
  I: Integer;
begin
  if Options.id = '' then
    raise Exception.Create('"Options.Version" option is empty!');

  // Парсим стандартный json
  if not ExtParse(Paths.json(Options.id), @Options.Version) then
  begin
    ShowMessage(Format(ErrorMessage, [Options.id, Paths.json(Options.id)]));
    Exit;
  end;

  // Проверяем, а нет ли наcледования json?

  Inherits := Options.Version.S['inheritsFrom'];

  if Inherits <> '' then
    if not ExtParse(Paths.json(Inherits), @Options.Parent) then
    begin
      ShowMessage(SysUtils.Format(ErrorMessage, [Options.id, Paths.json(Inherits)]));
      Exit;
    end
    else
      // Если без ошибок, то объединяем
      with Options do
      begin
        if (Parent.A['libraries'] <> nil) and (Version.A['libraries'] <> nil) then
        begin
          for I := 0 to Parent.A['libraries'].Length - 1 do
            Version.A['libraries'].Add(Parent.A['libraries'].O[I]);
          Parent.Delete('libraries');
        end;
        Parent.Merge(Version);
        Version := Parent;
      end;

  if Options.Memory <> '' then
    Options.Memory := '-Xmx' + Options.Memory;

  if Paths.Java = '' then
    Paths.Java := 'javaw.exe';

  Result := GetCommand(Options);
end;

end.

