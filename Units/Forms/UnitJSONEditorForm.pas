unit UnitJSONEditorForm;

interface

uses
  Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Controls, System.Classes;

type
  TJSONEditorForm = class(TForm)
    Label1: TLabel;
    Memo: TMemo;
    SaveButton: TButton;
    CancelButton: TButton;
    procedure SaveButtonClick(Sender: TObject);
  public
    VersionName: String;
  end;

var
  JSONEditorForm: TJSONEditorForm;

implementation

{$R *.dfm}

uses
  System.UITypes,
  SuperObject,
  LauncherStrings, LauncherPaths;

procedure TJSONEditorForm.SaveButtonClick(Sender: TObject);
var
  Obj: ISuperObject;
begin
  Obj := SO(Memo.Text);

  if not Assigned(Obj) then
  begin
    if MessageDlg(StrJSONContainsErrors, mtWarning, mbOkCancel, 0) <> 1 then
      Exit;
    Close;
    Exit;
  end;

  Obj.SaveTo(Paths.json(VersionName), True);

  Close;
end;

end.
