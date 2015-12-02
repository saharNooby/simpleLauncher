unit BrowseDirectory;

interface

function BrowseDir(Caption: String; Root: String; var Dir: String): boolean;

implementation

uses
  SysUtils, Windows, ActiveX, ShlObj, Forms;

function SelectDirCB(Wnd: HWND; uMsg: UINT; lParam, lpData: lParam): integer;
  stdcall;
begin
  if uMsg = BFFM_INITIALIZED then
    SendMessage(Wnd, BFFM_SETSELECTION, Ord(True), integer(lpData));
  Result := 0;
end;

function BrowseDir(Caption: String; Root: String; var Dir: String): boolean;
const
  BIF_USENEWUI = $0040;
var
  WindowList: Pointer;
  BrowseInfo: TBrowseInfo;
  Buffer: PChar;
  RootItemIDList, ItemIDList: PItemIDList;
  ShellMalloc: IMalloc;
  IDesktopFolder: IShellFolder;
  Eaten, Flags: LongWord;
begin
  Result := False;
  if not DirectoryExists(Dir) then
    Dir := '';
  FillChar(BrowseInfo, SizeOf(BrowseInfo), 0);
  if (ShGetMalloc(ShellMalloc) = S_OK) and (ShellMalloc <> nil) then
  begin
    Buffer := ShellMalloc.Alloc(MAX_PATH);
    try
      RootItemIDList := nil;
      if Root <> '' then
      begin
        SHGetDesktopFolder(IDesktopFolder);
        IDesktopFolder.ParseDisplayName(Application.Handle, nil,
          POleStr(Root), Eaten, RootItemIDList, Flags);
      end;
      OleInitialize(nil);
      with BrowseInfo do
      begin
        hwndOwner := Application.Handle;
        pidlRoot := RootItemIDList;
        pszDisplayName := Buffer;
        lpszTitle := PWideChar(Caption);
        ulFlags := BIF_RETURNONLYFSDIRS or BIF_USENEWUI;
        lpfn := @SelectDirCB;
        if Dir <> '' then
          lParam := integer(PChar(Dir));
      end;
      WindowList := DisableTaskWindows(0);
      try
        ItemIDList := ShBrowseForFolder(BrowseInfo);
      finally
        EnableTaskWindows(WindowList);
      end;
      Result := ItemIDList <> nil;
      if Result then
      begin
        ShGetPathFromIDList(ItemIDList, Buffer);
        ShellMalloc.Free(ItemIDList);
        Dir := Buffer;
      end;
    finally
      ShellMalloc.Free(Buffer);
    end;
  end;
end;

end.
