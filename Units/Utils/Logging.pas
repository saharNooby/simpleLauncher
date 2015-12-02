unit Logging;

interface

uses
  SysUtils;

procedure Log(Source: TObject; const Msg: string; const MsgType: integer = 0);
  overload;

procedure Log(const Msg: string; const MsgType: integer = 0); overload;

procedure LogE(Source: TObject; E: Exception); overload;

procedure LogE(E: Exception); overload;

procedure LogF(Source: TObject; const Msg: string; Args: array of const;
  const MsgType: integer = 0); overload;

procedure LogF(const Msg: string; Args: array of const;
  const MType: integer = 0); overload;

implementation

uses
  Windows, UnitLauncherForm, SyncObjs;

var
  LogCritSection: TCriticalSection;

procedure Log(Source: TObject; const Msg: string; const MsgType: integer = 0);
const
  Prefs: array [0 .. 2] of String[3] = ('INF', 'ERR', 'WRN');
  Prefix = '[%s] [%s]';
  SrcPrefix = ' [%s]:';
var
  MsgStr: string;
begin
  MsgStr := Format(Prefix, [TimeToStr(Now), Prefs[MsgType]]);
  if Source <> nil then
    MsgStr := MsgStr + Format(SrcPrefix, [Source.ClassName]);
  MsgStr := MsgStr + ' ' + Msg;
  // Ќа вс€кий случай, чтобы не было проблем доступа
  LogCritSection.Acquire;
  try
    SendMessage(LauncherForm.Handle, LM_LOG, 0, Integer(PChar(MsgStr)));
  finally
    LogCritSection.Release;
  end;
end;

procedure Log(const Msg: string; const MsgType: integer = 0);
begin
  Log(nil, Msg, MsgType);
end;

procedure LogE(Source: TObject; E: Exception);
begin
  LogF(Source, 'Raised exception "%s" with message "%s".', [E.ClassName, E.Message], 1);
end;

procedure LogE(E: Exception);
begin
  LogE(nil, E);
end;

procedure LogF(Source: TObject; const Msg: string; Args: array of const;
  const MsgType: integer = 0);
begin
  Log(Source, Format(Msg, Args), MsgType);
end;

procedure LogF(const Msg: string; Args: array of const; const MType: Integer = 0);
begin
  Log(Format(Msg, Args), MType);
end;

initialization

  LogCritSection := TCriticalSection.Create;

finalization

  LogCritSection.Free;

end.
