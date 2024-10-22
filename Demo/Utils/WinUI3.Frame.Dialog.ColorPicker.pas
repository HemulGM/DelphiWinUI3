unit WinUI3.Frame.Dialog.ColorPicker;

interface

uses
  System.SysUtils,
  {$IFDEF MSWINDOWS}
  Winapi.Windows,
  {$ENDIF}
  System.Types, System.UITypes, System.Classes, System.Variants, FMX.Types,
  FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, FMX.Edit,
  FMX.ListBox, FMX.Colors, FMX.Controls.Presentation, FMX.Objects;

type
  TDialogColorParams = record
  private
    FTitle: string;
    FColor: TAlphaColor;
    FCheckText: string;
    FCheckValue: Boolean;
    FButtons: TArray<string>;
    FFrameColor: TColor;
    FCanClose: Boolean;
    FAccentId: Integer;
    FDefaultId: Integer;
    FAlpha: Boolean;
  public
    property Title: string read FTitle write FTitle;
    property Color: TAlphaColor read FColor write FColor;
    property CheckText: string read FCheckText write FCheckText;
    property CheckValue: Boolean read FCheckValue write FCheckValue;
    property Buttons: TArray<string> read FButtons write FButtons;
    property AccentId: Integer read FAccentId write FAccentId;
    property DefaultId: Integer read FDefaultId write FDefaultId;
    property CanClose: Boolean read FCanClose write FCanClose;
    property FrameColor: TColor read FFrameColor write FFrameColor;
    property Alpha: Boolean read FAlpha write FAlpha;
  end;

  TDialogColorResult = record
    Result: Integer;
    Color: TAlphaColor;
    IsChecked: Boolean;
  end;

  TBWTrackBar = class(TBitmapTrackBar)
  private
    FInputColor: TAlphaColor;
    procedure SetInputColor(const Value: TAlphaColor);
  protected
    procedure FillBitmap; override;
    property InputColor: TAlphaColor read FInputColor write SetInputColor;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TAlphaTrackBar = class(TBitmapTrackBar)
  private
    FInputColor: TAlphaColor;
    procedure SetInputColor(const Value: TAlphaColor);
  protected
    procedure FillBitmap; override;
    property InputColor: TAlphaColor read FInputColor write SetInputColor;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TFrameDialogColorPicker = class(TFrame)
    AlphaTrackBar: TAlphaTrackBar;
    BWTrackBar: TBWTrackBar;
    ComboBoxType: TComboBox;
    EditHEX: TEdit;
    EditR: TEdit;
    EditG: TEdit;
    EditB: TEdit;
    EditA: TEdit;
    RectangleBox: TRectangle;
    CircleBoxPoint: TCircle;
    RectangleColor: TRectangle;
    RectangleTransparent: TRectangle;
    LabelR: TLabel;
    LabelG: TLabel;
    LabelB: TLabel;
    LabelA: TLabel;
    procedure RectangleBoxMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure RectangleBoxMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure RectangleBoxMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
    procedure BWTrackBarChange(Sender: TObject);
    procedure AlphaTrackBarChange(Sender: TObject);
    procedure ComboBoxTypeChange(Sender: TObject);
    procedure EditHEXChange(Sender: TObject);
    procedure EditAChange(Sender: TObject);
    procedure EditAKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
  private
    FBitmap: TBitmap;
    FRawColor: TAlphaColor;
    procedure FOnBoxKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure SetColor(const Value: TAlphaColor);
    function GetColor: TAlphaColor;
    procedure FindColor(Color: TAlphaColor);
    procedure UpdateBoxColor(Point: TPointF);
    procedure UpdateResultColor;
  public
    procedure Fill(Data: TDialogColorParams);
    property Color: TAlphaColor read GetColor write SetColor;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

uses
  HGM.ColorUtils, System.Math, System.UIConsts;

{$R *.fmx}

function ChangeHSVValue(Color: TAlphaColor; Value: Double): TAlphaColor;
begin
  var R, G, B: Byte;
  var TmpColor := TAlphaColorF.Create(Color);
  R := Trunc(TmpColor.R * 255);
  G := Trunc(TmpColor.G * 255);
  B := Trunc(TmpColor.B * 255);

  var H, S, V: Double;
  RGBToHSV(R, G, B, H, S, V);
  HSVToRGB(H, S, Value, R, G, B);
  Result := MakeColor(R, G, B);
end;

function ChangeAlpha(Color: TAlphaColor; Alpha: Byte): TAlphaColor;
begin
  var Rec := TAlphaColorRec.Create(Color);
  Rec.A := Alpha;
  Result := Rec.Color;
end;

{ TFrameDialogColorPicker }

procedure TFrameDialogColorPicker.AlphaTrackBarChange(Sender: TObject);
begin
  UpdateResultColor;
end;

procedure TFrameDialogColorPicker.BWTrackBarChange(Sender: TObject);
begin
  UpdateResultColor;
end;

procedure TFrameDialogColorPicker.UpdateResultColor;
begin
  BeginUpdate;
  try
    var Color := ChangeHSVValue(FRawColor, BWTrackBar.Value);
    Color := ChangeAlpha(Color, Trunc(AlphaTrackBar.Value));

    RectangleColor.Fill.Color := Color;

    var Rec := TAlphaColorRec.Create(Color);
    case ComboBoxType.ItemIndex of
      0:
        begin
          EditR.Text := Rec.R.ToString;
          EditG.Text := Rec.G.ToString;
          EditB.Text := Rec.B.ToString;
          LabelR.Text := 'R';
          LabelG.Text := 'G';
          LabelB.Text := 'B';
        end;
      1:
        begin
          var H, S, V: Double;
          RGBToHSV(Rec.R, Rec.G, Rec.B, H, S, V);
          EditR.Text := Trunc(H * 360).ToString;
          EditG.Text := Trunc(S * 100).ToString;
          EditB.Text := Trunc(V * 100).ToString;
          LabelR.Text := 'H';
          LabelG.Text := 'S';
          LabelB.Text := 'V';
        end;
    end;
    EditHEX.Text := '#' + IntToHex(Color, 8);
    EditA.Text := Rec.A.ToString;
    BWTrackBar.InputColor := FRawColor;
    BWTrackBar.UpdateBitmap;
    AlphaTrackBar.InputColor := FRawColor;
    AlphaTrackBar.UpdateBitmap;
  finally
    EndUpdate;
  end;
end;

procedure TFrameDialogColorPicker.ComboBoxTypeChange(Sender: TObject);
begin
  UpdateResultColor;
end;

constructor TFrameDialogColorPicker.Create(AOwner: TComponent);
begin
  inherited;
  RectangleBox.AutoCapture := True;
  RectangleBox.CanFocus := True;
  RectangleBox.TabStop := True;
  RectangleBox.OnKeyDown := FOnBoxKeyDown;
  RectangleBox.TabOrder := 8;
  FBitmap := TBitmap.Create(Trunc(RectangleBox.Width), Trunc(RectangleBox.Height));

  var Bits: TBitmapData;
  if FBitmap.Map(TMapAccess.Write, Bits) then
  try
    for var X := 0 to Bits.Width - 1 do
      for var Y := 0 to Bits.Height - 1 do
      begin
        var Hue := (((100 / (Bits.Width - 1)) * X) / 100);
        var Sat := 100 - (100 / (Bits.Height - 1)) * Y;
        var R, G, B: Byte;
        //if X = Bits.Width - 1 then
        //  Sleep(1);
        HSVToRGB(Hue, Sat / 100, 1, R, G, B);
        var Color: TAlphaColor := TAlphaColorF.Create(R / 255, G / 255, B / 255, 1).ToAlphaColor;
        Bits.SetPixel(X, Y, Color);
      end;
  finally
    FBitmap.Unmap(Bits);
  end;

  RectangleBox.Fill.Bitmap.Bitmap := FBitmap;
  var Transp := TBitmap.Create(Trunc(RectangleTransparent.Width), Trunc(RectangleTransparent.Height));
  try
    if Transp.Map(TMapAccess.Write, Bits) then
    try
      for var Y := 0 to Transp.Height - 1 do
      begin
        for var X := 0 to Transp.Width - 1 do
        begin
          if Odd(X div 3) and not Odd(Y div 3) then
            Bits.SetPixel(X, Y, $FFA0A0A0)
          else if not Odd(X div 3) and Odd(Y div 3) then
            Bits.SetPixel(X, Y, $FFA0A0A0)
          else
            Bits.SetPixel(X, Y, $FFFFFFFF)
        end;
      end;
    finally
      Transp.Unmap(Bits);
    end;
  finally
    RectangleTransparent.Fill.Bitmap.Bitmap := Transp;
    Transp.Free;
  end;
end;

destructor TFrameDialogColorPicker.Destroy;
begin
  FBitmap.Free;
  inherited;
end;

procedure TFrameDialogColorPicker.EditAChange(Sender: TObject);
begin
  if IsUpdating then
    Exit;
  var NewColor := GetColor;
  try
    case ComboBoxType.ItemIndex of
      0:
        begin
          var Cl: TAlphaColorRec;
          Cl.R := Min(StrToInt(EditR.Text), 255);
          Cl.G := Min(StrToInt(EditG.Text), 255);
          Cl.B := Min(StrToInt(EditB.Text), 255);
          Cl.A := Min(StrToInt(EditA.Text), 255);
          NewColor := Cl.Color;
        end;
      1:
        begin
          var Cl: TAlphaColorRec;
          HSVtoRGB(
            Min(StrToInt(EditR.Text), 360) / 359,
            Min(StrToInt(EditG.Text), 100) / 100,
            Min(StrToInt(EditB.Text), 100) / 100,
            Cl.R, Cl.G, Cl.B);
          Cl.A := StrToInt(EditA.Text);
          NewColor := Cl.Color;
        end;
    end;
  except
    //
  end;
  SetColor(NewColor);
end;

procedure TFrameDialogColorPicker.EditAKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  if Key = vkReturn then
  begin
    Key := 0;
    TEdit(Sender).OnChange(Sender);
  end;
end;

procedure TFrameDialogColorPicker.EditHEXChange(Sender: TObject);
begin
  if IsUpdating then
    Exit;
  var NewColor := GetColor;
  try
    NewColor := StringToAlphaColor(EditHEX.Text);
  except
    //
  end;
  SetColor(NewColor);
end;

procedure TFrameDialogColorPicker.Fill(Data: TDialogColorParams);
begin
  AlphaTrackBar.Visible := Data.Alpha;
  EditA.Visible := Data.Alpha;
  if Data.Alpha then
    Height := 360
  else
    Height := 325;
  SetColor(Data.Color);
end;

procedure TFrameDialogColorPicker.FindColor(Color: TAlphaColor);
begin
  var Rec := TAlphaColorRec.Create(Color);
  AlphaTrackBar.Value := Rec.A;
  Rec.A := 255;
  var H, S, V: Double;
  RGBToHSV(Rec.R, Rec.G, Rec.B, H, S, V);
  var R, G, B: Byte;
  HSVtoRGB(H, S, 1, R, G, B);
  Rec.R := R;
  Rec.G := G;
  Rec.B := B;
  BWTrackBar.Value := V;
  var ClosePt := TPoint.Zero;
  var CloseDiff := 1000;
  var Bits: TBitmapData;
  if FBitmap.Map(TMapAccess.Read, Bits) then
  try
    for var X := 0 to Bits.Width - 1 do
      for var Y := 0 to Bits.Height - 1 do
        if Bits.GetPixel(X, Y) = Rec.Color then
        begin
          var Pt := TPoint.Create(X, Y);
          CircleBoxPoint.Position.Point := Pt - TPoint.Create(8, 8);
          Exit;
        end
        else  //more close
        begin
          var Pix := TAlphaColorRec.Create(Bits.GetPixel(X, Y));
          var Diff := Abs(Rec.R - Pix.R) + Abs(Rec.G - Pix.G) + Abs(Rec.B - Pix.B);
          if CloseDiff > Diff then
          begin
            CloseDiff := Diff;
            ClosePt := TPoint.Create(X, Y);
          end;
        end;
    CircleBoxPoint.Position.Point := ClosePt - TPoint.Create(8, 8);
  finally
    FBitmap.Unmap(Bits);
  end;
end;

procedure TFrameDialogColorPicker.FOnBoxKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  CircleBoxPoint.Visible := True;
  var Pt := CircleBoxPoint.Position.Point;
  Pt.Offset(CircleBoxPoint.Width / 2, CircleBoxPoint.Height / 2);

  var Speed: Single := 1;
  if ssShift in Shift then
    Speed := 5;
  case Key of
    vkLeft:
      Pt.X := Pt.X - Speed;
    vkRight:
      Pt.X := Pt.X + Speed;
    vkUp:
      Pt.Y := Pt.Y - Speed;
    vkDown:
      Pt.Y := Pt.Y + Speed;
  end;
  if not RectangleBox.LocalRect.Contains(Pt) then
    Exit;
  UpdateBoxColor(Pt);
end;

function TFrameDialogColorPicker.GetColor: TAlphaColor;
begin
  Result := RectangleColor.Fill.Color;
end;

procedure TFrameDialogColorPicker.RectangleBoxMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
var
  TL, BR: TPoint;
begin
  TL := RectangleBox.LocalToScreen(TPoint.Create(0, 0)).Truncate;
  BR := RectangleBox.LocalToScreen(TPointF.Create(RectangleBox.Width, RectangleBox.Height)).Truncate;
  {$IFDEF MSWINDOWS}
  var RC := TRect.Create(TL, BR);
  ClipCursor(@RC);
  {$ENDIF}
  CircleBoxPoint.Visible := True;
  UpdateBoxColor(RectangleBox.ScreenToLocal(Screen.MousePos));
end;

procedure TFrameDialogColorPicker.UpdateBoxColor(Point: TPointF);
begin
  var Pt := Point;
  CircleBoxPoint.Position.Point := Pt - TPointF.Create(8, 8);
  var Bits: TBitmapData;
  if FBitmap.Map(TMapAccess.Read, Bits) then
  try
    FRawColor := Bits.GetPixel(Round(Pt.X), Round(Pt.Y));
  finally
    FBitmap.Unmap(Bits);
  end;
  UpdateResultColor;
end;

procedure TFrameDialogColorPicker.RectangleBoxMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
begin
  if not Assigned(Root.Captured) then
    Exit;
  if Root.Captured.GetObject = RectangleBox then
    UpdateBoxColor(RectangleBox.ScreenToLocal(Screen.MousePos));
end;

procedure TFrameDialogColorPicker.RectangleBoxMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  {$IFDEF MSWINDOWS}
  ClipCursor(nil);
  {$ENDIF}
end;

procedure TFrameDialogColorPicker.SetColor(const Value: TAlphaColor);
begin
  var Rec := TAlphaColorRec.Create(Value);
  if not AlphaTrackBar.Visible then
  begin
    Rec.A := 255;
  end;

  AlphaTrackBar.Value := Rec.A;
  AlphaTrackBar.InputColor := FRawColor;
  AlphaTrackBar.UpdateBitmap;

  var H, S, V: Double;
  RGBToHSV(Rec.R, Rec.G, Rec.B, H, S, V);
  BWTrackBar.Value := V;
  FRawColor := Rec.Color;

  BWTrackBar.InputColor := FRawColor;
  BWTrackBar.UpdateBitmap;
  FindColor(Rec.Color);
  UpdateResultColor;
  Repaint;
end;

{ TBWTrackBar }

procedure TBWTrackBar.FillBitmap;
var
  X, Y: Integer;
  M: TBitmapData;
  Val: Single;
begin
  if FBitmap.Map(TMapAccess.Write, M) then
  try
    for Y := 0 to FBitmap.Height - 1 do
      for X := 0 to FBitmap.Width - 1 do
      begin
        if Orientation = TOrientation.Horizontal then
          Val := (100 / M.Width) * X
        else
          Val := (100 / M.Height) * Y;
        M.SetPixel(X, Y, ChangeHSVValue(FInputColor, Val / 100));
      end;
  finally
    FBitmap.Unmap(M);
  end;
end;

constructor TBWTrackBar.Create(AOwner: TComponent);
begin
  inherited;
  Max := 1;
  Value := 0.5;
end;

procedure TBWTrackBar.SetInputColor(const Value: TAlphaColor);
begin
  FInputColor := Value;
end;

{ TAlphaTrackBar }

constructor TAlphaTrackBar.Create(AOwner: TComponent);
begin
  inherited;
  Max := 1;
  Value := 1;
end;

procedure TAlphaTrackBar.FillBitmap;
var
  I, J: Integer;
  M: TBitmapData;
begin
  if FBitmap.Map(TMapAccess.Write, M) then
  try
    for J := 0 to FBitmap.Height - 1 do
    begin
      for I := 0 to FBitmap.Width - 1 do
      begin
        if odd(I div 3) and not odd(J div 3) then
          M.SetPixel(I, J, $FFA0A0A0)
        else if not odd(I div 3) and odd(J div 3) then
          M.SetPixel(I, J, $FFA0A0A0)
        else
          M.SetPixel(I, J, $FFFFFFFF)
      end;
    end;
  finally
    FBitmap.Unmap(M);
  end;
  if FBitmap.Canvas.BeginScene then
  try
    FBitmap.Canvas.Fill.Kind := TBrushKind.Gradient;
    FBitmap.Canvas.Fill.Gradient.Points[0].Color := ChangeAlpha(FInputColor, 0);
    FBitmap.Canvas.Fill.Gradient.Points[1].Color := ChangeAlpha(FInputColor, 255);
    if Orientation = TOrientation.Horizontal then
      FBitmap.Canvas.Fill.Gradient.StopPosition.Point := PointF(1, 0)
    else
      FBitmap.Canvas.Fill.Gradient.StopPosition.Point := PointF(0, 1);
    FBitmap.Canvas.FillRect(RectF(0, 0, FBitmap.Width, FBitmap.Height), 0, 0, [], 1);
  finally
    FBitmap.Canvas.EndScene;
  end;
end;

procedure TAlphaTrackBar.SetInputColor(const Value: TAlphaColor);
begin
  FInputColor := Value;
end;

end.

