unit WinUI3.Form;

interface

uses
  System.SysUtils, System.Classes, System.Types, FMX.Edit, FMX.Controls,
  System.UITypes, FMX.Memo, FMX.StdCtrls, FMX.Graphics, FMX.Forms, FMX.Types,
  {$IFDEF MSWINDOWS}
  Winapi.Windows, Winapi.Messages, FMX.Windows.Dispatch, FMX.Platform.Win,
  DelphiWindowStyle.Types,
  {$ENDIF}
  FMX.Platform, FMX.Ani, FMX.Filter.Effects, FMX.Effects, FMX.ActnList,
  DelphiWindowStyle.FMX, System.Messaging;

type
  TSystemThemeKind = FMX.platform.TSystemThemeKind;

  TWindowBackdropType = (//
    Auto = 0,    // Auto
    Disable = 1, // None
    Mica = 2,    // Mica
    Acrylic = 3, // Acrylic
    Tabbed = 4); // Tabbed

  TPopup = class(FMX.Controls.TPopup)
  end;

  TInternalSettingChangedMessage = class(System.Messaging.TMessage<TCommonCustomForm>)
  private
    FStyleBook: TStyleBook;
  public
    property StyleBook: TStyleBook read FStyleBook;
    constructor Create(StyleBook: TStyleBook; Form: TCommonCustomForm); reintroduce;
  end;

  TWinUIForm = class(TForm)
  protected
    class var
      FThemeKind: TSystemThemeKind;
      FSystemThemeKind: TSystemThemeKind;
      FSystemAccentColor: TAlphaColor;
  private
    FSubs1: TMessageSubscriptionId;
    FSubs2: TMessageSubscriptionId;
    FSubs3: TMessageSubscriptionId;
    FSubs4: TMessageSubscriptionId;
    FSubs5: TMessageSubscriptionId;
  private
    FModeFocus: Boolean;
    FPopupHint: TPopup;
    FTimerHintClose: TTimer;
    FTimerHint: TTimer;
    FLabelHint: TLabel;
    FFloatAnimationHint: TFloatAnimation;
    FSystemBackdropType: TWindowBackdropType;
    FCaptionControls: TArray<TControl>;
    FHideTitleBar: Boolean;
    FFocusStyle: TStrokeBrush;
    FFocusXRadius: Single;
    FFocusYRadius: Single;
    FFocusOpacity: Single;
    FFocusCornerType: TCornerType;
    FFocusCorners: TCorners;
    FFocusInflate: Single;
    FOffsetControls: TArray<TControl>;
    FTitleControls: TArray<TControl>;
    FAutoScrollToFocused: Boolean;
    FFocusHighlight: Boolean;
    FButtonClose: TStyledControl;
    FButtonMin: TStyledControl;
    FButtonMax: TStyledControl;
    {$IFDEF MSWINDOWS}
    FWindowHandle: HWND;
    FWindowCaptionColor: TColor;
    {$ENDIF}
    procedure SetFocusCorners(const Value: TCorners);
    procedure SetFocusCornerType(const Value: TCornerType);
    procedure SetFocusOpacity(const Value: Single);
    procedure SetFocusXRadius(const Value: Single);
    procedure SetFocusYRadius(const Value: Single);
    procedure SetFocusInflate(const Value: Single);
    procedure SetOffsetControls(const Value: TArray<TControl>);
    procedure SetTitleControls(const Value: TArray<TControl>);
    procedure SetPropSystemBackdropType(const Value: TWindowBackdropType);
    procedure SetAutoScrollToFocused(const Value: Boolean);
    procedure SetFocusHighlight(const Value: Boolean);
    class function GetIsDark: Boolean; static;
    procedure SetWindowCaptionColorInternal(const Value: TColor);
  protected
    procedure PaintRects(const UpdateRects: array of TRectF); override;
    procedure CreateHandle; override;
  protected
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
    procedure WMNCLButtonDown(var Message: TWMNCLButtonDown); message WM_NCLBUTTONDOWN;
    procedure WMNCLButtonUp(var Message: TWMNCLButtonUp); message WM_NCLBUTTONUP;
    procedure WMNCPAINT(var Msg: TWMNCPaint); message WM_NCPAINT;
    procedure WMNCACTIVATE(var Msg: TWMNCActivate); message WM_NCACTIVATE;
    procedure WMSize(var Msg: TWMSize); message WM_SIZE;
    {$ENDIF}
    procedure HookHints; virtual;
  protected
    function NotInitStyle: Boolean; virtual;
    procedure DoOnSettingChange; virtual;
    procedure FOnSysClose(Sender: TObject);
    procedure FOnSysMin(Sender: TObject);
    procedure FOnSysMax(Sender: TObject);
  public
    procedure AfterConstruction; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; AFormX, AFormY: Single); override;
    procedure KeyDown(var Key: Word; var KeyChar: System.WideChar; Shift: TShiftState); override;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  public
    procedure BeginLauncher(Proc: TProc = nil); virtual;
    procedure EndLauncher(Proc: TProc = nil); virtual;
    procedure SetSystemWindowControls(const AClose, AMax, AMin: TStyledControl); virtual;
    procedure UpdateSystemBackdropType;
    class property SystemAccentColor: TAlphaColor read FSystemAccentColor;
    class property SystemThemeKind: TSystemThemeKind read FSystemThemeKind;
    class property ThemeKind: TSystemThemeKind read FThemeKind write FThemeKind;
    class property IsDark: Boolean read GetIsDark;
    property SystemBackdropType: TWindowBackdropType read FSystemBackdropType write SetPropSystemBackdropType;
    property WindowCaptionColor: TColor read FWindowCaptionColor write SetWindowCaptionColorInternal;
    //
    /// <summary>
    /// Controls for drag form
    /// </summary>
    property CaptionControls: TArray<TControl> read FCaptionControls write SetCaptionControls;
    /// <summary>
    /// Controls for apply top offset for maximized
    /// </summary>
    property OffsetControls: TArray<TControl> read FOffsetControls write SetOffsetControls;
    /// <summary>
    /// Control for form catpion text
    /// </summary>
    property TitleControls: TArray<TControl> read FTitleControls write SetTitleControls;
    property HideTitleBar: Boolean read FHideTitleBar write SetHideTitleBar;
    /// <summary>
    /// Enables/disables the highlight of the control in focus when using the keyboard (Tab)
    /// </summary>
    property FocusHighlight: Boolean read FFocusHighlight write SetFocusHighlight;
    property FocusStyle: TStrokeBrush read FFocusStyle;
    property FocusXRadius: Single read FFocusXRadius write SetFocusXRadius;
    property FocusYRadius: Single read FFocusYRadius write SetFocusYRadius;
    property FocusCorners: TCorners read FFocusCorners write SetFocusCorners;
    property FocusOpacity: Single read FFocusOpacity write SetFocusOpacity;
    property FocusCornerType: TCornerType read FFocusCornerType write SetFocusCornerType;
    property FocusInflate: Single read FFocusInflate write SetFocusInflate;
    property AutoScrollToFocused: Boolean read FAutoScrollToFocused write SetAutoScrollToFocused;
  end;

implementation

uses
  FMX.Menus, FMX.DateTimeCtrls, System.Threading, FMX.Layouts,
  FMX.Bind.Navigator, Data.Bind.Controls;

procedure RegisterSystemThemeChanging;
begin
  // Read system style kind
  var SystemAppearanceService: IFMXSystemAppearanceService;
  if TPlatformServices.Current.SupportsPlatformService(IFMXSystemAppearanceService, SystemAppearanceService) then
  begin
    TWinUIForm.FSystemAccentColor := SystemAppearanceService.GetSystemColor(TSystemColorType.Accent);
    TWinUIForm.FSystemThemeKind := SystemAppearanceService.ThemeKind;
  end;
end;

{$REGION 'WinAPI for no TitleBar'}
{$IFDEF MSWINDOWS}

procedure TWinUIForm.InvalidateNonClient;
begin
  LockWindowUpdate(FWindowHandle);
  SetWindowPos(FWindowHandle, 0, 0, 0, 0, 0, SWP_NOSIZE or SWP_NOMOVE or SWP_NOZORDER or SWP_NOACTIVATE or SWP_NOSENDCHANGING or SWP_FRAMECHANGED);
  if not FHideTitleBar then
    SetWindowLong(FWindowHandle, GWL_STYLE, GetWindowLong(FWindowHandle, GWL_STYLE) + WS_SYSMENU)
  else
    SetWindowLong(FWindowHandle, GWL_STYLE, GetWindowLong(FWindowHandle, GWL_STYLE) - WS_SYSMENU);
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
    var Offset := 0.0;
    if IsZoomed(FWindowHandle) then
      Offset := R.Bottom;
    for var Item in OffsetControls do
      Item.Margins.Top := Offset;

    Inc(Message.CalcSize_Params.rgrc[0].Top, R.Top);
    //Message.CalcSize_Params.rgrc[0].Top := 48;
    Message.Result := 0;
  end
  else
    inherited;
end;

procedure TWinUIForm.WMNCPAINT(var Msg: TWMNCPaint);
begin
  //Msg.Result := 0;
end;

procedure TWinUIForm.WMSize(var Msg: TWMSize);
begin
  inherited;
  if WindowState = TWindowState.wsMaximized then
  begin
    if Assigned(FButtonMax) then
      FButtonMax.StyleLookup := 'win_sys_btn_restore'
  end
  else
  begin
    if Assigned(FButtonMax) then
      FButtonMax.StyleLookup := 'win_sys_btn_max';
  end;
end;

procedure TWinUIForm.WMNCACTIVATE(var Msg: TWMNCActivate);
begin
  //Msg.Result := 1;
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
        var Control := ObjectAtPoint(Screen.MousePos);
        if Assigned(Control) then
        begin
          if Control.GetObject = FButtonMax then
          begin
            Message.Result := HTMAXBUTTON;
            var P := ScreenToClient(Screen.MousePos);
            MouseMove([], P.X, P.Y);
            Exit;
          end;
        end;
        var P := ScreenToClient(Screen.MousePos).Round;
        if P.Y > FCaptionControls[0].Height then
          Exit;
        var R := TRect.Create(5, 5, 32, 32);
        // sys menu
        if (P.X < R.Right) and ((WindowState = TWindowState.wsMaximized) or ((P.Y >= R.Top) and (P.Y < R.Bottom))) then
          Message.Result := HTSYSMENU
        else  // top resize
        if (P.Y < 5) and (BorderStyle in [TFmxFormBorderStyle.Sizeable, TFmxFormBorderStyle.SizeToolWin]) then
        begin
          if P.X < 5 then
            Message.Result := HTTOPLEFT
          else if P.X > ClientWidth - 5 then
            Message.Result := HTTOPRIGHT
          else
            Message.Result := HTTOP;
        end
        else // drag
        begin
          var Obj := ObjectAtPoint(Screen.MousePos);
          if not Assigned(Obj) then
            Exit;
          for var Item in FCaptionControls do
            if Item = Obj.GetObject then
            begin
              Message.Result := HTCAPTION;
              Exit;
            end;
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

procedure TWinUIForm.WMNCLButtonDown(var Message: TWMNCLButtonDown);
begin
  var Control := ObjectAtPoint(Screen.MousePos);
  if Assigned(Control) then
  begin
    if Control.GetObject = FButtonMax then
    begin
      Message.Result := HTMAXBUTTON;
      var P := ScreenToClient(Screen.MousePos);
      MouseDown(TMouseButton.mbLeft, [], P.X, P.Y);
      Exit;
    end;
  end;
end;

procedure TWinUIForm.WMNCLButtonUp(var Message: TWMNCLButtonUp);
begin
  var Control := ObjectAtPoint(Screen.MousePos);
  if Assigned(Control) then
  begin
    if Control.GetObject = FButtonMax then
    begin
      Message.Result := HTMAXBUTTON;
      var P := ScreenToClient(Screen.MousePos);
      MouseUp(TMouseButton.mbLeft, [], P.X, P.Y);
      Exit;
    end;
  end;
end;

{$ENDIF}
{$ENDREGION}

procedure TWinUIForm.AfterConstruction;
begin
  inherited;
  if @Application.OnHint = nil then
    HookHints;

  // Override for set own style
  DoOnSettingChange;
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

  //
  FAutoScrollToFocused := True;
  FFocusHighlight := True;

  // Subscribe to change caption
  FSubs1 := TMessageManager.DefaultManager.SubscribeToMessage(TMainCaptionChangedMessage,
    procedure(const Sender: TObject; const M: TMessage)
    begin
      if TMainCaptionChangedMessage(M).Value = Self then
      begin
        var TextControl: ICaption;
        if (Length(TitleControls) > 0) and Supports(TitleControls[0], ICaption, TextControl) then
          TextControl.Text := TMainCaptionChangedMessage(M).Value.Caption;
      end;
    end);

  // Subscribe to change internal settings
  FSubs2 := TMessageManager.DefaultManager.SubscribeToMessage(TInternalSettingChangedMessage,
    procedure(const Sender: TObject; const M: TMessage)
    begin
      if TInternalSettingChangedMessage(M).Value <> Self then
      begin
        DoOnSettingChange;
        StyleBook := TInternalSettingChangedMessage(M).StyleBook;
        TMessageManager.DefaultManager.SendMessage(Self, TStyleChangedMessage.Create(TInternalSettingChangedMessage(M).StyleBook, Self), True);
      end;
    end);

  // Subscribe to activate form
  FSubs3 := TMessageManager.DefaultManager.SubscribeToMessage(TFormActivateMessage,
    procedure(const Sender: TObject; const M: TMessage)
    begin
      if TFormActivateMessage(M).Value = Self then
      begin
        for var Control in TitleControls do
          Control.Opacity := 1;
        if Assigned(FButtonClose) then
          FButtonClose.Opacity := 1;
        if Assigned(FButtonMin) then
          FButtonMin.Opacity := 1;
        if Assigned(FButtonMax) then
          FButtonMax.Opacity := 1;
      end;
    end);

  // Subscribe to deactivate form
  FSubs4 := TMessageManager.DefaultManager.SubscribeToMessage(TFormDeactivateMessage,
    procedure(const Sender: TObject; const M: TMessage)
    begin
      if TFormActivateMessage(M).Value = Self then
      begin
        for var Control in TitleControls do
          Control.Opacity := 0.5;
        if Assigned(FButtonClose) then
          FButtonClose.Opacity := 0.5;
        if Assigned(FButtonMin) then
          FButtonMin.Opacity := 0.5;
        if Assigned(FButtonMax) then
          FButtonMax.Opacity := 0.5;
      end;
    end);

  // Subscribe to change system theme
  FSubs5 := TMessageManager.DefaultManager.SubscribeToMessage(TSystemAppearanceChangedMessage,
    procedure(const Sender: TObject; const M: TMessage)
    begin
      FSystemAccentColor := TSystemAppearanceChangedMessage(M).Value.AccentColor;
      FSystemThemeKind := TSystemAppearanceChangedMessage(M).Value.ThemeKind;
      DoOnSettingChange;
    end);

  // Style defaults
  FSystemBackdropType := TWindowBackdropType.Mica;
  inherited;
end;

procedure TWinUIForm.CreateHandle;
begin
  inherited;
  {$IFDEF MSWINDOWS}
  FWindowHandle := FormToHWND(Self);
  AllowDispatchWindowMessages(Self);
  if FHideTitleBar then
    SetWindowLong(FWindowHandle, GWL_STYLE, GetWindowLong(FWindowHandle, GWL_STYLE) - WS_SYSMENU);
  {$ENDIF}
end;

destructor TWinUIForm.Destroy;
begin
  TMessageManager.DefaultManager.Unsubscribe(TMainCaptionChangedMessage, FSubs1);
  TMessageManager.DefaultManager.Unsubscribe(TInternalSettingChangedMessage, FSubs2);
  TMessageManager.DefaultManager.Unsubscribe(TFormActivateMessage, FSubs3);
  TMessageManager.DefaultManager.Unsubscribe(TFormDeactivateMessage, FSubs4);
  TMessageManager.DefaultManager.Unsubscribe(TSystemAppearanceChangedMessage, FSubs5);
  inherited;
  FFocusStyle.Free;
end;

procedure TWinUIForm.UpdateSystemBackdropType;
begin
  if SetSystemBackdropType(TSystemBackdropType(FSystemBackdropType)) then
  begin
    Fill.Kind := TBrushKind.Solid;
    Fill.Color := TAlphaColorRec.Null;
    SetExtendFrameIntoClientArea(TRect.Create(-1, -1, -1, -1));
  end
  else
    Fill.Kind := TBrushKind.None;
end;

procedure TWinUIForm.DoOnSettingChange;
begin
  SetWindowColorMode(IsDark);
  UpdateSystemBackdropType;

  // Set focus color
  if IsDark then
    FocusStyle.Color := TAlphaColorRec.White
  else
    FocusStyle.Color := TAlphaColorRec.Black;
end;

procedure TWinUIForm.BeginLauncher(Proc: TProc);
begin
  if Assigned(Proc) then
    Proc;
end;

procedure TWinUIForm.EndLauncher(Proc: TProc);
begin
  if Assigned(Proc) then
    Proc;
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

procedure TWinUIForm.FOnSysClose(Sender: TObject);
begin
  Close;
end;

procedure TWinUIForm.FOnSysMax(Sender: TObject);
begin
  {$IFDEF MSWINDOWS}
  if WindowState = TWindowState.wsMaximized then
    PostMessage(FWindowHandle, WM_SYSCOMMAND, SC_RESTORE, 0)
  else
    PostMessage(FWindowHandle, WM_SYSCOMMAND, SC_MAXIMIZE, 0);
  {$ELSE}
  if WindowState = TWindowState.wsMaximized then
    WindowState := TWindowState.wsNormal
  else
    WindowState := TWindowState.wsMaximized;
  {$ENDIF}
end;

procedure TWinUIForm.FOnSysMin(Sender: TObject);
begin
  {$IFDEF MSWINDOWS}
  PostMessage(FWindowHandle, WM_SYSCOMMAND, SC_MINIMIZE, 0);
  {$ELSE}
  WindowState := TWindowState.wsMinimized;
  {$ENDIF}
end;

class function TWinUIForm.GetIsDark: Boolean;
begin
  if FThemeKind <> TSystemThemeKind.Unspecified then
    Result := FThemeKind = TSystemThemeKind.Dark
  else
    Result := FSystemThemeKind = TSystemThemeKind.Dark;
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
  var Shadow: TShadowEffect;
  if FPopupHint.FindStyleResource<TShadowEffect>('shadow', Shadow) then
  begin
    Shadow.UpdateParentEffects;
  end;
end;

procedure TWinUIForm.KeyDown(var Key: Word; var KeyChar: System.WideChar; Shift: TShiftState);
begin
  if not FFocusHighlight then
  begin
    inherited;
    Exit;
  end;

  var DoScroll := False;
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
    begin
      DoScroll := True;
      Invalidate;
    end;
  end;
  inherited;
  if DoScroll and FAutoScrollToFocused then
    if Assigned(Focused) and (Focused is TControl) and Assigned(TControl(Focused).Parent) then
      if TControl(Focused).Parent is TScrollContent then
      begin
        var Control := TControl(Focused);
        var ScrollBox := TScrollContent(Control.Parent).ScrollBox;
        var NewViewPos: TPointF := ScrollBox.ViewportPosition;

        if (Control.Position.Y < ScrollBox.ViewportPosition.Y) or (Control.Position.Y + Control.Height > ScrollBox.BoundsRect.Bottom) then
          NewViewPos.Y := Control.Position.Y;
        if (Control.Position.X < ScrollBox.ViewportPosition.X) or (Control.Position.X + Control.Width > ScrollBox.BoundsRect.Right) then
          NewViewPos.X := Control.Position.X;

        ScrollBox.ViewportPosition := NewViewPos;
      end;
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

  function IsControlHighlight(Control: IControl): Boolean;
  begin
    if not Assigned(Focused) then
      Exit(False);
    if not (Control is TControl) then
      Exit(False);
    if Control is TCustomEdit then
      Exit(False);
    if Control is TCustomMemo then
      Exit(False);
    if Control is TCustomDateTimeEdit then
      Exit(False);
    Result := True;
  end;

begin
  if FFocusHighlight and FModeFocus and IsControlHighlight(Focused) then
  begin
    var FUpdateRects := [ClientRect];
    Canvas.BeginScene(@FUpdateRects, ContextHandle);
    try
      // draw all form if focus mode is on
      inherited PaintRects(FUpdateRects);

      var R := TControl(Focused).AbsoluteRect;
      Canvas.Stroke.Assign(FFocusStyle);
      R.Inflate(FFocusInflate, FFocusInflate);
      Canvas.DrawRect(R, FFocusXRadius, FFocusYRadius, FFocusCorners, FFocusOpacity, FFocusCornerType);
    finally
      Canvas.EndScene;
    end;
  end
  else
    inherited;
end;

procedure TWinUIForm.SetAutoScrollToFocused(const Value: Boolean);
begin
  FAutoScrollToFocused := Value;
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

procedure TWinUIForm.SetFocusHighlight(const Value: Boolean);
begin
  FFocusHighlight := Value;
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
  // Disable caption color, if hideen title bar
  if Value then
    WindowCaptionColor := TColors.SysNone
  else
    WindowCaptionColor := TColors.SysDefault;
  InvalidateNonClient;
  {$ENDIF}
end;

procedure TWinUIForm.SetOffsetControls(const Value: TArray<TControl>);
begin
  FOffsetControls := Value;
end;

procedure TWinUIForm.SetPropSystemBackdropType(const Value: TWindowBackdropType);
begin
  FSystemBackdropType := Value;
end;

procedure TWinUIForm.SetSystemWindowControls(const AClose, AMax, AMin: TStyledControl);
begin
  FButtonClose := AClose;
  FButtonMin := AMin;
  FButtonMax := AMax;
  if Assigned(FButtonClose) then
    FButtonClose.OnClick := FOnSysClose;
  if Assigned(FButtonMin) then
    FButtonMin.OnClick := FOnSysMin;
  if Assigned(FButtonMax) then
    FButtonMax.OnClick := FOnSysMax;
end;

procedure TWinUIForm.SetTitleControls(const Value: TArray<TControl>);
begin
  FTitleControls := Value;
end;

procedure TWinUIForm.SetWindowCaptionColorInternal(const Value: TColor);
begin
  FWindowCaptionColor := Value;
  SetWindowCaptionColor(FWindowCaptionColor);
end;

{ TInternalSettingChangedMessage }

constructor TInternalSettingChangedMessage.Create(StyleBook: TStyleBook; Form: TCommonCustomForm);
begin
  inherited Create(Form);
  FStyleBook := StyleBook;
end;

initialization
  TWinUIForm.FThemeKind := TSystemThemeKind.Unspecified;
  RegisterSystemThemeChanging;

end.

