unit NickValidator;

interface

function IsValidNick(const Nick: String): Boolean;

implementation

uses
  SysUtils;

function IsValidNick(const Nick: String): Boolean;
const
  Valids = ['A' .. 'Z', 'a' .. 'z', '0' .. '9', '_'];
var
  C: Char;
begin
  Result := False;

  if Nick = '' then
    Exit;

  for C in Nick do
    if not CharInSet(C, Valids) then
      Exit;

  Result := True;
end;

end.
