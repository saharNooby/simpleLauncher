unit UnitRemoteRefresherThread;

interface

procedure RefreshRemoteVersionsList;

implementation

uses
  TypeTMinecraftVersions, VersionsListDownload, UnitLauncherForm, Windows,
  BaseUtils;

procedure SendRemoteVersionsList;
var
  List: TMinecraftVersions;
begin
  try
    List := GetRemoteVersionsList;
    if not Assigned(List) then
      Exit;
    if List.Filled then
      SendMessage(LauncherForm.Handle, LM_REMOTE_LIST_LOADED, 0, LongWord(List));
  finally
    LauncherForm.UnblockAfterRemoteRefresh(nil);
  end;
end;

procedure RefreshRemoteVersionsList;
begin
  StartThread(@SendRemoteVersionsList, 'Downloadable versions list refresher');
end;

end.
