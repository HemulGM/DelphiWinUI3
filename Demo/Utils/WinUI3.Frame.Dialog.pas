unit WinUI3.Frame.Dialog;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Controls.Presentation, FMX.Objects;

const
  DefaultMaxHeight = 700;
  MR_AUTOCLOSE = MaxInt;

type
  TDialogFramedParams = record
  private
    FTitle: string;
    FBody: TFrame;
    FButtons: TArray<string>;
    FFrameColor: TColor;
    FCanClose: Boolean;
    FAccentId: Integer;
    FDefaultId: Integer;
    FCheckValue: Boolean;
    FCheckText: string;
    procedure SetTitle(const Value: string);
    procedure SetBody(const Value: TFrame);
    procedure SetButtons(const Value: TArray<string>);
    procedure SetAccentId(const Value: Integer);
    procedure SetCanClose(const Value: Boolean);
    procedure SetDefaultId(const Value: Integer);
    procedure SetFrameColor(const Value: TColor);
    procedure SetCheckText(const Value: string);
    procedure SetCheckValue(const Value: Boolean);
  public
    property Title: string read FTitle write SetTitle;
    property Body: TFrame read FBody write SetBody;
    property Buttons: TArray<string> read FButtons write SetButtons;
    property AccentId: Integer read FAccentId write SetAccentId;
    property DefaultId: Integer read FDefaultId write SetDefaultId;
    property CanClose: Boolean read FCanClose write SetCanClose;
    property FrameColor: TColor read FFrameColor write SetFrameColor;
    property CheckText: string read FCheckText write SetCheckText;
    property CheckValue: Boolean read FCheckValue write SetCheckValue;
  end;

  TDialogParamsProc = reference to procedure(var Params: TDialogFramedParams);

  ICanCopy = interface
    ['{8BE82487-40DC-437A-B417-418DE7878FD1}']
    procedure Copy;
  end;

  TFrameDialog = class(TFrame)
    LayoutClient: TLayout;
    LayoutContent: TLayout;
    LayoutOver: TLayout;
    LayoutTitle: TLayout;
    ButtonClose: TButton;
    LabelTitle: TLabel;
    VertScrollBoxBody: TVertScrollBox;
    PanelGrid: TPanel;
    FlowLayoutButtons: TFlowLayout;
    ButtonCancel: TButton;
    ButtonDontSave: TButton;
    ButtonSave: TButton;
    Panel1: TPanel;
    CheckBoxCheck: TCheckBox;
    PanelInnerBG: TPanel;
    procedure LayoutContentMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure ButtonCloseClick(Sender: TObject);
    procedure LayoutTitleMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
  public
    class var
      MaxHeight: Integer;
  private
    FModalResult: TModalResult;
    FCanClose: Boolean;
    FResult: Integer;
    FBody: TFrame;
    FOnStartDrag: TNotifyEvent;
    FOnClose: TNotifyEvent;
    FFilling: Boolean;
    procedure ButtonClick(Sender: TObject);
    procedure SetModalResult(const Value: TModalResult);
    procedure SetOnStartDrag(const Value: TNotifyEvent);
    procedure FillButtons(Buttons: TArray<string>; AccentId, DefaultId: Integer);
    procedure FillContent(const Title: string; Body: TFrame; const CheckText: string; CheckValue: Boolean);
    procedure FOnBodyResized(Sender: TObject);
    procedure SetOnClose(const Value: TNotifyEvent);
    procedure UpdateSize;
    class procedure StopPropertyAnimation(const Target: TFmxObject; const APropertyName: string); static;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    procedure Clear;
    procedure DoCopy;
    procedure SetForInner;
    procedure FillData(Data: TDialogFramedParams);
    property ModalResult: TModalResult read FModalResult write SetModalResult;
    property OnStartDrag: TNotifyEvent read FOnStartDrag write SetOnStartDrag;
    property OnClose: TNotifyEvent read FOnClose write SetOnClose;
    property Result: Integer read FResult;
    procedure Close;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

uses
  System.Math, WinUI3.Utils, FMX.Ani;

{$R *.fmx}

procedure TFrameDialog.ButtonClick(Sender: TObject);
begin
  FResult := (Sender as TButton).Tag;
  ModalResult := mrOk;
end;

procedure TFrameDialog.ButtonCloseClick(Sender: TObject);
begin
  ModalResult := mrClose;
end;

procedure TFrameDialog.Clear;
begin
  while FlowLayoutButtons.ControlsCount > 0 do
    FlowLayoutButtons.Controls[0].Free;
end;

procedure TFrameDialog.Close;
begin
  if Assigned(FOnClose) then
    FOnClose(Self);
end;

constructor TFrameDialog.Create(AOwner: TComponent);
begin
  inherited;
  LayoutTitle.Visible := False;
  FResult := -1;
  VertScrollBoxBody.AniCalculations.Animation := True;
end;

destructor TFrameDialog.Destroy;
begin
  inherited;
end;

procedure TFrameDialog.DoCopy;
begin
  var CanCopy: ICanCopy;
  if Supports(FBody, ICanCopy, CanCopy) then
    CanCopy.Copy;
end;

procedure TFrameDialog.FillData(Data: TDialogFramedParams);
begin
  FCanClose := Data.CanClose;
  var ColorRec: TColorRec;
  ColorRec.Color := Data.FrameColor;
  var AlphaColor := TAlphaColorF.Create(ColorRec.R / 255, ColorRec.G / 255, ColorRec.B / 255, 1);
  PanelInnerBG.StylesData['bg.Stroke.Color'] := AlphaColor.ToAlphaColor;

  if IsWin11OrNewest then
    LayoutTitle.Visible := FCanClose;
  Clear;
  FillContent(Data.Title, Data.Body, Data.CheckText, Data.CheckValue);
  FillButtons(Data.Buttons, Data.AccentId, Data.DefaultId);
end;

procedure TFrameDialog.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if (AComponent = FBody) and (Operation = TOperation.opRemove) then
  begin
    FCanClose := True;
    FResult := MR_AUTOCLOSE;
    Close;
  end;
end;

procedure TFrameDialog.FillButtons(Buttons: TArray<string>; AccentId, DefaultId: Integer);
begin
  var BtnCnt := Length(Buttons);
  for var i := High(Buttons) downto Low(Buttons) do
  begin
    var Button := TButton.Create(FlowLayoutButtons);
    FlowLayoutButtons.AddObject(Button);
    if i = AccentId then
      Button.StyleLookup := 'buttonstyle_accent';
    Button.ApplyStyleLookup;
    Button.CanFocus := True;
    Button.Text := Buttons[i];
    Button.Tag := i;
    Button.OnClick := ButtonClick;
    Button.Height := 32;
    case BtnCnt of
      1, 2:
        Button.Width := 130;
    else
      Button.Width := ((FlowLayoutButtons.Width - FlowLayoutButtons.HorizontalGap * (BtnCnt - 1)) - FlowLayoutButtons.Padding.Left * 2) / Length(Buttons);
    end;
    if i = DefaultId then
    begin
      Button.Default := True;
      Button.SetFocus;
    end;
  end;
  FlowLayoutButtons.RecalcSize;
end;

procedure TFrameDialog.FOnBodyResized(Sender: TObject);
begin
  UpdateSize;
end;

procedure TFrameDialog.FillContent(const Title: string; Body: TFrame; const CheckText: string; CheckValue: Boolean);
begin
  if not Assigned(Body) then
    Exit;
  LabelTitle.Text := Title;
  if Title.IsEmpty then
    LabelTitle.Visible := False;

  CheckBoxCheck.Text := CheckText;
  if CheckText.IsEmpty then
    CheckBoxCheck.Visible := False;
  CheckBoxCheck.IsChecked := CheckValue;

  FBody := Body;
  VertScrollBoxBody.AddObject(Body);
  Body.RecalcSize;
  Body.OnResize := FOnBodyResized;
  Body.OnResized := FOnBodyResized;
  Body.AddFreeNotify(Self);
  FFilling := True;
  UpdateSize;
  FFilling := False;
end;

class procedure TFrameDialog.StopPropertyAnimation(const Target: TFmxObject; const APropertyName: string);
var
  I: Integer;
begin
  I := Target.ChildrenCount - 1;
  while I >= 0 do
  begin
    if (Target.Children[I] is TCustomPropertyAnimation) and
      (CompareText(TCustomPropertyAnimation(Target.Children[I]).PropertyName, APropertyName) = 0) then
      TFloatAnimation(Target.Children[I]).StopAtCurrent;
    if I > Target.ChildrenCount then
      I := Target.ChildrenCount;
    Dec(I);
  end;
end;

procedure TFrameDialog.UpdateSize;
begin
  Width := Round(FBody.Width + LayoutContent.Padding.Left + LayoutContent.Padding.Right);
  var FHeight := FBody.Height + LayoutContent.Padding.Top + LayoutContent.Padding.Bottom;
  if LabelTitle.IsVisible then
    FHeight := FHeight + LabelTitle.Height + LabelTitle.Margins.Top + LabelTitle.Margins.Bottom;
  if CheckBoxCheck.IsVisible then
    FHeight := FHeight + CheckBoxCheck.Height + CheckBoxCheck.Margins.Top + CheckBoxCheck.Margins.Bottom;
  FHeight := FHeight + PanelGrid.Height + PanelGrid.Margins.Top + PanelGrid.Margins.Bottom;
  if FFilling then
    Height := Min(Round(FHeight), MaxHeight)
  else
  begin
    if Round(FHeight) > MaxHeight then
      VertScrollBoxBody.ShowScrollBars := True
    else
      VertScrollBoxBody.ShowScrollBars := False;
    StopPropertyAnimation(Self, 'Height');
    TAnimator.AnimateFloat(Self, 'Height', Min(Round(FHeight), MaxHeight));
  end;
end;

procedure TFrameDialog.LayoutContentMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  if Assigned(FOnStartDrag) then
    FOnStartDrag(Self);
end;

procedure TFrameDialog.LayoutTitleMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  if Assigned(FOnStartDrag) then
    FOnStartDrag(Self);
end;

procedure TFrameDialog.SetForInner;
begin
  PanelInnerBG.Visible := True;
  PanelInnerBG.SendToBack;
  PanelGrid.StyleLookup := 'panelstyle_fill_strong_dialog';
  PanelGrid.Margins.Rect := TRectF.Create(1, 0, 1, 1);
end;

procedure TFrameDialog.SetModalResult(const Value: TModalResult);
begin
  FModalResult := Value;
  Close;
end;

procedure TFrameDialog.SetOnClose(const Value: TNotifyEvent);
begin
  FOnClose := Value;
end;

procedure TFrameDialog.SetOnStartDrag(const Value: TNotifyEvent);
begin
  FOnStartDrag := Value;
end;

{ TDialogFramedParams }

procedure TDialogFramedParams.SetAccentId(const Value: Integer);
begin
  FAccentId := Value;
end;

procedure TDialogFramedParams.SetBody(const Value: TFrame);
begin
  FBody := Value;
end;

procedure TDialogFramedParams.SetButtons(const Value: TArray<string>);
begin
  FButtons := Value;
end;

procedure TDialogFramedParams.SetCanClose(const Value: Boolean);
begin
  FCanClose := Value;
end;

procedure TDialogFramedParams.SetCheckText(const Value: string);
begin
  FCheckText := Value;
end;

procedure TDialogFramedParams.SetCheckValue(const Value: Boolean);
begin
  FCheckValue := Value;
end;

procedure TDialogFramedParams.SetDefaultId(const Value: Integer);
begin
  FDefaultId := Value;
end;

procedure TDialogFramedParams.SetFrameColor(const Value: TColor);
begin
  FFrameColor := Value;
end;

procedure TDialogFramedParams.SetTitle(const Value: string);
begin
  FTitle := Value;
end;

initialization
  TFrameDialog.MaxHeight := DefaultMaxHeight;

end.

