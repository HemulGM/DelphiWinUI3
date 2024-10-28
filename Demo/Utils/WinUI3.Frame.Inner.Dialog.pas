unit WinUI3.Frame.Inner.Dialog;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  System.Generics.Collections, FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms,
  FMX.Dialogs, FMX.StdCtrls, FMX.Objects, WinUI3.Frame.Dialog, System.Actions,
  FMX.ActnList, WinUI3.Frame.Dialog.Text, WinUI3.Frame.Dialog.Input,
  WinUI3.Frame.Dialog.ColorPicker, WinUI3.Dialogs, FMX.Effects, WinUI3.Utils;

type
  TFrameInnerDialog = class(TFrame, ITabStopController)
    RectangleShadow: TRectangle;
    ActionList: TActionList;
    ActionClose: TAction;
    ActionCopy: TAction;
    FrameDialog: TFrameDialog;
    ShadowEffect1: TShadowEffect;
    procedure ActionCloseExecute(Sender: TObject);
    procedure ActionCopyExecute(Sender: TObject);
  private
    FTabList: TRingTabList;
    FCanClose: Boolean;
    FFrameColor: TColor;
    FResult: Integer;
    FCheck: Boolean;
    FIsClosing: Boolean;
    FParams: TDialogFramedParams;
    FOwner: TCustomForm;
    FCallback: TProc<TDialogResult>;
    procedure DoCopy;
    procedure FOnFrameClose(Sender: TObject);
    procedure FOnStartDrag(Sender: TObject);
  protected
    procedure DoDeleteChildren; override;
    procedure DoAddObject(const AObject: TFmxObject); override;
    procedure DoRemoveObject(const AObject: TFmxObject); override;
  public
    function GetTabList: ITabList; override;
    constructor Create(AOwner: TCustomForm); reintroduce;
    destructor Destroy; override;
    procedure Close;
    class procedure Execute(Owner: TCustomForm; Callback: TProc<Integer>; const Title: string; Body: TFrame; Buttons: TArray<string>; AccentId, DefaultId: Integer; CanClose: Boolean; FrameColor: TColor = TColors.Null); overload;
    class procedure Execute(Owner: TCustomForm; Callback: TProc<TDialogResult>; Params: TDialogFramedParams; Ready: TProc = nil); overload;
    class procedure Execute(Owner: TCustomForm; Callback: TProc<TDialogResult>; Params: TDialogTextParams); overload;
    class procedure Execute(Owner: TCustomForm; Callback: TProc<TDialogInputResult>; Params: TDialogInputParams); overload;
    class procedure Execute(Owner: TCustomForm; Callback: TProc<TDialogColorResult>; Params: TDialogColorParams); overload;
    class procedure Execute(Owner: TCustomForm; Callback: TProc<Integer>; const Title: string; const Body: string; Buttons: TArray<string>; AccentId, DefaultId: Integer; CanClose: Boolean; FrameColor: TColor = TColors.Null); overload;
  end;

implementation

uses
  System.Math;

{$R *.fmx}

procedure TFrameInnerDialog.ActionCloseExecute(Sender: TObject);
begin
  Close;
end;

procedure TFrameInnerDialog.ActionCopyExecute(Sender: TObject);
begin
  DoCopy;
end;

destructor TFrameInnerDialog.Destroy;
begin
  FrameDialog.OnClose := nil;
  FrameDialog.OnStartDrag := nil;
  FreeAndNil(FTabList);
  inherited;
end;

procedure TFrameInnerDialog.DoAddObject(const AObject: TFmxObject);
var
  TabStop: IControl;
begin
  inherited;
  if Supports(AObject, IControl, TabStop) then
    GetTabList.Add(TabStop);
end;

procedure TFrameInnerDialog.DoCopy;
begin
  FrameDialog.DoCopy;
end;

procedure TFrameInnerDialog.DoDeleteChildren;
begin
  if FTabList <> nil then
    FTabList.Clear;
  inherited;
end;

procedure TFrameInnerDialog.DoRemoveObject(const AObject: TFmxObject);
var
  TabStop: IControl;
begin
  inherited;
  if (FTabList <> nil) and Supports(AObject, IControl, TabStop) then
    GetTabList.Remove(TabStop);
end;

class procedure TFrameInnerDialog.Execute(Owner: TCustomForm; Callback: TProc<TDialogResult>; Params: TDialogTextParams);
begin
  var BodyFrame := TFrameDialogText.Create(Owner);
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
  TFrameInnerDialog.Execute(Owner, Callback, Data,
    procedure
    begin
      BodyFrame.LabelBody.RecalcSize;
    end);
end;

class procedure TFrameInnerDialog.Execute(Owner: TCustomForm; Callback: TProc<TDialogResult>; Params: TDialogFramedParams; Ready: TProc);
begin
  var Form := TFrameInnerDialog.Create(Owner);

  Form.FrameDialog.SetForInner;
  Form.FrameDialog.FillData(Params);
  Form.FrameDialog.OnStartDrag := Form.FOnStartDrag;
  Form.FrameDialog.OnClose := Form.FOnFrameClose;
  Form.FCallback := Callback;
  Form.FCanClose := Params.CanClose;
  Form.FFrameColor := Params.FrameColor;
  Form.FParams := Params;
  Owner.AddObject(Form);
  Form.Align := TAlignLayout.Contents;
  Form.Visible := True;
  Form.SetFocus;
  Form.BringToFront;
  if Assigned(Ready) then
    Ready;
end;

class procedure TFrameInnerDialog.Execute(Owner: TCustomForm; Callback: TProc<Integer>; const Title: string; Body: TFrame; Buttons: TArray<string>; AccentId, DefaultId: Integer; CanClose: Boolean; FrameColor: TColor);
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

  var InnerCallback: TProc<TDialogResult> :=
    procedure(Result: TDialogResult)
    begin
      Callback(Result.Result);
    end;

  TFrameInnerDialog.Execute(Owner, InnerCallback, Data);
end;

class procedure TFrameInnerDialog.Execute(Owner: TCustomForm; Callback: TProc<Integer>; const Title, Body: string; Buttons: TArray<string>; AccentId, DefaultId: Integer; CanClose: Boolean; FrameColor: TColor);
begin
  var Data: TDialogTextParams;
  Data.Title := Title;
  Data.Body := Body;
  Data.Buttons := Buttons;
  Data.AccentId := AccentId;
  Data.DefaultId := DefaultId;
  Data.CanClose := CanClose;
  Data.FrameColor := FrameColor;

  var InnerCallback: TProc<TDialogResult> :=
    procedure(Result: TDialogResult)
    begin
      Callback(Result.Result);
    end;

  TFrameInnerDialog.Execute(Owner, InnerCallback, Data);
end;

class procedure TFrameInnerDialog.Execute(Owner: TCustomForm; Callback: TProc<TDialogColorResult>; Params: TDialogColorParams);
begin
  var BodyFrame := TFrameDialogColorPicker.Create(Owner);
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

  var InnerCallback: TProc<TDialogResult> :=
    procedure(Data: TDialogResult)
    begin
      var Res: TDialogColorResult;
      Res.Result := Data.Result;
      Res.IsChecked := Data.IsChecked;
      Res.Color := BodyFrame.Color;
      Callback(Res);
    end;

  TFrameInnerDialog.Execute(Owner, InnerCallback, Data);
end;

class procedure TFrameInnerDialog.Execute(Owner: TCustomForm; Callback: TProc<TDialogInputResult>; Params: TDialogInputParams);
begin
  var BodyFrame := TFrameDialogInput.Create(Owner);
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

  var InnerCallback: TProc<TDialogResult> :=
    procedure(Data: TDialogResult)
    begin
      var Res: TDialogInputResult;
      Res.Result := Data.Result;
      Res.IsChecked := Data.IsChecked;
      Res.Input := BodyFrame.EditInput.Text;
      Callback(Res);
    end;

  TFrameInnerDialog.Execute(Owner, InnerCallback, Data,
    procedure
    begin
      BodyFrame.EditInput.SetFocus;
    end);
end;

procedure TFrameInnerDialog.Close;
begin
  if not FCanClose then
    Exit;
  if FIsClosing then
    Exit;
  FIsClosing := True;
  Visible := False;
  FResult := FrameDialog.Result;
  FCheck := FrameDialog.CheckBoxCheck.IsChecked;
  var FDialogResult: TDialogResult;
  FDialogResult.Result := FResult;
  FDialogResult.IsChecked := FCheck;
  FCallback(FDialogResult);
  TThread.ForceQueue(nil, Free);
end;

procedure TFrameInnerDialog.FOnStartDrag(Sender: TObject);
begin
  if Owner is TForm then
    TForm(Owner).StartWindowDrag;
end;

function TFrameInnerDialog.GetTabList: ITabList;
begin
  if FTabList = nil then
    FTabList := TRingTabList.Create(Self);
  Result := FTabList;
end;

procedure TFrameInnerDialog.FOnFrameClose(Sender: TObject);
begin
  if FIsClosing then
    Exit;
  FCanClose := True;
  Close;
end;

constructor TFrameInnerDialog.Create(AOwner: TCustomForm);
begin
  inherited Create(AOwner);
  FOwner := AOwner;
  Name := '';
  FResult := -1;
  FIsClosing := False;
  CanFocus := True;
end;

end.

