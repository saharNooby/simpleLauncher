unit UnitLoginThread;

interface

uses
  System.Classes, SuperObject;

type
  TLoginThread = class(TThread)
  private
    function GetResponse: ISuperObject;
  protected
    procedure Execute; override;
  public
    Login, Pass: String;
  end;

implementation

uses
  SysUtils, Windows,
  Logging, AuthUnit, HTTPPost, UnitLauncherForm, LauncherStrings;

{ TLoginThread }

procedure TLoginThread.Execute;
var
  Resp: ISuperObject;
begin
  inherited;
  try
    Log(Self, 'Logging in with username and password...');

    Resp := GetResponse;

    if not Assigned(Resp) or (Resp.S['ResponceString'] = '') then
      raise EInvalidResponseException.Create(InvalidResponse);

    if Resp.S['error'] <> '' then
      if Resp.S['errorMessage'] = InvalidCredentials then
        raise EInvalidCredentialsException.Create(InvalidCredentialsRu)
      else
        raise EServerException.Create(Resp.S['errorMessage']);

    with Auth do
    begin
      UUID := Resp.O['selectedProfile'].S['id'];
      AccessToken := Resp.S['accessToken'];
      ClientToken := Resp.S['clientToken'];
      Nick := Resp.O['selectedProfile'].S['name'];
    end;

    if Resp.O['selectedProfile'].B['legacy'] then
      Auth.UserType := 'legacy'
    else
      Auth.UserType := 'mojang';

    Auth.LoggedIn := True;

    Log(Self, 'Logged in! Welcome, ' + Auth.Nick + '!');
  except
    on E: Exception do
    begin
      LogE(Self, E);
      Log(Self, 'Unable to login.');
      MessageBox(LauncherForm.Handle, PChar(LoginErrorMsg + E.Message),
        PChar('Ошибка авторизации!'), 0);
    end;
  end;
  SendMessage(LauncherForm.Handle, LM_AUTH_STATE_CHANGED, 0, 0);
end;

function TLoginThread.GetResponse: ISuperObject;
var
  Reqest: ISuperObject;
  Response: String;
begin
  Reqest := SO(AuthData);

  with Reqest do
  begin
    S['username'] := Login;
    S['password'] := Pass;
  end;

  Response := POST(AuthURL, Reqest.AsJSon(False));

  Result := SO(Response);
  Result.S['ResponceString'] := Response;
end;

end.
