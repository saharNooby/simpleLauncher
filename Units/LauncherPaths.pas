unit LauncherPaths;
(*
 *  Пути к клиенту, настройкам и appdata
 *  Написано для simpleLauncher
 *  (c) saharNooby 2014
 *)
interface

type
  TPaths = class
  private
    FClient: String;
    FJava: String;
  public
    property SetClient: string write FClient;
    property Java: string read FJava write FJava;
    function AppData: string;
    function ProgramFiles: string;
    { Launcher }
    function FileSettings: string;
    function Log: string;
    function Logs: string;
    function Settings: string;
    function Updates: string;
    function AdsImage: String;
    { Game }
    function Client: string;
    function ClientDefault: string;
    function ClientWithoutSlash: string;
    function Natives(const vrs: string): string;
    function Version(const vrs: string): string;
    function Versions: string;
    function jar(const vrs: string): string;
    function json(const vrs: string): string;
    function Index(const IndexName: String): String;
  end;

var
  Paths: TPaths;

implementation

uses
  SysUtils, Exceptions;

{ Paths }

function TPaths.AdsImage: String;
begin
  Result := Settings + 'ads.jpg';
end;

function TPaths.AppData: string;
begin
  Result := GetEnvironmentVariable('AppData');
  if not Result.EndsWith('\') then
    Result := Result + '\';
  Result := Result;
end;

function TPaths.Client: string;
begin
  Result := ClientWithoutSlash;
  if not Result.EndsWith('\') then
    Result := Result + '\';
end;

function TPaths.ClientWithoutSlash: string;
begin
  Result := FClient;
  if (Result = '') or (Result = '\') then
    Result := ExtractFileDir(ParamStr(0));
end;

function TPaths.ClientDefault: string;
begin
  Result := AppData + '.minecraft\'
end;

function TPaths.FileSettings: string;
begin
  Result := Settings + 'SettingsProfiles.json';
end;

function TPaths.Index(const IndexName: String): String;
begin
  Result := Client + 'assets\indexes\' + IndexName;
end;

function TPaths.jar(const vrs: string): string;
begin
  if vrs = '' then
    raise EEmptyVersionIDException.Create(
      'Version ID is empty (procedure: Paths method)!');
  Result := Versions + vrs + '\' + vrs + '.jar';
end;

function TPaths.json(const vrs: string): string;
begin
  if vrs = '' then
    raise EEmptyVersionIDException.Create(
      'Version ID is empty (procedure: Paths method)!');
  Result := Versions + vrs + '\' + vrs + '.json';
end;

function TPaths.Log: string;
begin
  Result := Logs + 'simpleLauncher.log'
end;

function TPaths.Logs: string;
begin
  Result := Settings;
end;

function TPaths.Natives(const vrs: string): string;
begin
  if vrs = '' then
    raise EEmptyVersionIDException.Create(
      'Version ID is empty (procedure: Paths method)!');
  Result := Version(vrs) + vrs + '-natives';
end;

function TPaths.ProgramFiles: string;
begin
  Result := GetEnvironmentVariable('ProgramFiles');
  if not Result.EndsWith('\') then
    Result := Result + '\';
  Result := Result;
end;

function TPaths.Settings: string;
begin
  Result:= AppData + 'simpleLauncher\'
end;

function TPaths.Updates: string;
begin
  Result := Paths.Settings + 'updates\';
end;

function TPaths.Version(const vrs: string): string;
begin
  if vrs = '' then
    raise EEmptyVersionIDException.Create(
      'Version ID is empty (procedure: Paths method)!');
  Result := Versions + vrs + '\'
end;

function TPaths.Versions: string;
begin
  Result := Client + 'versions\';
end;

initialization

  Paths := TPaths.Create;

finalization

  Paths.Free;

end.
