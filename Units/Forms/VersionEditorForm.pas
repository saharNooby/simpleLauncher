unit VersionEditorForm;

interface

uses
  Vcl.Forms, Vcl.StdCtrls, SuperObject, LauncherPaths, Vcl.Controls,
  System.Classes;

type
  TFm_VersionEditor = class(TForm)
    Bt_Cancel: TButton;
    Bt_OK: TButton;
    Bt_OpenVersionsFolder: TButton;
    CB_Types: TComboBox;
    Ed_Args: TEdit;
    Ed_EdDate: TEdit;
    Ed_LVersion: TEdit;
    Ed_MainClass: TEdit;
    Ed_RelDate: TEdit;
    Ed_VersionID: TEdit;
    GB_Compatibility: TGroupBox;
    GB_LaunchSettings: TGroupBox;
    GB_VersionInfo: TGroupBox;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label1: TLabel;
    Label20: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    procedure Bt_OpenVersionsFolderClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  end;

var
  Fm_VersionEditor: TFm_VersionEditor;
  VersionObject: ISuperObject;

implementation

uses
  SysUtils, ShellApi, BaseUtils;

{$R *.dfm}

procedure TFm_VersionEditor.Bt_OpenVersionsFolderClick(Sender: TObject);
begin
  ShellExecute(0, 'Explore', PWideChar(Paths.Versions), nil, nil, 5);
end;

function IsValidVersionName(const S: string): Boolean;
const
  Invalids = ['\', '/', ':', '*', '?', '"', '<', '>', '|'];
var
  C: Char;
begin
  Result := True;

  if S = '' then
    Exit(False);

  for C in S do
    if CharInSet(C, Invalids) then
      Exit(False);
end;

procedure TFm_VersionEditor.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  with VersionObject do
  begin
    if IsValidVersionName(Ed_VersionID.Text) then
      S['id'] := Ed_VersionID.Text;
    S['mainClass'] := Ed_MainClass.Text;
    S['releaseTime'] := Ed_RelDate.Text;
    S['time'] := Ed_EdDate.Text;
    S['minecraftArguments'] := Ed_Args.Text;
    I['minimumLauncherVersion'] := StrToInt(Ed_LVersion.Text);
    S['type'] := CB_Types.Text;
  end;
end;

procedure TFm_VersionEditor.FormCreate(Sender: TObject);
begin
  if Assigned(VersionObject) then
    with VersionObject do
    begin
      Caption := SysUtils.Format(Caption, [S['id']]);
      Ed_VersionID.Text := S['id'];
      Ed_RelDate.Text := S['releaseTime'];
      Ed_EdDate.Text := S['time'];
      Ed_MainClass.Text := S['mainClass'];
      Ed_Args.Text := S['minecraftArguments'];
      Ed_LVersion.Text := Integer.ToString(I['minimumLauncherVersion']);
      CB_Types.ItemIndex := CB_Types.Items.IndexOf(S['type']);
    end
  else
    Close;
end;

end.
