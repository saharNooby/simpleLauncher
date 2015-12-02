unit IndexesManagerClass;

interface

uses
  SuperObject, SysUtils, Classes;

type
  IndexesManager = class
  public
    class function GetIndexes: TStringList;
    class procedure GetNames(const IndexPath: String);
    class procedure Move(IndexPath: String; Names: TStringList; AssetsType: Boolean);
  end;

implementation

uses
  LauncherPaths, BaseUtils,
  UnitLauncherForm, UnitIndexListerThread;

{ IndexesManager }

class function IndexesManager.GetIndexes: TStringList;
var
  SR: TSearchRec;
begin
  Result := TStringList.Create;

  if FindFirst(Paths.Client + 'assets\indexes\' + '*', faAnyFile, SR) = 0 then
  begin
    repeat
      if
        ((SR.Attr and not faDirectory) <> 0) and
        (SR.Name <> '.') and
        (SR.Name <> '..')
      then
        Result.Add(SR.Name);
    until FindNext(SR) <> 0;
  end;

  SysUtils.FindClose(SR);
end;

class procedure IndexesManager.GetNames;
var
  Index: ISuperObject;
begin
  if not ExtParse(IndexPath, @Index) then
    raise Exception.CreateFmt('Can not parse index "%s"', [IndexPath]);

  TIndexListerThread.Create(Index).Start;
end;

class procedure IndexesManager.Move;
var
  Index: ISuperObject;
  PathFrom, PathTo, Name: String;
begin
  if not ExtParse(IndexPath, @Index) then
    raise Exception.CreateFmt('Can not parse index "%s"', [IndexPath]);

  if AssetsType then
  begin
    PathFrom := 'objects';
    PathTo := 'disabledObjects';
  end
  else
  begin
    PathFrom := 'disabledObjects';
    PathTo := 'objects';
  end;

  if not ObjectExists(Index, PathFrom) then
    Index.O[PathFrom] := SO();

  if not ObjectExists(Index, PathTo) then
    Index.O[PathTo] := SO();

  for Name in Names do
  begin
    Index.O[PathTo].O[Name] := Index.O[PathFrom].O[Name];
    Index.O[PathFrom].Delete(Name);
  end;

  Index.SaveTo(IndexPath, True);
end;

end.
