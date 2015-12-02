unit TypeTDownloadableVersion;

interface

uses
  SuperObject;

type
  TVerType = 0 .. 3;

const
  vtVanilla: TVerType = 0;
  vtOptiFine: TVerType = 1;
  vtLiteLoader: TVerType = 2;
  vtOptiFineLiteLoader: TVerType = 3;

type
  TRemoteVersion = class
  private
    FData: ISuperObject;
    FType: TVerType;
  public
    constructor Create(const AData: ISuperObject; const AType: TVerType);
    function ID: String;
    property VerType: TVerType read FType;
    property Data: ISuperObject read FData;
  end;

implementation

var
  Instances: array of TRemoteVersion;

procedure FreeInstances;
var
  Str: TRemoteVersion;
begin
  for Str in Instances do
    Str.Free;
end;

constructor TRemoteVersion.Create;
begin
  inherited Create;

  FData := AData.Clone;
  FType := AType;

  SetLength(Instances, Length(Instances) + 1);
  Instances[Length(Instances) - 1] := Self;
end;

function TRemoteVersion.ID: String;
begin
  Result := FData.S['id']
end;

initialization

  SetLength(Instances, 0);

finalization

  // Очистка всех ранее созданных объектов
  FreeInstances;

end.
