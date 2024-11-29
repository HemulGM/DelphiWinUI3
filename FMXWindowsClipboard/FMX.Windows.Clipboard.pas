unit FMX.Windows.Clipboard;

interface

uses
  System.Classes;

function GetClipboardHTML: string;

function GetClipboardGIF: TMemoryStream;

function ClipboardHasHTML: Boolean;

function ClipboardHasGIF: Boolean;

var
  CF_HTML: Cardinal = 0;
  CF_GIF: Cardinal = 0;

implementation

uses
  FMX.Platform.Win, Winapi.Windows, Winapi.ShellAPI;

function ClipboardHasHTML: Boolean;
begin
  Result := IsClipboardFormatAvailable(CF_HTML);
end;

function ClipboardHasGIF: Boolean;
begin
  Result := IsClipboardFormatAvailable(CF_GIF);
end;

function GetClipboardHTML: string;
begin
  if not IsClipboardFormatAvailable(CF_HTML) then
    Exit;
  if OpenClipboard(ApplicationHWND) then
  try
    var AData := GetClipboardData(CF_HTML);
    if AData = 0 then
      Exit;
    var Size := GlobalSize(AData);
    var Buffer := GlobalLock(AData);
    try
      var Stream := TStringStream.Create;
      try
        Stream.SetSize(Size);
        Move(Buffer^, Stream.Memory^, Size);
        Result := Stream.DataString;
      finally
        Stream.Free;
      end;
    finally
      GlobalUnlock(AData);
    end;
  finally
    CloseClipboard;
  end;
end;

function GetClipboardGIF: TMemoryStream;
begin
  Result := nil;
  if not IsClipboardFormatAvailable(CF_GIF) then
    Exit;
  if OpenClipboard(ApplicationHWND) then
  try
    var AData := GetClipboardData(CF_GIF);
    if AData = 0 then
      Exit;
    var Size := GlobalSize(AData);
    var Buffer := GlobalLock(AData);
    try
      Result := TMemoryStream.Create;
      Result.SetSize(Size);
      Move(Buffer^, Result.Memory^, Size);
    finally
      GlobalUnlock(AData);
    end;
  finally
    CloseClipboard;
  end;
end;

initialization
  CF_HTML := RegisterClipboardFormat('HTML Format');
  CF_GIF := RegisterClipboardFormat('GIF Format');

end.

