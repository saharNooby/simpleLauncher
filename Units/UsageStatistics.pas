unit UsageStatistics;

interface

uses
    Windows, WinSock, SysUtils;

var
    //LauncherVersion
    //OSName
    //MinecraftVersionName
    
    AdsClickedTimes: Integer = 0;
    PageLinkClickedTimes: Integer = 0;
    MinecraftTriedToBeLaunchedTimes: Integer = 0;
    MinecraftLaunchedTimes: Integer = 0;

procedure SendStatistics();

const
  winsocket = 'wsock32.dll';

function WSAStartup(wVersionRequired: word; var WSData: TWSAData): Integer; stdcall; external winsocket;
function WSACleanup: Integer; stdcall; external winsocket;
function socket(af, Struct, protocol: Integer): TSocket; stdcall; external winsocket;
function connect(s: TSocket; var name: TSockAddr; namelen: Integer): Integer; stdcall; external winsocket;
function send(s: TSocket; var Buf; len, flags: Integer): Integer; stdcall; external winsocket;

implementation

uses
  Vcl.Dialogs, SuperObject, UnitLauncherForm, LauncherStrings;

procedure SendInt(ASocket: TSocket; I: Integer);
begin
    if send(ASocket, I, 4, 0) = SOCKET_ERROR then
    begin
        raise Exception.Create('Socket write error: for integer ' + IntToStr(I));
    end;
end;

procedure SendString(ASocket: TSocket; AString: String);
begin
    SendInt(ASocket, Length(AString));
    if send(ASocket, AString[1], Length(AString) * 2, 0) = SOCKET_ERROR then
    begin
        raise Exception.Create('Socket write error: for string ' + AString);
    end;
end;

procedure SendStatistics();
var
    I: Integer;
    vWSAData : TWSAData;
    vSocket : TSocket;
    vSockAddr : TSockAddr;
begin
    try
        if WSAStartup($101, vWSAData) <> 0 then
        begin
            raise Exception.Create('WSAStartup returned error');
        end;

        vSocket := socket(AF_INET,SOCK_STREAM,IPPROTO_IP);
        if vSocket = INVALID_SOCKET then
        begin
            raise Exception.Create('Invalid socket');
        end;

        FillChar(vSockAddr, SizeOf(TSockAddr), 0);
        vSockAddr.sin_family := AF_INET;
        vSockAddr.sin_port := htons(9901);
        vSockAddr.sin_addr.S_addr := inet_addr('195.88.209.68');
        if connect(vSocket, vSockAddr, SizeOf(TSockAddr)) = SOCKET_ERROR then
        begin
            raise Exception.Create('Socket connect error');
        end;

        I := Random($FFFFFFF) or 48;
        SendInt(vSocket, I);
        
        SendString(vSocket, LauncherStrings.LauncherVersionString);
        SendString(vSocket, TOSVersion.ToString);
        SendString(vSocket, LauncherForm.VersionsComboList.Text);

        SendInt(vSocket, AdsClickedTimes);
        SendInt(vSocket, PageLinkClickedTimes);
        SendInt(vSocket, MinecraftTriedToBeLaunchedTimes);
        SendInt(vSocket, MinecraftLaunchedTimes);
        
        closesocket(vSocket);
        WSACleanup();
    except
        on E: Exception do
        begin 
            // Ignore
        end;
    end;
end;

end.

