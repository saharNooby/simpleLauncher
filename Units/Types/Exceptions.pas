unit Exceptions;

interface

uses
  SysUtils;

type
  EEmptyVersionIDException = class(Exception);

  EDownloadError = class(Exception);
  EInvalidRespCode = class(EDownloadError);

implementation

end.
