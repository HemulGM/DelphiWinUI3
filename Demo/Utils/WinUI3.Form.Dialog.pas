unit WinUI3.Form.Dialog;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Controls.Presentation, System.Actions, FMX.ActnList,
  System.Generics.Collections, FMX.Edit, FMX.Memo, WinUI3.Form,
  WinUI3.Frame.Dialog.Text, WinUI3.Frame.Dialog, WinUI3.Frame.Dialog.Input,
  WinUI3.Frame.Dialog.ColorPicker, WinUI3.Dialogs;

type
  TFormDialogs = class(TWinUIForm)
    ActionList: TActionList;
    ActionClose: TAction;
    TimerBF: TTimer;
    FrameDialog: TFrameDialog;
    ActionCopy: TAction;
    procedure FormCreate(Sender: TObject);
    procedure LayoutContentMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ActionCloseExecute(Sender: TObject);
    procedure TimerBFTimer(Sender: TObject);
    procedure FrameDialogResize(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ActionCopyExecute(Sender: TObject);
  protected
    function NotInitStyle: Boolean; override;
    procedure Clear;
    procedure CreateHandle; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure BeforeShow; //override;
  private
    FBeforeShowMessageId: Integer;
    FCanClose: Boolean;
    FFrameColor: TColor;
    FResult: Integer;
    FCheck: Boolean;
    FIsClosing: Boolean;
    FParams: TDialogFramedParams;
    procedure FOnFrameClose(Sender: TObject);
    procedure FOnStartDrag(Sender: TObject);
    procedure DoCopy;
  public
    class function Execute(Owner: TCustomForm; const Title: string; Body: TFrame; Buttons: TArray<string>; AccentId, DefaultId: Integer; CanClose: Boolean; FrameColor: TColor = TColors.Null): Integer; overload;
    class function Execute(Owner: TCustomForm; Params: TDialogFramedParams; Ready: TProc = nil): TDialogResult; overload;
    class function Execute(Owner: TCustomForm; Params: TDialogTextParams): TDialogResult; overload;
    class function Execute(Owner: TCustomForm; Params: TDialogInputParams): TDialogInputResult; overload;
    class function Execute(Owner: TCustomForm; Params: TDialogColorParams): TDialogColorResult; overload;
    class function Execute(Owner: TCustomForm; const Title: string; const Body: string; Buttons: TArray<string>; AccentId, DefaultId: Integer; CanClose: Boolean; FrameColor: TColor = TColors.Null): Integer; overload;
    constructor Create(AOwner: TComponent; Proc: TProc<TFormDialogs>); reintroduce;
  end;

var
  FormDialogs: TFormDialogs;

implementation

uses
  System.Math, DelphiWindowStyle.FMX, System.Messaging, WinUI3.Utils;

{$R *.fmx}

procedure TFormDialogs.ActionCloseExecute(Sender: TObject);
begin
  Close;
end;

procedure TFormDialogs.ActionCopyExecute(Sender: TObject);
begin
  DoCopy;
end;

procedure TFormDialogs.BeforeShow;
begin
  FrameDialog.RecalcSize;
  PaintRects([Self.ClientRect]);
end;

procedure TFormDialogs.DoCopy;
begin
  FrameDialog.DoCopy;
end;

procedure TFormDialogs.Clear;
begin
  FrameDialog.Clear;
end;

constructor TFormDialogs.Create(AOwner: TComponent; Proc: TProc<TFormDialogs>);
begin
  inherited Create(AOwner);
  Proc(Self);
  HandleNeeded;
end;

procedure TFormDialogs.CreateHandle;
begin
  inherited;
  if not IsWin11OrNewest then
  begin
    BorderStyle := TFmxFormBorderStyle.Single;
  end;
  Self.SetWindowColorMode(True);
  Self.SetWindowCorner(TWindowCornerPreference.DWMWCP_ROUND);
  if FFrameColor <> TColors.Null then
    Self.SetWindowBorderColor(FFrameColor);
  if SetSystemBackdropType(TSystemBackdropType.DWMSBT_MAINWINDOW) then
  begin
    SetExtendFrameIntoClientArea(TRect.Create(-1, -1, -1, -1));
  end;
end;

class function TFormDialogs.Execute(Owner: TCustomForm; Params: TDialogColorParams): TDialogColorResult;
begin
  var BodyFrame := TFrameDialogColorPicker.Create(Owner);
  try
    BodyFrame.Fill(Params);
    var Data: TDialogFramedParams;
    Data.Title := Params.Title;
    Data.Body := BodyFrame;
    Data.Buttons := Params.Buttons;
    Data.AccentId := Params.AccentId;
    Data.DefaultId := Params.DefaultId;
    Data.CanClose := Params.CanClose;
    Data.FrameColor := Params.FrameColor;
    Data.CheckText := Params.CheckText;
    Data.CheckValue := Params.CheckValue;

    var FResult := TFormDialogs.Execute(Owner, Data);
    Result.Result := FResult.Result;
    Result.IsChecked := FResult.IsChecked;
    Result.Color := BodyFrame.Color;
  finally
    BodyFrame.Free;
  end;
end;

class function TFormDialogs.Execute(Owner: TCustomForm; const Title, Body: string; Buttons: TArray<string>; AccentId, DefaultId: Integer; CanClose: Boolean; FrameColor: TColor): Integer;
begin
  var Data: TDialogTextParams;
  Data.Title := Title;
  Data.Body := Body;
  Data.Buttons := Buttons;
  Data.AccentId := AccentId;
  Data.DefaultId := DefaultId;
  Data.CanClose := CanClose;
  Data.FrameColor := FrameColor;

  Result := TFormDialogs.Execute(Owner, Data).Result;
end;

class function TFormDialogs.Execute(Owner: TCustomForm; Params: TDialogInputParams): TDialogInputResult;
begin
  var BodyFrame := TFrameDialogInput.Create(Owner);
  try
    BodyFrame.Fill(Params);
    var Data: TDialogFramedParams;
    Data.Title := Params.Title;
    Data.Body := BodyFrame;
    Data.Buttons := Params.Buttons;
    Data.AccentId := Params.AccentId;
    Data.DefaultId := Params.DefaultId;
    Data.CanClose := Params.CanClose;
    Data.FrameColor := Params.FrameColor;
    Data.CheckText := Params.CheckText;
    Data.CheckValue := Params.CheckValue;
    var FResult := TFormDialogs.Execute(Owner, Data,
      procedure
      begin
        BodyFrame.EditInput.SetFocus;
      end);
    Result.Result := FResult.Result;
    Result.IsChecked := FResult.IsChecked;
    Result.Input := BodyFrame.EditInput.Text;
  finally
    BodyFrame.Free;
  end;
end;

class function TFormDialogs.Execute(Owner: TCustomForm; Params: TDialogTextParams): TDialogResult;
begin
  var BodyFrame := TFrameDialogText.Create(Owner);
  try
    BodyFrame.Fill(Params);
    var Data: TDialogFramedParams;
    Data.Title := Params.Title;
    Data.Body := BodyFrame;
    Data.Buttons := Params.Buttons;
    Data.AccentId := Params.AccentId;
    Data.DefaultId := Params.DefaultId;
    Data.CanClose := Params.CanClose;
    Data.FrameColor := Params.FrameColor;
    Data.CheckText := Params.CheckText;
    Data.CheckValue := Params.CheckValue;
    Result := TFormDialogs.Execute(Owner, Data,
      procedure
      begin
        BodyFrame.LabelBody.RecalcSize;
      end);
  finally
    BodyFrame.Free;
  end;
end;

class function TFormDialogs.Execute(Owner: TCustomForm; Params: TDialogFramedParams; Ready: TProc): TDialogResult;
begin
  var Form := TFormDialogs.Create(Owner,
    procedure(Form: TFormDialogs)
    begin
      Form.Name := '';
      Form.Caption := Params.Title;
      Form.StyleBook := Owner.StyleBook;
      Form.FCanClose := Params.CanClose;
      Form.FFrameColor := Params.FrameColor;
      Form.FParams := Params;
      Form.RecreateCanvas;
      Form.Visible := False;

      if not IsWin11OrNewest then
      begin
        if Params.CanClose then
          Form.BorderIcons := [TBorderIcon.biSystemMenu];
      end;
    end);
  if Assigned(Ready) then
    Ready;
  {$IF DEFINED(ANDROID) or DEFINED(IOS)}
  Form.Show;
  {$ELSE}
  Form.ShowModal;
  {$ENDIF}
  Result.Result := Form.FResult;
  Result.IsChecked := Form.FCheck;
end;

class function TFormDialogs.Execute(Owner: TCustomForm; const Title: string; Body: TFrame; Buttons: TArray<string>; AccentId, DefaultId: Integer; CanClose: Boolean; FrameColor: TColor): Integer;
begin
  var Data: TDialogFramedParams;
  Data.Title := Title;
  Data.Body := Body;
  Data.Buttons := Buttons;
  Data.AccentId := AccentId;
  Data.DefaultId := DefaultId;
  Data.CanClose := CanClose;
  Data.FrameColor := FrameColor;
  Data.CheckText := '';
  Data.CheckValue := False;

  Result := TFormDialogs.Execute(Owner, Data).Result;
end;

procedure TFormDialogs.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if FIsClosing then
    Exit;
  FIsClosing := True;
  Action := TCloseAction.caFree;
  FResult := FrameDialog.Result;
  FCheck := FrameDialog.CheckBoxCheck.IsChecked;
end;

procedure TFormDialogs.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := FCanClose or (FResult <> -1);
end;

procedure TFormDialogs.FormCreate(Sender: TObject);
begin
  FResult := -1;
  FIsClosing := False;
  FrameDialog.FillData(FParams);
  FrameDialog.OnStartDrag := FOnStartDrag;
  FrameDialog.OnClose := FOnFrameClose;

  FBeforeShowMessageId := TMessageManager.DefaultManager.SubscribeToMessage(TFormBeforeShownMessage,
    procedure(const Sender: TObject; const M: TMessage)
    begin
      BeforeShow;
    end);
  //
end;

procedure TFormDialogs.FormDestroy(Sender: TObject);
begin
  TMessageManager.DefaultManager.Unsubscribe(TFormBeforeShownMessage, FBeforeShowMessageId);
end;

procedure TFormDialogs.FormShow(Sender: TObject);
begin
  Self.AnimateWindow(200, AW_BLEND or AW_ACTIVATE);
end;

procedure TFormDialogs.FOnStartDrag(Sender: TObject);
begin
  StartWindowDrag;
end;

procedure TFormDialogs.FOnFrameClose(Sender: TObject);
begin
  if FIsClosing then
    Exit;
  FCanClose := True;
  Close;
end;

procedure TFormDialogs.FrameDialogResize(Sender: TObject);
begin
  var OldWidth := ClientWidth;
  ClientWidth := Round(FrameDialog.Width);
  Left := Round(Left + (OldWidth - ClientWidth) / 2);

  var OldHeight := ClientHeight;
  ClientHeight := Round(FrameDialog.Height);
  Top := Round(Top + (OldHeight - ClientHeight) / 2);
end;

procedure TFormDialogs.LayoutContentMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  StartWindowDrag;
end;

procedure TFormDialogs.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
end;

function TFormDialogs.NotInitStyle: Boolean;
begin
  Result := True;
end;

procedure TFormDialogs.TimerBFTimer(Sender: TObject);
begin
  BringToFront;
end;

end.

