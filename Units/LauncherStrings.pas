// Ресурсные строки и строковые константы

unit LauncherStrings;

interface

const
  { Адреса сайтов }
  StrLauncherUpdates           = 'http://www.simplelauncher.ru/dl/updateinfo.php?v=';
  { Стандартные значения}
  StrDefaultJavaPath           = 'javaw';
  StrDefaultNick               = 'Player';

resourcestring
  InvalidResponse              = 'Сервер не вернул ответ, проверьте подключение к Интернету.';
  InvalidCredentials           = 'Invalid credentials. Invalid username or password.';
  InvalidCredentialsRu         = 'Неверный логин или пароль.';
  LoginErrorMsg                = 'Произошла ошибка во время авторизации. Причина:'#13#13;

  { Строки }
  StrJSONContainsErrors        = 'Изменённый JSON содержит ошибки. Выйти без сохранения?';
  StrButtonUpdateCaption       = 'Проверить наличие новой версии лаунчера';
  StrDlgBrowseClientPath       = 'Выберите папку с Minecraft';
  StrDlgCantFindStyle          = 'Файл стиля не найден! Укажите его заново в дополнительных настройках.';
  StrDlgCantFindVersion        = 'Версия не существует, недоступна или json-файл содержит ошибки.';
  StrDlgCantRemoleLastProfile  = 'Нельзя удалить последний профиль!';
  StrDlgDeleteProfile          = 'Удалить профиль?';
  StrDlgDeleteVersion          = 'Удалить версию? Она удалится не только из списка, но и с жесткого диска!';
  StrDlgDownloadError          = 'Произошла ошибка при загрузке файла "%s". Загрузить заново?';
  { Предупреждение при закрытии }
  StrDlgDownloading            = 'Сейчас загружается какой-то файл! Закрыть лаунчер?';
  { Диалог ошибки запуска }
  StrDlgLaunchError            = 'Во время запуска игры произошла ошибка.'#13#10#13#10'Текст ошибки: %s'#13#10#13#10'Попробуйте загрузить версию заново.';
  StrDlgLaunchErrorCaption     = 'Ошибка запуска игры';
  { Ошибки при загрузке списка версий }
  StrDlgListDownloadError      = 'Невозможно получить список версий. Это может быть из-за отсутствия интернета или недоступности сервера.';
  StrDlgListParsingError       = 'Невозможно распарсить загруженный список версий, попробуйте нажать на кнопку ещё раз.';

  StrDlgVersionNotRemoved      = 'Произошла ошибка при удалении версии. Текст ошибки: "%s"';
  { Кнопка загрузки версии }
  StrDownloadSomeVersion       = 'Загрузить версию %s';
  StrDownloadVersion           = 'Загрузить выбранную версию';
  StrDownloadingVersion        = 'Загружаю версию %s...';
  { Исключения }
  StrExcInternetReadFile       = 'Can''t "InterenetReadFile"!';
  StrExcParsingError           = 'Can''t parse JSON!';
  { Управление профилями }
  StrInputNewProfile           = 'Введите имя нового профиля:';
  StrInputNewProfileTitle      = 'Новый профиль настроек';
  StrInputRenameProfile        = 'Введите новое имя профиля:';
  StrInputRenameProfileTitle   = 'Переименовывание профиля настроек';
  { Лог }
  StrLogAssetNotMigrated       = 'Asset not migrated: "%s"';
  StrLogCMDString              = 'Full launch command: %s';
  StrLogCantCreateDir          = 'Can''t create directory "%s"!';
  StrLogCantDownloadList       = 'Can''t download versions list.';
  StrLogCantWriteFile          = 'Can''t write file "%s".';
  StrLogDefaultMinecraftPath   = 'Applied default Minecraft path: "%s".';
  StrLogDirNotRemoved          = 'Directory "%s" has not been removed. Exception message: %s';
  StrLogDownloaded             = '"%s" successfully downloaded!';
  StrLogDownloading            = 'Downloading "%s" from "%s"...';
  StrLogFileNotFound           = 'File "%s" not found.';
  StrLogFileNotRemoved         = 'File "%s" has been not removed, exception message: %s';
  StrLogFileRemoved            = 'File "%s" has been removed.';
  StrLogLibDownloaded          = 'Library successfully downloaded.';
  StrLogMigratedAssetsCount    = '%d assets migrated.';
  StrLogNotDownloaded          = '"%s" not downloaded!';
  StrLogParsingError           = 'An error occurred while parsing file "%s": an object or array is not found!';
  StrLogRefreshingList         = 'Refreshing downloadable versions list...';
  StrLogSettingDefaultSettings = 'Applied default settings.';
  StrLogSettingsError          = 'Error when applying settings.';
  StrLogSettingsLoaded         = 'Settings loaded. Profile name: "%s"';
  StrLogSettingsSaved          = 'Settings saved.';
  StrLogSuccessfulRefresh      = 'Versions list succsessfully refreshed.';
  StrLogTryDownloadAsset       = 'Trying %d of %d download asset "%s"...';
  StrLogTryingLaunch           = 'Try to run version "%s"...';
  StrLogUnknownFileError       = 'Unknown error when opening a file "%s"';
  StrLogUnknownFileWriteError  = 'Unknown error when writing to file "%s"';
  StrLogVersionDeleted         = 'Version "%s" has been removed.';
  StrLogVersionNotSaved        = 'Version "%s" has not been saved!';
  StrLogVersionSaved           = 'Version "%s" has been saved.';
  { Надписи на прогрессбаре }
  StrProgressBarAsset          = 'Загружаю ресурс "%s" (%d из %d)...';
  StrProgressBarLib            = 'Загружаю библиотеку "%s" (%d из %d)...';
  { Кнопка обновления списка версий }
  StrRefreshList               = 'Обновить список загружаемых версий';
  StrRefreshingList            = 'Обновляю список...';
  { Сообщения апдейтера лаунчера }
  StrUpdaterError              = 'Не удалось проверить наличие обновлений.'#13#10'Возможно, нет подключения к интернету или сайт лаунчера недоступен.';
  StrUpdaterNotNeed            = 'Обновление лаунчера не требуется.'#13#10'Ваша версия лаунчера самая новая.';

{ Информация о версии }
function LauncherVersionCode: Word;
function LauncherVersionString: String;

implementation

uses
  SysUtils, Windows;

type
  TVersionInfo = packed record
    Major, Release: Word;
  end;

function GetVersionInfo: TVersionInfo;
var
  Handle: THandle;
  VerInfoSize: DWORD;
  VerInfoSize2: UINT;
  VerData, VerData2: Pointer;
begin
  // Инициализация
  FillChar(Result, SizeOf(Result), #0);
  Handle := 0;

  VerInfoSize := GetFileVersionInfoSize(PChar(ParamStr(0)), VerInfoSize);
  if VerInfoSize <> 0 then
  begin
    GetMem(VerData, VerInfoSize);
    if GetFileVersionInfo(PChar(ParamStr(0)), Handle, VerInfoSize, VerData) then
    begin
      VerInfoSize2 := SizeOf(TVSFixedFileInfo);
      VerQueryValue(VerData, '\', VerData2, VerInfoSize2);

      // Запись в результат
      with Result, PVSFixedFileInfo(VerData2)^ do
      begin
        Major := HiWord(dwFileVersionMS);
        Release := HiWord(dwFileVersionLS);
      end;
    end;
    FreeMem(VerData, VerInfoSize);
  end
  else
    raise Exception.Create(
      'Не могу получить информацию о версии! Ты трогал екзешник?'#10#10 +
      'Убедись, что ты скачал версию с официального сайта simplelauncher.ru'
    );
end;

function LauncherVersionCode: Word;
var
  VersionInfo: TVersionInfo;
begin
  VersionInfo := GetVersionInfo;
  Result := VersionInfo.Major * 100 + VersionInfo.Release;
end;

function LauncherVersionString: String;
var
  VersionInfo: TVersionInfo;
begin
  VersionInfo := GetVersionInfo;
  Result := Format('%d.%.2d', [VersionInfo.Major, VersionInfo.Release]);
end;

end.
