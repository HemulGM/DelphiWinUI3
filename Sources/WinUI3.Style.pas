unit WinUI3.Style;

interface

uses
  System.SysUtils, System.UITypes, FMX.Styles, FMX.Types, FMX.Controls,
  FMX.StdCtrls, FMX.Objects, FMX.Styles.Objects, FMX.Colors, FMX.Graphics,
  FMX.Ani, FMX.Filter.Effects, FMX.Styles.Switch, HGM.ColorUtils;

procedure ChangeStyleBookColor(StyleBook: TStyleBook; AccentColor: TAlphaColor);

implementation

procedure ChangeStyleBookColor(StyleBook: TStyleBook; AccentColor: TAlphaColor);

  procedure ForAll(Obj: TFmxObject; Proc: TProc<TFmxObject>);
  begin
    // Ignore meta style resource
    if Obj.StyleName = '#resources' then
      Exit;
    Proc(Obj);
    if Assigned(Obj.Children) then
      for var Child in Obj.Children do
        ForAll(Child, Proc);
  end;

begin
  var Style := StyleBook.Style;

  // Get current accent color
  var ColorAccentObj := StyleBook.Style.FindStyleResource('color_accent', False);
  if not (Assigned(ColorAccentObj) and (ColorAccentObj is TBrushObject)) then
    Exit;

  // Get current accent text color
  var ColorAccentTextObj := StyleBook.Style.FindStyleResource('color_accent_text', False);
  if not (Assigned(ColorAccentTextObj) and (ColorAccentTextObj is TBrushObject)) then
    Exit;

  // Get current theme mode
  var ThemeObj := StyleBook.Style.FindStyleResource('theme', False);
  if not (Assigned(ThemeObj) and (ThemeObj is TStyleTag)) then
    Exit;

  // Change saturation for dark theme accent color
  if ThemeObj.TagString = 'dark' then
    AccentColor := ChangeColorSat(AccentColor, 50);

  // Read previous accent color
  var OldColorRec := TAlphaColorF.Create(TBrushObject(ColorAccentObj).Brush.Color);
  var OldColorAccentTextRec := TAlphaColorF.Create(TBrushObject(ColorAccentTextObj).Brush.Color);

  // Exit if same colors
  if OldColorRec.ToAlphaColor = AccentColor then
    Exit;

  // New colors recs
  var NewColorRec := TAlphaColorF.Create(AccentColor);
  var NewColorAccentText := TAlphaColorF.Create(DecreaseSaturation(AccentColor, 10));

  // Save colors
  TBrushObject(ColorAccentObj).Brush.Color := NewColorRec.ToAlphaColor;
  TBrushObject(ColorAccentTextObj).Brush.Color := NewColorAccentText.ToAlphaColor;

  // Drop change flags
  ForAll(Style,
    procedure(Item: TFmxObject)
    begin
      Item.TagString := '';
    end);

  // Fix for progresscell style
  var PC_Image := StyleBook.Style.FindStyleResource('progresscell_bmp', False);
  if Assigned(PC_Image) and (PC_Image is TImage) then
    TImage(PC_Image).Bitmap.Clear(NewColorRec.ToAlphaColor);

  // Update old color to new color
  ForAll(Style,
    procedure(Item: TFmxObject)

      function UpdateColor(TargetColor: TAlphaColor): TAlphaColor;
      begin
        var Rec := TAlphaColorF.Create(TargetColor);
        // Try accent
        if (Rec.R = OldColorRec.R) and (Rec.G = OldColorRec.G) and (Rec.B = OldColorRec.B) then
        begin
          Rec.R := NewColorRec.R;
          Rec.G := NewColorRec.G;
          Rec.B := NewColorRec.B;
        end
        else // try accent text
          if (Rec.R = OldColorAccentTextRec.R) and (Rec.G = OldColorAccentTextRec.G) and (Rec.B = OldColorAccentTextRec.B) then
        begin
          Rec.R := NewColorAccentText.R;
          Rec.G := NewColorAccentText.G;
          Rec.B := NewColorAccentText.B;
        end;
        Result := Rec.ToAlphaColor;
      end;


    begin
      if not Item.TagString.IsEmpty then
        Exit;
      if Item is TShape then
      begin
        var Control := TRectangle(Item);

        Control.Fill.Color := UpdateColor(Control.Fill.Color);
        Control.Stroke.Color := UpdateColor(Control.Stroke.Color);

        Item.TagString := '0';
      end
      else if Item is TColorObject then
      begin
        var Control := TColorObject(Item);
        Control.Color := UpdateColor(Control.Color);
        Item.TagString := '0';
      end
      else if Item is TBrushObject then
      begin
        var Control := TBrushObject(Item);
        Control.Brush.Color := UpdateColor(Control.Brush.Color);
        Item.TagString := '0';
      end
      else if Item is TColorAnimation then
      begin
        var Control := TColorAnimation(Item);
        Control.StartValue := UpdateColor(Control.StartValue);
        Control.StopValue := UpdateColor(Control.StopValue);
        Item.TagString := '0';
      end
      else if Item is TLabel then
      begin
        var Control := TLabel(Item);
        Control.TextSettings.FontColor := UpdateColor(Control.TextSettings.FontColor);
        Item.TagString := '0';
      end
      else if Item is TText then
      begin
        if Item is TTabStyleTextObject then
        begin
          var Control := TTabStyleTextObject(Item);
          Control.HotColor := UpdateColor(Control.HotColor);
          Control.ActiveColor := UpdateColor(Control.ActiveColor);
          Control.Color := UpdateColor(Control.Color);
          Item.TagString := '0';
        end
        else if Item is TActiveStyleTextObject then
        begin
          var Control := TActiveStyleTextObject(Item);
          Control.ActiveColor := UpdateColor(Control.ActiveColor);
          Control.Color := UpdateColor(Control.Color);
          Item.TagString := '0';
        end
        else if Item is TButtonStyleTextObject then
        begin
          var Control := TButtonStyleTextObject(Item);
          Control.HotColor := UpdateColor(Control.HotColor);
          Control.FocusedColor := UpdateColor(Control.FocusedColor);
          Control.NormalColor := UpdateColor(Control.NormalColor);
          Control.PressedColor := UpdateColor(Control.PressedColor);
          Item.TagString := '0';
        end
        else
        begin
          var Control := TText(Item);
          Control.TextSettings.FontColor := UpdateColor(Control.TextSettings.FontColor);
          Item.TagString := '0';
        end;
      end
      else if Item is TSwitchObject then
      begin
        var Control := TSwitchObject(Item);
        Control.Fill.Color := UpdateColor(Control.Fill.Color);
        Control.FillOn.Color := UpdateColor(Control.FillOn.Color);
        Control.Stroke.Color := UpdateColor(Control.Stroke.Color);
        Control.Thumb.Color := UpdateColor(Control.Thumb.Color);
        Item.TagString := '0';
      end
      else if Item is TFillRGBEffect then
      begin
        var Control := TFillRGBEffect(Item);
        Control.Color := UpdateColor(Control.Color);
        Item.TagString := '0';
      end;
    end);

  // Drop change flags
  ForAll(Style,
    procedure(Item: TFmxObject)
    begin
      Item.TagString := '';
    end);
end;

end.

