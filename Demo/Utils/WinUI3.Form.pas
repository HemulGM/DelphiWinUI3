unit WinUI3.Form;

interface

uses
  System.SysUtils, System.Classes, System.Types, FMX.Edit, FMX.Controls,
  System.UITypes, FMX.Memo, FMX.StdCtrls, FMX.Graphics, FMX.Forms, FMX.Types,
  FMX.Ani, FMX.ActnList;

type
  TPopup = class(FMX.Controls.TPopup)
  end;

  TWinUIForm = class(TForm)
  protected
    function NotInitStyle: Boolean; virtual;
    procedure PaintRects(const UpdateRects: array of TRectF); override;
    procedure CreateHandle; override;
  private
    FModeFocus: Boolean;
    FPopupHint: TPopup;
    FTimerHintClose: TTimer;
    FTimerHint: TTimer;
    FLabelHint: TLabel;
    FFloatAnimationHint: TFloatAnimation;
    procedure FloatAnimationHintProcess(Sender: TObject);
    procedure TimerHintCloseTimer(Sender: TObject);
    procedure TimerHintTimer(Sender: TObject);
    procedure FOnAppHint(Sender: TObject);
  public
    procedure AfterConstruction; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; AFormX, AFormY: Single); override;
    procedure KeyDown(var Key: Word; var KeyChar: System.WideChar; Shift: TShiftState); override;
    procedure HookHints;
    constructor Create(AOwner: TComponent); override;
    procedure BeginLauncher(Proc: TProc = nil);
    procedure EndLauncher(Proc: TProc = nil);
  end;

implementation

uses
  FMX.Menus, FMX.Platform, DelphiWindowStyle.FMX;

procedure TWinUIForm.AfterConstruction;
begin
  inherited;
  if @Application.OnHint = nil then
    HookHints;
end;

constructor TWinUIForm.Create(AOwner: TComponent);
begin
  inherited;
  TAnimation.AniFrameRate := 120;
  if not NotInitStyle then
  begin
    SetWindowColorMode(True);
    if SetSystemBackdropType(TSystemBackdropType.DWMSBT_MAINWINDOW) then
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
  if SetSystemBackdropType(TSystemBackdropType.DWMSBT_MAINWINDOW) then
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
  inherited;
  if FModeFocus and Assigned(Focused) then
  begin
    if (Focused is TControl) and not (Focused is TCustomEdit) and not (Focused is TCustomMemo) then
    begin
      Canvas.BeginScene;
      try
        Canvas.Stroke.Kind := TBrushKind.Solid;
        Canvas.Stroke.Color := TAlphaColorRec.White;
        Canvas.Stroke.Thickness := 2;
        var R := TControl(Focused).AbsoluteRect;
        R.Inflate(2, 2);
        Canvas.DrawRect(R, 3, 3, AllCorners, 1);
      finally
        Canvas.EndScene;
      end;
    end;
  end;
end;

end.

