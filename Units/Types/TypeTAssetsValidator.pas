unit TypeTAssetsValidator;

interface

uses
  SuperObject;

type
  TAssetsValidator = class
  private
    FIndex: ISuperObject;
    FForce: Boolean;
    FMigrated: Integer;
    FIndexName: String;

    procedure ParseIndex;
    procedure ValidateAsset(Migr: boolean; Asset: TSuperAVLEntry);
    procedure MigrateAsset(ObjPath: String; Asset: TSuperAVLEntry);
  public
    constructor Create(const MCVer: string; const Force: Boolean);
  end;

implementation

uses
  SysUtils, BaseUtils, LauncherPaths, Exceptions, Logging, LauncherURLs,
  LauncherStrings, Downloader, UnitLauncherForm;


{ TAssetsValidator }

procedure TAssetsValidator.MigrateAsset(ObjPath: String; Asset: TSuperAVLEntry);
var
  VirtualPath: String;
begin
  VirtualPath := Paths.Client + 'assets\virtual\legacy\' + Asset.Name;
  if FForce or not FileExists(VirtualPath) then
    try
      ForceDirectories(ExtractFileDir(VirtualPath.Replace('/', '\')));
      CopyFile(ObjPath, VirtualPath);
      Inc(FMigrated);
    except
      LogF(StrLogAssetNotMigrated, [ObjPath], 1);
    end;
end;

procedure TAssetsValidator.ParseIndex;
const
  TryCnt = 3;
var
  IndexPath: String;
  TryNum: Integer;
  Data: TDownloadData;
begin
  IndexPath := Paths.Client + 'assets\indexes\' + FIndexName + '.json';

  for TryNum := 1 to TryCnt do
  begin
    if ExtParse(IndexPath, @FIndex) then
      Break
    else
    begin
      FillChar(Data, SizeOf(Data), #0);
      Data.WndHandle := LauncherForm.Handle;
      Data.URL := URLs.Index(FIndexName);
      Data.FileName := IndexPath;
      Data.Notify := True;
      try
        LogF(Self, 'Trying %d of %d download index "%s"', [TryNum, TryCnt,
          IndexPath]);
        ForceDirectories(Paths.Client + 'assets\indexes\');
        Download(Data);
      except
        on E: EInvalidRespCode do
        begin
          LogF(Self, '%s, assets checking aborted.', [E.Message], 1);
          raise;
        end;
        else
          raise;
      end;
    end;
  end;

  if not Assigned(FIndex) then
  begin
    Log(Self, 'Can parse index.', 1);
    raise Exception.Create('Can not parse index');
  end;
end;

constructor TAssetsValidator.Create(const MCVer: string; const Force: Boolean);
var
  Obj: ISuperObject;
  ObjectsEnum: TSuperAvlIterator;
begin
  inherited Create();
  try
    FMigrated := 0;
    FForce := Force;

    LogF(Self, 'Validating assets for version %s, Force = %s',
      [MCVer, Force.ToString]);

    // Получаем данные о версии
    // О наличии json-файла версии должны заботиться методы выше по стеку
    if not ExtParse(Paths.json(MCVer), @Obj) then
      Exit
    else
      if Obj.S['assets'] = '' then
        FIndexName := 'legacy'
      else
        FIndexName := Obj.S['assets'];

    // Парсинг индекс-файла и его загрузка, если отсутствует
    try
      ParseIndex;
    except
      Exit;
    end;

    ObjectsEnum := FIndex.O['objects'].AsObject.GetEnumerator;
    ObjectsEnum.First;

    // Пробегаемся по каждому ресурсу
    repeat
      ValidateAsset(FIndex.B['virtual'], ObjectsEnum.Current);
    until not ObjectsEnum.MoveNext;
    FreeAndNil(ObjectsEnum);

    if FMigrated <> 0 then
      LogF(StrLogMigratedAssetsCount, [FMigrated]);
  finally
    Log(Self, 'Validating completed.');
    Free;
  end;
end;

procedure TAssetsValidator.ValidateAsset(Migr: boolean; Asset: TSuperAVLEntry);
const
  TryCnt = 3;
var
  Hash, RealHash, ObjDir, ObjPath: String;
  TryNum: Integer;
  Data: TDownloadData;
begin
  Hash := Asset.Value.S['hash'];

  ObjDir := Paths.Client + 'assets\objects\' + Hash[1] + Hash[2] + '\';
  ObjPath := ObjDir + Hash;

  // Если файл отсутствует или форсрованная загрузка включена
  if FForce or not FileExists(ObjPath) then
  begin
    FillChar(Data, SizeOf(Data), #0);
    Data.WndHandle := LauncherForm.Handle;
    Data.URL := URLs.Asset(Hash);
    Data.FileName := ObjPath;
    Data.Notify := True;
    for TryNum := 1 to TryCnt do // Попытки закачать ресурс
    begin
      LogF(Self, StrLogTryDownloadAsset, [TryNum, TryCnt, Hash]);
      try
        ForceDirectories(ObjDir);
        Download(Data);
        // При успешной загрузке сверяем хэши
        RealHash := GetSHA1(ObjPath);
        if RealHash = Hash then
          Break;
      except
        on E: EInvalidRespCode do
        begin
          LogF(Self, '%s, asset downloading aborted.', [E.Message], 1);
          Break;
        end;
        else
          Break;
      end;
    end;
  end;

  // Если успешно загружен ресурс (или был уже) и нужно мигрировать
  if FileExists(ObjPath) and Migr then
    MigrateAsset(ObjPath, Asset);
end;

end.
