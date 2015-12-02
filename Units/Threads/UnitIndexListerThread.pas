unit UnitIndexListerThread;

interface

uses
  StdCtrls, System.Classes,
  SuperObject;

type
  TIndexListerThread = class(TThread)
  private
    FObject: ISuperObject;
    EnabledList, DisabledList: TStringList;
    procedure DisableBoxes;
    procedure FillBoxes;
    procedure FillBox(const Box: TListBox; const List: TStringList);
  protected
    procedure Execute; override;
  public
    constructor Create(const AObject: ISuperObject);
  end;

implementation

uses
  BaseUtils, UnitLauncherForm;

{ IndexListerThread }

constructor TIndexListerThread.Create;
begin
  inherited Create(True);
  FreeOnTerminate := True;
  FObject := AObject;
end;

procedure TIndexListerThread.DisableBoxes;
begin
  with LauncherForm do
  begin
    EnabledAssets.Enabled := False;
    DisabledAssets.Enabled := False;
  end;
end;

procedure TIndexListerThread.Execute;
begin
  Synchronize(DisableBoxes);

  EnabledList := SO2StringList(FObject.O['objects']);
  DisabledList := SO2StringList(FObject.O['disabledObjects']);

  Synchronize(FillBoxes);
end;

procedure TIndexListerThread.FillBox;
begin
  with Box do
  begin
    Items.Assign(List);
    List.Free;
    Enabled := Count > 0;
    Sorted := True;
  end;
end;

procedure TIndexListerThread.FillBoxes;
begin
  with LauncherForm do
  begin
    FillBox(EnabledAssets, EnabledList);
    FillBox(DisabledAssets, DisabledList);
  end;
end;

end.
