unit WinUI3.Dialogs.DataTransferManager;

interface

uses
  System.SysUtils, System.Classes,
  {$IFDEF MSWINDOWS}
  Winapi.Windows, Winapi.WinRT, System.Generics.Collections,
  System.Win.ShareContract, Winapi.ApplicationModel.DataTransfer,
  System.Win.WinRT, Winapi.CommonTypes,
  {$ENDIF}
  FMX.Forms;

type
  {$IFDEF MSWINDOWS}
  TShareContract = class(System.Win.ShareContract.TShareContract)
    type
      TDataTransferEventHandler = class(TInspectableObject, TypedEventHandler_2__IDataTransferManager__IDataRequestedEventArgs_Delegate_Base, TypedEventHandler_2__IDataTransferManager__IDataRequestedEventArgs)
      private
        [Weak]
        FOwner: TShareContract;
        procedure Invoke(sender: IDataTransferManager; args: IDataRequestedEventArgs); safecall;
      public
        constructor Create(const AOwner: TShareContract);
        destructor Destroy; override;
      end;
    constructor Create(AWinHandle: HWND);
  end;

  TIterableStorageItems = class(TInspectableObject, IIterable_1__IStorageItem)
  private
    FItems: TList<IStorageItem>;
  public
    constructor Create;
    destructor Destroy; override;
    function First: IIterator_1__IStorageItem; safecall;
    procedure Add(AItem: IStorageItem);
  end;
  {$ELSE}

  TShareContract = class
  end;
  {$ENDIF}

var
  LastShare: TShareContract = nil;

procedure ShowShareUI(Form: TCustomForm; Proc: TProc<TShareContract>);

implementation

{$IFDEF MSWINDOWS}

uses
  FMX.Platform.Win, Winapi.Foundation, Winapi.Storage;
{$ENDIF}

procedure ShowShareUI(Form: TCustomForm; Proc: TProc<TShareContract>);
begin
  {$IFDEF MSWINDOWS}
  TShareContract.OnProcessMessages := Application.ProcessMessages;
  if LastShare <> nil then
  begin
    LastShare.Free;
    LastShare := nil;
  end;
  LastShare := TShareContract.Create(FormToHWND(Form));
  try
    Proc(LastShare);
    LastShare.InitSharing;
  except
    LastShare.Free;
    LastShare := nil;
  end;
  {$ENDIF}
end;

{$IFDEF MSWINDOWS}

{ TShareContract.TDataTransferEventHandler }

constructor TShareContract.TDataTransferEventHandler.Create(const AOwner: TShareContract);
begin
  inherited Create;
  FOwner := AOwner;
end;

destructor TShareContract.TDataTransferEventHandler.Destroy;
begin
  inherited;
end;

procedure TShareContract.TDataTransferEventHandler.Invoke(sender: IDataTransferManager; args: IDataRequestedEventArgs);
var
  LRequest: IDataRequest;
  LDataPackage: IDataPackage;
  LProperties: IDataPackagePropertySet;
  LProperties2: IDataPackagePropertySet2;
  LURI: IUriRuntimeClass;
  LWebURI: IUriRuntimeClass;
  LWebAppURI: IUriRuntimeClass;
  LWindowsString: TWindowsString;
  LTmpWinStr: TWindowsString;
  LMyElem: string;
  LIterableStorageItems: TIterableStorageItems;
  LAsynOp: IAsyncOperation_1__IStorageFile;
  LStorageFile: IStorageFile;
  LOut: IAsyncInfo;
  LErr: Cardinal;
begin
  LRequest := args.get_Request;
  LDataPackage := LRequest.get_Data;

  LProperties := LDataPackage.get_Properties;

  if FOwner.DataTitle <> '' then
  begin
    LWindowsString := TWindowsString.Create(FOwner.DataTitle);
    LProperties.Title := LWindowsString;
  end;

  if FOwner.ApplicationName <> '' then
  begin
    LWindowsString := TWindowsString.Create(FOwner.ApplicationName);
    LProperties.ApplicationName := LWindowsString;
  end;

  if FOwner.Description <> '' then
  begin
    LWindowsString := TWindowsString.Create(FOwner.Description);
    LProperties.Description := LWindowsString;
  end;

  if FOwner.ImageFile <> '' then
  begin
    LProperties.Thumbnail := FileNameToStream(FOwner.ImageFile);
  end;

  if FOwner.DataText <> '' then
  begin
    LWindowsString := TWindowsString.Create(FOwner.DataText);
    LDataPackage.SetText(LWindowsString);
  end;

  if FOwner.RtfText <> '' then
  begin
    LDataPackage.Properties.FileTypes.Append(TStandardDataFormats.Statics.Rtf);
    LWindowsString := TWindowsString.Create(FOwner.RtfText);
    LDataPackage.SetRtf(LWindowsString);
  end;

  if FOwner.HTML <> '' then
  begin
    LDataPackage.Properties.FileTypes.Append(TStandardDataFormats.Statics.Html);
    LWindowsString := TWindowsString.Create(FOwner.HTML);
    LDataPackage.SetHtmlFormat(THtmlFormatHelper.Statics.CreateHtmlFormat(LWindowsString));
  end;

  if FOwner.WebAddress <> '' then
  begin
    LWindowsString := TWindowsString.Create(FOwner.WebAddress);
    LURI := TUri.Factory.CreateUri(LWindowsString);
    LDataPackage.SetUri(LURI);
  end;

  LProperties2 := LDataPackage.get_Properties as IDataPackagePropertySet2;

  if FOwner.ContentSourceApplicationLink <> '' then
  begin
    LWindowsString := TWindowsString.Create(FOwner.ContentSourceApplicationLink);
    LWebAppURI := TUri.Factory.CreateUri(LWindowsString);
    LProperties2.ContentSourceApplicationLink := LWebAppURI;
  end;

  if FOwner.ContentSourceWebLink <> '' then
  begin
    LWindowsString := TWindowsString.Create(FOwner.ContentSourceWebLink);
    LWebURI := TUri.Factory.CreateUri(LWindowsString);
    LProperties2.ContentSourceWebLink := LWebURI;
  end;

  if FOwner.PackageName <> '' then
  begin
    LWindowsString := TWindowsString.Create(FOwner.PackageName);
    LProperties2.PackageFamilyName := LWindowsString;
  end;

  if FOwner.LogoFile <> '' then
    LProperties2.Square30x30Logo := FileNameToStream(FOwner.LogoFile);

  if FOwner.FileList.Count > 0 then
  begin
    LIterableStorageItems := TIterableStorageItems.Create;
    try
      for LMyElem in FOwner.FileList do
      begin
        if LMyElem <> '' then
        begin
          LTmpWinStr := TWindowsString.Create(LMyElem);
          LAsynOp := TStorageFile.GetFileFromPathAsync(LTmpWinStr);
          if not Supports(LAsynOp, IAsyncInfo, LOut) then
            raise Exception.Create('Interface not supports IAsyncInfo');

          while not (LOut.Status in [AsyncStatus.Completed, AsyncStatus.Canceled, AsyncStatus.Error]) do
          begin
            Sleep(100);
            FOwner.OnProcessMessages;
          end;
          LErr := HResultCode(LOut.ErrorCode);
          if LErr <> ERROR_SUCCESS then
            // FIX {how to retrieve the error description?}
            raise Exception.Create(SysErrorMessage(LErr));

          LStorageFile := LAsynOp.GetResults;
          LIterableStorageItems.Add(LStorageFile as IStorageItem);
        end;
      end;
      LRequest.Data.SetStorageItems(LIterableStorageItems);
    finally
      LIterableStorageItems.Free;
    end;
  end;
end;

{ TShareContract }

constructor TShareContract.Create(AWinHandle: HWND);
begin
  inherited Create(AWinHandle);
  FDataRequestedHandlerIntf := nil;
  FTransferManager.remove_DataRequested(FSharingRequested);
  FDataRequestedHandlerIntf := TDataTransferEventHandler.Create(Self);
  FSharingRequested := FTransferManager.add_DataRequested(FDataRequestedHandlerIntf);
end;

{ TIterableStorageFiles }

procedure TIterableStorageItems.Add(AItem: IStorageItem);
begin
  FItems.Add(AItem);
end;

constructor TIterableStorageItems.Create;
begin
  inherited;
  FItems := TList<IStorageItem>.Create;
end;

destructor TIterableStorageItems.Destroy;
begin
  FItems.Free;
  inherited;
end;

function TIterableStorageItems.First: IIterator_1__IStorageItem;
begin
  Result := TIteratorStorageItems.Create(FItems);
end;
{$ENDIF}

initialization

finalization
  LastShare.Free;
  LastShare := nil;

end.

