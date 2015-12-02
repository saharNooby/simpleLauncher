unit TypeTMinecraftVersions;

interface

uses
  Classes;

type
  TMinecraftVersions = class
  public
    R: TStringList; // Releases
    S: TStringList; // Snapshots
    B: TStringList; // Beta
    A: TStringList; // Alpha
    constructor Create;
    destructor Destroy; override;
    function Filled: Boolean;
    function GetListByName(const Name: String): TStringList;
  end;

implementation

constructor TMinecraftVersions.Create;
begin
  inherited Create;
  R := TStringList.Create;
  S := TStringList.Create;
  B := TStringList.Create;
  A := TStringList.Create;
end;

destructor TMinecraftVersions.Destroy;
begin
  R.Free;
  S.Free;
  B.Free;
  A.Free;
  inherited Destroy;
end;

function TMinecraftVersions.Filled: boolean;
begin
  Result := (R.Count <> 0) and (S.Count <> 0) and (B.Count <> 0) and
    (A.Count <> 0);
end;

function TMinecraftVersions.GetListByName(const Name: String): TStringList;
begin
  Result := nil;
  if Name = 'release' then
    Result := R
  else
    if Name = 'snapshot' then
      Result := S
    else
      if Name = 'old_beta' then
        Result := B
      else
        if Name = 'old_alpha' then
          Result := A;
end;

end.
