unit UnitLauncherThread;

interface

uses
  LaunchCommand, Classes, SuperObject;

type
  TLauncherThread = class(TThread)
  private
    FCommandOptions: TCommandOptions;
    FCmdStr: String;
    FMsg: String;

    procedure ValidateMinecraft;
    procedure Launch;
    procedure SetTrayIcon;
    procedure AppShow;
    procedure StartAndListen;
    procedure OnListenMC(const Msg: String);
    procedure FillOptions;
    procedure AddMsgToLog;
  protected
    procedure Execute; override;
  public
    procedure DisableButtons;
    procedure EnableButtons;
  end;

var
  LauncherThread: TLauncherThread;

implementation

uses
  Logging, LauncherStrings, SysUtils, BaseUtils,
  TypeTAssetsValidator, TypeTLibsValidator,
  LauncherPaths, LauncherSettings, UsageStatistics,
  UnitLauncherForm,
  PipesAPI, UnitMinecraftListenerThread,
  Dialogs, Windows, AuthUnit;

procedure TLauncherThread.AddMsgToLog;
begin
  LauncherForm.LauncherLog.Lines.Append(FMsg);
end;

procedure TLauncherThread.AppShow;
begin
  with LauncherForm do
    if not (Visible or CloseOnLauncherTerminates) then
    begin
      Show;
      Log(Self, 'Main form has been showed.');
      TrayIcon.Visible := False;
    end;
end;

procedure TLauncherThread.DisableButtons;
begin
  with LauncherForm do
  begin
    with DownloadVersionButton do
    begin
      Tag := Enabled.ToInteger;
      Enabled := False;
    end;
    LaunchButton.Enabled := False;
  end;
end;

procedure TLauncherThread.EnableButtons;
begin
  with LauncherForm do
  begin
    with DownloadVersionButton do
      Enabled := Integer(Tag).ToBoolean;
    LaunchButton.Enabled := True;
  end;
end;

procedure TLauncherThread.Execute;
begin
  Synchronize(DisableButtons);
  if Settings.Profile.I['LoginMode'] = 1 then
  with Auth do
    Auth.Refresh;
  Synchronize(FillOptions);
  ValidateMinecraft;
  FCmdStr := GetLaunchCommand(FCommandOptions);
  LogF(Self, StrLogCMDString, [FCmdStr]);
  Launch;
end;

procedure TLauncherThread.FillOptions;
begin
  FillChar(FCommandOptions, SizeOf(FCommandOptions), #0);

  with FCommandOptions, LauncherForm do
  begin
    id := VersionsComboList.Text;
    Memory := MemoryEdit.Text;
    case MemoryComboBox.ItemIndex of
      0:
        MemChar := 'M';
      1:
        MemChar := 'G';
    end;
    Arguments := JVMArgsEdit.Text;
    MCArguments := MinecraftArgsEdit.Text;
    FCommandOptions.Width := MCWidthEdit.Text;
    FCommandOptions.Height := MCHeightEdit.Text;
  end;
end;

procedure TLauncherThread.SetTrayIcon;
begin
  // Настройка иконки в трее, которая появляется на время скрытия
  if Settings.Profile.B['ShowTrayIcon'] then
    with LauncherForm.TrayIcon do
    begin
      Visible := True;
      Hint :=
        'simpleLauncher свёрнут и ожидает завершения игры.'#13#10 +
        'Нажмите на эту иконку, чтобы развернуть окно.';
    end;
end;

procedure TLauncherThread.OnListenMC(const Msg: String);
begin
  // Пришло сообщение от процесса, пишем его в поле
  FMsg := Msg;
  // ...и синхронизованно пишем сообщение в лог
  Synchronize(AddMsgToLog);
end;

procedure TLauncherThread.StartAndListen;
var
  LastErr, SleepDelay: Integer;
  ErrMsg: String;
begin
  if Settings.Profile.B['DebugMode'] then
    Exit;

  if CreatePipes(nil, PWideChar(FCmdStr), PWideChar(Paths.Client), 1,
    REDIRECT_OUTPUT, PipeInfo) then
  begin
    Inc(UsageStatistics.MinecraftLaunchedTimes);

    // Сообщаем форме о том, что нужно ждать завершения Minecraft

    Synchronize(procedure begin
      LauncherForm.WaitForProcessExit := True;
      LauncherForm.SaveLaunchCommandButton.Enabled := True;
      LauncherForm.LastLaunchCommand := FCmdStr;
      SleepDelay := StrToInt(LauncherForm.EditSleepDelay.Text);
    end);

    // Настройка ловчего лога
    MinecraftListener := TMinecraftListenerThread.Create(True);
    MinecraftListener.SleepDelay := SleepDelay;
    with MinecraftListener do
    begin
      FreeOnTerminate := True;
      // Если нужно ловить лог, то назначаем ему обработчик
      if Settings.Profile.B['CatchMinecraftLog'] then
        OnListen := OnListenMC;
      Start;
    end;

    // Ожидание завершения процесса
    WaitForSingleObject(PipeInfo.ProcessInfo.hProcess, INFINITE);

    // По завершении убить ловчего
    MinecraftListener.Terminate;
    // Подождём, пока ловчий уничтожится
    WaitForSingleObject(MinecraftListener.Handle, INFINITE);
    // Закрываем трубки
    with PipeInfo do
      DestroyPipes(StdIn, WriteStdIn, StdOut, ReadStdOut);

    // Ждать не надо
    Synchronize(procedure begin LauncherForm.WaitForProcessExit := False end);
  end
  else
  begin
    LastErr := GetLastError;
    if LastErr <> 2 then
      ErrMsg :=
        'Не могу создать процесс.'#10#10 +
        IntToStr(LastErr) + ': ' + SysErrorMessage(LastErr)
    else
      ErrMsg :=
        'Не найдена Java по пути "' + Paths.Java + '".'#10#10 +
        'Укажите другой путь или переустановите Java.';
    Synchronize(procedure begin ShowMessage(ErrMsg) end);
  end;
end;

procedure TLauncherThread.ValidateMinecraft;
begin
  // Ресурсы
  if not Settings.Profile.B['DontCheckAssets'] then
    TAssetsValidator.Create(LauncherForm.VersionsComboList.Text, False);
  // Библиотеки
  if not Settings.Profile.B['DontCheckLibraries'] then
    TLibsValidator.Create(LauncherForm.VersionsComboList.Text, False);
end;

procedure TLauncherThread.Launch;
begin
  if FCmdStr = '' then
    raise Exception.Create('Пустая команда запуска!');

  case Settings.Profile.I['LauncherVisibility'] of
    0:
      begin
        Log(Self, 'Starting Minecraft with closing, kthxbai!');
        Synchronize(procedure begin LauncherForm.Hide end);
        StartAndListen;
        Synchronize(procedure begin LauncherForm.Close end);
      end;
    1:
      begin
        Log(Self, 'Starting Minecraft without closing...');
        StartAndListen;
      end;
    2:
      begin
        Log(Self, 'Starting Minecraft with hiding to tray...');
        Synchronize(procedure begin LauncherForm.Hide end);
        Synchronize(SetTrayIcon);
        StartAndListen;
        Synchronize(AppShow);
      end;
    3:
      begin
        Log(Self, 'Starting Minecraft with closing on exit.');
        StartAndListen;
        Synchronize(procedure begin LauncherForm.Close end);
      end;
  end;
end;

end.
