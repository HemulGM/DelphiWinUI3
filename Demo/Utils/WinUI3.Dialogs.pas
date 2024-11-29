unit WinUI3.Dialogs;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Controls.Presentation, System.Actions, FMX.ActnList,
  System.Generics.Collections, FMX.Edit, FMX.Memo, WinUI3.Frame.Dialog.Text,
  WinUI3.Frame.Dialog, WinUI3.Frame.Dialog.Input, WinUI3.Frame.Inner.InfoBar,
  WinUI3.Frame.Dialog.ColorPicker, WinUI3.Dialogs.DataTransferManager;

const
  MR_AUTOCLOSE = WinUI3.Frame.Dialog.MR_AUTOCLOSE;

type
  TDialogResult = record
    Result: Integer;
    IsChecked: Boolean;
  end;

  TDialogFramedParams = WinUI3.Frame.Dialog.TDialogFramedParams;

  TDialogTextParams = WinUI3.Frame.Dialog.Text.TDialogTextParams;

  TDialogInputParams = WinUI3.Frame.Dialog.Input.TDialogInputParams;

  TDialogInputResult = WinUI3.Frame.Dialog.Input.TDialogInputResult;

  TDialogColorParams = WinUI3.Frame.Dialog.ColorPicker.TDialogColorParams;

  TDialogColorResult = WinUI3.Frame.Dialog.ColorPicker.TDialogColorResult;

  TShareContract = WinUI3.Dialogs.DataTransferManager.TShareContract;

  TInfoBarParams = WinUI3.Frame.Inner.InfoBar.TInfoBarParams;

  TWinUIDialog = class
  public //modal
    class function Show(Owner: TCustomForm; const Title: string; Body: TFrame; Buttons: TArray<string>; AccentId, DefaultId: Integer; CanClose: Boolean; FrameColor: TColor = TColors.Null): Integer; overload;
    class function Show(Owner: TCustomForm; Params: TDialogFramedParams; Ready: TProc = nil): TDialogResult; overload;
    class function Show(Owner: TCustomForm; Params: TDialogTextParams): TDialogResult; overload;
    class function Show(Owner: TCustomForm; Params: TDialogInputParams): TDialogInputResult; overload;
    class function Show(Owner: TCustomForm; Params: TDialogColorParams): TDialogColorResult; overload;
    class function Show(Owner: TCustomForm; const Title: string; const Body: string; Buttons: TArray<string>; AccentId, DefaultId: Integer; CanClose: Boolean; FrameColor: TColor = TColors.Null): Integer; overload;
  public //inner
    class procedure ShowInline(Owner: TCustomForm; Callback: TProc<Integer>; const Title: string; Body: TFrame; Buttons: TArray<string>; AccentId, DefaultId: Integer; CanClose: Boolean; FrameColor: TColor = TColors.Null); overload;
    class procedure ShowInline(Owner: TCustomForm; Callback: TProc<Integer>; const Title: string; const Body: string; Buttons: TArray<string>; AccentId, DefaultId: Integer; CanClose: Boolean; FrameColor: TColor = TColors.Null); overload;
    class procedure ShowInline(Owner: TCustomForm; Callback: TProc<TDialogResult>; Params: TDialogFramedParams; Ready: TProc = nil); overload;
    class procedure ShowInline(Owner: TCustomForm; Callback: TProc<TDialogResult>; Params: TDialogTextParams); overload;
    class procedure ShowInline(Owner: TCustomForm; Callback: TProc<TDialogInputResult>; Params: TDialogInputParams); overload;
    class procedure ShowInline(Owner: TCustomForm; Callback: TProc<TDialogColorResult>; Params: TDialogColorParams); overload;
  public //share
    class procedure ShowShare(Owner: TCustomForm; Params: TProc<TShareContract>);
  public //infobar
    class function ShowInfoBar(Owner: TFmxObject; OnClose: TProc<Boolean>; OnAction: TProc; Params: TInfoBarParams): TFrameInnerInfoBar;
  end;

procedure ShowUIMessage(Owner: TCustomForm; const Body: string); overload;

procedure ShowUIMessage(Owner: TCustomForm; const Title, Body: string); overload;

implementation

uses
  WinUI3.Form.Dialog, WinUI3.Frame.Inner.Dialog;

procedure ShowUIMessage(Owner: TCustomForm; const Body: string);
begin
  ShowUIMessage(Owner, '', Body);
end;

procedure ShowUIMessage(Owner: TCustomForm; const Title, Body: string);
begin
  var Data: TDialogTextParams;
  Data.Title := Title;
  Data.Body := Body;
  Data.Buttons := [Translate('OK')];
  Data.AccentId := -1;
  Data.DefaultId := 0;
  Data.CanClose := True;

  TFormDialogs.Execute(Owner, Data);
end;

{ TWinUIDialog }

class function TWinUIDialog.Show(Owner: TCustomForm; Params: TDialogTextParams): TDialogResult;
begin
  Result := TFormDialogs.Execute(Owner, Params);
end;

class function TWinUIDialog.Show(Owner: TCustomForm; Params: TDialogFramedParams; Ready: TProc): TDialogResult;
begin
  Result := TFormDialogs.Execute(Owner, Params, Ready);
end;

class function TWinUIDialog.Show(Owner: TCustomForm; const Title: string; Body: TFrame; Buttons: TArray<string>; AccentId, DefaultId: Integer; CanClose: Boolean; FrameColor: TColor): Integer;
begin
  Result := TFormDialogs.Execute(Owner, Title, Body, Buttons, AccentId, DefaultId, CanClose, FrameColor);
end;

class function TWinUIDialog.Show(Owner: TCustomForm; const Title, Body: string; Buttons: TArray<string>; AccentId, DefaultId: Integer; CanClose: Boolean; FrameColor: TColor): Integer;
begin
  Result := TFormDialogs.Execute(Owner, Title, Body, Buttons, AccentId, DefaultId, CanClose, FrameColor);
end;

class function TWinUIDialog.Show(Owner: TCustomForm; Params: TDialogColorParams): TDialogColorResult;
begin
  Result := TFormDialogs.Execute(Owner, Params);
end;

class function TWinUIDialog.Show(Owner: TCustomForm; Params: TDialogInputParams): TDialogInputResult;
begin
  Result := TFormDialogs.Execute(Owner, Params);
end;

class procedure TWinUIDialog.ShowInline(Owner: TCustomForm; Callback: TProc<TDialogResult>; Params: TDialogTextParams);
begin
  TFrameInnerDialog.Execute(Owner, Callback, Params);
end;

class procedure TWinUIDialog.ShowInline(Owner: TCustomForm; Callback: TProc<TDialogResult>; Params: TDialogFramedParams; Ready: TProc);
begin
  TFrameInnerDialog.Execute(Owner, Callback, Params, Ready);
end;

class procedure TWinUIDialog.ShowInline(Owner: TCustomForm; Callback: TProc<Integer>; const Title: string; Body: TFrame; Buttons: TArray<string>; AccentId, DefaultId: Integer; CanClose: Boolean; FrameColor: TColor);
begin
  TFrameInnerDialog.Execute(Owner, Callback, Title, Body, Buttons, AccentId, DefaultId, CanClose, FrameColor);
end;

class function TWinUIDialog.ShowInfoBar(Owner: TFmxObject; OnClose: TProc<Boolean>; OnAction: TProc; Params: TInfoBarParams): TFrameInnerInfoBar;
begin
  Result := TFrameInnerInfoBar.Execute(Owner, OnClose, OnAction, Params);
end;

class procedure TWinUIDialog.ShowInline(Owner: TCustomForm; Callback: TProc<Integer>; const Title, Body: string; Buttons: TArray<string>; AccentId, DefaultId: Integer; CanClose: Boolean; FrameColor: TColor);
begin
  TFrameInnerDialog.Execute(Owner, Callback, Title, Body, Buttons, AccentId, DefaultId, CanClose, FrameColor);
end;

class procedure TWinUIDialog.ShowInline(Owner: TCustomForm; Callback: TProc<TDialogColorResult>; Params: TDialogColorParams);
begin
  TFrameInnerDialog.Execute(Owner, Callback, Params);
end;

class procedure TWinUIDialog.ShowInline(Owner: TCustomForm; Callback: TProc<TDialogInputResult>; Params: TDialogInputParams);
begin
  TFrameInnerDialog.Execute(Owner, Callback, Params);
end;

class procedure TWinUIDialog.ShowShare(Owner: TCustomForm; Params: TProc<TShareContract>);
begin
  ShowShareUI(Owner, Params);
end;

end.

