unit WinUI.MultiView.CustomPresentation;

interface

uses
  System.Messaging, System.UITypes, System.Classes, FMX.MultiView,
  FMX.MultiView.Presentations, FMX.MultiView.Types, FMX.StdCtrls, FMX.Ani,
  FMX.Controls;

type
  TMultiViewWinUIPresentation = class(TMultiViewPresentation)
  private
    FDetailOverlay: TTouchInterceptingLayout;
    FFrame: TPanel;
    procedure DoFormReleased(const Sender: TObject; const M: TMessage);
  protected
    function GetDisplayName: string; override;
    procedure DoOpen(const ASpeed: Single); override;
    procedure DoClose(const ASpeed: Single); override;
    procedure DoInstall; override;
    procedure DoUninstall; override;
    procedure DoMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X: Single; Y: Single); virtual;
  public
    constructor Create(AMultiView: TCustomMultiView); override;
    destructor Destroy; override;
    procedure UpdateSettings; override;
    procedure Realign; override;
  end;

implementation

uses
  FMX.Types, FMX.Forms, System.Types, FMX.Consts, System.Math,
  System.Math.Vectors, FMX.Pickers, FMX.Platform;

{ TMultiViewWinUIPresentation }

constructor TMultiViewWinUIPresentation.Create(AMultiView: TCustomMultiView);
begin
  inherited;
  TMessageManager.DefaultManager.SubscribeToMessage(TFormReleasedMessage, DoFormReleased);

  // Detail overlay layer for catching mouse events
  FDetailOverlay := TTouchInterceptingLayout.Create(nil);
  FDetailOverlay.Stored := False;
  FDetailOverlay.Mode := TOverlayMode.AllLocalArea;
  FDetailOverlay.EnabledShadow := MultiView.ShadowOptions.Enabled;
  FDetailOverlay.Color := MultiView.ShadowOptions.Color;
  FDetailOverlay.Opacity := 0;
  FDetailOverlay.Align := TAlignLayout.Contents;
  FDetailOverlay.Lock;
  FDetailOverlay.Visible := False;
  FDetailOverlay.OnMouseDown := DoMouseDown;

  FFrame := TPanel.Create(nil);
  FFrame.Padding.Rect := TRectF.Create(1, 1, 1, 1);
  FFrame.StyleLookup := 'multiviewstyle';
  FFrame.StylesData['bg_layer.Opacity'] := 1.0;
end;

destructor TMultiViewWinUIPresentation.Destroy;
begin
  inherited;
  TMessageManager.DefaultManager.Unsubscribe(TFormReleasedMessage, DoFormReleased);

  FDetailOverlay.Free;
  FFrame.Free;
end;

procedure TMultiViewWinUIPresentation.DoClose(const ASpeed: Single);
begin
  inherited;
  FFrame.Parent := nil;
  FDetailOverlay.Visible := False;
  MultiView.MasterContent.Parent := MultiView;
end;

procedure TMultiViewWinUIPresentation.DoFormReleased(const Sender: TObject; const M: TMessage);
begin
  if Sender = FDetailOverlay.Parent then
    FDetailOverlay.Parent := nil;
  if Sender = FFrame.Parent then
    FFrame.Parent := nil;
end;

procedure TMultiViewWinUIPresentation.DoInstall;
begin
  inherited;
  MultiView.Visible := False;
  MultiView.Align := TAlignLayout.None;
  if MultiView.Scene <> nil then
    FDetailOverlay.Parent := (MultiView.Scene.GetObject as TCommonCustomForm);
  if MultiView.HasMasterButton then
    MultiView.MasterButton.Visible := True;
end;

procedure TMultiViewWinUIPresentation.DoMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  Close;
end;

procedure TMultiViewWinUIPresentation.DoOpen(const ASpeed: Single);
var
  SceneForm: TCommonCustomForm;
begin
  inherited;
  FDetailOverlay.Opacity := 0;
  // Install content into Alert Panel
  FFrame.Opacity := 0;
  FFrame.Width := MultiView.Width;
  FFrame.Height := MultiView.PopoverOptions.PopupHeight;
  if MultiView.Scene <> nil then
  begin
    SceneForm := MultiView.Scene.GetObject as TCommonCustomForm;
    FFrame.Parent := SceneForm;
    FFrame.BringToFront;
    FFrame.Height := Min(MultiView.PopoverOptions.PopupHeight, SceneForm.ClientHeight);
    FFrame.Width := Min(MultiView.Width, SceneForm.ClientWidth);
    FFrame.Position.Point := TPointF.Create(SceneForm.ClientWidth / 2 - FFrame.Width / 2, SceneForm.ClientHeight / 2 - FFrame.Height / 2)
  end;
  MultiView.MasterContent.Parent := FFrame;
  FDetailOverlay.Visible := True;
  TAnimator.AnimateFloat(FDetailOverlay, 'opacity', MultiView.ShadowOptions.Opacity, MultiView.DrawerOptions.DurationSliding);
  TAnimator.AnimateFloat(FFrame, 'opacity', 1, MultiView.DrawerOptions.DurationSliding);
end;

procedure TMultiViewWinUIPresentation.DoUninstall;
begin
  MultiView.Visible := True;
  FDetailOverlay.Parent := nil;
  inherited;
end;

function TMultiViewWinUIPresentation.GetDisplayName: string;
begin
  Result := 'WinUI Multiview';
end;

procedure TMultiViewWinUIPresentation.Realign;
var
  SceneForm: TCommonCustomForm;
begin
  inherited;
  if MultiView.Scene <> nil then
  begin
    SceneForm := MultiView.Scene.GetObject as TCommonCustomForm;
    FFrame.Height := Min(MultiView.PopoverOptions.PopupHeight, SceneForm.ClientHeight);
    FFrame.Width := Min(MultiView.Width, SceneForm.ClientWidth);
    FFrame.Position.Point := TPointF.Create(SceneForm.ClientWidth / 2 - FFrame.Width / 2, SceneForm.ClientHeight / 2 - FFrame.Height / 2)
  end;
end;

procedure TMultiViewWinUIPresentation.UpdateSettings;
begin
  inherited;
  if not Opened then
    FDetailOverlay.Opacity := 0
  else
    FDetailOverlay.Opacity := MultiView.ShadowOptions.Opacity;
  FDetailOverlay.EnabledShadow := MultiView.ShadowOptions.Enabled;
  FDetailOverlay.Color := MultiView.ShadowOptions.Color;
end;

end.

