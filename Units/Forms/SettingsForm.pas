unit SettingsForm;

interface

uses
  Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, LauncherPaths,
  LauncherSettings, Vcl.Controls, Vcl.Themes, Vcl.ExtCtrls,
  LauncherStrings, Vcl.ComCtrls, System.Classes;

type
  TFm_Settings = class(TForm)
    GroupBoxVisibility: TGroupBox;
    GroupBoxValidation: TGroupBox;
    CheckBoxDontValidLibs: TCheckBox;
    CheckBoxDontValidAssets: TCheckBox;
    GroupBoxProfiles: TGroupBox;
    Label2: TLabel;
    ComboBoxProfiles: TComboBox;
    ButtonPRename: TButton;
    Label3: TLabel;
    ButtonPDelete: TButton;
    ButtonPNew: TButton;
    GroupBoxAdditional: TGroupBox;
    CheckBoxDebug: TCheckBox;
    ButtonOpenFolder: TButton;
    Label4: TLabel;
    ComboBoxTheme: TComboBox;
    RadioGroupEditorAction: TRadioGroup;
    CheckBoxUseCustStyles: TCheckBox;
    Label5: TLabel;
    EditCustStylePath: TEdit;
    ButtonBrowseCustomStyle: TButton;
    GroupBoxThemes: TGroupBox;
    ButtonReset: TButton;
    ComboBoxVisibility: TComboBox;
    CheckBoxShowTray: TCheckBox;
    CheckBoxAutoCheckUpdates: TCheckBox;
    PageControlMain: TPageControl;
    TabSheetMisc: TTabSheet;
    TabSheetLaunch: TTabSheet;
    TabSheetInterface: TTabSheet;
    DisableAdsCheckBox: TCheckBox;
    Label1: TLabel;
    TabSheetStats: TTabSheet;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    CheckBoxStats: TCheckBox;
    procedure ButtonOpenFolderClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ComboBoxProfilesSelect(Sender: TObject);
    procedure ButtonPDeleteClick(Sender: TObject);
    procedure ButtonPRenameClick(Sender: TObject);
    procedure ButtonPNewClick(Sender: TObject);
    procedure CheckBoxDontValidLibsClick(Sender: TObject);
    procedure CheckBoxDontValidAssetsClick(Sender: TObject);
    procedure CheckBoxDebugClick(Sender: TObject);
    procedure ComboBoxThemeSelect(Sender: TObject);
    procedure RadioGroupEditorActionClick(Sender: TObject);
    procedure EditCustStylePathChange(Sender: TObject);
    procedure CheckBoxUseCustStylesClick(Sender: TObject);
    procedure ButtonBrowseCustomStyleClick(Sender: TObject);
    procedure ButtonResetClick(Sender: TObject);
    procedure ComboBoxVisibilityClick(Sender: TObject);
    procedure CheckBoxShowTrayClick(Sender: TObject);
    procedure CheckBoxAutoCheckUpdatesClick(Sender: TObject);
    procedure DisableAdsCheckBoxClick(Sender: TObject);
    procedure CheckBoxStatsClick(Sender: TObject);
  end;

var
  Fm_Settings: TFm_Settings;

implementation

uses
  SysUtils, System.UITypes, ShellApi, BaseUtils;

{$R *.dfm}

procedure LoadAdditionalSettings;
begin
  with Fm_Settings, Settings.Profile do
  begin
    { Booleans }
    CheckBoxDebug.Checked := B['DebugMode'];
    CheckBoxDontValidAssets.Checked := B['DontCheckAssets'];
    CheckBoxDontValidLibs.Checked := B['DontCheckLibraries'];
    CheckBoxShowTray.Checked := B['ShowTrayIcon'];
    CheckBoxAutoCheckUpdates.Checked := B['AutoCheckUpdates'];
    DisableAdsCheckBox.Checked := B['DisableAds'];
    { Ints }
    ComboBoxVisibility.ItemIndex := I['LauncherVisibility'];
  end;
  // Global Settings
  with Fm_Settings, Settings.Global do
  begin
    EditCustStylePath.Text := S['CustomStylePath'];
    ComboBoxTheme.ItemIndex := I['ThemeIndex'];
    RadioGroupEditorAction.ItemIndex := I['EditorAction'];
    CheckBoxUseCustStyles.Checked := B['UseCustomStyle'];
    CheckBoxStats.Checked := B['DoNotSendStats'];
  end;
end;

procedure TFm_Settings.ButtonBrowseCustomStyleClick(Sender: TObject);
var
  OpenDialogStyle: TOpenDialog;
  H: TStyleManager.TStyleServicesHandle;
  SI: TStyleInfo;
begin
  OpenDialogStyle := TOpenDialog.Create(Fm_Settings);
  with OpenDialogStyle do
  try
    Filter := 'Файл стилей|*.vsf|Другой файл|*';
    InitialDir := 'C:\';
    if Execute then
      if TStyleManager.IsValidStyle(FileName, SI) then
      begin
        EditCustStylePath.Text := FileName;
        if TStyleManager.Style[SI.Name] = nil then
        begin
          H := TStyleManager.LoadFromFile(FileName);
          TStyleManager.SetStyle(H);
        end
        else
          TStyleManager.SetStyle(SI.Name);
    end;
  finally
    OpenDialogStyle.Free;
  end;
end;

procedure TFm_Settings.ButtonOpenFolderClick(Sender: TObject);
begin
  ShellExecute(Handle, 'Explore', PChar(Paths.Settings), nil, nil, 1);
end;

procedure TFm_Settings.ButtonPDeleteClick(Sender: TObject);
var
  int: integer;
begin
  if ComboBoxProfiles.Items.Count < 2 then
    ShowMessage(StrDlgCantRemoleLastProfile)
  else if MessageDlg(StrDlgDeleteProfile, mtWarning, mbOkCancel, 0) = mrOk then
    with ComboBoxProfiles do
    begin
      int := ItemIndex;
      Items.Delete(int);
      ItemIndex := int - 1;
      if ItemIndex < 0 then
        ItemIndex := 0;
      Settings.DeleteProfile(int, ItemIndex);
      LoadAdditionalSettings;
    end;
end;

procedure TFm_Settings.ButtonPNewClick(Sender: TObject);
var
  NewProfileName: string;
begin
  if InputQuery(StrInputNewProfileTitle, StrInputNewProfile, NewProfileName) then
  begin
    with ComboBoxProfiles do
    begin
      Items.Add(NewProfileName);
      ItemIndex := Items.IndexOf(NewProfileName);
    end;
    Settings.NewProfile(NewProfileName);
  end;
end;

procedure TFm_Settings.ButtonPRenameClick(Sender: TObject);
var
  NewProfileName: string;
  int: integer;
begin
  NewProfileName := ComboBoxProfiles.Text;
  if InputQuery(StrInputRenameProfileTitle, StrInputRenameProfile, NewProfileName) then
  begin
    with ComboBoxProfiles do
    begin
      int := ItemIndex;
      Items.Strings[int] := NewProfileName;
      ItemIndex := int;
    end;
    Settings.RenameCurrentProfile(NewProfileName);
  end;
end;

procedure TFm_Settings.ButtonResetClick(Sender: TObject);
begin
  if MessageDlg('Вы действительно хотите сбросить настройки?', mtWarning,
    mbOkCancel, 0) = mrOk then
  begin
    Settings.Reset;
    LoadAdditionalSettings;
  end;
end;

procedure TFm_Settings.CheckBoxAutoCheckUpdatesClick(Sender: TObject);
begin
  Settings.Profile.B['AutoCheckUpdates'] := CheckBoxAutoCheckUpdates.Checked;
end;

procedure TFm_Settings.CheckBoxDebugClick(Sender: TObject);
begin
  Settings.Profile.B['DebugMode'] := CheckBoxDebug.Checked;
end;

procedure TFm_Settings.CheckBoxDontValidAssetsClick(Sender: TObject);
begin
  Settings.Profile.B['DontCheckAssets'] := CheckBoxDontValidAssets.Checked;
end;

procedure TFm_Settings.CheckBoxDontValidLibsClick(Sender: TObject);
const
  LibsWarning = 'Отключение этой опции может повредить игре (вплоть до незапу' +
    'ска).'#13#10'Нажмите "OK", только если вы понимаете, что делаете.';
begin
  Settings.Profile.B['DontCheckLibraries'] := CheckBoxDontValidLibs.Checked;
  if not CheckBoxDontValidLibs.Checked then
    CheckBoxDontValidLibs.Checked :=
      MessageDlg(LibsWarning, mtWarning, mbOkCancel, 0) <> mrOk;
end;

procedure TFm_Settings.CheckBoxShowTrayClick(Sender: TObject);
begin
  Settings.Profile.B['ShowTrayIcon'] := CheckBoxShowTray.Checked;
end;

procedure TFm_Settings.CheckBoxStatsClick(Sender: TObject);
begin
  Settings.Global.B['DoNotSendStats'] := CheckBoxStats.Checked;
end;

procedure TFm_Settings.CheckBoxUseCustStylesClick(Sender: TObject);
var
  H: TStyleManager.TStyleServicesHandle;
  SI: TStyleInfo;
begin
  if CheckBoxUseCustStyles.Checked then
  begin
    Label5.Enabled := true;
    EditCustStylePath.Enabled := true;
    ButtonBrowseCustomStyle.Enabled := true;

    ComboBoxTheme.Enabled := false;
    Label4.Enabled := false;

    if EditCustStylePath.Text <> '' then
      if TStyleManager.IsValidStyle(EditCustStylePath.Text, SI) then
        if not Assigned(TStyleManager.Style[SI.Name]) then
        begin
          H := TStyleManager.LoadFromFile(EditCustStylePath.Text);
          TStyleManager.SetStyle(H);
        end
        else
          TStyleManager.SetStyle(SI.Name);
  end
  else
  begin
    Label5.Enabled := False;
    EditCustStylePath.Enabled := False;
    ButtonBrowseCustomStyle.Enabled := False;

    ComboBoxTheme.Enabled := True;

    Label4.Enabled := True;
    ComboBoxThemeSelect(ComboBoxTheme);
  end;
  Settings.Global.B['UseCustomStyle'] := CheckBoxUseCustStyles.Checked;
end;

procedure TFm_Settings.ComboBoxProfilesSelect(Sender: TObject);
begin
  Settings.SelectProfile(ComboBoxProfiles.ItemIndex);
  LoadAdditionalSettings;
end;

procedure TFm_Settings.ComboBoxThemeSelect(Sender: TObject);
begin
  case ComboBoxTheme.ItemIndex of
    0: TStyleManager.TrySetStyle('Carbon', True);
    1: TStyleManager.TrySetStyle('Light', True);
    2: TStyleManager.TrySetStyle('Windows', True);
  end;
  Settings.Global.I['ThemeIndex'] := ComboBoxTheme.ItemIndex;
end;

procedure TFm_Settings.ComboBoxVisibilityClick(Sender: TObject);
begin
  Settings.Profile.I['LauncherVisibility'] := ComboBoxVisibility.ItemIndex;
end;

procedure TFm_Settings.DisableAdsCheckBoxClick(Sender: TObject);
begin
  Settings.Profile.B['DisableAds'] := DisableAdsCheckBox.Checked;
end;

procedure TFm_Settings.EditCustStylePathChange(Sender: TObject);
begin
  Settings.Global.S['CustomStylePath'] := EditCustStylePath.Text;
end;

procedure TFm_Settings.FormCreate(Sender: TObject);
var
  List: TStringList;
begin
  with ComboBoxProfiles do
  begin
    Clear;
    List := Settings.AllProfilesNames;
    Items.Assign(List);
    FreeAndNil(List);
    ItemIndex := Settings.CurrentProfile;
  end;
  LoadAdditionalSettings;
end;

procedure TFm_Settings.RadioGroupEditorActionClick(Sender: TObject);
begin
  Settings.Global.I['EditorAction'] := RadioGroupEditorAction.ItemIndex;
end;

end.
