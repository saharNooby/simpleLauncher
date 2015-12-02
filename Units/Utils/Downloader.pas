unit Downloader;

interface

uses
  Classes;

type
  TDownloadData = packed record
    WndHandle   : THandle;  { Хэндл формы для отправки сообщений }
    URL         : String;   { Ссылка на загрузку }
    FileName    : String;   { Имя файла для сохранения }
    Speed       : Single;   { Скорость загрузки (б/с) }
    FileSize    : Cardinal; { Размер файла в байтах (заполняется загрузчиком) }
    Downloaded  : Cardinal; { Сколько байт уже загружено }
    Notify      : Boolean;  { Уведомлять ли о том, что загружается файл }
  end;

var
  NowDownloading: Boolean = False;

procedure Download(Data: TDownloadData);

procedure FillInternetStream(const URL: String; const Stream: TStream);

function GetInternetString(const URL: String): String;

implementation

uses
  LauncherStrings, SysUtils, Exceptions, Windows, WinInet;

function SetOnline: Boolean;
var
  CI: INTERNET_CONNECTED_INFO;
begin
    FillChar(CI, SizeOf(CI), #0);
    CI.dwConnectedState := INTERNET_STATE_CONNECTED;
    Result :=
      InternetSetOption(nil, INTERNET_OPTION_CONNECTED_STATE, @CI, SizeOf(CI));
end;

function GetQueryInfo(Request: Pointer; Flag: Integer): String;
const
  TryCount = 3;
var
  Code: String;
  CodeSize, Index: Cardinal;
  Tryings: Byte;
begin
  SetLength(Code, 64);
  CodeSize := Length(Code);
  Result := '';
  Index := 0;

  for Tryings := 1 to TryCount do
    if HttpQueryInfo(Request, Flag, PChar(Code), CodeSize, Index) then
    begin
      Result := Code;
      Break;
    end
    else if GetLastError = ERROR_INSUFFICIENT_BUFFER then
    begin
      SetLength(Code, CodeSize);
      CodeSize := Length(Code);
    end;
end;

procedure Download(Data: TDownloadData);
const
  BufferSize = 1024 * 32;
var
  Stream: TMemoryStream;
  Buffer: array [1 .. BufferSize] of Byte;
  Readed: DWORD;
  hInet, hURL: HInternet;
  Code: Integer;
  TicksFreq, TicksBefore, TicksAfter: Int64;
  TimeElapsed: Single;
begin
  // Сообщение о начале загрузки
  SendMessage(Data.WndHandle, 1024 + $1, 0, LongWord(@Data));
  SetOnline;
  NowDownloading := Data.Notify;
  Stream := TMemoryStream.Create;
  hInet := InternetOpen(PChar('simpleLauncher ' + LauncherVersionString),
    INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
  hURL := InternetOpenURL(hInet, PChar(Data.URL), nil, 0,
    INTERNET_FLAG_RELOAD, 0);
  try
    try
      Data.FileSize := StrToInt(GetQueryInfo(hURL, HTTP_QUERY_CONTENT_LENGTH));
    except
      on EConvertError do
        // Переопределение сообщения
        raise Exception.Create('Server didn''t responded content length!');
      on Exception do
        raise;
    end;
    Stream.SetSize(Data.FileSize);
    try
      Code := StrToInt(GetQueryInfo(hURL, HTTP_QUERY_STATUS_CODE));
    except
      on EConvertError do
        // Переопределение сообщения
        raise Exception.Create('Server didn''t responded status code!');
      on Exception do
        raise;
    end;
    if (Code = 403) or (Code = 404) then
      raise EInvalidRespCode.CreateFmt('Responded %d', [Code]);
    repeat
      QueryPerformanceFrequency(TicksFreq);
      QueryPerformanceCounter(TicksBefore);
      if not InternetReadFile(hURL, @Buffer, SizeOf(Buffer), Readed) then
        raise EDownloadError.Create(StrExcInternetReadFile);
      if Readed <> 0 then
      begin
        QueryPerformanceCounter(TicksAfter);
        Data.Downloaded := Data.Downloaded + Readed;
        TimeElapsed := (TicksAfter - TicksBefore) / TicksFreq;
        if TimeElapsed <> 0 then
          Data.Speed := Readed / TimeElapsed;
        Stream.Write(Buffer, Readed);

        // Собщение о том, что часть файла загружена
        SendMessage(Data.WndHandle, 1024 + $2, 0, LongWord(@Data));
      end;
    until Readed = 0;
    Stream.SaveToFile(Data.FileName);
  finally
    NowDownloading := False;

    // Сообщение о том, что загрузка окончена
    SendMessage(Data.WndHandle, 1024 + $3, 0, LongWord(@Data));

    InternetCloseHandle(hURL);
    InternetCloseHandle(hInet);
    FreeAndNil(Stream);
  end;
end;

procedure FillInternetStream(const URL: String; const Stream: TStream);
const
  BufferSize = 1024 * 32;
var
  hSession, hURL: HInternet;
  Buffer: array [1 .. BufferSize] of Byte;
  BufferLen: DWORD;
begin
  // Открытие хэндлов
  hSession := InternetOpen(PChar('simpleLauncher'), 0, nil, nil, 0);
  hURL := InternetOpenURL(hSession, PChar(URL), nil, 0, $80000000, 0);
  try
    repeat
      if not InternetReadFile(hURL, @Buffer, SizeOf(Buffer), BufferLen) then
        raise EDownloadError.Create(StrExcInternetReadFile);
      Stream.Write(Buffer, BufferLen);
    until BufferLen = 0;
  finally
    InternetCloseHandle(hURL);
    InternetCloseHandle(hSession);
  end;
end;

function GetInternetString(const URL: String): String;
var
  Stream: TStringStream;
begin
  Result := '';
  Stream := TStringStream.Create;
  try
    FillInternetStream(URL, Stream);
    Result := Stream.DataString;
  finally
    Stream.Free;
  end;
end;

end.
