unit Auth;

interface

implementation

uses
  HTTPPost;

const
  AuthServer: AnsiString = 'authserver.mojang.com';

  AUTHENFICATE_URL: AnsiString = 'authenticate';
  AUTHENFICATE_DATA =
    '{"agent":{"name":"Minecraft","version":1},"username":"%s","password":"%s"}';

end.
