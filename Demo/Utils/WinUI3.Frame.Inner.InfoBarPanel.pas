﻿unit WinUI3.Frame.Inner.InfoBarPanel;

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
  end;

  TFrameInnerInfoBarPanel = class(TFrame, ITabStopController)
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
    property BarPosition: TInfoBarPosition read FBarPosition write SetBarPosition;
    /// <summary>
    /// In milliseconds
    /// </summary>
    property AutoCloseDelay: Int64 read FAutoCloseDelay write SetAutoCloseDelay;
  public
    class function Execute(Owner: TFmxObject; OnClose: TProc<Boolean>; Params: TInfoBarParams): TFrameInnerInfoBarPanel;
  end;

implementation

uses
  System.Math;

{$R *.fmx}

procedure TFrameInnerInfoBarPanel.ButtonCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFrameInnerInfoBarPanel.Animate;
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

procedure TFrameInnerInfoBarPanel.ButtonActionClick(Sender: TObject);
begin
  FWasActionPressed := True;
  if FActionIsClose then
    Close;
end;

procedure TFrameInnerInfoBarPanel.FloatAnimationCloseFinish(Sender: TObject);
begin
  InternalClose;
end;

procedure TFrameInnerInfoBarPanel.FloatAnimationOpenProcess(Sender: TObject);
begin
  ShadowEffect1.UpdateParentEffects;
end;

procedure TFrameInnerInfoBarPanel.FrameResize(Sender: TObject);
begin
  UpdateSize;
end;

function TFrameInnerInfoBarPanel.GetMaxWidth: Single;
begin
  Result := Width - (PanelInfoBar.Padding.Left + PanelInfoBar.Padding.Right) - 100;
  if LayoutLeft.Visible then
    Result := Result - (LayoutLeft.Width + LayoutLeft.Margins.Left + LayoutLeft.Margins.Right);
  if LayoutRight.Visible then
    Result := Result - (LayoutRight.Width + LayoutRight.Margins.Left + LayoutRight.Margins.Right);
end;

procedure TFrameInnerInfoBarPanel.SetActionAsHyperLink(const Value: Boolean);
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

procedure TFrameInnerInfoBarPanel.SetActionIsClose(const Value: Boolean);
begin
  FActionIsClose := Value;
end;

procedure TFrameInnerInfoBarPanel.SetActionText(const Value: string);
begin
  FActionText := Value;
  ButtonAction.Text := Value;
  ButtonAction.Visible := not Value.IsEmpty;
  UpdateSize;
end;

procedure TFrameInnerInfoBarPanel.SetAutoCloseDelay(const Value: Int64);
begin
  FAutoCloseDelay := Value;
end;

procedure TFrameInnerInfoBarPanel.SetBarPosition(const Value: TInfoBarPosition);
begin
  FBarPosition := Value;
  case Value of
    TInfoBarPosition.Top:
      LayoutContent.Align := TAlignLayout.Top;
    TInfoBarPosition.Bottom:
      LayoutContent.Align := TAlignLayout.Bottom;
  end;
end;

procedure TFrameInnerInfoBarPanel.SetBody(const Value: string);
begin
  FBody := Value;
  LabelBody.Text := Value;
  LayoutBody.Visible := not Value.IsEmpty;
  UpdateSize;
end;

procedure TFrameInnerInfoBarPanel.SetCanClose(const Value: Boolean);
begin
  FCanClose := Value;
  LayoutRight.Visible := Value;
  UpdateSize;
end;

procedure TFrameInnerInfoBarPanel.UpdateSize;
begin
  if not Assigned(Canvas) then
    Exit;
  if IsUpdating then
    Exit;
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
  PanelInfoBar.Width := ContentWidth + PanelInfoBar.Padding.Left + PanelInfoBar.Padding.Right;
  LayoutContent.Height := PanelInfoBar.Height + 100;
  if FActionAsHyperLink and (ButtonAction.Position.X <= 0) then
    ButtonAction.Margins.Left := -8
  else
    ButtonAction.Margins.Left := 0;
end;

procedure TFrameInnerInfoBarPanel.SetInfoType(const Value: TInfoBarType);
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

procedure TFrameInnerInfoBarPanel.SetOnClose(const Value: TProc<Boolean>);
begin
  FOnClose := Value;
end;

procedure TFrameInnerInfoBarPanel.SetTitle(const Value: string);
begin
  FTitle := Value;
  LabelTitle.Text := Value;
  LayoutTitle.Visible := not Value.IsEmpty;
  UpdateSize;
end;

procedure TFrameInnerInfoBarPanel.TimerAutoCloseTimer(Sender: TObject);
begin
  if (PanelInfoBar.AbsoluteRect.Contains(ScreenToLocal(Screen.MousePos))) then
    Exit;
  TimerAutoClose.Enabled := False;
  Close;
end;

procedure TFrameInnerInfoBarPanel.Close;
begin
  TimerAutoClose.Enabled := False;
  if Assigned(FOnClose) then
    FOnClose(WasActionPressed);
  CloseAni;
end;

procedure TFrameInnerInfoBarPanel.CloseAni;
begin
  if FloatAnimationClose.Enabled then
    Exit;
  PanelInfoBar.Opacity := 1;
  FloatAnimationClose.Enabled := True;
end;

procedure TFrameInnerInfoBarPanel.InternalClose;
begin
  TimerAutoClose.Enabled := False;
  Release;
end;

constructor TFrameInnerInfoBarPanel.Create(AOwner: TFmxObject);
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

procedure TFrameInnerInfoBarPanel.EndUpdate;
begin
  inherited;
  if not IsUpdating then
    UpdateSize;
end;

procedure TFrameInnerInfoBarPanel.Open;
begin
  Animate;
  if FAutoCloseDelay > 0 then
  begin
    TimerAutoClose.Interval := FAutoCloseDelay;
    TimerAutoClose.Enabled := True;
  end;
end;

class function TFrameInnerInfoBarPanel.Execute(Owner: TFmxObject; OnClose: TProc<Boolean>; Params: TInfoBarParams): TFrameInnerInfoBarPanel;
begin
  Result := TFrameInnerInfoBarPanel.Create(Owner);
  Result.Parent := Owner;
  Result.BeginUpdate;
  Result.OnClose := OnClose;
  try
    Result.Align := TAlignLayout.Contents;
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

