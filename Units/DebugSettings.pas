unit DebugSettings;

interface

function DontSetupThemes: Boolean;
function DontRefreshRemoteVersions: Boolean;
function DontLoadAds: Boolean;
function DontCheckUpdates: Boolean;
function DontTouchSettings: Boolean;

implementation

uses
  Classes;

var
  Args: TStringList;

function DisableAll: Boolean;
begin
  Result := (Args.IndexOf('--d_DisableAll') <> -1);
end;

function DontSetupThemes: Boolean;
begin
  Result := (Args.IndexOf('--d_DontSetupThemes') <> -1) or DisableAll;
end;

function DontRefreshRemoteVersions: Boolean;
begin
  Result := (Args.IndexOf('--d_DontRefreshRemoteVersions') <> -1) or DisableAll;
end;

function DontLoadAds: Boolean;
begin
  Result := (Args.IndexOf('--d_DontLoadAds') <> -1) or DisableAll;
end;

function DontCheckUpdates: Boolean;
begin
  Result := (Args.IndexOf('--d_DontCheckUpdates') <> -1) or DisableAll;
end;

function DontTouchSettings: Boolean;
begin
  Result := (Args.IndexOf('--d_DontTouchSettings') <> -1) or DisableAll;
end;

procedure Init();
var
  I: Integer;
begin
  Args := TStringList.Create;

  // First param is app path, so ignore
  for I := 0 to ParamCount() - 1 do
    Args.Add(ParamStr(I + 1));
end;

initialization

  Init();

finalization

  Args.Free;

end.
