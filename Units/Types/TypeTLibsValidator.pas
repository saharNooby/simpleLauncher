unit TypeTLibsValidator;

interface

uses
  TypeTMinecraftLib;

type
  TLibsValidator = class
  private
    FForce: Boolean;
    procedure ValidateHash(Lib: TMinecraftLib);
    procedure ValidateLib(Lib: TMinecraftLib);
  public
    constructor Create(const MCVer: string; const Force: Boolean);
  end;

implementation

uses
  SysUtils, BaseUtils, LauncherPaths, SuperObject, Downloader, Logging,
  LauncherStrings, Exceptions, UnitLauncherForm;

{ TLibsValidator }

constructor TLibsValidator.Create(const MCVer: string; const Force: Boolean);
var
  Obj: ISuperObject;
  I: Integer;
  Lib: TMinecraftLib;
begin
  inherited Create();
  try
    FForce := Force;

    LogF(Self, 'Validating libraries for version %s, Force = %s',
      [MCVer, Force.ToString]);

    if ExtParse(Paths.json(MCVer), @Obj) then
    begin
      for I := 0 to Obj.A['libraries'].Length - 1 do
      begin
        try
          Lib := TMinecraftLib.Create(Obj.A['libraries'].O[I].Clone);
        except
          Continue;
        end;
        if Lib.IsForWindows then
        begin
          ValidateHash(Lib);
          ValidateLib(Lib);
        end;
        FreeAndNil(Lib);
      end;
    end;
  finally
    Log(Self, 'Validating completed.');
    Free;
  end;
end;

procedure TLibsValidator.ValidateHash(Lib: TMinecraftLib);
const
  TryCnt = 3;
var
  TryNum: Integer;
  Hash: String;
  Data: TDownloadData;
begin
  // Хэш валиден ЕСЛИ он существует И сколько-там hex символов ИНАЧЕ скачать
  if FForce or not Lib.IsValidHash(Hash) then
  begin
    Log(Self, 'Downloading hash...');

    FillChar(Data, SizeOf(Data), #0);
    Data.WndHandle := LauncherForm.Handle;
    Data.URL := Lib.HashURL;
    Data.FileName := Lib.HashPath;
    Data.Notify := True;

    for TryNum := 1 to TryCnt do
      try
        ForceDirectories(Lib.Dir);
        Download(Data);
        Break;
      except
        on E: EInvalidRespCode do
        begin
          LogF(Self, '%s, hash not downloaded.', [E.Message], 1);
          Break;
        end;
        else
          Break;
      end;
  end;
end;

procedure TLibsValidator.ValidateLib(Lib: TMinecraftLib);
const
  TryCnt = 3;
var
  TryNum: Integer;
  Data: TDownloadData;
begin
  if FForce or not Lib.IsValid then
  begin
    Log(Self, 'Downloading library...');

    FillChar(Data, SizeOf(Data), #0);
    Data.WndHandle := LauncherForm.Handle;
    Data.URL := Lib.URL;
    Data.FileName := Lib.Path;
    Data.Notify := True;

    for TryNum := 1 to TryCnt do
      try
        ForceDirectories(Lib.Dir);
        Download(Data);
        Log(Self, 'Library downloaded!');
        Break;
      except
        on E: EInvalidRespCode do
        begin
          LogF(Self, '%s, lib not downloaded.', [E.Message], 1);
          Break;
        end;
        else
          Break;
      end;
  end;
end;

end.
