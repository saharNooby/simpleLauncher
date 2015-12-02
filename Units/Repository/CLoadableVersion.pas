// 07.11.2015 19:13
unit CLoadableVersion;

interface

type
    // Класс для взаимодействия с любыми версиями

    TLoadableVersion = class
    protected
        FId, FSourceId: String;
    public
        class procedure DownloadFile(const AURL, APath: String);
        property Id: String read FId;
        constructor Create(const AId: String);
        procedure Download; virtual;
    end;

implementation

uses


{ TLoadableVersion }

constructor TLoadableVersion.Create(const AId: String);
begin
  if AId = '' then
    raise Exception.Create('Version ID is empty!');

  FId := AId;
  FSourceId := AId;
end;

procedure TLoadableVersion.Download;
begin
  ForceDirectories(Paths.Version(FId));

  EasyDl(URLs.VersionJson(FSourceId), Paths.json(FId));
  EasyDl(URLs.VersionJar(FSourceId), Paths.jar(FId));
end;

class procedure TLoadableVersion.DownloadFile(const AURL, APath: String);
var
  Data: TDownloadData;
begin
  FillChar(Data, SizeOf(Data), #0);
  with Data do
  begin
    WndHandle := LauncherForm.Handle;
    URL := AURL;
    FileName := APath;
    Notify := True;
  end;
  repeat
    try
      Download(Data);
      LogF('File "%s" downloaded!', [APath]);
      Break;
    except
      on E: Exception do
      begin
        LogE(E);
        LogF('File "%s" not downloaded!', [APath], 1);
      end;
    end;
  until ErrorDlg(Format(StrDlgDownloadError, [ExtractFileName(APath)])) <> idYes;
end;

end.

