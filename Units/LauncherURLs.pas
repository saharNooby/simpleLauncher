unit LauncherURLs;

interface

type
  URLs = class
  public
    class function Asset(const Hash: string): string;
    class function Index(const Version: string): string;
    class function VersionsList: string;
    class function OptiFineVersionsList: string;
    class function LiteLoaderVersionsList: string;
    class function VersionJar(const Version: string): string;
    class function VersionJson(const Version: string): string;
    class function OptiFineLib(const Vanilla: string): string;
    class function Ads: String;
  end;

implementation

const
  AssetsURL = 'http://resources.download.minecraft.net/';
  MCDownloadURL = 'https://s3.amazonaws.com/Minecraft.Download/';
  IndexesURL = MCDownloadURL + 'indexes/';
  VersionsURL = MCDownloadURL + 'versions/';
  Site = 'http://simplelauncher.ru.swtest.ru/';

{ URLs }

class function URLs.Ads: String;
begin
  Result := Site + 'ads/';
end;

class function URLs.Asset(const Hash: string): string;
begin
  Result := AssetsURL + Hash[1] + Hash[2] + '/' + Hash;
end;

class function URLs.Index(const Version: string): string;
begin
  Result := IndexesURL + Version + '.json';
end;

class function URLs.VersionJar(const Version: string): string;
begin
  Result := VersionsURL + Version + '/' + Version + '.jar';
end;

class function URLs.VersionJson(const Version: string): string;
begin
  Result := VersionsURL + Version + '/' + Version + '.json';
end;

class function URLs.OptiFineLib(const Vanilla: string): string;
begin
  Result := Site + 'repo/optifine/OptiFine_' + Vanilla + '_HD_U.jar';
end;

class function URLs.LiteLoaderVersionsList: string;
begin
  Result := Site + 'repo/liteloader.json';
end;

class function URLs.OptiFineVersionsList: string;
begin
  Result := Site + 'repo/optifine/list.json';
end;

class function URLs.VersionsList: string;
begin
  Result := MCDownloadURL + 'versions/versions.json';
end;

end.
