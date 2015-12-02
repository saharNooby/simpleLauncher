unit UnitLauncherForm;

interface

uses
  // Windows
  Windows, Messages,
  // System
  System.SysUtils, System.Classes,
  // VCL
  Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls,
  Vcl.Buttons, Vcl.Menus, Vcl.Dialogs, Vcl.Themes, Vcl.Imaging.pngimage,
  Vcl.Imaging.jpeg,
  // Свои модули
  SuperObject;

const
  // LM = Launcher Message
  LM_BASE = WM_USER;

  LM_DOWNLOAD_START = LM_BASE + $1;
  LM_DOWNLOAD_IDLE = LM_BASE + $2;
  LM_DOWNLOAD_FINISH = LM_BASE + $3;

  LM_REMOTE_LIST_LOADED = LM_BASE + $4;

  LM_AUTH_STATE_CHANGED = LM_BASE + $5;
  LM_AUTH_AUTOVALID_STATED = LM_BASE + $6;

  LM_LOG = LM_BASE + $7;
  LM_ADS_LOADED = LM_BASE + $8;
  LM_UPDATE_CHECKING_FINISHED = LM_BASE + $9;

type
  TLauncherForm = class(TForm)
    {$REGION 'Fields'}
    AboutTabSheet: TTabSheet;
    AdsGroupBox: TGroupBox;
    AdsImage: TImage;
    AllAlphas: TComboBox;
    AllBetas: TComboBox;
    AllReleases: TComboBox;
    AllSnapshots: TComboBox;
    AlphaSpeedButton: TSpeedButton;
    AssetsEditorTabSheet: TTabSheet;
    AutoRemoteRefreshCheckBox: TCheckBox;
    BetaSpeedButton: TSpeedButton;
    BrowseJVMButton: TButton;
    BrowseMinecraftButton: TButton;
    CatchMCLogCheckBox: TCheckBox;
    CheckUpdatesButton: TButton;
    ChooseIndexLabel: TLabel;
    DefaultMinecraftPathButton: TButton;
    DisableAssetsButton: TButton;
    DisabledAssetsLabel: TLabel;
    DownloadAssetsCheckBox: TCheckBox;
    DownloadLibsCheckBox: TCheckBox;
    DownloadOptionsGroupBox: TGroupBox;
    DownloadVersionButton: TButton;
    DownloaderProgressBar: TProgressBar;
    DownloaderTabSheet: TTabSheet;
    EditorMenu_Delete: TMenuItem;
    EditorMenu_DeleteWithLibs: TMenuItem;
    EditorMenu_Edit: TMenuItem;
    EditorMenu_Launch: TMenuItem;
    EditorMenu_Refresh: TMenuItem;
    EditorMenu_Separator: TMenuItem;
    EnableAssetsButton: TButton;
    EnabledAssetsLabel: TLabel;
    ForceCheckBox: TCheckBox;
    IndexesList: TComboBox;
    JVMArgsEdit: TEdit;
    JVMArgsGroupBox: TGroupBox;
    JVMPathEdit: TEdit;
    JVMPathGroupBox: TGroupBox;
    LabelOnProgressBar: TLabel;
    LaunchButton: TButton;
    LauncherLog: TMemo;
    LauncherLogTabSheet: TTabSheet;
    LauncherLogo: TImage;
    LauncherLogoGroupBox: TGroupBox;
    LauncherSettingsButton: TButton;
    LauncherVersionLabel: TLabel;
    MCHeightEdit: TEdit;
    MCHeightLabel: TLabel;
    MCWidthEdit: TEdit;
    MCWidthLabel: TLabel;
    MemoryComboBox: TComboBox;
    MemoryEdit: TEdit;
    MemoryGroupBox: TGroupBox;
    MinecraftArgsEdit: TEdit;
    MinecraftArgsGroupBox: TGroupBox;
    MinecraftPathEdit: TEdit;
    MinecraftPathGroupBox: TGroupBox;
    NicksList: TComboBox;
    OpenMinecraftButton: TButton;
    PageControl: TPageControl;
    RefreshAssetsButton: TButton;
    RefreshRemoteButton: TButton;
    ReleaseSpeedButton: TSpeedButton;
    ResolutionGroupBox: TGroupBox;
    SettingsTabSheet: TTabSheet;
    SnapshotSpeedButton: TSpeedButton;
    TrayIcon: TTrayIcon;
    UseDefaultJVMCheckBox: TCheckBox;
    VersionEditorList: TListView;
    VersionEditorPopupMenu: TPopupMenu;
    VersionEditorTabSheet: TTabSheet;
    VersionSelectGroupBox: TGroupBox;
    VersionsComboList: TComboBox;
    AssetsPopupMenu: TPopupMenu;
    AssetsMenu_Enable: TMenuItem;
    AssetsMenu_Disable: TMenuItem;
    LoginPageControl: TPageControl;
    PiracyTabSheet: TTabSheet;
    LogPopupMenu: TPopupMenu;
    Minecraft1: TMenuItem;
    TabSheet1: TTabSheet;
    AuthButton: TButton;
    AuthLabel: TLabel;
    LogoutButton: TButton;
    NickLabel: TLabel;
    AuthStatusLabel: TLabel;
    CopyrightsLinkLabel: TLinkLabel;
    EditorMenu_Copy: TMenuItem;
    NickDeleteButton: TButton;
    LinksLabel: TLinkLabel;
    ShowNewReleasesCheckBox: TCheckBox;
    ShowNewSnapshotsCheckBox: TCheckBox;
    NicksBalloonHint: TBalloonHint;
    EnabledAssets: TListBox;
    DisabledAssets: TListBox;
    AssetsMenu_SelectAll: TMenuItem;
    EditorMenu_EditJSON: TMenuItem;
    SaveLogButton: TButton;
    SaveLaunchCommandButton: TButton;
    EditSleepDelay: TEdit;
  {$ENDREGION}
    {$REGION 'Methods'}
    procedure BrowseClient(Sender: TObject);
    procedure BrowseJava(Sender: TObject);
    procedure DisableAssetsButtonClick(Sender: TObject);
    procedure EnableAssetsButtonClick(Sender: TObject);
    procedure RefreshAssetsLists(Sender: TObject);
    procedure CheckUpdatesButtonClick(Sender: TObject);
    procedure IndexesListSelect(Sender: TObject);
    procedure ChangeJavaPath(Sender: TObject);
    procedure ClientPathChange(Sender: TObject);
    procedure DeleteNick(Sender: TObject);
    procedure DeleteVersion(Sender: TObject);
    procedure DeleteVersionWithLibs(Sender: TObject);
    procedure DownloadVersionMethod(Sender: TObject);
    procedure JVMArgsEditChange(Sender: TObject);
    procedure JVMPathEditChange(Sender: TObject);
    procedure MinecraftArgsEditChange(Sender: TObject);
    procedure MemoryEditChange(Sender: TObject);
    procedure MCHeightEditChange(Sender: TObject);
    procedure MCWidthEditChange(Sender: TObject);
    procedure EditVersion(Sender: TObject);
    procedure EditVersionFromEditor(Sender: TObject);
    procedure FoundedVersion(Obj: ISuperObject);
    procedure LauncherThreadExit(Sender: TObject);
    procedure LaunchMinecraft(Sender: TObject);
    procedure LauncherCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure LauncherCreate(Sender: TObject);
    procedure NickExit(Sender: TObject);
    procedure OpenAdditionalSettingsWindow(Sender: TObject);
    procedure OpenAdsSite(Sender: TObject);
    procedure OpenClient(Sender: TObject);
    procedure PopupEditorMenu(Sender: TObject);
    procedure RefreshLocalVersions(Sender: TObject);
    procedure RefreshRemoteVersions(Sender: TObject);
    procedure SelectVersionInCB(Sender: TObject);
    procedure SelectVersionInLV(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure SelectVersionToDownload(Sender: TObject);
    procedure SelectVersionType(Sender: TObject);
    procedure SetDefaultClientPath(Sender: TObject);
    procedure TrayIconClick(Sender: TObject);
    procedure MemoryComboBoxSelect(Sender: TObject);
    procedure UnblockAfterRemoteRefresh(Sender: TObject);

    procedure SaveCheckBoxValue(Sender: TObject);
    procedure LauncherDestroy(Sender: TObject);
    procedure AssetsPopupMenuPopup(Sender: TObject);
    procedure Minecraft1Click(Sender: TObject);
    procedure LogPopupMenuPopup(Sender: TObject);
    procedure AuthButtonClick(Sender: TObject);
    procedure LoginPageControlChange(Sender: TObject);
    procedure LogoutButtonClick(Sender: TObject);
    procedure CopyrightsLinkLabelLinkClick(Sender: TObject; const Link: string;
      LinkType: TSysLinkType);
    procedure EditorMenu_CopyClick(Sender: TObject);
    procedure VersionsComboListDropDown(Sender: TObject);
    procedure PageControlChange(Sender: TObject);
    procedure LinksLabelLinkClick(Sender: TObject; const Link: string;
      LinkType: TSysLinkType);
    procedure LauncherLogoClick(Sender: TObject);
    procedure AutoRemoteRefreshCheckBoxClick(Sender: TObject);
    procedure NicksListKeyPress(Sender: TObject; var Key: Char);
    procedure AssetsMenu_SelectAllClick(Sender: TObject);
    procedure NicksListChange(Sender: TObject);
    procedure EditJSONVersion(Sender: TObject);
    procedure SaveLogButtonClick(Sender: TObject);
    procedure SaveLaunchCommandButtonClick(Sender: TObject);
    procedure EditSleepDelayChange(Sender: TObject);
    {$ENDREGION}
    public
      LastNickString: String;
      LastLaunchCommand: String;
      CloseOnLauncherTerminates: Boolean;
      WaitForProcessExit: Boolean;
      procedure RefreshClientVersions;
      procedure DisableUpdateButton;
      procedure SetProgressBarLabel;
      procedure SetDefaultStyle;
      procedure SetCustomStyle;
      // Обработка сообщений лаунчера
      procedure DownloadHandlerIdle(var Message: TMessage);
        message LM_DOWNLOAD_IDLE;
      procedure DownloadHandlerStart(var Message: TMessage);
        message LM_DOWNLOAD_START;
      procedure DownloadHandlerFinish(var Message: TMessage);
        message LM_DOWNLOAD_FINISH;
      procedure RemoteRefreshHandler(var Message: TMessage);
        message LM_REMOTE_LIST_LOADED;
      procedure AuthRefreshState(var Message: TMessage);
        message LM_AUTH_STATE_CHANGED;
      procedure AuthAutoValidStart(var Message: TMessage);
        message LM_AUTH_AUTOVALID_STATED;
      procedure WriteToLog(var Message: TMessage);
        message LM_LOG;
      procedure AdsLoaded(var Message: TMessage);
        message LM_ADS_LOADED;
      procedure UpdateCheckingFinished(var Message: TMessage);
        message LM_UPDATE_CHECKING_FINISHED;
  end;

var
  LauncherForm: TLauncherForm;

implementation

uses
  // Система, IDE
  System.UITypes, ShellApi,
  // Потоки
  UnitRemoteRefresherThread, UnitLauncherThread, UnitMinecraftListenerThread,
  // Формы
  SettingsForm, UnitLoginForm, UnitUpdaterForm,
  // Модули с функционалом
  LauncherSettings, LauncherUpdater, MinecraftDownload, AdsClass, AuthUnit,
  IndexesManagerClass, DebugSettings, UsageStatistics,
  // Типы
  DownloadableVersions, TypeTMinecraftVersions,
  // Утилиты, другие модули
  BaseUtils, Logging, Downloader, LauncherStrings, LauncherPaths,
  VersionsManagerClass, PipesAPI, BrowseDirectory, NickValidator,
  UnitCaptionChangerThread;

{$R *.dfm}

{$REGION 'Misc Procedures'}

procedure UpdaterFinish;
begin
  with LauncherForm.CheckUpdatesButton do
  begin
    Enabled := True;
    Caption := StrButtonUpdateCaption;
  end;
end;

procedure LoadSettings;
var
  List: TStringList;
begin
  Log('Loading settings...');
  with LauncherForm, Settings.Profile do
  try
    { Strings }
    NicksList.Text := S['CurrentNick'];
    JVMArgsEdit.Text := S['AdditionalArgs'];
    MemoryEdit.Text := S['Memory'];
    MCWidthEdit.Text := S['MinecraftWidth'];
    MCHeightEdit.Text := S['MinecraftHeight'];
    JVMPathEdit.Text := S['JVMPath'];
    MinecraftArgsEdit.Text := S['MinecraftArgs'];
    EditSleepDelay.Text := Settings.Profile.S['sleepDelay'];
    { Booleans }
    DownloadLibsCheckBox.Checked := B['DownloadLibrariesWithVersions'];
    DownloadAssetsCheckBox.Checked := B['DownloadAssetsWithVersions'];
    AutoRemoteRefreshCheckBox.Checked := B['AutoRefreshRemoteVersionsList'];
    ForceCheckBox.Checked := B['ForceDownload'];
    CatchMCLogCheckBox.Checked := B['CatchMinecraftLog'];
    ShowNewReleasesCheckBox.Checked := B['ShowNewReleases'];
    ShowNewSnapshotsCheckBox.Checked := B['ShowNewSnapshots'];
    { Arrays }
    List := SuperArray2StringList(A['Nicks']);
    NicksList.Items.Assign(List);
    FreeAndNil(List);
    { Integers }
    MemoryComboBox.ItemIndex := I['MemoryChar'];
    LoginPageControl.TabIndex := I['LoginMode'];
    { Other }
    if JVMPathEdit.Text <> StrDefaultJavaPath then
    begin
      UseDefaultJVMCheckBox.Checked := False;
      JVMPathEdit.Enabled := True;
    end;

    with VersionsComboList do
      if Items.Count = 0 then
      begin
        Items.Add(S['CurrentVersionID']);
        ItemIndex := 0;
      end;

    if S['MCPath'] = '?default?' then
      MinecraftPathEdit.Text := Paths.ClientDefault
    else
      MinecraftPathEdit.Text := S['MCPath'];

    AutoRemoteRefreshCheckBoxClick(LauncherForm);

    if I['LoginMode'] = 1 then
      Auth.CheckTokens;
  except
    on E: Exception do
      LogE(E);
  end;
  LogF(StrLogSettingsLoaded, [Settings.CurrProfileName]);
end;

function GetObjToDl: TLoadableVersion;
var
  List: TComboBox;
begin
  Result := nil;
  List := nil;
  with LauncherForm do
  begin
    // Получаем указатель (List) на выбранный список (под нажатой кнопкой)
    if ReleaseSpeedButton.Down then
      List := AllReleases
    else if SnapshotSpeedButton.Down then
      List := AllSnapshots
    else if BetaSpeedButton.Down then
      List := AllBetas
    else if AlphaSpeedButton.Down then
      List := AllAlphas;
  end;
  // Считываем объект из списка, на который указывает List
  if List <> nil then
    with List do
      Result := TLoadableVersion(Items.Objects[ItemIndex]);
end;

function GetVersionToDl: string;
begin
  Result := GetObjToDl.ID;
end;

procedure AddVersionInfo(Obj: ISuperObject);
var
  ListItem: TListItem;
  Date: string;
begin
  ListItem := LauncherForm.VersionEditorList.Items.Add;
  with ListItem do
  begin
    Caption := Obj.S['id'];
    SubItems.Add(Obj.S['type']);
    try
      Date := GetNormalDate(Obj.S['releaseTime']);
      SubItems.Add(Date);
    except
      SubItems.Add('');
    end;
    try
      Date := GetNormalDate(Obj.S['time']);
      SubItems.Add(Date);
    except
      SubItems.Add('');
    end;
    SubItems.Add(Obj.A['libraries'].Length.ToString());;
  end;
end;

procedure CreateLauncherProfiles;
const
  Content = '{"profiles":{"(Default)":{"name":"(Default)"}},' +
    '"selectedProfile":"(Default)"}';
var
  Stream: TStringStream;
begin
  Stream := TStringStream.Create;
  try
    Stream.WriteString(Content);
    Stream.SaveToFile(Paths.Client + 'launcher_profiles.json');
  finally
    FreeAndNil(Stream);
  end;
end;

{$ENDREGION}

{$REGION 'Form'}

procedure TLauncherForm.RefreshClientVersions;
var
  SelectedVersion: String;
begin
  SelectedVersion := VersionsComboList.Text;
  VersionsComboList.Clear;
  VersionEditorList.Clear;

  if VersionsManager.GetVersions(FoundedVersion) > 0 then
  begin
    with VersionsComboList do
      if Items.IndexOf(SelectedVersion) <> -1 then
        ItemIndex := Items.IndexOf(SelectedVersion)
      else
        ItemIndex := 0;
    with VersionEditorList do
    begin
      ItemIndex := -1;
      Selected := Items.Item[LauncherForm.VersionsComboList.ItemIndex];
    end;
  end;

  with VersionsComboList do
    Enabled := Items.Count > 0;
end;

procedure TLauncherForm.RemoteRefreshHandler(var Message: TMessage);
var
  VersionsList: TMinecraftVersions;
begin
  VersionsList := Pointer(Message.LParam);

  with LauncherForm do
  begin
    with AllReleases do
    begin
      Items.Assign(VersionsList.R);
      ItemIndex := 0;
    end;
    with AllSnapshots do
    begin
      Items.Assign(VersionsList.S);
      ItemIndex := 0;
    end;
    with AllBetas do
    begin
      Items.Assign(VersionsList.B);
      ItemIndex := 0;
    end;
    with AllAlphas do
    begin
      Items.Assign(VersionsList.A);
      ItemIndex := 0;
    end;

    DownloadVersionButton.Enabled := True;
    ReleaseSpeedButton.Enabled := True;
    SnapshotSpeedButton.Enabled := True;
    BetaSpeedButton.Enabled := True;
    AlphaSpeedButton.Enabled := True;
    SelectVersionType(ReleaseSpeedButton);
  end;
  FreeAndNil(VersionsList);
  Settings.Profile.B['RefreshButtonClicked'] := False;

  Log(Self, StrLogSuccessfulRefresh);
end;

procedure TLauncherForm.UnblockAfterRemoteRefresh;
begin
  with RefreshRemoteButton do
  begin
    Enabled := True;
    Caption := StrRefreshList;
  end;
end;

procedure TLauncherForm.UpdateCheckingFinished(var Message: TMessage);
begin
  // Если найдены обновления
  if Message.LParam = 0 then
  begin
    Application.CreateForm(TUpdaterForm, UpdaterForm);
    with UpdaterForm do
      try
        LabelOldVersion.Caption := LauncherVersionString;
        ShowModal;
      finally
        FreeAndNil(UpdaterForm);
      end;
  end;
  if Message.WParam = 1 then
  // Если нужно показывать окна о неудаче или ненужности обновлений
    case Message.LParam of
      1:
        ShowMessage(StrUpdaterNotNeed);
      2:
        ShowMessage(StrUpdaterError);
    end;
  with LauncherForm.CheckUpdatesButton do
  begin
    Enabled := True;
    Caption := StrButtonUpdateCaption;
  end;
end;

procedure TLauncherForm.FoundedVersion(Obj: ISuperObject);
begin
  AddVersionInfo(Obj);
  VersionsComboList.Items.Add(Obj.S['id']);
end;

procedure TLauncherForm.TrayIconClick(Sender: TObject);
begin
  Show;
  TrayIcon.Visible := False;
  Log(Self, 'Main form has been showed.');
end;

procedure TLauncherForm.DisableUpdateButton;
begin
  with CheckUpdatesButton do
  begin
    Enabled := False;
    Caption := 'Проверяю...';
  end;
end;

procedure TLauncherForm.CheckUpdatesButtonClick(Sender: TObject);
begin
  DisableUpdateButton;
  CheckForLauncherUpdates(True);
end;

procedure TLauncherForm.LauncherCreate(Sender: TObject);
begin
  LogF(Self, 'Starting simpleLauncher %s...', [LauncherVersionString]);

  // Интерфейс формы
  SetProgressBarLabel;
  PageControl.TabIndex := 0;
  LoginPageControl.TabIndex := 0;
  with LauncherVersionLabel do
    Caption := Format(Caption, [LauncherVersionString]);

  // Настройки
  Settings := TLauncherSettings.Create;

  if not DebugSettings.DontTouchSettings then
    LoadSettings;

  PageControl.TabIndex := Settings.Global.I['TabIndex'];

  if not DebugSettings.DontSetupThemes then
    if not Settings.Global.B['UseCustomStyle'] then
      SetDefaultStyle
    else
      if Settings.Global.S['CustomStylePath'] <> '' then
        SetCustomStyle;

  LastNickString := NicksList.Text;

  // Процедуры
  if not DebugSettings.DontRefreshRemoteVersions then
    if AutoRemoteRefreshCheckBox.Checked then
      RefreshRemoteVersions(Self);

  if not DebugSettings.DontLoadAds then
    if not Settings.Profile.B['DisableAds'] then
      StartThread(@ExecuteAdsLoader, 'Ads Loader');

  if not DebugSettings.DontCheckUpdates then
    if Settings.Profile.B['AutoCheckUpdates'] then
    begin
      DisableUpdateButton;
      Log('Checking for launcher updates (AutoCheckUpdates = true)...');
      CheckForLauncherUpdates(False);
      Application.ProcessMessages;
    end;

  Log(Self, 'Launcher has been started!');
end;

procedure TLauncherForm.LauncherDestroy(Sender: TObject);
begin
  // Сохранение настроек
  NickExit(NicksList);
  if not DebugSettings.DontTouchSettings then
    Settings.SaveToFile;
  // Сохранение лога, любые сообщения в лог дальше не имеют смысла
  if Settings.Profile.B['SaveLog'] then
  begin
    ForceDirectories(Paths.Logs);
    LauncherLog.Lines.SaveToFile(Paths.Log);
  end;
end;

procedure TLauncherForm.LauncherLogoClick(Sender: TObject);
begin
  ShellExecute(0, nil, PChar('http://vk.com/simplelauncher'), nil, nil, 1);
  Inc(UsageStatistics.PageLinkClickedTimes);
end;

procedure TLauncherForm.LauncherCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if NowDownloading then
    CanClose := MessageDlg(StrDlgDownloading, mtWarning, mbOkCancel, 0) = 1;

  if CanClose and WaitForProcessExit then
  begin
    CanClose := False;
    Hide; // Если поток активен, то скрываемся вместо закрытия...
    CloseOnLauncherTerminates := True; // ...а закроемся по завершении потока
  end else
  begin
      if not Settings.Global.B['DoNotSendStats'] then
      begin
            Hide();
            UsageStatistics.SendStatistics();
      end;
  end;
end;

procedure TLauncherForm.PageControlChange(Sender: TObject);
begin
  Settings.Global.I['TabIndex'] := PageControl.TabIndex;
end;

procedure TLauncherForm.PopupEditorMenu(Sender: TObject);
var
  IsSelected: Boolean;
begin
  with VersionEditorPopupMenu.Items do
  begin
    IsSelected := VersionEditorList.Selected <> nil;
    Items[2].Enabled := IsSelected;
    Items[3].Enabled := IsSelected;
    Items[4].Enabled := IsSelected;
    Items[5].Enabled := IsSelected;
    Items[6].Enabled := IsSelected;
  end;
end;

procedure TLauncherForm.DeleteVersionWithLibs(Sender: TObject);
var
  VersionID: string;
begin
  VersionID := VersionEditorList.Selected.Caption;
  if MessageDlg(StrDlgDeleteVersion, mtWarning, mbOkCancel, 0) = mrOk then
  begin
    VersionsManager.DeleteLibs(VersionID);

    if VersionsManager.DeleteVersion(VersionID) then
      RefreshClientVersions;
  end;
end;

procedure TLauncherForm.EditVersion(Sender: TObject);
begin
  VersionsManager.EditVersion(VersionEditorList.Selected.Caption);
  RefreshClientVersions;
end;

procedure TLauncherForm.EditorMenu_CopyClick(Sender: TObject);

  function IsValidVersionName(const S: string): Boolean;
  const
    Invalids = ['\', '/', ':', '*', '?', '"', '<', '>', '|'];
  var
    C: Char;
  begin
    Result := True;
    if S = '' then Exit(False);
    for C in S do if CharInSet(C, Invalids) then Exit(False);
  end;

var
  NewName: String;
begin
  NewName := VersionsComboList.Text;
  if InputQuery('Введите имя новой версии', 'Новое имя версии', NewName) then
    if IsValidVersionName(NewName) then
    begin
      VersionsManager.CopyVersion(VersionsComboList.Text, NewName);
      RefreshClientVersions;
    end
    else
      ShowMessage('Неверное имя версии: не может содержать символы \, /, :, *, ?, ", <, >, |');
end;

procedure TLauncherForm.EditSleepDelayChange(Sender: TObject);
begin
  Settings.Profile.S['sleepDelay'] := EditSleepDelay.Text;
end;

procedure TLauncherForm.EditJSONVersion(Sender: TObject);
begin
  VersionsManager.EditJSONVersion(VersionEditorList.Selected.Caption);
end;

procedure TLauncherForm.AssetsMenu_SelectAllClick(Sender: TObject);
begin
  if EnabledAssets.Focused then
    EnabledAssets.SelectAll;

  if DisabledAssets.Focused then
    DisabledAssets.SelectAll;
end;

procedure TLauncherForm.NickExit(Sender: TObject);

  procedure SaveList;
  var
    List: TStringList;
  begin
    List := TStringList.Create;
    List.Assign(NicksList.Items);
    StringList2SuperArray(List, Settings.Profile.A['Nicks']);
    FreeAndNil(List);
  end;

begin
  with NicksList do
    if Items.IndexOf(Text) = -1 then
      Items.Add(Text);
  SaveList;
end;

procedure ShowNicksHint;
var
  Point: TPoint;
begin
  with LauncherForm do
  begin
    NicksBalloonHint.Title := 'Ошибка';
    NicksBalloonHint.Description :=
      'Разрешено вводить только буквы'#13'от A до z, цифры и символ "_"'#13;

    Point.X := NicksList.Width - 10;
    Point.Y := 0;

    NicksBalloonHint.ShowHint(NicksList.ClientToScreen(Point));
  end;
end;

procedure TLauncherForm.NicksListChange(Sender: TObject);
begin
  Settings.Profile.S['CurrentNick'] := NicksList.Text;
end;

procedure TLauncherForm.NicksListKeyPress(Sender: TObject; var Key: Char);
begin
  if not CharInSet(Key, ['A' .. 'Z', 'a' .. 'z', '0' .. '9', '_',
    Char(VK_TAB), Char(VK_BACK), Char(VK_DELETE), Char(VK_ESCAPE)]) then
  begin
    Key := #0;
    ShowNicksHint;
  end;
end;

procedure TLauncherForm.SelectVersionInCB(Sender: TObject);
var
  I: integer;
begin
  I := VersionsComboList.ItemIndex;
  with VersionEditorList do
    Selected := Items.Item[I];
  Settings.Profile.S['CurrentVersionID'] := VersionsComboList.Text;
end;

procedure TLauncherForm.OpenAdsSite(Sender: TObject);
begin
  if Ads.CurrentLink <> '' then
  begin
    ShellExecute(0, 'Open', PWideChar(Ads.CurrentLink), nil, nil, 5);
    Inc(UsageStatistics.AdsClickedTimes);
  end;
end;

procedure TLauncherForm.AdsLoaded(var Message: TMessage);
begin
  AdsImage.Picture.LoadFromFile(Paths.AdsImage);
  AdsImage.Cursor := crHandPoint;
end;

procedure TLauncherForm.OpenAdditionalSettingsWindow(Sender: TObject);
begin
  LauncherSettingsButton.Enabled := False;
  Application.CreateForm(TFm_Settings, Fm_Settings);
  Fm_Settings.ShowModal;
  FreeAndNil(Fm_Settings);
  LoadSettings;
  LauncherSettingsButton.Enabled := True;
end;

procedure TLauncherForm.IndexesListSelect(Sender: TObject);
begin
  try
    if IndexesList.Text <> '' then
      IndexesManager.GetNames(Paths.Index(IndexesList.Text));
  except
    on E: Exception do
      LogE(Self, E);
  end;
end;

procedure TLauncherForm.MemoryComboBoxSelect(Sender: TObject);
begin
  Settings.Profile.I['MemoryChar'] := MemoryComboBox.ItemIndex;
end;

procedure TLauncherForm.ChangeJavaPath(Sender: TObject);
begin
  with JVMPathEdit do
    if UseDefaultJVMCheckBox.Checked then
    begin
      Enabled := False;
      Text := StrDefaultJavaPath;
    end
    else
      Enabled := True;
end;

procedure TLauncherForm.DownloadHandlerFinish(var Message: TMessage);
begin
  LabelOnProgressBar.Caption := '';
  with DownloaderProgressBar do
  begin
    Max := 0;
    Position := 0;
  end;
end;

procedure TLauncherForm.DownloadHandlerIdle(var Message: TMessage);

  function ConvertSize(Bytes: Single): String;
  var
    SizeChar: String;
  begin
    Result := '';
    SizeChar := 'Б';
    if Bytes > 1024 * 1024 then // Если больше 1 МБ
    begin
      Bytes := Bytes / (1024 * 1024);
      SizeChar := 'МБ';
    end
    else if Bytes > 1024 then // Если больше 1 КБ
    begin
      Bytes := Bytes / 1024;
      SizeChar := 'КБ';
    end;
    Result := FormatFloat('0.00', Bytes) + ' ' + SizeChar;
  end;

var
  Data: TDownloadData;
  Size, Downloaded, Speed: String;
begin
  Data := TDownloadData(Pointer(Message.LParam)^);

  Size := ConvertSize(Data.FileSize);
  Downloaded := ConvertSize(Data.Downloaded);
  Speed := ConvertSize(Data.Speed);

  with DownloaderProgressBar, Data do
  begin
    Max := FileSize;
    Position := Downloaded;
  end;

  LabelOnProgressBar.Caption :=
    Format('Загружаю файл "%s": %s из %s (%d%s) @ %s/с', [
    ExtractFileName(Data.FileName), Downloaded, Size,
    Trunc(Data.Downloaded / Data.FileSize * 100), '%', Speed]);
end;

procedure TLauncherForm.DownloadHandlerStart(var Message: TMessage);
var
  Data: TDownloadData;
begin
  Data := TDownloadData(Pointer(Message.LParam)^);

  LogF(StrLogDownloading, [Data.FileName, Data.URL], 2);

  LabelOnProgressBar.Caption :=
    Format('Загружаю файл "%s": соединение с сервером...',
    [ExtractFileName(Data.FileName)]);
end;

procedure TLauncherForm.DownloadVersionMethod(Sender: TObject);

  procedure DisableSpeedButtons;
  begin
    ReleaseSpeedButton.Enabled := False;
    SnapshotSpeedButton.Enabled := False;
    BetaSpeedButton.Enabled := False;
    AlphaSpeedButton.Enabled := False;
  end;

  procedure DisableLists;
  begin
    AllReleases.Enabled := False;
    AllSnapshots.Enabled := False;
    AllBetas.Enabled := False;
    AllAlphas.Enabled := False;
  end;

  procedure DisableOtherButtons;
  begin
    DownloadVersionButton.Enabled := False;
    RefreshRemoteButton.Enabled := False;
    LaunchButton.Enabled := False;
  end;

begin
  DisableSpeedButtons;
  DisableLists;
  DisableOtherButtons;
  DownloadVersionButton.Caption :=
    Format(StrDownloadingVersion, [GetVersionToDl]);
  DownloadVersion(GetObjToDl);
end;

procedure TLauncherForm.SelectVersionType(Sender: TObject);

  procedure EnableLists;
  begin
    AllReleases.Enabled  := ReleaseSpeedButton.Down;
    AllSnapshots.Enabled := SnapshotSpeedButton.Down;
    AllBetas.Enabled     := BetaSpeedButton.Down;
    AllAlphas.Enabled    := AlphaSpeedButton.Down;
  end;

begin
  EnableLists;
  DownloadVersionButton.Caption :=
    Format(StrDownloadSomeVersion, [GetVersionToDl]);
end;

procedure TLauncherForm.JVMArgsEditChange(Sender: TObject);
begin
  Settings.Profile.S['AdditionalArgs'] := JVMArgsEdit.Text;
end;

procedure TLauncherForm.JVMPathEditChange(Sender: TObject);
begin
  Settings.Profile.S['JVMPath'] := JVMPathEdit.Text;
  Paths.Java := JVMPathEdit.Text;
end;

procedure TLauncherForm.Minecraft1Click(Sender: TObject);
begin
  with PipeInfo.ProcessInfo do
    DestroyConsole(hProcess, hThread);
end;

procedure TLauncherForm.MinecraftArgsEditChange(Sender: TObject);
begin
  Settings.Profile.S['MinecraftArgs'] := MinecraftArgsEdit.Text;
end;

procedure TLauncherForm.MemoryEditChange(Sender: TObject);
begin
  Settings.Profile.S['Memory'] := MemoryEdit.Text;
end;

procedure TLauncherForm.ClientPathChange(Sender: TObject);
begin
  Paths.SetClient := MinecraftPathEdit.Text;
  Settings.Profile.S['MCPath'] := MinecraftPathEdit.Text;
  RefreshClientVersions;
  RefreshAssetsLists(RefreshAssetsButton);
  if not FileExists(Paths.Client + 'launcher_profiles.json') then
    try
      CreateLauncherProfiles;
    except
      Log(Self, 'Can''t create file ' + Paths.Client + 'launcher_profiles.json')
    end;
end;

procedure TLauncherForm.CopyrightsLinkLabelLinkClick(Sender: TObject;
  const Link: string; LinkType: TSysLinkType);
begin
  ShellExecute(0, nil, PWideChar(Link), nil, nil, SW_SHOWNORMAL);
end;

procedure TLauncherForm.MCHeightEditChange(Sender: TObject);
begin
  Settings.Profile.S['MinecraftHeight'] := MCHeightEdit.Text;
end;

procedure TLauncherForm.MCWidthEditChange(Sender: TObject);
begin
  Settings.Profile.S['MinecraftWidth'] := MCWidthEdit.Text;
end;

procedure TLauncherForm.DeleteNick(Sender: TObject);
var
  I: Integer;
begin
  with NicksList do
  begin
    I := ItemIndex;
    Items.Delete(Items.IndexOf(Text));
    ItemIndex := I + 1;
    if ItemIndex <> -1 then
      Text := Items.Strings[ItemIndex]
    else
      Text := StrDefaultNick;
  end;
end;

procedure TLauncherForm.RefreshRemoteVersions(Sender: TObject);
begin
  Settings.Profile.B['RefreshButtonClicked'] := (Sender = RefreshRemoteButton);
  with RefreshRemoteButton do
  begin
    Enabled := False;
    Caption := StrRefreshingList;
  end;
  DownloadVersionButton.Enabled := False;
  Log(Self, StrLogRefreshingList);
  RefreshRemoteVersionsList;
end;

procedure TLauncherForm.LauncherThreadExit(Sender: TObject);

  procedure ExcMessage(const E: Exception);
  begin
    LogE(Self, E);
    ShowMessage(Format(StrDlgLaunchError, [E.Message]));
  end;

begin
  with LauncherThread do
  begin
    EnableButtons;
    if FatalException <> nil then
      ExcMessage(Exception(FatalException));
  end;
  LauncherThread := nil;

  if CloseOnLauncherTerminates then
    Close;
end;

procedure TLauncherForm.LaunchMinecraft(Sender: TObject);
var
  VersionID: string;
begin
    Inc(UsageStatistics.MinecraftTriedToBeLaunchedTimes);

  VersionID := VersionsComboList.Text;

  if VersionID = '' then
    Exit;

  LogF(Self, StrLogTryingLaunch, [VersionID]);

  LauncherThread := TLauncherThread.Create(True);
  with LauncherThread do
  begin
    OnTerminate := LauncherThreadExit;
    FreeOnTerminate := True;
    Start;
  end;
end;

procedure TLauncherForm.LinksLabelLinkClick(Sender: TObject; const Link: string;
  LinkType: TSysLinkType);
begin
    if Link = 'http://vk.com/simplelauncher' then Inc(UsageStatistics.PageLinkClickedTimes);
  ShellExecute(0, 'Open', PWideChar(Link), nil, nil, 5);
end;

procedure TLauncherForm.LoginPageControlChange(Sender: TObject);
begin
  Settings.Profile.I['LoginMode'] := LoginPageControl.TabIndex;
  if LoginPageControl.TabIndex = 1 then
    Auth.CheckTokens;
end;

procedure TLauncherForm.LogoutButtonClick(Sender: TObject);
begin
  Auth.LogOut;
  SendMessage(LauncherForm.Handle, LM_AUTH_STATE_CHANGED, 0, 0);
end;

procedure TLauncherForm.LogPopupMenuPopup(Sender: TObject);
begin
  Minecraft1.Enabled := WaitForProcessExit;
end;

procedure TLauncherForm.EditVersionFromEditor(Sender: TObject);
begin
  if Settings.Global.I['EditorAction'] <> 0 then
    LaunchMinecraft(nil)
  else
    EditVersion(nil);
end;

procedure TLauncherForm.SelectVersionInLV(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  VersionsComboList.ItemIndex := VersionEditorList.Items.IndexOf(Item);
  Settings.Profile.S['CurrentVersionID'] := VersionsComboList.Text;
end;

procedure TLauncherForm.RefreshLocalVersions(Sender: TObject);
begin
  RefreshClientVersions;
end;

procedure TLauncherForm.BrowseJava(Sender: TObject);
var
  OpenDialogJava: TOpenDialog;
begin
  OpenDialogJava := TOpenDialog.Create(LauncherForm);
  try
    with OpenDialogJava do
    begin
      Filter := 'JVM|javaw.exe|Другое приложение|*.exe|Другой файл|*';
      InitialDir := Paths.ProgramFiles;
      if Execute then
      begin
        UseDefaultJVMCheckBox.Checked := False;
        ChangeJavaPath(Sender);
        JVMPathEdit.Text := FileName;
      end;
    end;
  finally
    FreeAndNil(OpenDialogJava);
  end;
end;

procedure TLauncherForm.DisableAssetsButtonClick(Sender: TObject);
var
  List: TStringList;
  I: Integer;
begin
  if EnabledAssets.SelCount = 0 then
    Exit;

  List := TStringList.Create;

  for I := 0 to EnabledAssets.Count - 1 do
    if EnabledAssets.Selected[I] then
      List.Add(EnabledAssets.Items[I]);

  IndexesManager.Move(Paths.Index(IndexesList.Text), List, True);

  IndexesListSelect(Sender);
end;

procedure TLauncherForm.EnableAssetsButtonClick(Sender: TObject);
var
  List: TStringList;
  I: Integer;
begin
  if DisabledAssets.SelCount = 0 then
    Exit;

  List := TStringList.Create;

  for I := 0 to DisabledAssets.Count - 1 do
    if DisabledAssets.Selected[I] then
      List.Add(DisabledAssets.Items[I]);

  IndexesManager.Move(Paths.Index(IndexesList.Text), List, False);

  IndexesListSelect(Sender);
end;

procedure TLauncherForm.RefreshAssetsLists(Sender: TObject);
var
  Selected: string;
  List: TStringList;
begin
  Selected := IndexesList.Text;
  with IndexesList do
  begin
    EnabledAssets.Clear;
    EnabledAssets.Enabled := False;

    DisabledAssets.Clear;
    DisabledAssets.Enabled := False;

    List := IndexesManager.GetIndexes;
    Items.Assign(List);
    FreeAndNil(List);

    if Items.Count = 0 then
      Enabled := False
    else
    begin
      Enabled := True;
      if Items.IndexOf(Selected) <> -1 then
        ItemIndex := Items.IndexOf(Selected)
      else
        ItemIndex := 0;
    end;

    IndexesListSelect(Self);
  end;
end;

procedure TLauncherForm.AssetsPopupMenuPopup(Sender: TObject);
begin
  with AssetsPopupMenu.Items do
  begin
    Items[1].Enabled := (EnabledAssets.Focused and (EnabledAssets.Count > 0)) or
      (DisabledAssets.Focused and (DisabledAssets.Count > 0));

    Items[1].Enabled := (EnabledAssets.SelCount <> 0) and
      EnabledAssets.Focused;
    Items[2].Enabled := (DisabledAssets.SelCount <> 0) and
      DisabledAssets.Focused;
  end;
end;

procedure TLauncherForm.AuthRefreshState(var Message: TMessage);
begin
  with Auth do
  begin
    AuthLabel.Visible := LoggedIn;
    LogoutButton.Visible := LoggedIn;
    NickLabel.Visible := LoggedIn;
    if LoggedIn then
      NickLabel.Caption := Nick;
    if Visible then
      LoginPageControl.SetFocus;
    AuthButton.Visible := not LoggedIn;
  end;
  AuthStatusLabel.Visible := False;
end;

procedure TLauncherForm.AutoRemoteRefreshCheckBoxClick(Sender: TObject);
begin
  with AutoRemoteRefreshCheckBox do
  begin
    Settings.Profile.B['AutoRefreshRemoteVersionsList'] := Checked;
    ShowNewReleasesCheckBox.Enabled := Checked;
    ShowNewSnapshotsCheckBox.Enabled := Checked;
  end;
end;

procedure TLauncherForm.AuthAutoValidStart(var Message: TMessage);
begin
  AuthLabel.Visible := False;
  LogoutButton.Visible := False;
  AuthButton.Visible := False;
  NickLabel.Visible := False;
  AuthStatusLabel.Visible := True;
end;

procedure TLauncherForm.AuthButtonClick(Sender: TObject);
begin
  LoginForm := TLoginForm.Create(LauncherForm);
  try
    if LoginForm.ShowModal = mrOk then
    begin
      AuthStatusLabel.Visible := True;
      LoginPageControl.SetFocus;
      AuthButton.Visible := False;
      Auth.LogIn(LoginForm.Login.Text, LoginForm.Pass.Text);
    end;
  finally
    FreeAndNil(LoginForm);
  end;
end;

procedure TLauncherForm.BrowseClient(Sender: TObject);
var
  ChosenDirectory: string;
begin
  if BrowseDir(StrDlgBrowseClientPath, '', ChosenDirectory) then
    MinecraftPathEdit.Text := ChosenDirectory;
end;

procedure TLauncherForm.OpenClient(Sender: TObject);
begin
  ShellExecute(Handle, 'Explore', PWideChar(Paths.Client), nil, nil, 1);
end;

procedure TLauncherForm.SetCustomStyle;
var
  hStyle: TStyleManager.TStyleServicesHandle;
  StyleInfo: TStyleInfo;
  StylePath: String;
begin
  try
    StylePath := Settings.Global.S['CustomStylePath'];

    LogF(Self, 'Loading custom style from "%s"...', [StylePath]);
    if TStyleManager.IsValidStyle(StylePath, StyleInfo) then
      if TStyleManager.Style[StyleInfo.Name] = nil then
      begin
        hStyle := TStyleManager.LoadFromFile(StylePath);
        TStyleManager.SetStyle(hStyle);
      end
      else
        TStyleManager.SetStyle(StyleInfo.Name);
  except
    on E: Exception do
    begin
      Log(Self, 'Failed to load custom style.');
      LogE(Self, E);
      Settings.Global.S['CustomStylePath'] := '';
      ShowMessage(StrDlgCantFindStyle);
    end;
  end;
end;

procedure TLauncherForm.SetDefaultClientPath(Sender: TObject);
begin
  MinecraftPathEdit.Text := Paths.ClientDefault;
  LogF(Self, StrLogDefaultMinecraftPath, [MinecraftPathEdit.Text]);
end;

procedure TLauncherForm.SetDefaultStyle;
begin
  case Settings.Global.I['ThemeIndex'] of
    0: TStyleManager.TrySetStyle('Carbon', True);
    1: TStyleManager.TrySetStyle('Light', True);
    else
      TStyleManager.TrySetStyle('Windows', True);
  end;
end;

procedure TLauncherForm.SetProgressBarLabel;
begin
  with LabelOnProgressBar do
  begin
    Parent := DownloaderProgressBar;
    Top := 3;
    Left := 5;
  end;
end;

procedure TLauncherForm.SelectVersionToDownload(Sender: TObject);
begin
  DownloadVersionButton.Caption :=
    Format(StrDownloadSomeVersion, [GetVersionToDl]);
end;

procedure TLauncherForm.DeleteVersion(Sender: TObject);
begin
  if MessageDlg(StrDlgDeleteVersion, mtWarning, mbOkCancel, 0) = mrOk then
    if VersionsManager.DeleteVersion(LauncherForm.VersionsComboList.Text) then
      RefreshClientVersions;
end;

procedure TLauncherForm.VersionsComboListDropDown(Sender: TObject);
begin
  RefreshClientVersions;
end;

procedure TLauncherForm.WriteToLog(var Message: TMessage);
begin
  LauncherLog.Lines.Add(PWideChar(Message.LParam));
end;

procedure TLauncherForm.SaveCheckBoxValue(Sender: TObject);
const
  LibsWarning = 'Отключение этой опции может повредить игре (вплоть до незапу' +
    'ска).'#13#10'Нажмите "OK", только если вы понимаете, что делаете.';
var
  Name: String;
begin
  Name := '';

  if Sender = CatchMCLogCheckBox then
    Name := 'CatchMinecraftLog'
  else if Sender = DownloadLibsCheckBox then
  begin
    Name := 'DownloadLibrariesWithVersions';
    if not DownloadLibsCheckBox.Checked then
      DownloadLibsCheckBox.Checked :=
        MessageDlg(LibsWarning, mtWarning, mbOkCancel, 0) <> mrOk;
  end
  else if Sender = DownloadAssetsCheckBox then
    Name := 'DownloadAssetsWithVersions'
  else if Sender = ForceCheckBox then
    Name := 'ForceDownload'
  else if Sender = ShowNewReleasesCheckBox then
    Name := 'ShowNewReleases'
  else if Sender = ShowNewSnapshotsCheckBox then
    Name := 'ShowNewSnapshots';

  if Name <> '' then
    Settings.Profile.B[Name] := (Sender as TCheckBox).Checked;
end;

procedure TLauncherForm.SaveLaunchCommandButtonClick(Sender: TObject);
var
  SaveDialog: TSaveDialog;
  Cmd: TextFile;
begin
  SaveDialog := TSaveDialog.Create(Self);

  SaveDialog.FileName := 'launch';
  SaveDialog.Filter := 'Bat|*.bat';
  SaveDialog.DefaultExt := 'bat';
  SaveDialog.FilterIndex := 1;

  if SaveDialog.Execute(Self.Handle) then
  begin
    AssignFile(Cmd, SaveDialog.FileName);
    Rewrite(Cmd);
    WriteLn(Cmd, LastLaunchCommand.Replace('javaw', 'java', [rfIgnoreCase]));
    WriteLn(Cmd, 'pause');
    CloseFile(Cmd);
  end;

  SaveDialog.Free;
end;

procedure TLauncherForm.SaveLogButtonClick(Sender: TObject);
var
  SaveDialog: TSaveDialog;
begin
  SaveDialog := TSaveDialog.Create(Self);

  SaveDialog.FileName := 'log';
  SaveDialog.Filter := 'Текстовый файл|*.txt';
  SaveDialog.DefaultExt := 'txt';
  SaveDialog.FilterIndex := 1;

  if SaveDialog.Execute(Self.Handle) then
    LauncherLog.Lines.SaveToFile(SaveDialog.FileName);

  SaveDialog.Free;
end;

{$ENDREGION}

end.
