unit PipesAPI;

interface

uses Windows;

type
  TPipeInformation = record
    StdIn: THandle;
    WriteStdIn: THandle;
    StdOut: THandle;
    ReadStdOut: THandle;
    StdErr: THandle;
    ReadStdErr: THandle;
    ProcessInfo: TProcessInformation;
  end;

const
  REDIRECT_INPUT  = 1;  // Перенаправлять только ввод
  REDIRECT_OUTPUT = 2;  // Перенаправлять только вывод
  REDIRECT_ALL    = 3;  // Перенаправлять всё

function CreatePipes(ExecObject, CommandLine, CurrentDir: PWideChar;
  ShowWindow: LongWord; RedirectType: byte;
  out PipeInformation: TPipeInformation): LongBool;

function GetOutputPipeDataSize(ReadStdOut: THandle): LongWord;

function ReadPipe(ReadStdOut: THandle; Buffer: pointer; BytesToRead: LongWord;
  out BytesRead: LongWord): LongBool;

function WritePipe(WriteStdIn: THandle; Buffer: pointer; BytesToWrite: LongWord;
  out BytesWritten: LongWord): LongBool;

procedure DestroyPipes(StdIn, WriteStdIn, StdOut, ReadStdOut: THandle);

procedure DestroyConsole(ProcessHandle, ThreadHandle: THandle);

function ConvertToAnsi(OEM: PAnsiChar): PAnsiChar;

function ConvertToOEM(Ansi: PAnsiChar): PAnsiChar;

function ReadConsole(ReadStdOut: THandle): AnsiString;

function ReadConsoleW(ReadStdOut: THandle): String;

function WriteConsole(WriteStdIn: THandle; Command: AnsiString): LongWord;

implementation

function CreatePipes(ExecObject, CommandLine, CurrentDir: PWideChar;
  ShowWindow: LongWord; RedirectType: Byte;
  out PipeInformation: TPipeInformation): LongBool;
var
  SecurityAttributes: TSecurityAttributes;
  StdIn, WriteStdIn, StdOut, ReadStdOut, StdErr, ReadStdErr: THandle;
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
begin
  SecurityAttributes.nLength := SizeOf(SecurityAttributes);
  SecurityAttributes.lpSecurityDescriptor := nil;
  SecurityAttributes.bInheritHandle := true;

  // Пайп для StdIn:
  if not CreatePipe(StdIn, WriteStdIn, @SecurityAttributes, 0) then
  begin
    Result := false;
    Exit;
  end;

  // Пайп для StdOut:
  if not CreatePipe(ReadStdOut, StdOut, @SecurityAttributes, 0) then
  begin
    Result := false;
    Exit;
  end;

    // Пайп для StdOut:
  if not CreatePipe(ReadStdErr, StdErr, @SecurityAttributes, 0) then
  begin
    Result := false;
    Exit;
  end;

  // Пайпы созданы, создаём процесс:
  FillChar(StartupInfo, SizeOf(StartupInfo), #0);
  StartupInfo.cb := SizeOf(StartupInfo);
  StartupInfo.wShowWindow := ShowWindow;

  // Перенаправление ввода:
  if (RedirectType and REDIRECT_INPUT) = REDIRECT_INPUT then
    StartupInfo.hStdInput := StdIn;

  // Перенаправление вывода:
  if (RedirectType and REDIRECT_OUTPUT) = REDIRECT_OUTPUT then
  begin
    StartupInfo.hStdOutput := StdOut;
    StartupInfo.hStdError := StdErr;
  end;

  StartupInfo.dwFlags := STARTF_USESTDHANDLES;// or STARTF_USESHOWWINDOW;

  Result := CreateProcess(ExecObject, CommandLine, nil, nil, True, 0, nil,
    CurrentDir, StartupInfo, ProcessInfo);

  // Процесс создан, возвращаем результат:
  FillChar(PipeInformation, SizeOf(PipeInformation), #0);
  if Result then
  begin
    PipeInformation.StdIn := StdIn;
    PipeInformation.StdOut := StdOut;
    PipeInformation.WriteStdIn := WriteStdIn;
    PipeInformation.ReadStdOut := ReadStdOut;
    PipeInformation.StdErr := StdErr;
    PipeInformation.ReadStdErr := ReadStdErr;
    PipeInformation.ProcessInfo := ProcessInfo;
  end;
end;

function GetOutputPipeDataSize(ReadStdOut: THandle): LongWord;
var
  BytesRead, AvailToRead: LongWord;
begin
  if not PeekNamedPipe(ReadStdOut, nil, 0, @BytesRead, @AvailToRead, nil) then
    Result := 0
  else
    Result := AvailToRead;
end;

function ReadPipe(ReadStdOut: THandle; Buffer: pointer; BytesToRead: LongWord;
  out BytesRead: LongWord): LongBool;
var
  AvailToRead: LongWord;
begin
  // Проверяем, есть ли данные в пайпе:
  if not PeekNamedPipe(ReadStdOut, nil, 0, @BytesRead, @AvailToRead, nil) then
    AvailToRead := 0;

  // Если есть, то читаем:
  if AvailToRead > 0 then
  begin
    Result := ReadFile(ReadStdOut, Buffer^, BytesToRead, BytesRead, nil);
  end
  else
  begin
    Result := false;
    BytesRead := 0;
  end;
end;

function WritePipe(WriteStdIn: THandle; Buffer: pointer; BytesToWrite: LongWord;
  out BytesWritten: LongWord): LongBool;
begin
  Result := WriteFile(WriteStdIn, Buffer^, BytesToWrite, BytesWritten, nil);
end;

procedure DestroyPipes(StdIn, WriteStdIn, StdOut, ReadStdOut: THandle);
begin
  CloseHandle(StdIn);
  CloseHandle(WriteStdIn);
  CloseHandle(StdOut);
  CloseHandle(ReadStdOut);
end;

procedure DestroyConsole(ProcessHandle, ThreadHandle: THandle);
begin
  TerminateProcess(ProcessHandle, 0);
  CloseHandle(ThreadHandle);
  CloseHandle(ProcessHandle);
end;

function WriteConsole(WriteStdIn: THandle; Command: AnsiString): LongWord;
var
  Size: LongWord;
  Buffer: PAnsiChar;
  BytesWritten: LongWord;
begin
  Command := Command + #13#10;
  Size := Length(Command);
  Buffer := PAnsiChar(Command);
  WritePipe(WriteStdIn, Buffer, Size, BytesWritten);
  Result := BytesWritten;
end;

function ReadConsole(ReadStdOut: THandle): AnsiString;
var
  BufferSize: LongWord;
  Buffer: Pointer;
  BytesRead: LongWord;
begin
  Result := '';
  BufferSize := GetOutputPipeDataSize(ReadStdOut);
  if BufferSize <= 0 then Exit;

  GetMem(Buffer, BufferSize + 2);
  FillChar(Buffer^, BufferSize + 2, #0);
  if ReadPipe(ReadStdOut, Buffer, BufferSize, BytesRead) then
    Result := PAnsiChar(Buffer)
  else
    Result := '';

  FreeMem(Buffer);
end;

function ReadConsoleW(ReadStdOut: THandle): String;
begin
  Result := String(ReadConsole(ReadStdOut));
end;

//------------------------------------------------------------------------------

function ConvertToAnsi(OEM: PAnsiChar): PAnsiChar;
begin
  OemToAnsi(OEM, OEM);
  Result := OEM;
end;

function ConvertToOEM(Ansi: PAnsiChar): PAnsiChar;
begin
  AnsiToOem(Ansi, Ansi);
  Result := Ansi;
end;

end.
