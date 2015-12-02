unit LauncherUpdater;

interface

procedure CheckForLauncherUpdates(AShowMessages: Boolean);

implementation

uses
  Windows, SysUtils, BaseUtils, Downloader, LauncherStrings, UnitUpdaterForm,
  SuperObject, Logging, UnitLauncherForm;

var
  ShowMessages: Boolean;

procedure CheckForUpdates;
var
  Response, RequestType: String;
  LParam: Cardinal;
begin
  try
    if not ShowMessages then
      RequestType := '2'
    else
      RequestType := '1';

    Response := GetInternetString(StrLauncherUpdates + LauncherVersionCode.ToString + '&t=' + RequestType);
    LauncherVersionInfo := SO(Response);

    if not Assigned(LauncherVersionInfo) or (LauncherVersionInfo.I['Version'] = 0) then
      raise Exception.Create(StrExcParsingError);

    if LauncherVersionCode < LauncherVersionInfo.I['Version'] then
      LParam := 0
    else
      LParam := 1;
  except
    on E: Exception do
    begin
      LogE(E);
      LParam := 2;
    end;
  end;
  SendMessage(LauncherForm.Handle, 1033, ShowMessages.ToInteger, LParam);
end;

procedure CheckForLauncherUpdates(AShowMessages: Boolean);
begin
  ShowMessages := AShowMessages;
  StartThread(@CheckForUpdates, 'Launcher Updater');
end;

end.
