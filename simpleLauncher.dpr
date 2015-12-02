program simpleLauncher;

uses
  Vcl.Forms,
  Vcl.Themes,
  Vcl.Styles,
  UnitChangelogForm in 'Units\Forms\UnitChangelogForm.pas' {ChangelogForm},
  UnitLauncherForm in 'Units\Forms\UnitLauncherForm.pas' {LauncherForm},
  SettingsForm in 'Units\Forms\SettingsForm.pas' {Fm_Settings},
  UnitUpdaterForm in 'Units\Forms\UnitUpdaterForm.pas' {UpdaterForm},
  VersionEditorForm in 'Units\Forms\VersionEditorForm.pas' {Fm_VersionEditor},
  Exceptions in 'Units\Types\Exceptions.pas',
  TypeTAssetsValidator in 'Units\Types\TypeTAssetsValidator.pas',
  LauncherSettings in 'Units\LauncherSettings.pas',
  TypeTLibsValidator in 'Units\Types\TypeTLibsValidator.pas',
  LaunchCommand in 'Units\LaunchCommand.pas',
  TypeTMinecraftLib in 'Units\Types\TypeTMinecraftLib.pas',
  TypeTMinecraftVersions in 'Units\Types\TypeTMinecraftVersions.pas',
  VersionsListDownload in 'Units\VersionsListDownload.pas',
  BaseUtils in 'Units\Utils\BaseUtils.pas',
  Downloader in 'Units\Utils\Downloader.pas',
  Logging in 'Units\Utils\Logging.pas',
  SuperObject in 'Units\Utils\SuperObject.pas',
  DCPbase64 in 'Units\Utils\Hash\DCPbase64.pas',
  DCPconst in 'Units\Utils\Hash\DCPconst.pas',
  DCPcrypt2 in 'Units\Utils\Hash\DCPcrypt2.pas',
  DCPsha1 in 'Units\Utils\Hash\DCPsha1.pas',
  LauncherPaths in 'Units\LauncherPaths.pas',
  LauncherStrings in 'Units\LauncherStrings.pas',
  LauncherUpdater in 'Units\LauncherUpdater.pas',
  LauncherURLs in 'Units\LauncherURLs.pas',
  MinecraftDownload in 'Units\MinecraftDownload.pas',
  UnitRemoteRefresherThread in 'Units\Threads\UnitRemoteRefresherThread.pas',
  UnitLauncherThread in 'Units\Threads\UnitLauncherThread.pas',
  UnitMinecraftListenerThread in 'Units\Threads\UnitMinecraftListenerThread.pas',
  PipesAPI in 'Units\Utils\PipesAPI.pas',
  FWZipReader in 'Units\Utils\FWZip\FWZipReader.pas',
  FWZipConsts in 'Units\Utils\FWZip\FWZipConsts.pas',
  FWZipCrc32 in 'Units\Utils\FWZip\FWZipCrc32.pas',
  FWZipCrypt in 'Units\Utils\FWZip\FWZipCrypt.pas',
  FWZipStream in 'Units\Utils\FWZip\FWZipStream.pas',
  FWZipZLib in 'Units\Utils\FWZip\FWZipZLib.pas',
  BrowseDirectory in 'Units\Utils\BrowseDirectory.pas',
  HTTPPost in 'Units\Utils\HTTPPost.pas',
  AuthUnit in 'Units\AuthUnit.pas',
  UnitLoginForm in 'Units\Forms\UnitLoginForm.pas' {LoginForm},
  AdsClass in 'Units\Classes\AdsClass.pas',
  updater_exe in 'Units\updater_exe.pas',
  NickValidator in 'Units\NickValidator.pas',
  IndexesManagerClass in 'Units\Classes\IndexesManagerClass.pas',
  UnitIndexListerThread in 'Units\Threads\UnitIndexListerThread.pas',
  VersionsManagerClass in 'Units\Classes\VersionsManagerClass.pas',
  UnitLoginThread in 'Units\Threads\UnitLoginThread.pas',
  UnitJSONEditorForm in 'Units\Forms\UnitJSONEditorForm.pas' {JSONEditorForm},
  UnitCaptionChangerThread in 'Units\Threads\UnitCaptionChangerThread.pas',
  DownloadableVersions in 'Units\Repository\DownloadableVersions.pas',
  DebugSettings in 'Units\DebugSettings.pas',
  UsageStatistics in 'Units\UsageStatistics.pas';

{$R *.res}

begin
  //ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.FormBorderStyle := fbsSystemStyle;
  Application.CreateForm(TLauncherForm, LauncherForm);
  Application.Run;
end.
