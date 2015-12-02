unit OnInstallSender;

interface

procedure SendOnInstall;

implementation

uses
  SysUtils, BaseUtils, Downloader, LauncherStrings;

procedure Send;
begin
  GetInternetString('http://simplelauncher.ru/onInstall.php?version=' +
    LauncherVersionCode.ToString);
end;

procedure SendOnInstall;
begin
  StartThread(@Send, 'Thread');
end;

end.
