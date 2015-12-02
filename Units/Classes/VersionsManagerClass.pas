unit VersionsManagerClass;

interface

uses
  SuperObject;

type
  TOnFindVersion = procedure(Obj: ISuperObject) of object;

  VersionsManager = class
  private
    CLASS function IsValidVersionName(const Name: string): Boolean;
    CLASS function IsValidVersion(const Name: String; const Obj: ISuperObject): Boolean;
  public
    class function GetVersions(OnFindVersion: TOnFindVersion): Integer;
    class procedure RenameVersion(const OldName, NewName: String);
    class function DeleteVersion(const Name: String): Boolean;
    class procedure DeleteLibs(const Name: String);
    class procedure CopyVersion(const Name, NewName: String);
    class procedure EditVersion(const Name: String);
    class procedure EditJSONVersion(const AName: String);
  end;

implementation

uses
  SysUtils, Dialogs,
  Logging, BaseUtils, LauncherStrings, LauncherPaths, TypeTMinecraftLib,
  VersionEditorForm, UnitLauncherForm, UnitJSONEditorForm;

{ VersionsManager }

class procedure VersionsManager.CopyVersion(const Name, NewName: String);
var
  Obj: ISuperObject;
begin
  ForceDirectories(Paths.Version(NewName));
  CopyFile(Paths.json(Name), Paths.json(NewName));
  CopyFile(Paths.jar(Name), Paths.jar(NewName));
  if ExtParse(Paths.json(NewName), @Obj) then
  begin
    Obj.S['id'] := NewName;
    Obj.SaveTo(Paths.json(NewName));
  end;
end;

class procedure VersionsManager.DeleteLibs(const Name: String);
var
  Obj: ISuperObject;
  I: integer;
  Lib: TMinecraftLib;
begin
  if ExtParse(Paths.json(Name), @Obj) then
    if Obj.A['libraries'] <> nil then
      for I := 0 to Obj.A['libraries'].Length - 1 do
      begin
        try
          Lib := TMinecraftLib.Create(Obj.A['libraries'].O[I].Clone);
        except
          LogF('Skipping lib "%s"...', [Obj.A['libraries'].O[I].S['name']]);
          continue;
        end;
        try
          DeleteFile(Lib.Path);
          LogF(StrLogFileRemoved, [Lib.Path]);
        except
          on E: Exception do
            LogF(StrLogFileNotRemoved, [Lib.Path, E.Message], 1);
        end;
        try
          DeleteFile(Lib.HashPath);
          LogF(StrLogFileRemoved, [Lib.HashPath]);
        except
          on E: Exception do
            LogF(StrLogFileNotRemoved, [Lib.HashPath, E.Message], 1);
        end;
        FreeAndNil(Lib);
      end;
end;

class function VersionsManager.DeleteVersion(const Name: String): Boolean;
begin
  Result := True;

  try
    RemoveDirectory(Paths.Version(Name));
    LogF(StrLogVersionDeleted, [Name]);
  except
    on E: Exception do
    begin
      Result := False;

      ShowMessage(Format(StrDlgVersionNotRemoved, [E.Message]));
      LogF(StrLogDirNotRemoved, [Paths.Version(Name), E.Message], 1);
    end;
  end;
end;

class procedure VersionsManager.EditJSONVersion(const AName: String);
var
  Obj: ISuperObject;
begin
  if not ExtParse(Paths.json(AName), @Obj) then
  begin
    ShowMessage(StrDlgCantFindVersion);
    Exit;
  end;

  JSONEditorForm := TJSONEditorForm.Create(LauncherForm);
  with JSONEditorForm do
  begin
    VersionName := AName;

    Caption := Format(Caption, [AName]);
    Memo.Text := Obj.AsJSon(True);

    ShowModal;
  end;

  FreeAndNil(JSONEditorForm);
end;

class procedure VersionsManager.EditVersion(const Name: String);
var
  Obj: ISuperObject;
begin
  if not ExtParse(Paths.json(Name), @Obj) then
  begin
    ShowMessage(StrDlgCantFindVersion);
    Exit;
  end;

  VersionObject := Obj;
  Fm_VersionEditor := TFm_VersionEditor.Create(LauncherForm);
  if Fm_VersionEditor.ShowModal = 1 then
  begin
    if Name <> Obj.S['id'] then
      RenameVersion(Name, Obj.S['id']);
    try
      Obj.SaveTo(Paths.json(Obj.S['id']), true);
      LogF(StrLogVersionSaved, [Obj.S['id']]);
    except
      on E: Exception do
      begin
        LogE(E);
        LogF(StrLogVersionNotSaved, [Obj.S['id']], 1);
      end;
    end;
  end;
  FreeAndNil(Fm_VersionEditor);
end;

class function VersionsManager.GetVersions(OnFindVersion: TOnFindVersion): Integer;
var
  SR: TSearchRec;
  Obj: ISuperObject;
begin
  Result := 0;

  if FindFirst(Paths.Versions + '*', faAnyFile, SR) = 0 then
    repeat
      if ((SR.Attr and faDirectory) <> 0) and IsValidVersionName(SR.Name) then
        if ExtParse(Paths.json(SR.Name), @Obj) then
          if IsValidVersion(SR.Name, Obj) then
          begin
            OnFindVersion(Obj);
            Inc(Result);
          end;
    until FindNext(SR) <> 0;

  FindClose(SR);
end;

class function VersionsManager.IsValidVersion(const Name: String;
  const Obj: ISuperObject): Boolean;
begin
  if Name <> Obj.S['id'] then
    Exit(False);

  if FileExists(Paths.jar(Name)) then
    Exit(True)
  else
    Result := (Obj.S['jar'] <> '') and (FileExists(Paths.jar(Obj.S['jar'])));
end;

class function VersionsManager.IsValidVersionName(const Name: string): Boolean;
begin
  Result := (Name <> '.') and (Name <> '..');
end;

class procedure VersionsManager.RenameVersion(const OldName, NewName: String);
begin
  ForceDirectories(Paths.Version(NewName));

  CopyFile(Paths.json(OldName), Paths.json(NewName));
  CopyFile(Paths.jar(OldName), Paths.jar(NewName));

  RemoveDirectory(Paths.Version(OldName));
end;

end.
