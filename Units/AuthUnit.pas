unit AuthUnit;

interface

uses
  SysUtils;

type
  EAuthException = class(Exception);
  EInvalidResponseException = class(EAuthException);
  EServerException = class(EAuthException);
  EInvalidCredentialsException = class(EServerException);

  Auth = class
  private
    class procedure SetAT(Value: String); static;
    class procedure SetCT(Value: String); static;
    class procedure SetUUID(Value: String); static;
    class procedure SetNick(Value: String); static;
    class procedure SetUT(Value: String); static;
    class procedure SetLoggedIn(Value: Boolean); static;

    class function GetAT: String; static;
    class function GetCT: String; static;
    class function GetUUID: String; static;
    class function GetNick: String; static;
    class function GetUT: String; static;
    class function GetLoggedIn: Boolean; static;

    class procedure Invalidate;
    class procedure ClearData;
  public
    class procedure LogIn(const ALogin, APass: String);
    class procedure CheckTokens;
    class procedure Refresh;
    class procedure LogOut;

    class property AccessToken: String read GetAT write SetAT;
    class property ClientToken: String read GetCT write SetCT;
    class property UUID: String read GetUUID write SetUUID;
    class property Nick: String read GetNick write SetNick;
    class property UserType: String read GetUT write SetUT;
    class property LoggedIn: Boolean read GetLoggedIn write SetLoggedIn;
  end;

const
  AuthSrv = 'authserver.mojang.com';
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  AuthURL = AuthSrv + '/authenticate';
  AuthData = '{"agent":{"name":"Minecraft","version":1}}';
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  InvalidateURL = AuthSrv + '/invalidate';
  InvalidateData = '{"accessToken":"%s","clientToken":"%s"}';
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  RefreshURL = AuthSrv + '/refresh';
  RefreshData = InvalidateData;
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

implementation

uses
  SuperObject, HTTPPost, UnitLauncherForm, Windows, LauncherSettings,
  Logging, Classes, UnitLoginThread;

function IsValidToken(Token: String): Boolean;
const
  Valids = ['0'..'9', 'a'..'f'];
var
  C: Char;
begin
  Result := False;
  if Token.Length <> 32 then
    Exit;
  Token := LowerCase(Token);
  for C in Token do
    if not CharInSet(C, Valids) then
      Exit;
  Result := True;
end;

{ Auth }

class procedure Auth.LogIn(const ALogin, APass: String);
begin
  with TLoginThread.Create(True) do
  begin
    Login := ALogin;
    Pass := APass;
    FreeOnTerminate := True;
    Start;
  end;
end;

class procedure Auth.ClearData;
begin
  LoggedIn := False;
  AccessToken := '';
  ClientToken := '';
  UUID := '';
  Nick := '';
  UserType := '';
end;

class function Auth.GetAT: String;
begin
  Result := Settings.Profile.S['AccessToken'];
end;

class function Auth.GetCT: String;
begin
  Result := Settings.Profile.S['ClientToken'];
end;

class function Auth.GetLoggedIn: Boolean;
begin
  Result := Settings.Profile.B['LoggedIn'];
end;

class function Auth.GetNick: String;
begin
  if LoggedIn and (Settings.Profile.I['LoginMode'] = 1) then
    Result := Settings.Profile.S['MojangNick']
  else
    Result := Settings.Profile.S['CurrentNick'];
end;

class function Auth.GetUT: String;
begin
  Result := Settings.Profile.S['MojangUserType'];
end;

class function Auth.GetUUID: String;
begin
  Result := Settings.Profile.S['UUID'];
end;

class procedure Auth.Invalidate;
begin
  try
    POST(InvalidateURL, Format(InvalidateData, [AccessToken, ClientToken]));
    Log('Tokens invalidated.');
  except
    on E: Exception do
    begin
      LogE(E);
      Log('Unable to invalidate tokens.');
    end;
  end;
end;

class procedure Auth.LogOut;
begin
  Log('Loggnig out...');
  try
    Invalidate;
  finally
    ClearData;
  end;
end;

class procedure Auth.Refresh;
var
  Resp: ISuperObject;
  RespStr, NewToken: String;
begin
  try
    CheckTokens;
    if not LoggedIn then
      raise Exception.Create('Not logged in.');
    RespStr := POST(RefreshURL, Format(RefreshData, [AccessToken, ClientToken]));
    Resp := SO(RespStr);
    if not Assigned(Resp) or (RespStr = '') then
      raise EInvalidResponseException.Create('Invalid server response.');
    if Resp.S['error'] = 'ForbiddenOperationException' then
    begin
      ClearData;
      SendMessage(LauncherForm.Handle, LM_AUTH_STATE_CHANGED, 0, 0);
      raise Exception.Create(Resp.S['errorMessage']);
    end;
    NewToken := Resp.S['accessToken'];
    if IsValidToken(NewToken) then
      AccessToken := NewToken
    else
      raise EInvalidResponseException.Create('Responded token is invalid.');
    Log('Access token refreshed.');
  except
    on E: Exception do
    begin
      LogE(E);
      Log('Unable to refresh access token.');
    end;
  end;
end;

class procedure Auth.SetAT(Value: String);
begin
  Settings.Profile.S['AccessToken'] := Value;
end;

class procedure Auth.SetCT(Value: String);
begin
  Settings.Profile.S['ClientToken'] := Value;
end;

class procedure Auth.SetLoggedIn(Value: Boolean);
begin
  Settings.Profile.B['LoggedIn'] := Value;
end;

class procedure Auth.SetNick(Value: String);
begin
  Settings.Profile.S['MojangNick'] := Value;
end;

class procedure Auth.SetUT(Value: String);
begin
  Settings.Profile.S['MojangUserType'] := Value;
end;

class procedure Auth.SetUUID(Value: String);
begin
  Settings.Profile.S['UUID'] := Value;
end;

class procedure Auth.CheckTokens;
begin
  SendMessage(LauncherForm.Handle, LM_AUTH_AUTOVALID_STATED, 0, 0);
  if IsValidToken(AccessToken) and IsValidToken(ClientToken) then
    Log('Access token is valid.')
  else
  begin
    Log('Access token is invalid.');
    ClearData;
  end;
  SendMessage(LauncherForm.Handle, LM_AUTH_STATE_CHANGED, 0, 0);
end;

end.
