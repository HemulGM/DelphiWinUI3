unit WinUI3.Form;

interface

uses
  System.SysUtils, System.Classes, System.Types, FMX.Edit, FMX.Controls,
  System.UITypes, FMX.Memo, FMX.StdCtrls, FMX.Graphics, FMX.Forms, FMX.Types,
  {$IFDEF MSWINDOWS}
  Winapi.Windows, Winapi.Messages, FMX.Windows.Dispatch, FMX.Platform.Win,
  {$ENDIF}
  FMX.Ani, FMX.Filter.Effects, FMX.ActnList, DelphiWindowStyle.FMX;

type
  TPopup = class(FMX.Controls.TPopup)
  end;

  TSystemBackdropType = DelphiWindowStyle.FMX.TSystemBackdropType;

  TWinUIForm = class(TForm)
  private
    FModeFocus: Boolean;
    FPopupHint: TPopup;
    FTimerHintClose: TTimer;
    FTimerHint: TTimer;
    FLabelHint: TLabel;
    FFloatAnimationHint: TFloatAnimation;
    FSystemBackdropType: TSystemBackdropType;
    FCaptionControls: TArray<TControl>;
    FHideTitleBar: Boolean;
    FFocusStyle: TStrokeBrush;
    FFocusXRadius: Single;
    FFocusYRadius: Single;
    FFocusOpacity: Single;
    FFocusCornerType: TCornerType;
    FFocusCorners: TCorners;
    FFocusInflate: Single;
    procedure SetFocusCorners(const Value: TCorners);
    procedure SetFocusCornerType(const Value: TCornerType);
    procedure SetFocusOpacity(const Value: Single);
    procedure SetFocusXRadius(const Value: Single);
    procedure SetFocusYRadius(const Value: Single);
    procedure SetFocusInflate(const Value: Single);
  protected
    procedure PaintRects(const UpdateRects: array of TRectF); override;
    procedure CreateHandle; override;
  protected
    function NotInitStyle: Boolean; virtual;
    procedure TimerHintCloseTimer(Sender: TObject); virtual;
    procedure TimerHintTimer(Sender: TObject); virtual;
    procedure FloatAnimationHintProcess(Sender: TObject); virtual;
    procedure FOnAppHint(Sender: TObject); virtual;
    procedure SetCaptionControls(const Value: TArray<TControl>); virtual;
    procedure SetHideTitleBar(const Value: Boolean); virtual;
    {$IFDEF MSWINDOWS}
    procedure InvalidateNonClient;
    procedure WMNCCalcSize(var Message: TWMNCCalcSize); message WM_NCCALCSIZE;
    procedure WMNCHitTest(var Message: TWMNCHitTest); message WM_NCHITTEST;
    {$ENDIF}
  public
    procedure AfterConstruction; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; AFormX, AFormY: Single); override;
    procedure KeyDown(var Key: Word; var KeyChar: System.WideChar; Shift: TShiftState); override;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  public
    procedure HookHints; virtual;
    procedure BeginLauncher(Proc: TProc = nil); virtual;
    procedure EndLauncher(Proc: TProc = nil); virtual;
    procedure SystemBackdropType(AType: TSystemBackdropType); virtual;
    //
    property CaptionControls: TArray<TControl> read FCaptionControls write SetCaptionControls;
    property HideTitleBar: Boolean read FHideTitleBar write SetHideTitleBar;
    property FocusStyle: TStrokeBrush read FFocusStyle;
    property FocusXRadius: Single read FFocusXRadius write SetFocusXRadius;
    property FocusYRadius: Single read FFocusYRadius write SetFocusYRadius;
    property FocusCorners: TCorners read FFocusCorners write SetFocusCorners;
    property FocusOpacity: Single read FFocusOpacity write SetFocusOpacity;
    property FocusCornerType: TCornerType read FFocusCornerType write SetFocusCornerType;
    property FocusInflate: Single read FFocusInflate write SetFocusInflate;
  end;

implementation

uses
  FMX.Menus, FMX.Platform;

{$REGION 'WinAPI for no TitleBar'}
{$IFDEF MSWINDOWS}
procedure TWinUIForm.InvalidateNonClient;
begin
  var Handle := FormToHWND(Self);
  LockWindowUpdate(Handle);
  SetWindowPos(Handle, 0, 0, 0, 0, 0, SWP_NOSIZE or SWP_NOMOVE or
    SWP_NOZORDER or SWP_NOACTIVATE or SWP_NOSENDCHANGING or SWP_FRAMECHANGED);
  LockWindowUpdate(0);
end;

procedure TWinUIForm.WMNCCalcSize(var Message: TWMNCCalcSize);
begin
  if (not FHideTitleBar) or (Length(FCaptionControls) <= 0) or (not Message.CalcValidRects) then
  begin
    inherited;
    Exit;
  end;
  if WindowState <> TWindowState.wsMinimized then
  begin
    var R := GetAdjustWindowRect;
    if IsZoomed(FormToHWND(Self)) then
      FCaptionControls[0].Margins.Top := R.Bottom
    else
      FCaptionControls[0].Margins.Top := 0;

    Inc(Message.CalcSize_Params.rgrc[0].Top, R.Top);
  end
  else
    inherited;
end;

procedure TWinUIForm.WMNCHitTest(var Message: TWMNCHitTest);
begin
  if (not FHideTitleBar) or (Length(FCaptionControls) <= 0) then
  begin
    inherited;
    Exit;
  end;
  case Message.Result of
    HTNOWHERE:
      begin
        var P := ScreenToClient(Point(Message.XPos, Message.YPos)).Round;
        if P.Y > FCaptionControls[0].Height then
          Exit;
        var R := TRect.Create(0, 0, 20, 20);
        if (P.X < R.Right) and ((WindowState = TWindowState.wsMaximized) or ((P.Y >= R.Top) and (P.Y < R.Bottom))) then
          Message.Result := HTSYSMENU
        else if (P.Y < 4) and (BorderStyle in [TFmxFormBorderStyle.Sizeable, TFmxFormBorderStyle.SizeToolWin]) then
          Message.Result := HTTOP
        else
        begin
          var Obj := ObjectAtPoint(Point(Message.XPos, Message.YPos));
          if Assigned(Obj) and
            (function: Boolean
            begin
              for var Item in FCaptionControls do
                if Item = Obj.GetObject then
                  Exit(True);
              Result := False;
            end)()
           then
            Message.Result := HTCAPTION;
        end;
      end;
    HTMINBUTTON, HTMAXBUTTON, HTCLOSE:
      begin
        Message.Result := HTCAPTION;
        Exit;
      end;
  end;
  inherited;
end;
{$ENDIF}
{$ENDREGION}

procedure TWinUIForm.AfterConstruction;
begin
  inherited;
  if @Application.OnHint = nil then
    HookHints;
end;

constructor TWinUIForm.Create(AOwner: TComponent);
begin
  // Focus defaluts
  FFocusStyle := TStrokeBrush.Create(TBrushKind.Solid, TAlphaColors.White);
  FFocusStyle.Thickness := 2;
  FFocusXRadius := 3;
  FFocusYRadius := 3;
  FFocusCorners := AllCorners;
  FFocusOpacity := 1;
  FFocusCornerType := TCornerType.Round;

  // Style defaults
  FSystemBackdropType := TSystemBackdropType.DWMSBT_MAINWINDOW;
  inherited;
  TAnimation.AniFrameRate := 120;

  // Override method if skip step
  if not NotInitStyle then
  begin
    SetWindowColorMode(True);
    if SetSystemBackdropType(FSystemBackdropType) then
    begin
      Fill.Kind := TBrushKind.Solid;
      Fill.Color := TAlphaColorRec.Null;
      SetExtendFrameIntoClientArea(TRect.Create(-1, -1, -1, -1));
    end
    else
      Fill.Kind := TBrushKind.None;
  end;
end;

procedure TWinUIForm.CreateHandle;
begin
  inherited;
  {$IFDEF MSWINDOWS}
  AllowDispatchWindowMessages(Self);
  {$ENDIF}
end;

destructor TWinUIForm.Destroy;
begin
  inherited;
  FFocusStyle.Free;
end;

procedure TWinUIForm.BeginLauncher(Proc: TProc);
begin
  if Assigned(Proc) then
    Proc;
  if SetSystemBackdropType(TSystemBackdropType.DWMSBT_DISABLE) then
  begin
    Fill.Kind := TBrushKind.Solid;
    Fill.Color := TAlphaColorRec.Null;
    SetExtendFrameIntoClientArea(TRect.Create(-1, -1, -1, -1));
  end
  else
    Fill.Kind := TBrushKind.None;
end;

procedure TWinUIForm.EndLauncher(Proc: TProc);
begin
  if Assigned(Proc) then
    Proc;
  if SetSystemBackdropType(FSystemBackdropType) then
  begin
    Fill.Kind := TBrushKind.Solid;
    Fill.Color := TAlphaColorRec.Null;
    SetExtendFrameIntoClientArea(TRect.Create(-1, -1, -1, -1));
  end
  else
    Fill.Kind := TBrushKind.None;
end;

procedure TWinUIForm.HookHints;
begin
  FPopupHint := TPopup.Create(Self);
  AddObject(FPopupHint);
  with FPopupHint do
  begin
    HitTest := False;
    Position.X := 0;
    Position.Y := 0;
    Size.Width := 143;
    Size.Height := 28;
    StyleLookup := 'hintpopupstyle';

    FLabelHint := TLabel.Create(FPopupHint);
    AddObject(FLabelHint);
    with FLabelHint do
    begin
      Align := TAlignLayout.Center;
      AutoSize := True;
      StyledSettings := [TStyledSetting.Family, TStyledSetting.Style, TStyledSetting.FontColor];
      Size.Width := 21;
      Size.Height := 16;
      TextSettings.HorzAlign := TTextAlign.Center;
      TextSettings.WordWrap := False;
      TextSettings.Trimming := TTextTrimming.None;
      Text := '';
    end;

    FFloatAnimationHint := TFloatAnimation.Create(FPopupHint);
    FPopupHint.AddObject(FFloatAnimationHint);
    with FFloatAnimationHint do
    begin
      Duration := 0.2;
      OnProcess := FloatAnimationHintProcess;
      PropertyName := 'Opacity';
      StartValue := 0.1;
      StopValue := 1.0;
    end;

    FTimerHint := TTimer.Create(FPopupHint);
    FPopupHint.AddObject(FTimerHint);
    with FTimerHint do
    begin
      Enabled := False;
      Interval := 600;
      OnTimer := TimerHintTimer;
    end;

    FTimerHintClose := TTimer.Create(FPopupHint);
    FPopupHint.AddObject(FTimerHintClose);
    with FTimerHintClose do
    begin
      Enabled := False;
      Interval := 4000;
      OnTimer := TimerHintCloseTimer;
    end;
  end;
  Application.OnHint := FOnAppHint;
end;

procedure TWinUIForm.FOnAppHint(Sender: TObject);
begin
  FTimerHint.Enabled := False;
  if Application.Hint.IsEmpty then
  begin
    FPopupHint.IsOpen := False;
    Exit;
  end;
  if FPopupHint.IsOpen then
    TimerHintTimer(nil)
  else
    FTimerHint.Enabled := True;
end;

procedure TWinUIForm.TimerHintCloseTimer(Sender: TObject);
begin
  FTimerHintClose.Enabled := False;
  if FPopupHint.IsOpen then
    FPopupHint.IsOpen := False;
end;

procedure TWinUIForm.TimerHintTimer(Sender: TObject);
begin
  FTimerHintClose.Enabled := False;
  FTimerHint.Enabled := False;
  if not Active then
    Exit;
  FLabelHint.Text := Application.Hint;
  var Obj := ObjectAtPoint(Screen.MousePos);
  if (Obj <> nil) and (Obj is TControl) then
  begin
    var KS: IKeyShortcut;
    if Supports(Obj, IKeyShortcut, KS) then
    begin
      var FMenuService: IFMXMenuService;
      if TPlatformServices.Current.SupportsPlatformService(IFMXMenuService, FMenuService) then
        FLabelHint.Text := FLabelHint.Text + ' (' + FMenuService.ShortCutToText(KS.ShortCut) + ')';
    end;
  end;
  FPopupHint.Height := 28;
  FPopupHint.Width := FLabelHint.Width + 8 * 2;

  FPopupHint.Placement := TPlacement.absolute;
  var Pt := Screen.MousePos;
  Pt.Offset(-FPopupHint.Width / 2, -(FPopupHint.Height + 20));
  FPopupHint.PlacementRectangle.Rect := TRectF.Create(Pt, FPopupHint.Width, FPopupHint.Height);

  if not FPopupHint.IsOpen then
  begin
    FPopupHint.Popup;
    FFloatAnimationHint.StopAtCurrent;
    FPopupHint.Opacity := 0.1;
    FFloatAnimationHint.Inverse := False;
    FFloatAnimationHint.Start;
  end;
  FTimerHintClose.Enabled := True;
end;

procedure TWinUIForm.FloatAnimationHintProcess(Sender: TObject);
begin
  FPopupHint.UpdateEffects;
end;

procedure TWinUIForm.KeyDown(var Key: Word; var KeyChar: System.WideChar; Shift: TShiftState);
begin
  if Key = vkTab then
  begin
    if not FModeFocus then
    begin
      FModeFocus := True;
      Invalidate;
      if not ((Focused is TCustomEdit) or (Focused is TCustomMemo)) then
        Exit;
    end
    else
      Invalidate;
  end;
  inherited;
end;

procedure TWinUIForm.MouseDown(Button: TMouseButton; Shift: TShiftState; AFormX, AFormY: Single);
begin
  FModeFocus := False;
  Invalidate;
  inherited;
end;

function TWinUIForm.NotInitStyle: Boolean;
begin
  Result := False;
end;

procedure TWinUIForm.PaintRects(const UpdateRects: array of TRectF);
begin
  // draw all form if focus mode is on
  if FModeFocus then
    inherited PaintRects(ClientRect)
  else
    inherited;
  if FModeFocus and Assigned(Focused) then
  begin
    if (Focused is TControl) and not (Focused is TCustomEdit) and not (Focused is TCustomMemo) then
    begin
      Canvas.BeginScene;
      try
        Canvas.Stroke.Assign(FFocusStyle);
        var R := TControl(Focused).AbsoluteRect;
        R.Inflate(FFocusInflate, FFocusInflate);
        Canvas.DrawRect(R, FFocusXRadius, FFocusYRadius, FFocusCorners, FFocusOpacity, FFocusCornerType);
      finally
        Canvas.EndScene;
      end;
    end;
  end;
end;

procedure TWinUIForm.SetCaptionControls(const Value: TArray<TControl>);
begin
  FCaptionControls := Value;
end;

procedure TWinUIForm.SetFocusCorners(const Value: TCorners);
begin
  FFocusCorners := Value;
end;

procedure TWinUIForm.SetFocusCornerType(const Value: TCornerType);
begin
  FFocusCornerType := Value;
end;

procedure TWinUIForm.SetFocusInflate(const Value: Single);
begin
  FFocusInflate := Value;
end;

procedure TWinUIForm.SetFocusOpacity(const Value: Single);
begin
  FFocusOpacity := Value;
end;

procedure TWinUIForm.SetFocusXRadius(const Value: Single);
begin
  FFocusXRadius := Value;
end;

procedure TWinUIForm.SetFocusYRadius(const Value: Single);
begin
  FFocusYRadius := Value;
end;

procedure TWinUIForm.SetHideTitleBar(const Value: Boolean);
begin
  FHideTitleBar := Value;
  {$IFDEF MSWINDOWS}
  DwmWinProcProirity := FHideTitleBar;
  InvalidateNonClient;
  {$ENDIF}
end;

procedure TWinUIForm.SystemBackdropType(AType: TSystemBackdropType);
begin
  FSystemBackdropType := AType;
  SetSystemBackdropType(FSystemBackdropType);
end;

end.

