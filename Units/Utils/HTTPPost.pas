unit HTTPPost;

interface

function POST(const URL, Data: String): String;

implementation

uses
  WinInet, Windows, SysUtils, BaseUtils, Classes;

type
  EInternetException = class(Exception);

function SetOnline: Boolean;
var
  CI: INTERNET_CONNECTED_INFO;
begin
    FillChar(CI, SizeOf(CI), #0);
    CI.dwConnectedState := INTERNET_STATE_CONNECTED;
    Result :=
      InternetSetOption(nil, INTERNET_OPTION_CONNECTED_STATE, @CI, SizeOf(CI));
end;

function sslPOSTA(const Server, URL, Data: AnsiString): AnsiString;
const
  StrCantSend = 'Не могу отправить запрос. Проверьте подключение к интернету.';
  StrCantRead = 'Не могу считать данные, проверьте подключение к интернету!';
  Headers2: AnsiString =
    'User-Agent: simpleLauncher'#13#10 +
    'Content-Type: application/json'#13#10 +
    #13#10;
var
  Buffer: array [0 .. 4096] of AnsiChar;
  Readed: Cardinal;
  Headers: AnsiString;
  Stream: TMemoryStream;
  hInet, hConnect, hRequest: HINTERNET;
begin
  Result := '';

  SetOnline;

  hInet := InternetOpenA(nil, INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
  hConnect := InternetConnectA(hInet, PAnsiChar(Server), 443, nil, nil, 3, 0, 0);
  hRequest := HTTPOpenRequestA(hConnect, PAnsiChar('POST'), PAnsiChar(URL), nil, nil, nil, $800000 or $400000, 0);

  Headers := 'Host: ' + Server + #13#10 + Headers2;
  HttpAddRequestHeadersA(hRequest, PAnsiChar(Headers), Length(Headers), $20000000);

  Stream := TMemoryStream.Create;
  try
    if HTTPSendRequestA(hRequest, nil, 0, Pointer(Data), Length(Data)) then
    begin
      repeat
        if not InternetReadFile(hRequest, @Buffer, SizeOf(Buffer), Readed) then
          raise EInternetException.Create(StrCantRead);
        Stream.Write(Buffer, Readed);
      until Readed = 0;
      Buffer[0] := #0;
      Stream.Write(Buffer, 1);
      Result := PAnsiChar(Stream.Memory);
    end
    else
      raise EInternetException.Create(StrCantSend);
  finally
    Stream.Free;
    InternetCloseHandle(hRequest);
    InternetCloseHandle(hConnect);
    InternetCloseHandle(hInet);
  end;
end;

function POST(const URL, Data: String): String;
begin
  Result := String(
    sslPOSTA(
      AnsiString(Copy(URL, 1, CstmPos(URL, '/') - 1)),
      AnsiString(Copy(URL, CstmPos(URL, '/') + 1, Length(URL))),
      AnsiString(Data)
    )
  );
end;

end.
