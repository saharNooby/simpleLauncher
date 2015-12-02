unit TypeTMinecraftLib;

interface

uses
  SuperObject;

type
  TMinecraftLib = class
  private
    FRoot, FDir, FFileName, FRootURL: String;
    FIsForWindows: Boolean;
    FNatives: Integer;

    function GetFullDir: string;
    function GetFullPath: string;
    function GetFullHashPath: string;
    function GetURL: string;
    function GetHashURL: string;
  public
    property Dir: String read GetFullDir;
    property Path: String read GetFullPath;
    property HashPath: String read GetFullHashPath;

    property URL: String read GetURL;
    property HashURL: String read GetHashURL;

    property IsForWindows: Boolean read FIsForWindows;
    property Natives: Integer read FNatives;

    constructor Create(const Lib: ISuperObject; const CustPath: string = '');
    procedure ExtractNatives(const MCVer: string);
    function IsValid: Boolean;
    function IsValidHash(var Hash: string): Boolean;
  end;

implementation

uses
  SysUtils, Classes, BaseUtils, LauncherPaths, FWZipReader, Logging,
  Windows;

function Is64BitWindows: Boolean;
var
  IsWow64Process: function(hProcess: THandle; out Wow64Process: BOOL): BOOL;
    stdcall;
  Wow64Process: BOOL;
begin
  {$IF Defined(CPU64)}
    Result := True;
  {$ELSEIF Defined(CPU16)}
    Result := False;
  {$ELSE}
    @IsWow64Process := GetProcAddress(GetModuleHandle('Kernel32.dll'),
      PAnsiChar('IsWow64Process'));
    Wow64Process := False;
    if Assigned(IsWow64Process) then
      Wow64Process := IsWow64Process(GetCurrentProcess, Wow64Process)
        and Wow64Process;
    Result := Wow64Process;
  {$ENDIF}
end;

function GetWindowsArch: String;
begin
  if Is64BitWindows then
    Result := '64'
  else
    Result := '32';
end;

constructor TMinecraftLib.Create(const Lib: ISuperObject;
  const CustPath: string = '');
var
  // Package-Name-Version
  PNV: TStringList;
  NativesStr: string;
begin
  inherited Create;
  NativesStr := '';
  FNatives := 0;
  with Lib do
    if O['natives'] <> nil then
      if O['natives'].S['windows'] = 'natives-windows' then
      begin
        NativesStr := '-natives-windows';
        FNatives := 1;
      end
      else if O['natives'].S['windows'] = 'natives-windows-${arch}' then
      begin
        NativesStr := '-natives-windows-' + GetWindowsArch;
        FNatives := 2;
      end;

  PNV := TStringList.Create;
  ExtractStrings([':'], [], PChar(Lib.S['name']), PNV);

  FDir := Format('%s/%s/%s/', [PNV[0].Replace('.', '/'), PNV[1], PNV[2]]);

  FFileName := Format('%s-%s%s.jar', [PNV[1], PNV[2], NativesStr]);

  FreeAndNil(PNV);

  if CustPath <> '' then
    FRoot := CustPath + 'libraries\'
  else
    FRoot := Paths.Client + 'libraries\';

  FIsForWindows := True;
  if Lib.O['rules'] <> nil then
    with Lib.A['rules'] do
    begin
      if (O[0] <> nil) and (O[1] = nil) then
        if O[0].O['os'] <> nil then
          if O[0].O['os'].S['name'] <> 'windows' then
            FIsForWindows := False;
      if (O[0] <> nil) and (O[1] <> nil) then
        if O[1].O['os'] <> nil then
          if O[1].O['os'].S['name'] = 'windows' then
            FIsForWindows := False;
    end;

  if Lib.S['url'] <> '' then
    FRootURL := Lib.S['url']
  else
    FRootURL :='https://libraries.minecraft.net/';
end;

procedure TMinecraftLib.ExtractNatives(const MCVer: string);
var
  Zip: TFWZipReader;
  I: integer;
begin
  Zip := TFWZipReader.Create;
  try
    Zip.LoadFromFile(Path);

    for I := 0 to Zip.Count - 1 do
      with Zip.Item[I] do
        if (FileName <> 'META-INF/MANIFEST.MF') and not IsFolder then
          Extract(Paths.Natives(MCVer), '');

    LogF(Self, 'Extracted natives from "%s" to "%s"',
      [Path, Paths.Natives(MCVer)]);
  except
    LogF(Self, 'Natives from "%s" not extracted to "%s"!',
      [Path, Paths.Natives(MCVer)], 1);
  end;
  FreeAndNil(Zip);
end;

function TMinecraftLib.GetFullDir: string;
begin
  Result := FRoot + FDir.Replace('/', '\');
end;

function TMinecraftLib.GetFullHashPath: string;
begin
  Result := GetFullPath + '.sha1';
end;

function TMinecraftLib.GetFullPath: string;
begin
  Result := GetFullDir + FFileName;
end;

function TMinecraftLib.GetHashURL: string;
begin
  Result := GetURL + '.sha1';
end;

function TMinecraftLib.GetURL: string;
begin
  Result := FRootURL + FDir + FFileName;
end;

function TMinecraftLib.IsValid: boolean;
var
  Hash: String;
begin
  Result := True;
  if not FileExists(Path) then // Не существует - не валидна
    Exit(False);
  if IsValidHash(Hash) then // Если есть верный хэш...
    if GetSHA1(Path) <> Hash then // Хэш не совпадает - не валидна!
      Exit(False);
end;

function TMinecraftLib.IsValidHash(var Hash: string): boolean;
const
  Valids = ['0' .. '9', 'a' .. 'f'];
var
  I: integer;
  HashStream: TStringStream;
  Valid: boolean;
begin
  Hash := '';
  Valid := True;

  HashStream := TStringStream.Create;
  try
    try
      HashStream.LoadFromFile(HashPath);
      Hash := HashStream.ReadString(40);
    finally
      FreeAndNil(HashStream);
    end;
  except
    Exit(False); // Не существует - не валиден
  end;

  if Hash = '' then
    Valid := False
  else
    for I := 1 to Length(Hash) do
      Valid := Valid and CharInSet(Hash[I], Valids); // Неверные символы - ясно

  Result := Valid;

  {if Valid then
    Log('EXTR: ' + Hash);}
end;

end.
