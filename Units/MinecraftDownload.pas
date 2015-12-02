unit MinecraftDownload;

interface

uses
  DownloadableVersions;

procedure DownloadVersion(const AVersion: TLoadableVersion);

implementation

uses
  Classes,
  UnitLauncherForm, LauncherSettings, TypeTLibsValidator, TypeTAssetsValidator;

type
  TMCDownloaderThread = class(TThread)
  private
    FVersion: TLoadableVersion;
    procedure EnableForm;
    procedure Validate;
  protected
    procedure Execute; override;
  public
    constructor Create(const AVersion: TLoadableVersion);
  end;

procedure DownloadVersion(const AVersion: TLoadableVersion);
begin
  TMCDownloaderThread.Create(AVersion);
end;

{ TThreadVersionDownloader }

constructor TMCDownloaderThread.Create(const AVersion: TLoadableVersion);
begin
  inherited Create;

  FreeOnTerminate := True;
  FVersion := AVersion;
end;

procedure TMCDownloaderThread.EnableForm;
begin
  with LauncherForm do
  begin
    ReleaseSpeedButton.Enabled := True;
    SnapshotSpeedButton.Enabled := True;
    BetaSpeedButton.Enabled := True;
    AlphaSpeedButton.Enabled := True;

    AllReleases.Enabled := ReleaseSpeedButton.Down;
    AllSnapshots.Enabled := SnapshotSpeedButton.Down;
    AllBetas.Enabled := BetaSpeedButton.Down;
    AllAlphas.Enabled := AlphaSpeedButton.Down;

    DownloadVersionButton.Enabled := True;
    RefreshRemoteButton.Enabled := True;
    LaunchButton.Enabled := True;
    SelectVersionToDownload(Self);
    RefreshClientVersions;
  end;
end;

procedure TMCDownloaderThread.Execute;
begin
  inherited;

  FVersion.Download;
  Validate;
  Synchronize(EnableForm);
end;

procedure TMCDownloaderThread.Validate;
begin
  with Settings.Profile do
  begin
    if B['DownloadAssetsWithVersions'] then
      TAssetsValidator.Create(FVersion.ID, B['ForceDownload']);
    if B['DownloadLibrariesWithVersions'] then
      TLibsValidator.Create(FVersion.ID, B['ForceDownload']);
  end;
end;


end.
