unit UnitLoginForm;

interface

uses
  Vcl.Forms, Vcl.StdCtrls, Vcl.Mask, Vcl.Controls, System.Classes, Vcl.ExtCtrls;

type
  TLoginForm = class(TForm)
    Login: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    ButtonOK: TButton;
    Pass: TEdit;
    Bevel1: TBevel;
    LinkLabel1: TLinkLabel;
    LinkLabel2: TLinkLabel;
    RegButton: TButton;
    Label3: TLabel;
    procedure LinkLabel1LinkClick(Sender: TObject; const Link: string;
      LinkType: TSysLinkType);
    procedure LinkLabel2LinkClick(Sender: TObject; const Link: string;
      LinkType: TSysLinkType);
    procedure RegButtonClick(Sender: TObject);
    procedure FieldChange(Sender: TObject);
  end;

var
  LoginForm: TLoginForm;

implementation

uses
  ShellApi, BaseUtils;

{$R *.dfm}

const
  MojangHelp = 'https://help.mojang.com/customer/portal/articles/';
  LoginLink = MojangHelp + '1233873';
  PassLink = MojangHelp + '329524-change-or-forgot-password';
  RegLink = 'https://account.mojang.com/register';

procedure TLoginForm.FieldChange(Sender: TObject);
begin
  ButtonOK.Enabled := (Login.Text <> '') and (Pass.Text <> '');
end;

procedure TLoginForm.LinkLabel1LinkClick(Sender: TObject; const Link: string;
  LinkType: TSysLinkType);
begin
  ShellExecute(0, 'Open', PWideChar(LoginLink), nil, nil, 5);
end;

procedure TLoginForm.LinkLabel2LinkClick(Sender: TObject; const Link: string;
  LinkType: TSysLinkType);
begin
  ShellExecute(0, 'Open', PWideChar(PassLink), nil, nil, 5);
end;

procedure TLoginForm.RegButtonClick(Sender: TObject);
begin
  ShellExecute(0, 'Open', PWideChar(RegLink), nil, nil, 5);
end;

end.
