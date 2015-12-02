unit BaseUtils;

interface

uses
  Windows, Classes, SuperObject;

type
  PSuperObject = ^ISuperObject;

function SO2StringList(const Obj: ISuperObject): TStringList;

function MergeObjs(const Arr: array of ISuperObject): ISuperObject;

function FileExsitsInPaths(const FileName: String): Boolean;

procedure StartThread(const Proc: TFNThreadStartRoutine; const Name: String = 'Unnamed');

function ObjectExists(Parent: ISuperObject; const Name: string): Boolean;

procedure StringList2SuperArray(const List: TStringList; Arr: TSuperArray);

function SuperArray2StringList(const Arr: TSuperArray): TStringList;

function GetNormalDate(const DateTime: string): string;

function CstmPos(const Str: string; const SubStr: string): Integer;

function CopyFile(const Src, Trg: string): Boolean;

procedure RemoveDirectory(const Dir: string);

function ExtParse(const FileName: string; Obj: PSuperObject): Boolean;

function GetSHA1(const FileName: string): String;

implementation

uses
  SysUtils, Logging, LauncherStrings, Dialogs, DCPsha1;

function SO2StringList(const Obj: ISuperObject): TStringList;
var
  Enum: TSuperAvlIterator;
begin
  Result := TStringList.Create;

  if not Assigned(Obj) then
    Exit;

  try
    Enum := Obj.AsObject.GetEnumerator;

    Enum.First;

    if Enum.Current <> nil then
      repeat
        Result.Add(Enum.Current.Name);
      until not Enum.MoveNext;
  finally
    FreeAndNil(Enum);
  end;
end;

function MergeObjs(const Arr: array of ISuperObject): ISuperObject;
var
  ObjToMerge: ISuperObject;
begin
  Result := nil;
  if Length(Arr) > 1 then
  begin
    Result := Arr[0].Clone;
    for ObjToMerge in Arr do
      if Assigned(ObjToMerge) then
        Result.Merge(ObjToMerge);
  end;
end;

function ClearPath(Path: String): String;
var
  EVar, LPart, RPart: String;
begin
  Result := Path;

  if CstmPos(Path, '%') <> 0 then
  begin
    EVar := Path;
    LPart := Copy(EVar, 1, CstmPos(EVar, '%') - 1);
    Delete(EVar, 1, CstmPos(EVar, '%'));
    if CstmPos(EVar, '%') <> 0 then
    begin
      RPart := Copy(EVar, CstmPos(EVar, '%') + 1, Length(EVar));
      Delete(EVar, CstmPos(EVar, '%'), Length(EVar));
    end
    else
      Exit;
    Path := LPart + GetEnvironmentVariable(EVar) + RPart;
  end
  else
    Exit;

  Result := ClearPath(Path);
end;

function FileExsitsInPaths(const FileName: String): Boolean;
var
  PATH: String;
  List: TStringList;
  I: Integer;
begin
  // Если есть :, то указан диск, а значит, путь полный и можно не искать
  if CstmPos(FileName, ':') <> 0 then
    Exit(FileExists(FileName));

  Result := False;

  // Получаем все пути для поиска
  PATH := GetEnvironmentVariable('PATH');
  if PATH = '' then
    Exit;
  List := TStringList.Create;

  // Парсим строку в список путей
  while CstmPos(PATH, ';') <> 0 do
  begin
    List.Add(Copy(PATH, 1, CstmPos(PATH, ';') - 1));
    Delete(PATH, 1, CstmPos(PATH, ';'));
  end;
  List.Add(PATH);

  // Очищая строки от переменных среды и вствляя на конце слешы,
  // ищем в полученных путях нужные файлы.
  for I := 0 to List.Count - 1 do
  begin
    List[I] := ClearPath(List[I]);
    if List[I][Length(List[I])] <> '\' then
      List[I] := List[I] + '\';
    if FileExists(List[I] + Filename) then
      Exit(True);
  end;
end;

procedure StartThread(const Proc: TFNThreadStartRoutine; const Name: String = 'Unnamed');
var
  ThreadId: Cardinal;
begin
  CloseHandle(CreateThread(nil, 0, Proc, nil, 0, ThreadId));
  Log('Started thread "' + Name + '" id ' + ThreadId.ToString);
end;

function ObjectExists(Parent: ISuperObject; const Name: string): boolean;
begin
  Result := Assigned(Parent.O[Name]);
end;

procedure StringList2SuperArray(const List: TStringList; Arr: TSuperArray);
var
  I: Integer;
begin
  Arr.Clear(True);
  for I := 0 to List.Count - 1 do
    Arr.S[I] := List[I];
end;

function SuperArray2StringList(const Arr: TSuperArray): TStringList;
var
  I: Integer;
begin
  Result := TStringList.Create;

  for I := 0 to Arr.Length - 1 do
    Result.Add(Arr.S[I]);
end;

function GetNormalDate(const DateTime: string): string;
var
  Date: string;
  D, M, Y: string;
begin
  if CstmPos(DateTime, 'T') <> 0 then
    Date := Copy(DateTime, 1, CstmPos(DateTime, 'T') - 1)
  else
    Date := DateTime;

  Y := Copy(Date, 1, CstmPos(Date, '-') - 1);
  Delete(Date, 1, Length(Y) + 1);

  M := Copy(Date, 1, CstmPos(Date, '-') - 1);
  Delete(Date, 1, Length(M) + 1);

  D := Date;

  Date := D + '.' + M + '.' + Y; // ƒень.ћес¤ц.√од
  if Date = '..' then
    Result := ''
  else
    Result := Date;
end;

function CstmPos(const Str: string; const SubStr: string): Integer;
var
  I, J: Integer;
begin
  Result := 0;

  if (Str = '') or (SubStr = '') then
    Exit;

  for I := 1 to Length(Str) do
    if Str[I] = SubStr[1] then
      if Length(SubStr) = 1 then
        Exit(I)
      else
        if (Length(Str) - I - 1) >= Length(SubStr) then
          for J := 2 to Length(SubStr) do
          begin
            if Str[I + J - 1] <> SubStr[J] then
              Break;
            if J = Length(SubStr) then
              Exit(I);
           end;
end;

function CopyFile(const Src, Trg: string): Boolean;
begin
  Result := CopyFileW(PWideChar(Src), PWideChar(Trg), False);
end;

// Рекуррентное удаление папок
procedure RemoveDirectory(const Dir: string);
var
  SR: TSearchRec;
begin
  if FindFirst(Dir + '*', faAnyFile, SR) = 0 then
  repeat
    if SR.Attr and faDirectory = 0 then
      SysUtils.DeleteFile(Dir + SR.Name)
    else
      if (SR.Name <> '.') and (SR.Name <> '..') then
        RemoveDirectory(Dir + SR.Name + '\');
  until FindNext(SR) <> 0;
  SysUtils.FindClose(SR);

  RemoveDir(Dir);
end;

function ExtParse(const FileName: string; Obj: PSuperObject): Boolean;
begin
  try
    Obj^ := TSuperObject.ParseFile(FileName, True);
  except
    on E: EFOpenError do
      LogF(StrLogFileNotFound, [FileName], 1);
    on E: Exception do
      LogE(E);
  end;
  Result := Assigned(Obj^);
end;

function GetSHA1(const FileName: string): String;
var
  Source: TFileStream;
  SHA1: TDCP_sha1;
  Digest: array [0 .. 19] of Byte; // Хэш как число
  Digit: Byte;
begin
  Result := '';
  try
    Source := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  except
    LogF('[Hash] Unable to open file "%s".', [FileName], 1);
    Exit;
  end;

  SHA1 := TDCP_sha1.Create(nil);
  try
    with SHA1 do
    begin
      Init;
      UpdateStream(Source, Source.Size);
      Final(Digest);
    end;
    for Digit in Digest do
      Result := Result + IntToHex(Digit, 2); // БАЙТ = 2 СИМВОЛА
    Result := LowerCase(Result);
  except
    on E: Exception do
    begin
      LogE(E);
      LogF('Unable to open file "%s" and calculate it''s hash.', [FileName], 1);
    end;
  end;
  FreeAndNil(SHA1);
  FreeAndNil(Source);
end;

end.
