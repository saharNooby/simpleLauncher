unit AdsClass;

interface

type
  Ads = class
  private
    class var FLink: String;
    class procedure DownloadImage(const URL: String);
  public
    class procedure LoadInfo;
    class property CurrentLink: String read FLink;
  end;

procedure ExecuteAdsLoader;

implementation

uses
  Downloader, SuperObject, SysUtils, Classes, UnitLauncherForm, Windows,
  LauncherPaths, LauncherURLs, BaseUtils, Logging;

procedure ExecuteAdsLoader;
begin
  try
    Ads.LoadInfo;
  except
    on E: Exception do
      LogE(E);
  end;
end;

class procedure Ads.DownloadImage(const URL: String);
var
  Stream: TMemoryStream;
begin
  Stream := TMemoryStream.Create;
  try
    FillInternetStream(URL, Stream);
    ForceDirectories(Paths.Settings);
    Stream.SaveToFile(Paths.AdsImage);
  finally
    FreeAndNil(Stream);
  end;
end;

class procedure Ads.LoadInfo;
var
  Obj: ISuperObject;
  ImgURL: String;
begin
  Obj := SO(GetInternetString(URLs.Ads + 'info.json'));
  if Assigned(Obj) then
    if Obj.S['Hash'] <> '' then
    begin
      FLink := Obj.S['Link'];
      ImgURL := URLs.Ads + Obj.S['Hash'] + '.jpg';
      if GetSHA1(Paths.AdsImage) <> Obj.S['Hash'] then
        DownloadImage(ImgURL);
      SendMessage(LauncherForm.Handle, LM_ADS_LOADED, 0, 0);
    end;
end;

end.
