unit UnitUpdaterForm;

interface

uses
  Messages, SysUtils, System.Classes,
  Vcl.Controls, Vcl.Forms,  Vcl.StdCtrls, Vcl.ComCtrls,
  SuperObject;

type
  TUpdaterForm = class(TForm)
    published
      Label1: TLabel;
      LabelVersion: TLabel;
      Label2: TLabel;
      LabelOldVersion: TLabel;
      Label4: TLabel;
      LabelDate: TLabel;
      ButtonDownload: TButton;
      Label5: TLabel;
      ButtonViewChanges: TButton;
      ProgressBar: TProgressBar;
      procedure FormCreate(Sender: TObject);
      procedure ButtonDownloadClick(Sender: TObject);
      procedure ButtonViewChangesClick(Sender: TObject);
    public
      procedure DownloadHandlerIdle(var Message: TMessage);
        message 1026;
      procedure DownloadHandlerFinish(var Message: TMessage);
        message 1027;
  end;

var
  UpdaterForm: TUpdaterForm;
  LauncherVersionInfo: ISuperObject;

implementation

uses
  Windows, ShellApi, Dialogs,
  FWZipReader,
  UnitChangelogForm, BaseUtils, Downloader, LauncherPaths, updater_exe;

{$R *.dfm}

procedure DownloadNewLauncher;
var
  Data: TDownloadData;
begin
  ForceDirectories(Paths.Updates);
  with Data do
  begin
    WndHandle := UpdaterForm.Handle;
    URL := LauncherVersionInfo.S['Link'];
    FileName := Paths.Updates + 'simpleLauncher.zip';
    Notify := False;
    Downloaded := 0;
  end;
  Download(Data);
end;

procedure ExtractNewLauncher;
var
  Zip: TFWZipReader;
  ZipPath: String;
  I: Integer;
begin
  ZipPath := Paths.Updates + 'simpleLauncher.zip';
  Zip := TFWZipReader.Create;
  try
    Zip.LoadFromFile(ZipPath);
    I := Zip.GetElementIndex('simpleLauncher.exe');
    if I = -1 then
      raise Exception.Create('There is no file with name "simpleLauncher.exe"');
    Zip.Item[I].Extract(ExtractFileDir(ZipPath), '');
    SysUtils.DeleteFile(ZipPath);
  finally
    FreeAndNil(Zip);
  end;
end;

procedure UnpackUpdater;
begin
  with TStringStream.Create do
    try
      WriteString(updater_exe_bytes);
      SaveToFile(Paths.Updates + 'updater.exe');
    finally
      Free;
    end;
end;

procedure LaunchUpdater;
var
  CmdString, Path: String;
begin
  Path := Paths.Updates + 'updater.exe';
  CmdString := '--replace "' + Paths.Updates + 'simpleLauncher.exe" "' + ParamStr(0) + '"';

  ShellExecute(0, 'Open', PChar(Path), PChar(CmdString), PChar(Paths.Updates), 5);
end;

procedure TUpdaterForm.ButtonDownloadClick(Sender: TObject);
var
  ZipPath: String;
begin
  ZipPath := Paths.Updates + 'simpleLauncher.zip';
  try
    // Загружаем архив по ссылке
    DownloadNewLauncher;
  except
    on E: Exception do
    begin
      ShowMessage('Произошла ошибка при загрузке нового лаунчера.' + #10#10 + E.Message);
      Exit;
    end;
  end;
  try
    // Распаковываем лаунчер рядом и удаляем архив
    ExtractNewLauncher;
  except
    on E: Exception do
    begin
      ShowMessage('Произошла ошибка при распаковке нового лаунчера.' + #10#10 + E.Message);
      Exit;
    end;
  end;
  try
    UnpackUpdater;
  except
    on E: Exception do
    begin
      ShowMessage('Произошла ошибка при распаковке апдейтера.' + #10#10 + E.Message);
      Exit;
    end;
  end;
  LaunchUpdater;
  Application.Terminate;
end;

procedure TUpdaterForm.ButtonViewChangesClick(Sender: TObject);
var
  List: TStringList;
begin
  Application.CreateForm(TChangelogForm, ChangelogForm);
  try
    List := SuperArray2StringList(LauncherVersionInfo.A['Changelog']);
    ChangelogForm.Memo.Lines.Assign(List);
    FreeAndNil(List);
    ChangelogForm.ShowModal;
  finally
    FreeAndNil(ChangelogForm);
  end;
end;

procedure TUpdaterForm.DownloadHandlerFinish(var Message: TMessage);
begin
  with ProgressBar do
  begin
    Max := 0;
    Position := 0;
  end;
end;

procedure TUpdaterForm.DownloadHandlerIdle(var Message: TMessage);
var
  Data: TDownloadData;
begin
  Data := TDownloadData(Pointer(Message.LParam)^);
  with ProgressBar, Data do
  begin
    Max := FileSize;
    Position := Downloaded;
  end;
end;

procedure TUpdaterForm.FormCreate(Sender: TObject);
begin
  with LauncherVersionInfo do
  begin
    LabelVersion.Caption := S['VersionString'];
    LabelDate.Caption := S['Date'];
    if not Assigned(A['Changelog']) then
      ButtonViewChanges.Enabled := False;
  end;
end;

end.
