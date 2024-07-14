unit HGM.ColorUtils;

interface

uses
  System.Types, System.StrUtils, System.SysUtils, System.UIConsts,
  System.UITypes;

function CMYKToColor(C, M, Y, K: Byte): TColor;

function RGBToColor(R, G, B: Byte): TColor;

function GetRValue(RGB: Cardinal): Byte;

function GetGValue(RGB: Cardinal): Byte;

function GetBValue(RGB: Cardinal): Byte;

function GetAValue(RGB: Cardinal): Byte;

function GrayColor(Color: TColor): TColor;

procedure RGBToHSV(R, G, B: Byte; var H, S, V: Double);

procedure HSVtoRGB(H, S, V: Single; var R, G, B: Byte);

procedure HSVToColor(H: integer; S, V: Double; var Value: TColor);

procedure RGBToCMYK(const R, G, B: Byte; var C: Byte; var M: Byte; var Y: Byte; var K: Byte);

procedure CMYKToRGB(C, M, Y, K: Byte; var R: Byte; var G: Byte; var B: Byte);

procedure ColorCorrectCMYK(var C: Byte; var M: Byte; var Y: Byte; var K: Byte);

function HexToTColor(Value: string): TColor;

function ColorToHex(Color: TColor): string;

function ColorToHtml(Color: TColor): string;

function ColorToFMXColor(Color: TColor): string;

function FMXColorToColor(Color: string): TColor;

function HtmlToColor(Color: string): TColor;

function ColorToString(Color: TColor): string;

function InvertColor(const Color: TColor): TColor;

function VisibilityColor(const Color: TColor): TColor;

implementation

uses
  System.Math;

function RGB(r, g, b: Byte): Cardinal;
begin
  Result := (r or (g shl 8) or (b shl 16));
end;

function VisibilityColor(const Color: TColor): TColor;
begin
  Result := RGBToColor(
    IfThen(GetRValue(Color) > $40, $00, $FF),
    IfThen(GetGValue(Color) > $40, $00, $FF),
    IfThen(GetBValue(Color) > $40, $00, $FF));
end;

function InvertColor(const Color: TColor): TColor;
begin
  Result := RGBToColor(
    255 - GetRValue(Color),
    255 - GetGValue(Color),
    255 - GetBValue(Color));
end;

function ColorToString(Color: TColor): string;
begin
  Result := IntToHex(GetAValue(Color), 2) + IntToHex(GetRValue(Color), 2) + IntToHex(GetGValue(Color), 2) + IntToHex(GetBValue
    (Color), 2);
end;

function CMYKToColor(C, M, Y, K: Byte): TColor;
begin
  Result := (K or (Y shl 8) or (M shl 16) or (C shl 24));
end;

procedure ColorToCMYK(const Color: TColor; var C, M, Y, K: Byte);
var
  R, G, B: Byte;
begin
  R := GetRValue(Color);
  G := GetGValue(Color);
  B := GetBValue(Color);
  RGBToCMYK(R, G, B, C, M, Y, K);
end;

function RGBToColor(R, G, B: Byte): TColor;
begin
  Result := (R or (G shl 8) or (B shl 16));
end;

function GetRValue(RGB: Cardinal): Byte;
begin
  Result := Byte(RGB);
end;

function GetGValue(RGB: Cardinal): Byte;
begin
  Result := Byte(RGB shr 8);
end;

function GetBValue(RGB: Cardinal): Byte;
begin
  Result := Byte(RGB shr 16);
end;

function GetAValue(RGB: Cardinal): Byte;
begin
  Result := Byte(RGB shr 24);
end;

function GrayColor(Color: TColor): TColor;
var
  Gr: Byte;
begin
  Gr := Trunc((GetBValue(Color) + GetGValue(Color) + GetRValue(Color)) / 3);
  Result := RGBToColor(Gr, Gr, Gr);
end;

procedure RGBToHSV(R, G, B: Byte; var H, S, V: Double);
var
  Delta, RGBMin, RGBMax: integer;
const
  COneSixth = 1 / 6;
  COne255th = 1 / $FF;
begin

  RGBMin := Min(R, Min(G, B));
  RGBMax := Max(R, Max(G, B));
  V := RGBMax * COne255th;

  Delta := RGBMax - RGBMin;
  if RGBMax = 0 then
    S := 0
  else
    S := Delta / RGBMax;

  if S = 0.0 then
    H := 0
  else
  begin
    if R = RGBMax then
      H := COneSixth * (G - B) / Delta
    else if G = RGBMax then
      H := COneSixth * (2 + (B - R) / Delta)
    else if B = RGBMax then
      H := COneSixth * (4 + (R - G) / Delta);

    if H < 0.0 then
      H := H + 1;
  end;
end;

function RGBFP(R, G, B: Byte): TColor;
const
  RGBMax = 255;
begin
  Result := RGB(Round(RGBMax * R), Round(RGBMax * G), Round(RGBMax * B));
end;

procedure HSVtoRGB(H, S, V: Single; var R, G, B: Byte);
var
  Fraction: Single;
  Sel, Q, P: Integer;

  procedure CopyOutput(const RV, GV, BV: Byte);
  begin
    R := Round(RV);
    G := Round(GV);
    B := Round(BV);
  end;

begin
  V := 255 * V;

  if S = 0 then
  begin
    CopyOutput(Trunc(V), Trunc(V), Trunc(V));
    Exit;
  end;

  H := (H - Floor(H)) * 6; // 0 <= H < 6
  Fraction := H - Floor(H);

  Sel := Trunc(H);
  if (Sel mod 2) = 0 then
    Fraction := 1 - Fraction;

  P := Round(V * (1 - S));
  Q := Round(V * (1 - S * Fraction));

  case Sel of
    0:
      CopyOutput(Trunc(V), Q, P);
    1:
      CopyOutput(Q, Trunc(V), P);
    2:
      CopyOutput(P, Trunc(V), Q);
    3:
      CopyOutput(P, Q, Trunc(V));
    4:
      CopyOutput(Q, P, Trunc(V));
    5:
      CopyOutput(Trunc(V), P, Q);
  else
    CopyOutput(Trunc(V), Trunc(V), Trunc(V));
  end;
end;

procedure HSVToColor(H: integer; S, V: Double; var Value: TColor);
var
  R, G, B: Byte;
begin
  HSVToRGB(H, S, V, R, G, B);
  RGBToColor(R, G, B);
end;

procedure RGBToCMYK(const R, G, B: Byte; var C: Byte; var M: Byte; var Y: Byte; var K: Byte);
begin
  C := 255 - R;
  M := 255 - G;
  Y := 255 - B;
  if C < M then
    K := C
  else
    K := M;
  if Y < K then
    K := Y;
  if K > 0 then
  begin
    C := C - K;
    M := M - K;
    Y := Y - K;
  end;
end;

procedure CMYKToRGB(C, M, Y, K: Byte; var R: Byte; var G: Byte; var B: Byte);
begin
  if (Integer(C) + Integer(K)) < 255 then
    R := 255 - (C + K)
  else
    R := 0;
  if (Integer(M) + Integer(K)) < 255 then
    G := 255 - (M + K)
  else
    G := 0;
  if (Integer(Y) + Integer(K)) < 255 then
    B := 255 - (Y + K)
  else
    B := 0;
end;

procedure ColorCorrectCMYK(var C: Byte; var M: Byte; var Y: Byte; var K: Byte);
var
  MinColor: Byte;
begin
  if C < M then
    MinColor := C
  else
    MinColor := M;
  if Y < MinColor then
    MinColor := Y;
  if MinColor + K > 255 then
    MinColor := 255 - K;
  C := C - MinColor;
  M := M - MinColor;
  Y := Y - MinColor;
  K := K + MinColor;
end;

function HexToTColor(Value: string): TColor;
begin
  Result := RGBToColor(StrToInt('$' + Copy(Value, 5, 2)), StrToInt('$' + Copy(Value, 3, 2)), StrToInt('$' + Copy(Value, 1, 2)));
end;

function ColorToHex(Color: TColor): string;
begin
  Result := IntToHex(GetBValue(Color), 2) + IntToHex(GetGValue(Color), 2) + IntToHex(GetRValue(Color), 2);
end;

function ColorToHtml(Color: TColor): string;
begin
  Result := '#' + IntToHex(GetRValue(Color), 2) + IntToHex(GetGValue(Color), 2) + IntToHex(GetBValue(Color), 2);
end;

function ColorToFMXColor(Color: TColor): string;
begin
  Result := '#FF' + IntToHex(GetRValue(Color), 2) + IntToHex(GetGValue(Color), 2) + IntToHex(GetBValue(Color), 2);
end;

function HtmlToColor(Color: string): TColor;
begin
  Result := StringToColor('$' + Copy(Color, 6, 2) + Copy(Color, 4, 2) + Copy(Color, 2, 2));
end;

function FMXColorToColor(Color: string): TColor;
begin
  Result := StringToColor('$' + Copy(Color, 8, 2) + Copy(Color, 6, 2) + Copy(Color, 4, 2));
end;

end.

