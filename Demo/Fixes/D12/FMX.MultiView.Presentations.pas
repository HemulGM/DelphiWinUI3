{*******************************************************}
{                                                       }
{              Delphi FireMonkey Platform               }
{                                                       }
{ Copyright(c) 2014-2024 Embarcadero Technologies, Inc. }
{              All rights reserved                      }
{                                                       }
{*******************************************************}

unit FMX.MultiView.Presentations;

interface

{$SCOPEDENUMS ON}

uses
  System.UITypes, System.Classes, System.Types, System.Messaging, System.Generics.Collections, FMX.MultiView.Types,
  FMX.Ani, FMX.MultiView, FMX.Controls, FMX.Objects, FMX.Types;

type

{ TMultiViewBaseBorderedPresentation }

  TMultiViewBaseBorderedPresentation = class abstract(TMultiViewPresentation)
  private
    FBorderLine: TLine;
    FSavedSize: TSizeF;
    FSavedAlign: TAlignLayout;
    function IsHorizontalAlign(const AAlign: TAlignLayout): Boolean;
    function IsVerticalAlign(const AAlign: TAlignLayout): Boolean;
  protected
    procedure DoInstall; override;
    procedure DoUninstall; override;
    procedure SetExpandedSize(const Value: TSizeF); override;
  public
    constructor Create(AMultiView: TCustomMultiView); override;
    destructor Destroy; override;
    procedure UpdateSettings; override;
    procedure UpdateStyle; override;
    procedure Realign; override;
    property BorderLine: TLine read FBorderLine;
  end;

  /// <summary>Base presentation width border and shadowed overlay for target control</summary>
  TMultiViewBaseBorderWithOverlayPresentation = class(TMultiViewBaseBorderedPresentation, IFreeNotification)
  private
    FDetailOverlay: TTouchInterceptingLayout;
    FShadowAnimation: TFloatAnimation;
  protected
    /// <summary>Defines mode of Detail overlay based on drawer placement</summary>
    function DefineDetailOverlayMode: TOverlayMode; virtual;
    /// <summary>Set new parent for Detail overlay.</summary>
    procedure LinkDetailOverlayToParent(const AParent: TFmxObject);
    /// <summary>Unset parent of Detail overlay</summary>
    procedure UnlinkDetailOverlayFromParent;
    /// <summary>Notification about releasing form</summary>
    procedure FormReleased(const Sender: TObject; const M: TMessage);
    { IFreeNotification }
    /// <summary>Notification about removing parent of Detail overlay</summary>
    procedure FreeNotification(AObject: TObject);
    procedure DoInstall; override;
    procedure DoUninstall; override;
    procedure DoOpen(const ASpeed: Single); override;
    procedure DoClose(const ASpeed: Single); override;
    /// <summary>Updates parent of detail overlay. <c>ATargetControl</c> is a new parent. If <c>ATargetControl</c> is nil,
    /// method will use parent of MultiView as parent for Detail Overlay.</summary>
    procedure UpdateDetailOverlayParent(const ATargetControl: TControl);
  public
    constructor Create(AMultiView: TCustomMultiView); override;
    destructor Destroy; override;
    procedure ParentChanged; override;
    procedure EnabledChanged; override;
    /// <summary>Resets current focus</summary>
    procedure ResetFocus;
    procedure TargetControlChanging(AOldControl: TControl; ANewControl: TControl); override;
    procedure UpdateSettings; override;
    /// <summary>Access to detail overlay with shadow</summary>
    property DetailOverlay: TTouchInterceptingLayout read FDetailOverlay;
    /// <summary>Access to shadow animator of detail overlay</summary>
    property ShadowAnimation: TFloatAnimation read FShadowAnimation;
  end;

{ TMultiViewDrawerBasePresentation }

  /// <summary>MultiView moves from left form side</summary>
  TMultiViewDrawerBasePresentation = class abstract(TMultiViewBaseBorderWithOverlayPresentation)
  protected const
    MinimalSpeedThreshold = 150; // Pixels per secs
    HidingThreshold = 0.7; 
    ClickAreaExpansion = 5; // Pixels
    StorageTrackingTime = 0.25; // Sec
    SlidingSpeedReduction = 0.5; // Real traverse speed of user's finger is very big. So we should reduce speed of panel
                                 // sliding, because control close/open very-very fast
    DefaultDeadZone = 1; // Pixels
  protected type
    TTrackingInfo = record
      Position: TPointF;
      Time: TDateTime;
    end;
  private
    FMasterAnimation: TFloatAnimation;
    FTracksInfo: TList<TTrackingInfo>;
    FMousePressedAbsolutePosition: TPointF;
    FDrawerCaptured: Boolean;
    FPreviousOffset: Single;
    FDeadZone: Single;
    procedure DoAnimationFinished(Sender: TObject);
    function DoPointInObjectEvent(Sender: TObject; const X, Y: Single): Boolean;
    procedure UpdateMasterAlignment;
  protected
    /// <summary>Returns shadow opacity based on current offset of MultiView</summary>
    function DefineShadowOpacity(const AOffset: Single): Single;
    /// <summary>Returns position of opened MultiView</summary>
    function DefineOpenedPanelPosition: TPointF; virtual; abstract;
    /// <summary>Returns position of hidden MultiView</summary>
    function DefineHiddenPanelPosition: TPointF; virtual; abstract;
    /// <summary>Changes position of MultiView based on offset value</summary>
    procedure ShiftPanels(const AOffset: Single); virtual; abstract;
    /// <summary>Returns need hide panel or not. Returned value bases on current speed of moving panel.</summary>
    function NeedHidePanel(const ASpeed: Single): Boolean; virtual; abstract;
    procedure CaptureDrawer(const AX, AY: Single); virtual;
    { Tracking Information about sliding speed }
    /// <summary>Tracks position of multiview for correct calculation of panel speed.</summary>
    procedure TrackInfo(const AX, AY: Single);
    /// <summary>Returns current panel speed</summary>
    function CalculateMovingSpeed: Single;
    /// <summary>Calculates time, which is required for open or hide multiview (based on current speed of panel)</summary>
    function CalculateSlidingTime(const ASpeed: Single): Single; virtual; abstract;
    { Mouse events }
    procedure DoMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X: Single; Y: Single); virtual;
    procedure DoMouseMove(Sender: TObject; Shift: TShiftState; X: Single; Y: Single); virtual;
    procedure DoMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X: Single; Y: Single); virtual;
  protected
    procedure DoInstall; override;
    procedure DoUninstall; override;
    procedure DoOpen(const ASpeed: Single); override;
    procedure DoClose(const ASpeed: Single); override;
    procedure DoHidden; override;
    procedure DoStartMoving(const ASpeed: Single); override;
  public
    constructor Create(AMultiView: TCustomMultiView); override;
    destructor Destroy; override;
    { inherited }
    procedure Realign; override;
    procedure UpdateSettings; override;
    procedure ControlTypeChanged; override;
  public
    property MasterAnimation: TFloatAnimation read FMasterAnimation;
    /// <summary>If distance between two points less than this value, They are considered as the identical.
    /// This property affects on smooth sliding </summary>
    property DeadZone: Single read FDeadZone write FDeadZone;
  end;

{ TMultiViewDrawerPushingPresentation }

  TMultiViewDrawerPushingPresentation = class(TMultiViewDrawerBasePresentation)
  public const
    PushPanelStyle = 'pushpanel';
  private
    FDetailAnimation: TRectAnimation;
    FSavedTargetControlStyleLookup: string;
  protected
    procedure ShiftPanels(const AOffset: Single); override;
    function DefineOpenedPanelPosition: TPointF; override;
    function DefineHiddenPanelPosition: TPointF; override;
    function NeedHidePanel(const ASpeed: Single): Boolean; override;
  protected
    procedure DoOpen(const ASpeed: Single); override;
    procedure DoClose(const ASpeed: Single); override;
    procedure DoInstall; override;
    procedure DoUninstall; override;
    function GetDisplayName: string; override;
    function CalculateSlidingTime(const ASpeed: Single): Single; override;
    /// <summary>Saves current value of style lookup property of specified control</summary>
    procedure SaveStyleLookupAndUpdateStyle(const AControl: TStyledControl);
    /// <summary>Restores saved value of style lookup property of specified control</summary>
    procedure RestoreSavedStyleLookup(const AControl: TStyledControl);
  public
    constructor Create(AMultiView: TCustomMultiView); override;
    destructor Destroy; override;
    procedure Realign; override;
    procedure UpdateSettings; override;
    procedure TargetControlChanging(AOldControl: TControl; ANewControl: TControl); override;
  public
    property DetailAnimation: TRectAnimation read FDetailAnimation;
  end;

{ TMultiViewDrawerOverlapPresentation }

  TMultiViewDrawerOverlapPresentation = class(TMultiViewDrawerBasePresentation)
  protected
    function DefineOpenedPanelPosition: TPointF; override;
    function DefineHiddenPanelPosition: TPointF; override;
    procedure ShiftPanels(const AOffset: Single); override;
    function NeedHidePanel(const ASpeed: Single): Boolean; override;
    function GetDisplayName: string; override;
    function CalculateSlidingTime(const ASpeed: Single): Single; override;
    procedure DoMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X: Single; Y: Single); override;
  protected
    procedure DoOpen(const ASpeed: Single); override;
    procedure DoClose(const ASpeed: Single); override;
  public
    procedure Realign; override;
    procedure UpdateSettings; override;
  end;

{ TMultiViewPopoverPresentation }

  /// <summary>MultiView drops down from master button</summary>
  TMultiViewPopoverPresentation = class(TMultiViewPresentation)
  private
    FPopover: TCustomPopover;
  protected
    procedure DoClosePopup(Sender: TObject);
    procedure DoUninstall; override;
    procedure DoInstall; override;
    procedure DoOpen(const ASpeed: Single); override;
    procedure DoClose(const ASpeed: Single); override;
    function GetDisplayName: string; override;
    function GetExpandedSize: TSizeF; override;
  public
    constructor Create(AMultiView: TCustomMultiView); override;
    procedure Realign; override;
    procedure UpdateSettings; override;
  public
    property Popover: TCustomPopover read FPopover;
  end;

{ TMultiViewDockedPanelPresentation }

  /// <summary>Split view. Multi View is aligned by left side and detail fill the rest space of form</summary>
  TMultiViewDockedPanelPresentation = class(TMultiViewBaseBorderedPresentation)
  private
    procedure UpdateMasterAlignment;
  protected
    function GetDisplayName: string; override;
    function GetMasterButtonVisible: Boolean; override;
    procedure DoInstall; override;
  public
    procedure UpdateSettings; override;
    function NeedHideInDesignTime: Boolean; override;
    function CanShowHideInDesignTime: Boolean; override;
    procedure TargetControlChanging(AOldControl: TControl; ANewControl: TControl); override;
  end;

{ TMultiViewNavigationPanePresentation }

  /// <summary>Presentation like a navigation Pane for windows OS</summary>
  TMultiViewNavigationPanePresentation = class(TMultiViewBaseBorderWithOverlayPresentation)
  public const
    CloseSpeedReduction = 0.5;
  private
    FMasterAnimation: TFloatAnimation;
  private
    procedure OverlayClickHandler(Sender: TObject);
    procedure AnimationFinishedHandler(Sender: TObject);
  protected
    function DefineDetailOverlayMode: TOverlayMode; override;
    function GetDisplayName: string; override;
    procedure DoInstall; override;
    procedure DoUninstall; override;
    procedure DoOpen(const ASpeed: Single); override;
    procedure DoClose(const ASpeed: Single); override;
    procedure SetExpandedSize(const Value: TSizeF); override;
    function GetExpandedSize: TSizeF; override;
    function GetCollapsedSize: TSizeF; override;
  public
    constructor Create(AMultiView: TCustomMultiView); override;
    destructor Destroy; override;
    function NeedHideInDesignTime: Boolean; override;
    /// <summary>Resets current focus</summary>
    procedure ResetFocus;
    procedure TargetControlChanging(AOldControl: TControl; ANewControl: TControl); override;
    procedure UpdateSettings; override;
    procedure Realign; override;
    /// <summary>Updates width of MultiView based on current state (opened, closed)</summary>
    procedure RecalculateWidth;
  end;

implementation

uses
  System.Math, System.SysUtils, System.Math.Vectors, {$IFDEF MACOS}Macapi.CoreFoundation, {$ENDIF} FMX.Platform,
  FMX.Pickers, FMX.Forms, FMX.Graphics, FMX.Consts;

type
  TPanelPlacementHelper = record helper for TPanelPlacement
    function ToOverlayMode: TOverlayMode;
    function ToLineType: TLineType;
  end;

{ TMultiViewPopoverPresentation }

procedure TMultiViewPopoverPresentation.Realign;
begin
  inherited;
  FPopover.IsOpen := False;
  if MultiView.HasTargetControl then
    MultiView.TargetControl.Align := TAlignLayout.Client;
  if MultiView.HasMasterButton then
    MultiView.MasterButton.Visible := True;
end;

procedure TMultiViewPopoverPresentation.UpdateSettings;
var
  PopoverOptions: TPopoverAppearance;
begin
  inherited;
  PopoverOptions := MultiView.PopoverOptions;
  FPopover.AppearanceDuration := PopoverOptions.AppearanceDuration;
  FPopover.TintColor := PopoverOptions.TintColor;
  FPopover.StyleLookup := PopoverOptions.StyleLookup;
  FPopover.Height := PopoverOptions.PopupHeight;
  if csDesigning in MultiView.ComponentState then
    MultiView.Height := PopoverOptions.PopupHeight;
end;

constructor TMultiViewPopoverPresentation.Create(AMultiView: TCustomMultiView);
begin
  inherited;
  FPopover := TCustomPopover.Create(nil);
  FPopover.Stored := False;
  FPopover.Width := AMultiView.Width;
  FPopover.Visible := False;
  FPopover.OnClosePopup := DoClosePopup;
  FPopover.TintColor := MultiView.PopoverOptions.TintColor;
end;

procedure TMultiViewPopoverPresentation.DoClosePopup(Sender: TObject);
begin
  DoStartHiding;
  Close;
  DoHidden;
  MultiView.MasterContent.Parent := MultiView;
end;

procedure TMultiViewPopoverPresentation.DoInstall;
begin
  inherited;
  MultiView.Visible := False;
  MultiView.Align := TAlignLayout.None;
  MultiView.Size.Size := GetExpandedSize;
end;

procedure TMultiViewPopoverPresentation.DoUninstall;
begin
  FreeAndNil(FPopover);
  inherited;
end;

function TMultiViewPopoverPresentation.GetDisplayName: string;
begin
  Result := SPopover;
end;

function TMultiViewPopoverPresentation.GetExpandedSize: TSizeF;
begin
  Result := TSizeF.Create(MultiView.Width, MultiView.PopoverOptions.PopupHeight);
end;

procedure TMultiViewPopoverPresentation.DoClose;
begin
  inherited;
  if csDesigning in MultiView.ComponentState then
    MultiView.Visible := False
  else
    FPopover.IsOpen := False;
end;

procedure TMultiViewPopoverPresentation.DoOpen;
begin
  inherited;
  if csDesigning in MultiView.ComponentState then
  begin
    MultiView.Visible := True;
    MultiView.Size.Size := GetExpandedSize;
  end
  else
  begin
    FPopover.Width := MultiView.Width;
    FPopover.PlacementTarget := MultiView.MasterButton;

    MultiView.MasterContent.Parent := FPopover;
    DoStartShowing;
    FPopover.Popup;
    DoShown;
  end;
end;

{ TMultiViewDrawerPresentation }

procedure TMultiViewDrawerBasePresentation.Realign;
begin
  inherited;
  if (csDesigning in MultiView.ComponentState) or Opened then
    MultiView.Position.Point := DefineOpenedPanelPosition
  else
    MultiView.Position.Point := DefineHiddenPanelPosition;

  if MultiView.HasMasterButton then
    MultiView.MasterButton.Visible := True;
end;

procedure TMultiViewDrawerBasePresentation.DoStartMoving(const ASpeed: Single);
begin
  inherited;
  if MultiView.DrawerOptions.Placement in [TPanelPlacement.Left, TPanelPlacement.Top] then
  begin
    if ASpeed > 0 then
      DoStartShowing
    else
      DoStartHiding;
  end
  else
  begin
    if ASpeed < 0 then
      DoStartShowing
    else
      DoStartHiding;
  end;
end;

function TMultiViewDrawerBasePresentation.CalculateMovingSpeed: Single;
var
  Distance: Single;
  Interval: TTimeStamp;
begin
  Result := 0;
  if FTracksInfo.Count < 2 then
    Exit;

  Interval := DateTimeToTimeStamp(FTracksInfo.Last.Time - FTracksInfo.First.Time);
  Distance := FTracksInfo.Last.Position.X - FTracksInfo.First.Position.X;
  if Interval.Time = 0 then
    Result := MultiView.DrawerOptions.DurationSliding
  else
    Result := (Distance / Interval.Time) * MSecsPerSec;
end;

constructor TMultiViewDrawerBasePresentation.Create(AMultiView: TCustomMultiView);
begin
  inherited;
  FTracksInfo := TList<TTrackingInfo>.Create;
  FDrawerCaptured := False;
  FPreviousOffset := 0;
  FDeadZone := DefaultDeadZone;

  // Detail overlay layer for catching mouse events
  FDetailOverlay.OnMouseDown := DoMouseDown;
  FDetailOverlay.OnMouseMove := DoMouseMove;
  FDetailOverlay.OnMouseUp := DoMouseUp;
  FDetailOverlay.OnPointInObjectEvent := DoPointInObjectEvent;

  // Animation of moving Master panel
  FMasterAnimation := TFloatAnimation.Create(nil);
  FMasterAnimation.Parent := MultiView;
  FMasterAnimation.Stored := False;
  FMasterAnimation.PropertyName := 'position.x'; // do not localize
  FMasterAnimation.Duration := MultiView.DrawerOptions.DurationSliding;
  FMasterAnimation.OnFinish := DoAnimationFinished;
end;

function TMultiViewDrawerBasePresentation.DefineShadowOpacity(const AOffset: Single): Single;
var
  MaxOffset: Single;
begin
  if MultiView.DrawerOptions.Placement in [TPanelPlacement.Left, TPanelPlacement.Right] then
    MaxOffset := MultiView.Width
  else
    MaxOffset := MultiView.Height;

  if SameValue(MaxOffset, 0, TEpsilon.Vector) then
    Result := 0
  else if Opened then
    Result := 1 - Abs(AOffset) / MaxOffset
  else
    Result := Abs(AOffset) / MaxOffset;
  Result := MultiView.ShadowOptions.Opacity * Result;
end;

destructor TMultiViewDrawerBasePresentation.Destroy;
begin
  inherited Destroy;
  FreeAndNil(FTracksInfo);
  FreeAndNil(FMasterAnimation);
end;

procedure TMultiViewDrawerBasePresentation.DoInstall;
begin
  inherited;
  MultiView.Visible := True;
  if MultiView.HasTargetControl then
    MultiView.TargetControl.Margins.Rect := TRectF.Empty;
end;

procedure TMultiViewDrawerBasePresentation.DoMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Single);
begin
  CaptureDrawer(X, Y);
  MultiView.Visible := True;
  ResetFocus;
end;

procedure TMultiViewDrawerBasePresentation.DoMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);

  function NormalizeInBounds(const AOffset: Single): Single;
  begin
    Result := AOffset;
    if Opened then
    begin
      case MultiView.DrawerOptions.Placement of
        TPanelPlacement.Left:
          Result := EnsureRange(AOffset, -MultiView.Width, 0);
        TPanelPlacement.Right:
          Result := EnsureRange(AOffset, 0, MultiView.Width);
        TPanelPlacement.Top:
          Result := EnsureRange(AOffset, -MultiView.Height, 0);
        TPanelPlacement.Bottom:
          Result := EnsureRange(AOffset, 0, MultiView.Height);
      end;
    end
    else
    begin
      case MultiView.DrawerOptions.Placement of
        TPanelPlacement.Left:
          Result := EnsureRange(AOffset, 0, MultiView.Width);
        TPanelPlacement.Right:
          Result := EnsureRange(AOffset, -MultiView.Width, 0);
        TPanelPlacement.Top:
          Result := EnsureRange(AOffset, 0, MultiView.Height);
        TPanelPlacement.Bottom:
          Result := EnsureRange(AOffset, -MultiView.Height, 0);
      end;
    end;
  end;

  function CalculateOffset: Single;
  var
    MouseAbsolutePos: TPointF;
    Offset: Single;
  begin
    MouseAbsolutePos := FDetailOverlay.LocalToAbsolute(TPointF.Create(X, Y));
    if MultiView.DrawerOptions.Placement in [TPanelPlacement.Left, TPanelPlacement.Right] then
      Offset := MouseAbsolutePos.X - FMousePressedAbsolutePosition.X
    else
      Offset := MouseAbsolutePos.Y - FMousePressedAbsolutePosition.Y;
    Result := NormalizeInBounds(Offset);
  end;

  procedure UpdateShadowOpacity(const AOffset: SIngle);
  begin
    if MultiView.ShadowOptions.Enabled then
      FDetailOverlay.Opacity := DefineShadowOpacity(AOffset);
  end;

  function PointInMultiView(AMouseAbsoultePos: TPointF): Boolean;
  begin
    Result := MultiView.LocalRect.Contains(MultiView.AbsoluteToLocal(AMouseAbsoultePos));
  end;

var
  Offset: Single;
  MouseAbsoultePos: TPointF;
begin
  MouseAbsoultePos := DetailOverlay.LocalToAbsolute(TPointF.Create(X, Y));
{$IFDEF ANDROID}
  if not Opened then
    FDrawerCaptured := True
  else
    if PointInMultiView(MouseAbsoultePos) and not FDrawerCaptured then
    begin
      FDrawerCaptured := True;
      CaptureDrawer(X, Y);
    end;
{$ELSE}
  FDrawerCaptured := True;
{$ENDIF}

  if (ssLeft in Shift) and FDetailOverlay.Pressed and FDrawerCaptured then
  begin
    Offset := CalculateOffset;
    // Optimization: When user slowly moves finger through screen, OS can generate a lot of the similar mouse events.
    // We reject events, If they aren't noticeable in UI (very close pixels will be rounded in Paint in one)
    if Abs(FPreviousOffset - Offset) > DeadZone then
    begin
      ShiftPanels(Offset);
      // If offset is zero, we can not define a direction of sliding, so we don't invoke OnStartHiding or OnStartShowing
      if not (TPresentationState. Moving in State) and (Offset <> 0) then
        StartMoving(Offset);
      UpdateShadowOpacity(Offset);
      TrackInfo(X, Y);
      FPreviousOffset := Offset;
    end;
  end;
end;

procedure TMultiViewDrawerBasePresentation.DoMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);

  function IsClick: Boolean;
  var
    AbsolutePos: TPointF;
  begin
    AbsolutePos := DetailOverlay.LocalToAbsolute(TPointF.Create(X, Y));
    Result := FMousePressedAbsolutePosition.Distance(AbsolutePos) < ClickAreaExpansion;
  end;

var
  Speed: Single;
  NormalizedSpeed: Single;
begin
  Speed := CalculateMovingSpeed;
  NormalizedSpeed := Speed * (1 - SlidingSpeedReduction);
  if Opened and IsClick then
    Close(NormalizedSpeed)
  else
    if Opened or not IsClick or Moving then
      if NeedHidePanel(NormalizedSpeed) then
        Close(NormalizedSpeed)
      else
        Open(NormalizedSpeed);

  FDrawerCaptured := False;
end;

procedure TMultiViewDrawerBasePresentation.DoUninstall;
begin
  FMasterAnimation.Parent := nil;
  if MultiView.HasTargetControl then
    MultiView.TargetControl.Margins.Rect := TRectF.Empty;
  inherited;
end;

procedure TMultiViewDrawerBasePresentation.DoAnimationFinished(Sender: TObject);
begin
  EndMoving;
  if Opened then
    DoShown
  else
    DoHidden;
end;

procedure TMultiViewDrawerBasePresentation.DoClose(const ASpeed: Single);
begin
  if MultiView.ShadowOptions.Enabled then
   if SameValue(ASpeed, DefaultSpeed, TEpsilon.Vector) then
      FShadowAnimation.Duration := MultiView.DrawerOptions.DurationSliding
    else
      FShadowAnimation.Duration := CalculateSlidingTime(ASpeed);
  inherited;
end;

procedure TMultiViewDrawerBasePresentation.DoHidden;
begin
  inherited;
  MultiView.Visible := False;
end;

procedure TMultiViewDrawerBasePresentation.CaptureDrawer(const AX, AY: Single);
begin
  FMousePressedAbsolutePosition := DetailOverlay.LocalToAbsolute(TPointF.Create(AX, AY));
  FTracksInfo.Clear;
  TrackInfo(AX, AY);
end;

procedure TMultiViewDrawerBasePresentation.ControlTypeChanged;
begin
  inherited;
  FDetailOverlay.ControlType := MultiView.ControlType;
end;

procedure TMultiViewDrawerBasePresentation.TrackInfo(const AX, AY: Single);
var
  TrackingInfo: TTrackingInfo;
  Stopped: Boolean;
begin
  Stopped := False;
  while (FTracksInfo.Count > 0) and not Stopped do
    if (Now - FTracksInfo[0].Time) * SecsPerDay > StorageTrackingTime then
      FTracksInfo.Delete(0)
    else
      Stopped := True;

  TrackingInfo.Position := DetailOverlay.LocalToAbsolute(TPointF.Create(AX, AY));
  TrackingInfo.Time := Now;
  FTracksInfo.Add(TrackingInfo);
end;

procedure TMultiViewDrawerBasePresentation.UpdateMasterAlignment;
var
  MultiViewNewAlign: TAlignLayout;
  MultiViewNewSize: TSizeF;
begin
  inherited;
  MultiViewNewSize := FSavedSize;
  MultiViewNewAlign := TAlignLayout.Vertical;
  case MultiView.DrawerOptions.Placement of
    TPanelPlacement.Left:
    begin
      MultiViewNewAlign := TAlignLayout.Vertical;
      if IsVerticalAlign(MultiView.Align) then
        MultiViewNewSize := FSavedSize.SwapDimensions;
    end;
    TPanelPlacement.Right:
    begin
      MultiViewNewAlign := TAlignLayout.Vertical;
      if IsVerticalAlign(MultiView.Align) then
        MultiViewNewSize := FSavedSize.SwapDimensions;
    end;
    TPanelPlacement.Top:
    begin
      MultiViewNewAlign := TAlignLayout.Horizontal;
      if IsHorizontalAlign(MultiView.Align) or (MultiView.Align = TAlignLayout.None) then
        MultiViewNewSize := FSavedSize.SwapDimensions;
    end;
    TPanelPlacement.Bottom:
    begin
      MultiViewNewAlign := TAlignLayout.Horizontal;
      if IsHorizontalAlign(MultiView.Align) or (MultiView.Align = TAlignLayout.None) then
        MultiViewNewSize := FSavedSize.SwapDimensions;
    end;
  end;
  BeginInternalRealign;
  try
    MultiView.Align := MultiViewNewAlign;
    MultiView.Size.Size := MultiViewNewSize;
    FBorderLine.LineType := MultiView.DrawerOptions.Placement.ToLineType;
    FSavedSize := MultiViewNewSize;
  finally
    EndInternalRealign;
  end;
end;

procedure TMultiViewDrawerBasePresentation.UpdateSettings;
begin
  inherited;
  UpdateMasterAlignment;
  DetailOverlay.Mode := DefineDetailOverlayMode;
  FMasterAnimation.Duration := MultiView.DrawerOptions.DurationSliding;
  BeginInternalRealign;
  try
    Realign;
  finally
    EndInternalRealign;
  end;

  FMasterAnimation.Parent := nil;
  if MultiView.DrawerOptions.Placement in [TPanelPlacement.Left, TPanelPlacement.Right] then
    FMasterAnimation.PropertyName := 'position.x' // do not localize
  else
    FMasterAnimation.PropertyName := 'position.y'; // do not localize
  FMasterAnimation.Parent := MultiView;

  BorderLine.LineType := MultiView.DrawerOptions.Placement.ToLineType;
end;

procedure TMultiViewDrawerBasePresentation.DoOpen(const ASpeed: Single);
begin
  inherited;
  MultiView.Visible := True;

  if MultiView.ShadowOptions.Enabled then
    if SameValue(ASpeed, DefaultSpeed, TEpsilon.Vector) then
      FShadowAnimation.Duration := MultiView.DrawerOptions.DurationSliding
    else
      FShadowAnimation.Duration := CalculateSlidingTime(ASpeed);
end;

function TMultiViewDrawerBasePresentation.DoPointInObjectEvent(Sender: TObject; const X, Y: Single): Boolean;
var
  AbsolutePoint: TPointF;
begin
  // Exclude area of master button from DetailOverlay for correct for correct working of master button.
  // Because DetailOverlay can block MasterButton, in this case user can not click on master button
  if MultiView.HasMasterButton then
  begin
    AbsolutePoint := DetailOverlay.LocalToAbsolute(TPointF.Create(X, Y));
    Result := not MultiView.MasterButton.PointInObject(AbsolutePoint.X, AbsolutePoint.Y);
  end
  else
    Result := True;
end;

{ TMultiViewDockedPanelPresentation }

procedure TMultiViewDockedPanelPresentation.DoInstall;
begin
  MultiView.Visible := True;
  inherited;

  // Hides master button
  if MultiView.HasMasterButton then
    MultiView.MasterButton.Visible := MasterButtonVisible;

  // Resets margins from TargetControl
  if MultiView.HasTargetControl then
  begin
    MultiView.TargetControl.Align := TAlignLayout.Client;
    MultiView.TargetControl.Margins.Rect := TRectF.Empty;
  end;
end;

function TMultiViewDockedPanelPresentation.GetDisplayName: string;
begin
  Result := SDockedPanel;
end;

function TMultiViewDockedPanelPresentation.GetMasterButtonVisible: Boolean;
begin
  Result := False;
end;

function TMultiViewDockedPanelPresentation.CanShowHideInDesignTime: Boolean;
begin
  Result := False;
end;

function TMultiViewDockedPanelPresentation.NeedHideInDesignTime: Boolean;
begin
  Result := False;
end;

procedure TMultiViewDockedPanelPresentation.TargetControlChanging(AOldControl, ANewControl: TControl);
begin
  inherited;
  if MultiView.HasTargetControl then
  begin
    MultiView.TargetControl.Align := TAlignLayout.Client;
    MultiView.TargetControl.Margins.Rect := TRectF.Empty;
  end;
end;

procedure TMultiViewDockedPanelPresentation.UpdateMasterAlignment;
var
  MultiViewNewAlign: TAlignLayout;
  MultiViewNewSize: TSizeF;
begin
  inherited;
  MultiViewNewAlign := TAlignLayout.Left;
  MultiViewNewSize := FSavedSize;
  case MultiView.SplitViewOptions.Placement of
    TPanelPlacement.Left:
    begin
      MultiViewNewAlign := TAlignLayout.Left;
      if IsVerticalAlign(MultiView.Align) then
        MultiViewNewSize := FSavedSize.SwapDimensions;
    end;
    TPanelPlacement.Right:
    begin
      MultiViewNewAlign := TAlignLayout.Right;
      if IsVerticalAlign(MultiView.Align) then
        MultiViewNewSize := FSavedSize.SwapDimensions;
    end;
    TPanelPlacement.Top:
    begin
      MultiViewNewAlign := TAlignLayout.Top;
      if IsHorizontalAlign(MultiView.Align) or (MultiView.Align = TAlignLayout.None) then
        MultiViewNewSize := FSavedSize.SwapDimensions;
    end;
    TPanelPlacement.Bottom:
    begin
      MultiViewNewAlign := TAlignLayout.Bottom;
      if IsHorizontalAlign(MultiView.Align) or (MultiView.Align = TAlignLayout.None) then
        MultiViewNewSize := FSavedSize.SwapDimensions;
    end;
  end;
  BeginInternalRealign;
  try
    MultiView.Align := MultiViewNewAlign;
    MultiView.Size.Size := MultiViewNewSize;
    FSavedSize := MultiViewNewSize;
  finally
    EndInternalRealign;
  end;
  FBorderLine.LineType := MultiView.SplitViewOptions.Placement.ToLineType;
end;

procedure TMultiViewDockedPanelPresentation.UpdateSettings;
begin
  inherited;
  UpdateMasterAlignment;
end;

{ TMultiViewDrawerPushingPresentation }

function TMultiViewDrawerPushingPresentation.CalculateSlidingTime(const ASpeed: Single): Single;
var
  Distance: Single;
  Duration: Single;
begin
  if MultiView.HasTargetControl then
  begin
    if Opened then
    begin
      if MultiView.DrawerOptions.Placement in [TPanelPlacement.Left, TPanelPlacement.Right] then
        Distance := Abs(MultiView.Width - MultiView.TargetControl.Margins.Left)
      else
        Distance := Abs(MultiView.Height - MultiView.TargetControl.Margins.Top);
    end
    else
    begin
      if MultiView.DrawerOptions.Placement in [TPanelPlacement.Left, TPanelPlacement.Right] then
        Distance := Abs(MultiView.TargetControl.Margins.Left)
      else
        Distance := Abs(MultiView.TargetControl.Margins.Top);
    end;
    Duration := Distance / Abs(ASpeed);
    Result := Min(Duration, MultiView.DrawerOptions.DurationSliding);
  end
  else
    Result := MultiView.DrawerOptions.DurationSliding;
end;

constructor TMultiViewDrawerPushingPresentation.Create(AMultiView: TCustomMultiView);
const
  PropertyToPushAnimate = 'margins';
begin
  inherited;
  // Animation moves Detail panel
  FDetailAnimation := TRectAnimation.Create(nil);
  FDetailAnimation.PropertyName := PropertyToPushAnimate;
  FDetailAnimation.Stored := False;
  FDetailAnimation.Duration := MultiView.DrawerOptions.DurationSliding;
  FDetailAnimation.OnFinish := DoAnimationFinished;
end;

function TMultiViewDrawerPushingPresentation.DefineHiddenPanelPosition: TPointF;
begin
  Result := DefineOpenedPanelPosition;
end;

function TMultiViewDrawerPushingPresentation.DefineOpenedPanelPosition: TPointF;
var
  X: Single;
  Y: Single;
begin
  X := 0;
  Y := 0;
  if MultiView.DrawerOptions.Placement = TPanelPlacement.Right then
    X := GetParentWidth - MultiView.Width
  else if MultiView.DrawerOptions.Placement = TPanelPlacement.Bottom then
    Y := GetParentHeight - MultiView.Height;
  Result := TPointF.Create(X, Y);
end;

destructor TMultiViewDrawerPushingPresentation.Destroy;
begin
  inherited;
  FreeAndNil(FDetailAnimation);
end;

procedure TMultiViewDrawerPushingPresentation.TargetControlChanging(AOldControl, ANewControl: TControl);
begin
  inherited;
  if ANewControl = nil then
  begin
    FDetailAnimation.Parent := nil;
    if AOldControl is TStyledControl then
      RestoreSavedStyleLookup(TStyledControl(AOldControl));
  end
  else
  begin
    FDetailAnimation.Parent := ANewControl;
    if AOldControl is TStyledControl then
    begin
      RestoreSavedStyleLookup(TStyledControl(AOldControl));
    end;
    if ANewControl is TStyledControl then
    begin
      SaveStyleLookupAndUpdateStyle(TStyledControl(ANewControl));
    end;
    ANewControl.BringToFront;
  end;
end;

procedure TMultiViewDrawerPushingPresentation.DoUninstall;
begin
  if MultiView.TargetControl is TStyledControl then
    RestoreSavedStyleLookup(TStyledControl(MultiView.TargetControl));
  FDetailAnimation.Parent := nil;
  inherited;
end;

function TMultiViewDrawerPushingPresentation.GetDisplayName: string;
begin
  Result := SDrawer;
end;

function TMultiViewDrawerPushingPresentation.NeedHidePanel(const ASpeed: Single): Boolean;
begin
  if Abs(ASpeed) < MinimalSpeedThreshold then
  begin
    Result := False;
    if MultiView.HasTargetControl then
      case MultiView.DrawerOptions.Placement of
        TPanelPlacement.Left:
          Result := MultiView.TargetControl.Margins.Left < MultiView.Width * HidingThreshold;
        TPanelPlacement.Right:
          Result := MultiView.TargetControl.Margins.Left > -MultiView.Width * HidingThreshold;
        TPanelPlacement.Top:
          Result := MultiView.TargetControl.Margins.Top < MultiView.Height * HidingThreshold;
        TPanelPlacement.Bottom:
          Result := MultiView.TargetControl.Margins.Top > -MultiView.Height * HidingThreshold;
      end;
  end
  else
    if MultiView.DrawerOptions.Placement in [TPanelPlacement.Left, TPanelPlacement.Top] then
      Result := ASpeed < 0
    else
      Result := ASpeed > 0;
end;

procedure TMultiViewDrawerPushingPresentation.DoClose(const ASpeed: Single);
begin
  inherited;
  if MultiView.HasTargetControl then
  begin
    if SameValue(ASpeed, DefaultSpeed, TEpsilon.Vector) then
      FDetailAnimation.Duration := MultiView.DrawerOptions.DurationSliding
    else
      FDetailAnimation.Duration := CalculateSlidingTime(ASpeed);
    FDetailAnimation.StartValue.Left := MultiView.TargetControl.Margins.Left;
    FDetailAnimation.StartValue.Right := MultiView.TargetControl.Margins.Right;
    FDetailAnimation.StartValue.Top := MultiView.TargetControl.Margins.Top;
    FDetailAnimation.StartValue.Bottom := MultiView.TargetControl.Margins.Bottom;

    FDetailAnimation.StopValue.Left := 0;
    FDetailAnimation.StopValue.Right := 0;
    FDetailAnimation.StopValue.Top := 0;
    FDetailAnimation.StopValue.Bottom := 0;

    FDetailAnimation.Start;
  end
  else
  begin
    DoHidden;
    EndMoving;
  end;
end;

procedure TMultiViewDrawerPushingPresentation.DoInstall;
begin
  inherited;
  if MultiView.HasTargetControl then
    MultiView.TargetControl.BringToFront;

  MultiView.Visible := False;
end;

procedure TMultiViewDrawerPushingPresentation.Realign;
begin
  inherited;
  if MultiView.HasTargetControl then
  begin
    if Opened then
    begin
      MultiView.TargetControl.BringToFront;
      ShiftPanels(0);
    end;
    FDetailAnimation.Parent := MultiView.TargetControl;
  end;
end;

procedure TMultiViewDrawerPushingPresentation.RestoreSavedStyleLookup(const AControl: TStyledControl);
begin
  if (AControl <> nil) and (AControl.StyleLookup.ToLower = PushPanelStyle) then
    AControl.StyleLookup := FSavedTargetControlStyleLookup;
end;

procedure TMultiViewDrawerPushingPresentation.UpdateSettings;
begin
  inherited;
  if MultiView.HasTargetControl then
    FDetailAnimation.Duration := MultiView.DrawerOptions.DurationSliding;
end;

procedure TMultiViewDrawerPushingPresentation.SaveStyleLookupAndUpdateStyle(const AControl: TStyledControl);
begin
  if AControl <> nil then
  begin
    FSavedTargetControlStyleLookup := AControl.StyleLookup;
    AControl.StyleLookup := PushPanelStyle
  end;
end;

procedure TMultiViewDrawerPushingPresentation.ShiftPanels(const AOffset: Single);
var
  NewLeftMargin: Single;
  NewTopMargin: Single;
begin
  if not MultiView.HasTargetControl then
    Exit;

  NewLeftMargin := 0;
  NewTopMargin := 0;
  if Opened then
  begin
    case MultiView.DrawerOptions.Placement of
      TPanelPlacement.Left:
        NewLeftMargin := MultiView.Width + AOffset;
      TPanelPlacement.Right:
        NewLeftMargin := -MultiView.Width + AOffset;
      TPanelPlacement.Top:
        NewTopMargin := MultiView.Height + AOffset;
      TPanelPlacement.Bottom:
        NewTopMargin := -MultiView.Height + AOffset;
    end;
  end
  else
  begin
    if MultiView.DrawerOptions.Placement in [TPanelPlacement.Left, TPanelPlacement.Right] then
      NewLeftMargin := AOffset
    else
      NewTopMargin := AOffset;
  end;
  MultiView.TargetControl.Margins.Left := NewLeftMargin;
  MultiView.TargetControl.Margins.Top := NewTopMargin;
  MultiView.TargetControl.Margins.Right := -MultiView.TargetControl.Margins.Left;
  MultiView.TargetControl.Margins.Bottom := -MultiView.TargetControl.Margins.Top;
end;

procedure TMultiViewDrawerPushingPresentation.DoOpen(const ASpeed: Single);
begin
  inherited;
  if MultiView.HasTargetControl then
  begin
    MultiView.TargetControl.BringToFront;
    if SameValue(ASpeed, DefaultSpeed, TEpsilon.Vector) then
      FDetailAnimation.Duration := MultiView.DrawerOptions.DurationSliding
    else
      FDetailAnimation.Duration := CalculateSlidingTime(ASpeed);
    FDetailAnimation.StartValue.Left := MultiView.TargetControl.Margins.Left;
    FDetailAnimation.StartValue.Right := MultiView.TargetControl.Margins.Right;
    FDetailAnimation.StartValue.Top := MultiView.TargetControl.Margins.Top;
    FDetailAnimation.StartValue.Bottom := MultiView.TargetControl.Margins.Bottom;

    case MultiView.DrawerOptions.Placement of
      TPanelPlacement.Left:
        begin
          FDetailAnimation.StopValue.Left := MultiView.Width;
          FDetailAnimation.StopValue.Right := -MultiView.Width;
        end;
      TPanelPlacement.Right:
        begin
          FDetailAnimation.StopValue.Left := -MultiView.Width;
          FDetailAnimation.StopValue.Right := MultiView.Width;
        end;
      TPanelPlacement.Top:
        begin
          FDetailAnimation.StopValue.Top := MultiView.Height;
          FDetailAnimation.StopValue.Bottom := -MultiView.Height;
        end;
      TPanelPlacement.Bottom:
        begin
          FDetailAnimation.StopValue.Top := -MultiView.Height;
          FDetailAnimation.StopValue.Bottom := MultiView.Height;
        end;
    end;
    FDetailAnimation.Start;
  end
  else
  begin
    DoShown;
    EndMoving;
  end;
end;

{ TMultiViewDrawerOverlapPresentation }

function TMultiViewDrawerOverlapPresentation.CalculateSlidingTime(const ASpeed: Single): Single;
var
  Distance: Single;
  Duration: Single;
begin
  Distance := 0;
  if Opened then
  begin
    case MultiView.DrawerOptions.Placement of
      TPanelPlacement.Left, TPanelPlacement.Right:
        Distance := Abs(DefineOpenedPanelPosition.X - MultiView.Position.X);
      TPanelPlacement.Top, TPanelPlacement.Bottom:
        Distance := Abs(DefineOpenedPanelPosition.Y - MultiView.Position.Y);
    end;
    Duration := Distance / Abs(ASpeed);
  end
  else
  begin
    case MultiView.DrawerOptions.Placement of
      TPanelPlacement.Left, TPanelPlacement.Right:
        Distance := Abs(DefineHiddenPanelPosition.X - MultiView.Position.X);
      TPanelPlacement.Top, TPanelPlacement.Bottom:
        Distance := Abs(DefineHiddenPanelPosition.Y - MultiView.Position.Y);
    end;
    Duration := Distance / Abs(ASpeed);
  end;
  Result := Min(Duration, MultiView.DrawerOptions.DurationSliding);
end;

function TMultiViewDrawerOverlapPresentation.DefineHiddenPanelPosition: TPointF;
begin
  case MultiView.DrawerOptions.Placement of
    TPanelPlacement.Left:
      Result := TPointF.Create(-MultiView.Width, MultiView.Position.Y);
    TPanelPlacement.Right:
      Result := TPointF.Create(GetParentWidth, MultiView.Position.Y);
    TPanelPlacement.Top:
      Result := TPointF.Create(MultiView.Position.X, -MultiView.Height);
    TPanelPlacement.Bottom:
      Result := TPointF.Create(MultiView.Position.X, GetParentHeight);
  else
    Result := TPointF.Create(-MultiView.Width, MultiView.Position.Y);
  end;
end;

function TMultiViewDrawerOverlapPresentation.DefineOpenedPanelPosition: TPointF;
begin
  case MultiView.DrawerOptions.Placement of
    TPanelPlacement.Left:
      Result := TPointF.Create(0, MultiView.Position.Y);
    TPanelPlacement.Right:
      Result := TPointF.Create(GetParentWidth - MultiView.Width, MultiView.Position.Y);
    TPanelPlacement.Top:
      Result := TPointF.Create(MultiView.Position.X, 0);
    TPanelPlacement.Bottom:
      Result := TPointF.Create(MultiView.Position.X, GetParentHeight - MultiView.Height);
  else
    Result := TPointF.Zero;
  end;
end;

procedure TMultiViewDrawerOverlapPresentation.DoClose;
begin
  inherited;
  MultiView.BringToFront;
  if SameValue(ASpeed, DefaultSpeed, TEpsilon.Vector) then
    FMasterAnimation.Duration := MultiView.DrawerOptions.DurationSliding
  else
    FMasterAnimation.Duration := CalculateSlidingTime(ASpeed);

  if MultiView.DrawerOptions.Placement in [TPanelPlacement.Left, TPanelPlacement.Right] then
  begin
    FMasterAnimation.StartValue := MultiView.Position.X;
    FMasterAnimation.StopValue := DefineHiddenPanelPosition.X;
  end
  else
  begin
    FMasterAnimation.StartValue := MultiView.Position.Y;
    FMasterAnimation.StopValue := DefineHiddenPanelPosition.Y;
  end;
  FMasterAnimation.Start;
end;

procedure TMultiViewDrawerOverlapPresentation.DoMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Single);
begin
  inherited;
  if MultiView.DrawerOptions.Mode = TSlidingMode.OverlapDetailView then
    MultiView.BringToFront;
end;

procedure TMultiViewDrawerOverlapPresentation.ShiftPanels(const AOffset: Single);
var
  Offset: TPointF;
begin
  if MultiView.DrawerOptions.Placement in [TPanelPlacement.Left, TPanelPlacement.Right] then
    Offset := TPointF.Create(AOffset, 0)
  else
    Offset := TPointF.Create(0, AOffset);

  if Opened then
    MultiView.Position.Point := DefineOpenedPanelPosition + Offset
  else
    MultiView.Position.Point := DefineHiddenPanelPosition + Offset;
end;

procedure TMultiViewDrawerOverlapPresentation.UpdateSettings;
begin
  inherited;
  if MultiView.DrawerOptions.Placement in [TPanelPlacement.Left, TPanelPlacement.Right] then
    FMasterAnimation.PropertyName := 'position.x' // do not localize
  else
    FMasterAnimation.PropertyName := 'position.y'; // do not localize
end;

procedure TMultiViewDrawerOverlapPresentation.DoOpen;
begin
  inherited;
  MultiView.BringToFront;
  if SameValue(ASpeed, DefaultSpeed, TEpsilon.Vector) then
    FMasterAnimation.Duration := MultiView.DrawerOptions.DurationSliding
  else
    FMasterAnimation.Duration := CalculateSlidingTime(ASpeed);
  if MultiView.DrawerOptions.Placement in [TPanelPlacement.Left, TPanelPlacement.Right] then
  begin
    FMasterAnimation.StartValue := MultiView.Position.X;
    FMasterAnimation.StopValue := DefineOpenedPanelPosition.X;
  end
  else
  begin
    FMasterAnimation.StartValue := MultiView.Position.Y;
    FMasterAnimation.StopValue := DefineOpenedPanelPosition.Y;
  end;
  FMasterAnimation.Start;
end;

function TMultiViewDrawerOverlapPresentation.GetDisplayName: string;
begin
  Result := SOverlapDrawer;
end;

function TMultiViewDrawerOverlapPresentation.NeedHidePanel(const ASpeed: Single): Boolean;
begin
  Result := True;
  if Abs(ASpeed) < MinimalSpeedThreshold then
  begin
    case MultiView.DrawerOptions.Placement of
      TPanelPlacement.Left:
        Result := MultiView.Position.X < - MultiView.Width * (1 - HidingThreshold);
      TPanelPlacement.Right:
        Result := MultiView.Position.X > GetParentWidth - MultiView.Width * HidingThreshold;
      TPanelPlacement.Top:
        Result := MultiView.Position.Y < - MultiView.Height * (1 - HidingThreshold);
      TPanelPlacement.Bottom:
        Result := MultiView.Position.Y > GetParentHeight - MultiView.Height * HidingThreshold;
    end;
  end
  else
    case MultiView.DrawerOptions.Placement of
      TPanelPlacement.Left, TPanelPlacement.Top:
        Result := ASpeed < 0;
      TPanelPlacement.Right, TPanelPlacement.Bottom:
        Result := ASpeed > 0;
    end;
end;

procedure TMultiViewDrawerOverlapPresentation.Realign;
begin
  inherited;
  MultiView.BringToFront;
end;

{ TMultiViewBaseBorderedPresentation }

constructor TMultiViewBaseBorderedPresentation.Create(AMultiView: TCustomMultiView);
begin
  inherited;
  { Border Line }
  FBorderLine := TSeparatorLine.Create(nil);
  FBorderLine.Stored := False;
  FBorderLine.Lock;
  FBorderLine.Width := 1;
  FBorderLine.HitTest := False;
  FBorderLine.Align := TAlignLayout.Contents;
end;

destructor TMultiViewBaseBorderedPresentation.Destroy;
begin
  inherited;
  FreeAndNil(FBorderLine);
end;

procedure TMultiViewBaseBorderedPresentation.DoInstall;
begin
  FSavedSize := MultiView.Size.Size;
  FSavedAlign := MultiView.Align;

  inherited;

  FBorderLine.Parent := MultiView;
  UpdateStyle;
end;

procedure TMultiViewBaseBorderedPresentation.DoUninstall;

  function IsOrientationChanged(const AOldAlign, ANewAlign: TAlignLayout): Boolean;
  begin
    Result := (IsHorizontalAlign(AOldAlign) or (AOldAlign = TAlignLayout.None)) and IsVerticalAlign(ANewAlign) or
      IsVerticalAlign(AOldAlign) and IsHorizontalAlign(ANewAlign);
  end;

var
  SizeTmp: TSizeF;
begin
  if not (csDestroying in MultiView.ComponentState) then
  begin
    if IsOrientationChanged(FSavedAlign, MultiView.Align) then
      SizeTmp := FSavedSize.SwapDimensions
    else
      SizeTmp := FSavedSize;

    MultiView.Align := FSavedAlign;
    MultiView.Size.Size := SizeTmp;
  end;

  FBorderLine.Parent := nil;
  inherited;
end;

function TMultiViewBaseBorderedPresentation.IsHorizontalAlign(const AAlign: TAlignLayout): Boolean;
begin
  Result := AAlign in [TAlignLayout.Left, TAlignLayout.Right, TAlignLayout.Vertical, TAlignLayout.VertCenter];
end;

function TMultiViewBaseBorderedPresentation.IsVerticalAlign(const AAlign: TAlignLayout): Boolean;
begin
  Result := AAlign in [TAlignLayout.Top, TAlignLayout.Bottom, TAlignLayout.Horizontal, TAlignLayout.HorzCenter];
end;

procedure TMultiViewBaseBorderedPresentation.Realign;
begin
  inherited;
  if not IsInternalRealign and Opened then
    FSavedSize := MultiView.Size.Size;
end;

procedure TMultiViewBaseBorderedPresentation.SetExpandedSize(const Value: TSizeF);
begin
  inherited;
  FSavedSize := Value;
end;

procedure TMultiViewBaseBorderedPresentation.UpdateSettings;
begin
  inherited;
  if MultiView.BorderOptions.Color = TAlphaColorRec.Null then
    UpdateStyle
  else
    BorderLine.Stroke.Color := MultiView.BorderOptions.Color;
  BorderLine.Visible := MultiView.BorderOptions.Visible;
end;

procedure TMultiViewBaseBorderedPresentation.UpdateStyle;
var
  LineBrush: TBrushObject;
begin
  inherited;
  if (MultiView.BorderOptions.Color = TAlphaColorRec.Null) and  MultiView.FindStyleResource<TBrushObject>('dropline', LineBrush) then
    FBorderLine.Stroke.Assign(LineBrush.Brush);
end;

{ TMultiViewBaseBorderWithOverlayPresentation }

constructor TMultiViewBaseBorderWithOverlayPresentation.Create(AMultiView: TCustomMultiView);
begin
  inherited;
  TMessageManager.DefaultManager.SubscribeToMessage(TFormReleasedMessage, FormReleased);

  FDetailOverlay := TTouchInterceptingLayout.Create(nil);
  FDetailOverlay.Stored := False;
  FDetailOverlay.Mode := DefineDetailOverlayMode;
  FDetailOverlay.EnabledShadow := MultiView.ShadowOptions.Enabled;
  FDetailOverlay.Color := MultiView.ShadowOptions.Color;
  FDetailOverlay.Opacity := MultiView.ShadowOptions.Opacity;
  FDetailOverlay.Align := TAlignLayout.Contents;
  FDetailOverlay.Lock;
  FDetailOverlay.ControlType := MultiView.ControlType;

  // Animation Detail overlay shadow opacity
  FShadowAnimation := TFloatAnimation.Create(nil);
  FShadowAnimation.Parent := FDetailOverlay;
  FShadowAnimation.Stored := False;
  FShadowAnimation.PropertyName := 'opacity';
  FShadowAnimation.Duration := MultiView.DrawerOptions.DurationSliding;
end;

function TMultiViewBaseBorderWithOverlayPresentation.DefineDetailOverlayMode: TOverlayMode;
begin
  if Opened then
    Result := TOverlayMode.AllLocalArea
  else
    Result := MultiView.DrawerOptions.Placement.ToOverlayMode;
end;

destructor TMultiViewBaseBorderWithOverlayPresentation.Destroy;
begin
  inherited;
  TMessageManager.DefaultManager.Unsubscribe(TFormReleasedMessage, FormReleased);
  FreeAndNil(FDetailOverlay);
end;

procedure TMultiViewBaseBorderWithOverlayPresentation.DoClose(const ASpeed: Single);
begin
  inherited;

  if not (TPresentationState.Moving in State) then
    DoStartHiding;

  FDetailOverlay.Mode := DefineDetailOverlayMode;
  if MultiView.ShadowOptions.Enabled then
  begin
    FShadowAnimation.StartValue := FDetailOverlay.Opacity;
    FShadowAnimation.StopValue := 0;
    FShadowAnimation.Start;
  end;
end;

procedure TMultiViewBaseBorderWithOverlayPresentation.DoInstall;
begin
  inherited;
  FDetailOverlay.Enabled := MultiView.Enabled;
  UpdateDetailOverlayParent(MultiView.TargetControl);
end;

procedure TMultiViewBaseBorderWithOverlayPresentation.DoOpen(const ASpeed: Single);
begin
  if MultiView.ShadowOptions.Enabled then
  begin
    FShadowAnimation.Duration := MultiView.DrawerOptions.DurationSliding;
    FShadowAnimation.StartValue := FDetailOverlay.Opacity;
    FShadowAnimation.StopValue := MultiView.ShadowOptions.Opacity;
  end;

  inherited;

  if not (TPresentationState.Moving in State) then
    DoStartShowing;

  ResetFocus;

  FDetailOverlay.Mode := TOverlayMode.AllLocalArea;
  FDetailOverlay.BringToFront;

  if MultiView.ShadowOptions.Enabled then
    FShadowAnimation.Start;
end;

procedure TMultiViewBaseBorderWithOverlayPresentation.DoUninstall;
begin
  UnlinkDetailOverlayFromParent;
  inherited;
end;

procedure TMultiViewBaseBorderWithOverlayPresentation.EnabledChanged;
begin
  inherited;
  FDetailOverlay.Enabled := MultiView.Enabled;
end;

procedure TMultiViewBaseBorderWithOverlayPresentation.UpdateDetailOverlayParent(const ATargetControl: TControl);
var
  NewParent: TFmxObject;
begin
  if (ATargetControl <> nil) and not (csDestroying in MultiView.TargetControl.ComponentState) then
    NewParent := ATargetControl
  else if (MultiView.ParentControl <> nil) and not (csDestroying in MultiView.ParentControl.ComponentState) then
    NewParent := MultiView.ParentControl
  else if not (csDestroying in MultiView.ComponentState) then
    NewParent := MultiView.Parent
  else 
    NewParent := nil;

  UnlinkDetailOverlayFromParent;
  if NewParent <> nil then
  begin
    LinkDetailOverlayToParent(NewParent);
    FDetailOverlay.BringToFront;
  end;
end;

procedure TMultiViewBaseBorderWithOverlayPresentation.FormReleased(const Sender: TObject; const M: TMessage);
begin
  if Sender = FDetailOverlay.Parent then
    UnlinkDetailOverlayFromParent;
end;

procedure TMultiViewBaseBorderWithOverlayPresentation.FreeNotification(AObject: TObject);
begin
  if AObject = FDetailOverlay.Parent then
    UnlinkDetailOverlayFromParent;
end;

procedure TMultiViewBaseBorderWithOverlayPresentation.LinkDetailOverlayToParent(const AParent: TFmxObject);
begin
  if FDetailOverlay.Parent <> AParent then
  begin
    if FDetailOverlay.Parent <> nil then
      FDetailOverlay.Parent.RemoveFreeNotify(Self);

    FDetailOverlay.Parent := AParent;
    FDetailOverlay.Parent.AddFreeNotify(Self);
  end;
end;

procedure TMultiViewBaseBorderWithOverlayPresentation.ParentChanged;
begin
  inherited;
  UpdateDetailOverlayParent(MultiView.TargetControl);
end;

procedure TMultiViewBaseBorderWithOverlayPresentation.ResetFocus;
var
  PickerService: IFMXPickerService;
begin
  if (MultiView.Root <> nil) and (MultiView.Root.Focused <> nil) then
  begin
    MultiView.Root.Focused := nil;
    if TPlatformServices.Current.SupportsPlatformService(IFMXPickerService, PickerService) then
      PickerService.CloseAllPickers;
  end;
end;

procedure TMultiViewBaseBorderWithOverlayPresentation.TargetControlChanging(AOldControl, ANewControl: TControl);
begin
  inherited;
  if ANewControl = nil then
    UpdateDetailOverlayParent(ANewControl)
  else
  begin
    ANewControl.Align := TAlignLayout.Client;
    LinkDetailOverlayToParent(ANewControl);
    FDetailOverlay.BringToFront;
  end;
end;

procedure TMultiViewBaseBorderWithOverlayPresentation.UnlinkDetailOverlayFromParent;
begin
  if FDetailOverlay.Parent <> nil then
    FDetailOverlay.Parent.RemoveFreeNotify(Self);
  FDetailOverlay.Parent := nil;
end;

procedure TMultiViewBaseBorderWithOverlayPresentation.UpdateSettings;

  function DefineShadowOpacity: Single;
  begin
    if not Opened then
      Result := 0
    else
      Result := MultiView.ShadowOptions.Opacity;
  end;

begin
  inherited;
  FDetailOverlay.Opacity := DefineShadowOpacity;
  FDetailOverlay.EnabledShadow := MultiView.ShadowOptions.Enabled;
  FDetailOverlay.Color := MultiView.ShadowOptions.Color;
  FDetailOverlay.InterceptionSize := MultiView.DrawerOptions.TouchAreaSize;
  FShadowAnimation.Duration := MultiView.DrawerOptions.DurationSliding;
end;

{ TMultiViewNavigationPanePresentation }

constructor TMultiViewNavigationPanePresentation.Create(AMultiView: TCustomMultiView);
begin
  inherited;
  FBorderLine.LineType := TLineType.Right;

  DetailOverlay.OnClick := OverlayClickHandler;

  // Animation of moving Master panel
  FMasterAnimation := TFloatAnimation.Create(nil);
  FMasterAnimation.Parent := MultiView;
  FMasterAnimation.Stored := False;
  FMasterAnimation.PropertyName := 'Width'; // do not localize
  FMasterAnimation.Interpolation := TInterpolationType.Quartic;
  FMasterAnimation.AnimationType := TAnimationType.Out;
  FMasterAnimation.Duration := MultiView.DrawerOptions.DurationSliding;
  FMasterAnimation.OnFinish := AnimationFinishedHandler;
end;

function TMultiViewNavigationPanePresentation.DefineDetailOverlayMode: TOverlayMode;
begin
  if Opened then
    Result := TOverlayMode.AllLocalArea
  else
    Result := TOverlayMode.None;
end;

destructor TMultiViewNavigationPanePresentation.Destroy;
begin
  inherited;
  FreeAndNil(FMasterAnimation);
end;

procedure TMultiViewNavigationPanePresentation.AnimationFinishedHandler(Sender: TObject);
begin
  EndMoving;
  if Opened then
    DoShown
  else
    DoHidden;
end;

procedure TMultiViewNavigationPanePresentation.OverlayClickHandler(Sender: TObject);
begin
  Close;
end;

procedure TMultiViewNavigationPanePresentation.DoInstall;
begin
  inherited;
  MultiView.Align := TAlignLayout.Vertical;
  MultiView.Visible := True;
  if MultiView.HasTargetControl then
    MultiView.TargetControl.Margins.Left := MultiView.NavigationPaneOptions.CollapsedWidth;
  RecalculateWidth;
end;

procedure TMultiViewNavigationPanePresentation.DoOpen(const ASpeed: Single);
begin
  inherited;
  MultiView.BringToFront;
  FMasterAnimation.Duration := MultiView.DrawerOptions.DurationSliding;
  FMasterAnimation.StartValue := MultiView.NavigationPaneOptions.CollapsedWidth;
  FMasterAnimation.StopValue := FSavedSize.Width;
  FMasterAnimation.Start;
end;

procedure TMultiViewNavigationPanePresentation.DoClose(const ASpeed: Single);
begin
  if MultiView.ShadowOptions.Enabled then
    ShadowAnimation.Duration := MultiView.DrawerOptions.DurationSliding * CloseSpeedReduction;

  inherited;

  MultiView.BringToFront;
  FMasterAnimation.Duration := MultiView.DrawerOptions.DurationSliding * CloseSpeedReduction;
  FMasterAnimation.StartValue := MultiView.Width;
  FMasterAnimation.StopValue := MultiView.NavigationPaneOptions.CollapsedWidth;
  FMasterAnimation.Start;
end;

procedure TMultiViewNavigationPanePresentation.DoUninstall;
begin
  FMasterAnimation.Parent := nil;
  if MultiView.HasTargetControl then
    MultiView.TargetControl.Margins.Left := 0;
  inherited;
end;

function TMultiViewNavigationPanePresentation.GetDisplayName: string;
begin
  Result := SNavigationPane;
end;

function TMultiViewNavigationPanePresentation.GetCollapsedSize: TSizeF;
begin
  Result := TSizeF.Create(MultiView.NavigationPaneOptions.CollapsedWidth, MultiView.Height);
end;

function TMultiViewNavigationPanePresentation.GetExpandedSize: TSizeF;
begin
  Result := FSavedSize;
end;

function TMultiViewNavigationPanePresentation.NeedHideInDesignTime: Boolean;
begin
  Result := False;
end;

procedure TMultiViewNavigationPanePresentation.Realign;
begin
  inherited;
  // Refreshes collapsed width, if user change size of TMultiView in DesignTime
  if (csDesigning in MultiView.ComponentState) and (State = [TPresentationState.Installed]) then
  begin
    MultiView.NavigationPaneOptions.CollapsedWidth := Min(MultiView.Width, ExpandedSize.Width);
    if ExpandedSize.Width <= CollapsedSize.Width then
      MultiView.Width := ExpandedSize.Width;
  end;
  // Updates position, because user can drag multiview in design time
  MultiView.Position.Point := TPointF.Create(0, MultiView.Position.Y);
  // If user change width of MultiView in design time we need to update original saved size of MultiView
  // for correct restoring, when mutiview will unload this presentation.
  if Opened then
    FSavedSize.Width := MultiView.Width;
  if MultiView.HasMasterButton then
    MultiView.MasterButton.Visible := True;
  MultiView.BringToFront;
end;

procedure TMultiViewNavigationPanePresentation.RecalculateWidth;
begin
  if Opened then
    MultiView.Width := FSavedSize.Width
  else
    MultiView.Width := MultiView.NavigationPaneOptions.CollapsedWidth;
end;

procedure TMultiViewNavigationPanePresentation.ResetFocus;
var
  PickerService: IFMXPickerService;
begin
  if (MultiView.Root <> nil) and (MultiView.Root.Focused <> nil) then
  begin
    MultiView.Root.Focused := nil;
    if TPlatformServices.Current.SupportsPlatformService(IFMXPickerService, PickerService) then
      PickerService.CloseAllPickers;
  end;
end;

procedure TMultiViewNavigationPanePresentation.SetExpandedSize(const Value: TSizeF);
begin
  inherited;
  FSavedSize := Value;
end;

procedure TMultiViewNavigationPanePresentation.TargetControlChanging(AOldControl, ANewControl: TControl);
begin
  inherited;
  if ANewControl = nil then
    AOldControl.Margins.Left := 0
  else
  begin
    FDetailOverlay.Opacity := 0;
    ANewControl.Margins.Left := MultiView.NavigationPaneOptions.CollapsedWidth;
  end;
  if Opened then
    MultiView.BringToFront;
end;

procedure TMultiViewNavigationPanePresentation.UpdateSettings;
begin
  inherited;
  RecalculateWidth;
  if MultiView.HasTargetControl then
    MultiView.TargetControl.Margins.Left := MultiView.NavigationPaneOptions.CollapsedWidth;
end;

{ TPanelPlacementHelper }

function TPanelPlacementHelper.ToLineType: TLineType;
begin
  case Self of
    TPanelPlacement.Left:
      Result := TLineType.Right;
    TPanelPlacement.Right:
      Result := TLineType.Left;
    TPanelPlacement.Top:
      Result := TLineType.Bottom;
    TPanelPlacement.Bottom:
      Result := TLineType.Top;
  else
    Result := TLineType.Left;
  end;
end;

function TPanelPlacementHelper.ToOverlayMode: TOverlayMode;
begin
  case Self of
    TPanelPlacement.Left:
      Result := TOverlayMode.LeftSide;
    TPanelPlacement.Right:
      Result := TOverlayMode.RightSide;
    TPanelPlacement.Top:
      Result := TOverlayMode.TopSide;
    TPanelPlacement.Bottom:
      Result := TOverlayMode.BottomSide;
  else
    Result := TOverlayMode.LeftSide;
  end;
end;

end.
