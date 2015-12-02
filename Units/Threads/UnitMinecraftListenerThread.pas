unit UnitMinecraftListenerThread;

interface

uses
  Classes, PipesAPI;

type
  TOnListen = procedure(const Listened: String) of object;

  TMinecraftListenerThread = class(TThread)
  private
    Msg: String;
    FOnListen: TOnListen;
    procedure UpdateForm;
  protected
    procedure Execute; override;
  public
    SleepDelay: Integer;
    property OnListen: TOnListen write FOnListen;
  end;

var
  MinecraftListener: TMinecraftListenerThread;
  PipeInfo: TPipeInformation;

implementation

uses
  SysUtils;

function GetTabSize(const FullLen, MsgLen: Byte): Byte;
begin
  { FullLen - длина полоски, MsgLen - длина сообщения. }
  { Вернёт такую длину отступа, при которой
    сообщение расположится посередине полоски. }
  Result := FullLen div 2 - MsgLen div 2;
end;

function GenerateStripe(const Pat: String; Count: Byte): String;
var
  B: Byte;
begin
  { Pat - строка для повторения, Count - количество повторений. }
  { Вернёт строку, созданную повторением паттерна Count раз. }
  Result := '';
  for B := 1 to Count do
    Result := Result + Pat;
end;

function GetFancyMessage(const Msg: String): String;
var
  Stripe, Tab: String;
begin
  Stripe := GenerateStripe('- ', 38);
  Tab := GenerateStripe(' ', GetTabSize(Length(Stripe), Length(Msg)));
  Result := Stripe + #13#10 + Tab + Msg + #13#10 + Stripe;
end;

{ TMinecraftListenerThread }

procedure TMinecraftListenerThread.Execute;
begin
  inherited;

  Msg := GetFancyMessage('START OF MINECRAFT LOG');
  Synchronize(UpdateForm);

  while not Terminated do
  begin
    // STD_ERR
    Msg := ReadConsoleW(PipeInfo.ReadStdErr);

    if Length(Msg) > 0 then
    begin
      Msg := AdjustLineBreaks(Msg);

      // Если в конце #10, то удаляем (перевод автоматически добавится потом)
      if Msg[Length(Msg)] = #10 then
        Msg := Copy(Msg, 1, Length(Msg) - 2);

      // Пишем в лог
      Synchronize(UpdateForm);
    end;

    // STD_OUT
    Msg := ReadConsoleW(PipeInfo.ReadStdOut);

    if Length(Msg) > 0 then
    begin
      Msg := AdjustLineBreaks(Msg);

      // Если в конце #10, то удаляем (перевод автоматически добавится потом)
      if Msg[Length(Msg)] = #10 then
        Msg := Copy(Msg, 1, Length(Msg) - 2);

      // Пишем в лог
      Synchronize(UpdateForm);
    end;

    if SleepDelay <> 0 then
      Sleep(SleepDelay);
  end;

  Msg := GetFancyMessage('END OF MINECRAFT LOG');
  Synchronize(UpdateForm);

  MinecraftListener := nil;
end;

procedure TMinecraftListenerThread.UpdateForm;
begin
  if Assigned(FOnListen) then
    FOnListen(Msg);
end;

end.
