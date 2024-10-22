unit WinUI3.Frame.Inner.InfoBar;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  System.Generics.Collections, FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms,
  FMX.Dialogs, FMX.StdCtrls, FMX.Objects, System.Actions, FMX.ActnList,
  FMX.Effects, WinUI3.Utils, FMX.Layouts, FMX.Controls.Presentation,
  FMX.Memo.Types, FMX.ScrollBox, FMX.Memo, FMX.Edit, FMX.Ani;

{$SCOPEDENUMS ON}

type
  TInfoBarType = (None, Info, Success, Warning, Critical);

  TInfoBarPosition = (Top, Bottom);

  TInfoBarParams = record
    Title: string;
    Body: string;
    InfoType: TInfoBarType;
    ActionText: string;
    CanClose: Boolean;
    BarPosition: TInfoBarPosition;
    ActionAsHyperLink: Boolean;
    ActionIsClose: Boolean;
    AutoCloseDelay: Int64;
    AsPanel: Boolean;
  end;

  TFrameInnerInfoBar = class(TFrame, ITabStopController)
    LayoutContent: TLayout;
    PanelInfoBar: TPanel;
    ShadowEffect1: TShadowEffect;
    LabelTitle: TLabel;
    LabelBody: TLabel;
    FlowLayoutContent: TFlowLayout;
    LayoutTitle: TLayout;
    LayoutBody: TLayout;
    ButtonAction: TButton;
    LayoutLeft: TLayout;
    LayoutRight: TLayout;
    PathLabelIcon: TPathLabel;
    ButtonClose: TButton;
    TimerAutoClose: TTimer;
    FloatAnimationOpen: TFloatAnimation;
    FloatAnimationClose: TFloatAnimation;
    procedure ButtonActionClick(Sender: TObject);
    procedure FrameResize(Sender: TObject);
    procedure ButtonCloseClick(Sender: TObject);
    procedure TimerAutoCloseTimer(Sender: TObject);
    procedure FloatAnimationOpenProcess(Sender: TObject);
    procedure FloatAnimationCloseFinish(Sender: TObject);
  private
    FOwner: TFmxObject;
    FTitle: string;
    FBody: string;
    FInfoType: TInfoBarType;
    FOnClose: TProc<Boolean>;
    FWasActionPressed: Boolean;
    FCanClose: Boolean;
    FBarPosition: TInfoBarPosition;
    FActionText: string;
    FActionAsHyperLink: Boolean;
    FActionIsClose: Boolean;
    FAutoCloseDelay: Int64;
    FAsPanel: Boolean;
    FOnAction: TProc;
    procedure SetTitle(const Value: string);
    procedure SetBody(const Value: string);
    procedure SetInfoType(const Value: TInfoBarType);
    procedure SetOnClose(const Value: TProc<Boolean>);
    function GetMaxWidth: Single;
    procedure SetCanClose(const Value: Boolean);
    procedure SetBarPosition(const Value: TInfoBarPosition);
    procedure SetActionText(const Value: string);
    procedure SetActionAsHyperLink(const Value: Boolean);
    procedure SetActionIsClose(const Value: Boolean);
    procedure SetAutoCloseDelay(const Value: Int64);
    procedure Animate;
    procedure Open;
    procedure UpdateSize;
    procedure InternalClose;
    procedure CloseAni;
    procedure SetAsPanel(const Value: Boolean);
    procedure SetOnAction(const Value: TProc);
  public
    constructor Create(AOwner: TFmxObject); reintroduce;
    procedure EndUpdate; override;
  public
    procedure Close;
    property Title: string read FTitle write SetTitle;
    property Body: string read FBody write SetBody;
    property InfoType: TInfoBarType read FInfoType write SetInfoType;
    property ActionText: string read FActionText write SetActionText;
    property ActionAsHyperLink: Boolean read FActionAsHyperLink write SetActionAsHyperLink;
    property ActionIsClose: Boolean read FActionIsClose write SetActionIsClose;
    property WasActionPressed: Boolean read FWasActionPressed;
    property CanClose: Boolean read FCanClose write SetCanClose;
    property OnClose: TProc<Boolean> read FOnClose write SetOnClose;
    property OnAction: TProc read FOnAction write SetOnAction;
    property BarPosition: TInfoBarPosition read FBarPosition write SetBarPosition;
    property AsPanel: Boolean read FAsPanel write SetAsPanel;
    /// <summary>
    /// In milliseconds
    /// </summary>
    property AutoCloseDelay: Int64 read FAutoCloseDelay write SetAutoCloseDelay;
  public
    class function Execute(Owner: TFmxObject; OnClose: TProc<Boolean>; OnAction: TProc; Params: TInfoBarParams): TFrameInnerInfoBar;
  end;

implementation

uses
  System.Math;

{$R *.fmx}

procedure TFrameInnerInfoBar.ButtonCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFrameInnerInfoBar.Animate;
begin
  case FBarPosition of
    TInfoBarPosition.Top:
      begin
        PanelInfoBar.Margins.Top := -PanelInfoBar.Height;
        TAnimator.AnimateFloat(PanelInfoBar, 'Margins.Top', 0);
      end;
    TInfoBarPosition.Bottom:
      begin
        PanelInfoBar.Margins.Bottom := -PanelInfoBar.Height;
        TAnimator.AnimateFloat(PanelInfoBar, 'Margins.Bottom', 0);
      end;
  end;
  FloatAnimationOpen.Enabled := False;
  PanelInfoBar.Opacity := 0;
  FloatAnimationOpen.Enabled := True;
end;

procedure TFrameInnerInfoBar.ButtonActionClick(Sender: TObject);
begin
  FWasActionPressed := True;
  try
    if Assigned(FOnAction) then
      FOnAction();
  finally
    if FActionIsClose then
      Close;
  end;
end;

procedure TFrameInnerInfoBar.FloatAnimationCloseFinish(Sender: TObject);
begin
  InternalClose;
end;

procedure TFrameInnerInfoBar.FloatAnimationOpenProcess(Sender: TObject);
begin
  ShadowEffect1.UpdateParentEffects;
end;

procedure TFrameInnerInfoBar.FrameResize(Sender: TObject);
begin
  UpdateSize;
end;

function TFrameInnerInfoBar.GetMaxWidth: Single;
begin
  Result := Width - (PanelInfoBar.Padding.Left + PanelInfoBar.Padding.Right) - 100;
  if LayoutLeft.Visible then
    Result := Result - (LayoutLeft.Width + LayoutLeft.Margins.Left + LayoutLeft.Margins.Right);
  if LayoutRight.Visible then
    Result := Result - (LayoutRight.Width + LayoutRight.Margins.Left + LayoutRight.Margins.Right);
end;

procedure TFrameInnerInfoBar.SetActionAsHyperLink(const Value: Boolean);
begin
  FActionAsHyperLink := Value;
  if FActionAsHyperLink then
  begin
    ButtonAction.StyleLookup := 'buttonstyle_hyperlink';
    ButtonAction.Margins.Left := 0;
    ButtonAction.TextSettings.HorzAlign := TTextAlign.Leading;
  end
  else
  begin
    ButtonAction.StyleLookup := 'buttonstyle_borderless';
    ButtonAction.Margins.Left := 0;
    ButtonAction.TextSettings.HorzAlign := TTextAlign.Center;
  end;
end;

procedure TFrameInnerInfoBar.SetActionIsClose(const Value: Boolean);
begin
  FActionIsClose := Value;
end;

procedure TFrameInnerInfoBar.SetActionText(const Value: string);
begin
  FActionText := Value;
  ButtonAction.Text := Value;
  ButtonAction.Visible := not Value.IsEmpty;
  UpdateSize;
end;

procedure TFrameInnerInfoBar.SetAsPanel(const Value: Boolean);
begin
  FAsPanel := Value;
  UpdateSize;
end;

procedure TFrameInnerInfoBar.SetAutoCloseDelay(const Value: Int64);
begin
  FAutoCloseDelay := Value;
end;

procedure TFrameInnerInfoBar.SetBarPosition(const Value: TInfoBarPosition);
begin
  FBarPosition := Value;
  case Value of
    TInfoBarPosition.Top:
      LayoutContent.Align := TAlignLayout.Top;
    TInfoBarPosition.Bottom:
      LayoutContent.Align := TAlignLayout.Bottom;
  end;
end;

procedure TFrameInnerInfoBar.SetBody(const Value: string);
begin
  FBody := Value;
  LabelBody.Text := Value;
  LayoutBody.Visible := not Value.IsEmpty;
  UpdateSize;
end;

procedure TFrameInnerInfoBar.SetCanClose(const Value: Boolean);
begin
  FCanClose := Value;
  LayoutRight.Visible := Value;
  UpdateSize;
end;

procedure TFrameInnerInfoBar.UpdateSize;
begin
  if not Assigned(Canvas) then
    Exit;
  if IsUpdating then
    Exit;
  if FAsPanel then
  begin
    PanelInfoBar.StylesData['bg.XRadius'] := 0;
    PanelInfoBar.StylesData['bg.YRadius'] := 0;
    case FBarPosition of
      TInfoBarPosition.Top:
        Align := TAlignLayout.Top;
      TInfoBarPosition.Bottom:
        Align := TAlignLayout.Bottom;
    end;
  end
  else
  begin
    PanelInfoBar.StylesData['bg.XRadius'] := 7;
    PanelInfoBar.StylesData['bg.YRadius'] := 7;
    Align := TAlignLayout.Contents;
  end;
  var MaxWidth := GetMaxWidth;
  var MaxWidthLeft := MaxWidth;
  var ContentWidth: Single := 0;
  if ButtonAction.Visible then
  begin
    ButtonAction.ApplyStyleLookup;
    Canvas.Font.Assign(ButtonAction.StylesData['text.Font'].AsType<TFont>);
    var W := Canvas.TextWidth(ButtonAction.Text) + 8 * 2;
    if W > MaxWidthLeft then
      ButtonAction.Width := MaxWidth
    else
      ButtonAction.Width := W;
    ContentWidth := ContentWidth + ButtonAction.Width + FlowLayoutContent.VerticalGap;
    MaxWidthLeft := MaxWidthLeft - (ButtonAction.Width + FlowLayoutContent.VerticalGap);
  end;
  if LayoutTitle.Visible then
  begin
    LabelTitle.ApplyStyleLookup;
    Canvas.Font.Assign(LabelTitle.StylesData['text.Font'].AsType<TFont>);
    var W := Canvas.TextWidth(LabelTitle.Text);
    if W > MaxWidthLeft then
      LayoutTitle.Width := MaxWidth
    else
      LayoutTitle.Width := W;
    LayoutTitle.Margins.Bottom := -10;
    ContentWidth := ContentWidth + LayoutTitle.Width + FlowLayoutContent.VerticalGap;
    MaxWidthLeft := MaxWidthLeft - (LayoutTitle.Width + FlowLayoutContent.VerticalGap);
  end;
  if LayoutBody.Visible then
  begin
    LayoutBody.Margins.Bottom := 5;
    LabelBody.ApplyStyleLookup;
    Canvas.Font.Assign(LabelBody.StylesData['text.Font'].AsType<TFont>);
    var W := Canvas.TextWidth(LabelBody.Text);
    if W > MaxWidthLeft then
      LayoutBody.Width := MaxWidth
    else
      LayoutBody.Width := W;
    ContentWidth := ContentWidth + LayoutBody.Width + FlowLayoutContent.VerticalGap;
  end
  else
    LayoutTitle.Margins.Bottom := 0;

  if ContentWidth > MaxWidth then
  begin
    LayoutTitle.Width := MaxWidth;
    LayoutBody.Width := MaxWidth;
    ContentWidth := MaxWidth;
  end;

  LayoutTitle.Height := Min(LabelTitle.Height, 150);
  LayoutBody.Height := Min(LabelBody.Height, 150);

  var H: Single := 0;
  for var Control in FlowLayoutContent.Controls do
    if Control.Visible then
      H := Max(H, Control.Position.Y + Control.Height + Control.Margins.Bottom + FlowLayoutContent.HorizontalGap);
  H := H - FlowLayoutContent.HorizontalGap;
  PanelInfoBar.Height := Max(48, H + PanelInfoBar.Padding.Top + PanelInfoBar.Padding.Bottom);
  if LayoutLeft.Visible then
    ContentWidth := ContentWidth + (LayoutLeft.Width + LayoutLeft.Margins.Left + LayoutLeft.Margins.Right);
  if LayoutRight.Visible then
    ContentWidth := ContentWidth + (LayoutRight.Width + LayoutRight.Margins.Left + LayoutRight.Margins.Right)
  else
    ContentWidth := ContentWidth - FlowLayoutContent.HorizontalGap;
  FlowLayoutContent.RecalcSize;
  if FAsPanel then
  begin
    PanelInfoBar.Width := LayoutContent.Width;
    LayoutContent.Height := PanelInfoBar.Height;
    Height := LayoutContent.Height;
    ShadowEffect1.Enabled := False;
  end
  else
  begin
    PanelInfoBar.Width := ContentWidth + PanelInfoBar.Padding.Left + PanelInfoBar.Padding.Right;
    LayoutContent.Height := PanelInfoBar.Height + 100;
    ShadowEffect1.Enabled := True;
  end;
  if FActionAsHyperLink and (ButtonAction.Position.X <= 0) then
    ButtonAction.Margins.Left := -8
  else
    ButtonAction.Margins.Left := 0;
end;

procedure TFrameInnerInfoBar.SetInfoType(const Value: TInfoBarType);
begin
  FInfoType := Value;
  case Value of
    TInfoBarType.None:
      begin
        PanelInfoBar.StyleLookup := 'panelstyle_infobar_info';
        PathLabelIcon.StyleLookup := '';
      end;
    TInfoBarType.Info:
      begin
        PanelInfoBar.StyleLookup := 'panelstyle_infobar_info';
        PathLabelIcon.StyleLookup := 'pathlabel_info';
      end;
    TInfoBarType.Success:
      begin
        PanelInfoBar.StyleLookup := 'panelstyle_infobar_success';
        PathLabelIcon.StyleLookup := 'pathlabel_success';
      end;
    TInfoBarType.Warning:
      begin
        PanelInfoBar.StyleLookup := 'panelstyle_infobar_warning';
        PathLabelIcon.StyleLookup := 'pathlabel_warning';
      end;
    TInfoBarType.Critical:
      begin
        PanelInfoBar.StyleLookup := 'panelstyle_infobar_critical';
        PathLabelIcon.StyleLookup := 'pathlabel_critical';
      end;
  end;
  LayoutLeft.Visible := Value <> TInfoBarType.None;
  UpdateSize;
end;

procedure TFrameInnerInfoBar.SetOnAction(const Value: TProc);
begin
  FOnAction := Value;
end;

procedure TFrameInnerInfoBar.SetOnClose(const Value: TProc<Boolean>);
begin
  FOnClose := Value;
end;

procedure TFrameInnerInfoBar.SetTitle(const Value: string);
begin
  FTitle := Value;
  LabelTitle.Text := Value;
  LayoutTitle.Visible := not Value.IsEmpty;
  UpdateSize;
end;

procedure TFrameInnerInfoBar.TimerAutoCloseTimer(Sender: TObject);
begin
  if (PanelInfoBar.AbsoluteRect.Contains(ScreenToLocal(Screen.MousePos))) then
    Exit;
  TimerAutoClose.Enabled := False;
  Close;
end;

procedure TFrameInnerInfoBar.Close;
begin
  TimerAutoClose.Enabled := False;
  if Assigned(FOnClose) then
    FOnClose(WasActionPressed);
  CloseAni;
end;

procedure TFrameInnerInfoBar.CloseAni;
begin
  if FloatAnimationClose.Enabled then
    Exit;
  PanelInfoBar.Opacity := 1;
  FloatAnimationClose.Enabled := True;
end;

procedure TFrameInnerInfoBar.InternalClose;
begin
  TimerAutoClose.Enabled := False;
  Release;
end;

constructor TFrameInnerInfoBar.Create(AOwner: TFmxObject);
begin
  inherited Create(AOwner);
  FOwner := AOwner;
  BeginUpdate;
  try
    SetActionText('');
    SetTitle('');
    SetBody('');
    SetInfoType(TInfoBarType.None);
    SetCanClose(True);
    SetBarPosition(TInfoBarPosition.Bottom);
    SetActionAsHyperLink(False);
    SetActionIsClose(True);
    SetOnClose(nil);
    SetAutoCloseDelay(0);
  finally
    EndUpdate;
  end;
  Name := '';
end;

procedure TFrameInnerInfoBar.EndUpdate;
begin
  inherited;
  if not IsUpdating then
    UpdateSize;
end;

procedure TFrameInnerInfoBar.Open;
begin
  Animate;
  if FAutoCloseDelay > 0 then
  begin
    TimerAutoClose.Interval := FAutoCloseDelay;
    TimerAutoClose.Enabled := True;
  end;
end;

class function TFrameInnerInfoBar.Execute(Owner: TFmxObject; OnClose: TProc<Boolean>; OnAction: TProc; Params: TInfoBarParams): TFrameInnerInfoBar;
begin
  Result := TFrameInnerInfoBar.Create(Owner);
  Result.Parent := Owner;
  Result.BeginUpdate;
  Result.OnClose := OnClose;
  Result.OnAction := OnAction;
  try
    Result.Align := TAlignLayout.Contents;
    Result.AsPanel := Params.AsPanel;
    Result.Title := Params.Title;
    Result.Body := Params.Body;
    Result.InfoType := Params.InfoType;
    Result.ActionText := Params.ActionText;
    Result.CanClose := Params.CanClose;
    Result.BarPosition := Params.BarPosition;
    Result.ActionAsHyperLink := Params.ActionAsHyperLink;
    Result.ActionIsClose := Params.ActionIsClose;
    Result.AutoCloseDelay := Params.AutoCloseDelay;
    Result.Visible := True;
  finally
    Result.EndUpdate;
  end;
  Result.PrepareForPaint;
  Result.Resize;
  Result.UpdateSize;
  Result.BringToFront;
  Result.Open;
end;

end.

