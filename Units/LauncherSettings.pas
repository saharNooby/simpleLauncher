unit LauncherSettings;

interface

uses
  SuperObject, Classes;

type
  TLauncherSettings = class
  private
    FSettingsObject: ISuperObject;
    procedure SetDefaultSettings;
    function GetProfile: ISuperObject;
  public
    { Common procedures }
    constructor Create;
    procedure SaveToFile;
    procedure Reset;

    property Profile: ISuperObject read GetProfile;
    property Global: ISuperObject read FSettingsObject;

    { Profiles }
    procedure NewProfile(const NewName: string);
    procedure DeleteProfile(const Index, NextIndex: integer);
    procedure RenameCurrentProfile(NewName: string);
    procedure SelectProfile(i: integer);
    function CurrentProfile: integer;
    function CurrProfileName: string;
    function AllProfilesNames: TStringList;
  end;

var
  Settings: TLauncherSettings;

implementation

uses
  SysUtils, BaseUtils, Logging, LauncherStrings, LauncherPaths;

const DefaultSettings =
  '{' +
    '"Profiles":' +
    '[' +
      '{' +
        '"ProfileName": "Default",' +
        '"Settings":' +
        '{' +
          '"AccessToken": "",' +
          '"AdditionalArgs": "",' +
          '"ShowNewReleases": true,' +
          '"ShowNewSnapshots": true,' +
          '"AutoCheckUpdates": false,' +
          '"RefreshButtonClicked": false,' +
          '"CatchMinecraftLog": true,' +
          '"ClientToken": "",' +
          '"CurrentNick": "Player",' +
          '"CurrentVersionID": "",' +
          '"DebugMode": false,' +
          '"DontCheckAssets": false,' +
          '"DontCheckLibraries": false,' +
          '"DownloadAssetsWithVersions": true,' +
          '"DownloadLibrariesWithVersions": true,' +
          '"DisableAds": false,' +
          '"JVMPath": "' + StrDefaultJavaPath + '",' +
          '"LauncherVisibility": 0,' +
          '"LoggedIn": false,' +
          '"LoginMode": 0,' +
          '"MCPath": "?default?",' +
          '"Memory": "500",' +
          '"MemoryChar": 0,' +
          '"MinecraftHeight": "",' +
          '"MinecraftWidth": "",' +
          '"MojangNick": "",' +
          '"MojangUserType": "",' +
          '"Nicks": ["Player"],' +
          '"ShowTrayIcon": true,' +
          '"UUID": ""' +
        '}' +
      '}' +
    '],' +
    '"EditorAction": 1,' +
    '"TabIndex": 0,' +
    '"ThemeIndex": 2,' +
    '"DoNotSendStats": false,' +
    '"SelectedIndex": 0' +
  '}';

{ TLaucnherSettings }

procedure TLauncherSettings.DeleteProfile(const Index, NextIndex: Integer);
begin
  with FSettingsObject do
  begin
    A['Profiles'].Delete(Index);
    I['SelectedIndex'] := NextIndex;
  end;
end;

function TLauncherSettings.GetProfile: ISuperObject;
begin
  Result := FSettingsObject.A['Profiles'].O[CurrentProfile].O['Settings'];
end;

constructor TLauncherSettings.Create;
begin
  try
    FSettingsObject := TSuperObject.ParseFile(Paths.FileSettings, True);
  except
    on E: EFOpenError do
      SetDefaultSettings;
    on E: Exception do
      LogE(E);
  end;
  if not Assigned(FSettingsObject) then
    FSettingsObject := SO(DefaultSettings);
end;

function TLauncherSettings.CurrentProfile: integer;
begin
  Result := Global.I['SelectedIndex'];
end;

function TLauncherSettings.AllProfilesNames: TStringList;
var
  I: Integer;
begin
  Result := TStringList.Create;
  for I := 0 to FSettingsObject.A['Profiles'].Length - 1 do
    Result.Add(FSettingsObject.A['Profiles'].O[I].S['ProfileName']);
end;

function TLauncherSettings.CurrProfileName: string;
begin
  Result := FSettingsObject.A['Profiles'].O[CurrentProfile].S['ProfileName'];
end;

procedure TLauncherSettings.NewProfile(const NewName: string);
var
  OldSelected: Integer;
begin 
  OldSelected := CurrentProfile;
  with FSettingsObject.A['Profiles'] do
  begin
    SelectProfile(Add(SO));
    O[CurrentProfile].S['ProfileName'] := NewName;
    O[CurrentProfile].O['Settings'] := O[OldSelected].O['Settings'].Clone;
  end;
end;

procedure TLauncherSettings.RenameCurrentProfile(NewName: string);
begin
  FSettingsObject.A['Profiles'].O[CurrentProfile].S['ProfileName'] := NewName;
end;

procedure TLauncherSettings.Reset;
begin
  SetDefaultSettings;
end;

procedure TLauncherSettings.SaveToFile;
begin
  try
    if not ForceDirectories(Paths.Settings) then
      raise Exception.CreateFmt(StrLogCantCreateDir, [Paths.Settings]);
    FSettingsObject.SaveTo(Paths.FileSettings, True);
    Log(Self, StrLogSettingsSaved);
  except
    on E: Exception do
      LogE(Self, E);
  end;
end;

procedure TLauncherSettings.SelectProfile(i: integer);
begin
  FSettingsObject.I['SelectedIndex'] := i;
end;

procedure TLauncherSettings.SetDefaultSettings;
begin
  FSettingsObject := SO(DefaultSettings);
  Log(Self, StrLogSettingDefaultSettings, 2);
end;

initialization

finalization

  Settings.Free;

end.
