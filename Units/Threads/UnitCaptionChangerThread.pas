unit UnitCaptionChangerThread;

interface

uses
  Classes;

type
  TCaptionChangerThread = class(TThread)
  private
    FInterval: Integer;
    FIndex: Integer;
    FStrings: TStringList;
  protected
    procedure Execute; override;
  public
    constructor Create(AInterval: Integer; AStrings: TStringList);
  end;

implementation

uses
  UnitLauncherForm;

{ TCaptionChangerThread }

constructor TCaptionChangerThread.Create(AInterval: Integer; AStrings: TStringList);
begin
  inherited Create;

  FreeOnTerminate := True;
  FIndex := 0;

  FInterval := AInterval;
  FStrings := AStrings;
end;

procedure TCaptionChangerThread.Execute;
var
  I: Integer;
begin
  //Sleep(1000);

  while True do
    for I := 0 to FStrings.Count - 1 do
    begin
      Synchronize(procedure begin LauncherForm.Caption := FStrings[I]; end);
      Sleep(FInterval);
    end;
end;

end.
