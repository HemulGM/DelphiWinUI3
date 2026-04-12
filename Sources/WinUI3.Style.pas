unit WinUI3.Style;

interface

uses
  System.SysUtils, System.UITypes, FMX.Styles, FMX.Types, FMX.Controls,
  FMX.StdCtrls, FMX.Objects, FMX.Styles.Objects, FMX.Colors, FMX.Graphics,
  FMX.Ani, FMX.Filter.Effects, FMX.Styles.Switch;

var
  // Dark theme start color
  OldColor: TAlphaColor = $FF60CDFF;
  OldColorAccentText: TAlphaColor = $FF99EBFF;

  // Light theme start color
  OldColorL: TAlphaColor = $FF005FB8;
  OldColorAccentTextL: TAlphaColor = $FF003E92;

procedure ChangeStyleBookColor(StyleBook: TStyleBook; OldColor, NewColor: TAlphaColor; ChangeProgress: Boolean);

implementation

procedure ChangeStyleBookColor(StyleBook: TStyleBook; OldColor, NewColor: TAlphaColor; ChangeProgress: Boolean);
var
  OldColorRec: TAlphaColorF;
  NewColorRec: TAlphaColorF;

  procedure ForAll(Obj: TFmxObject; Proc: TProc<TFmxObject>);
  begin
    Proc(Obj);
    if Assigned(Obj.Children) then
      for var Child in Obj.Children do
        ForAll(Child, Proc);
  end;

begin
  var Style := StyleBook.Style;
  //RemoveObject(Style);
  OldColorRec := TAlphaColorF.Create(OldColor);
  NewColorRec := TAlphaColorF.Create(NewColor);

  // Fix for progresscell style
  if ChangeProgress then
  begin
    var PC_Image := StyleBook.Style.FindStyleResource('progresscell_bmp', False);
    if Assigned(PC_Image) and (PC_Image is TImage) then
    begin
      TImage(PC_Image).Bitmap.Clear(NewColor);
    end;
  end;

  ForAll(Style,
    procedure(Item: TFmxObject)
    begin
      Item.TagString := '';
    end);

  ForAll(Style,
    procedure(Item: TFmxObject)

      function UpdateColor(TargetColor: TAlphaColor): TAlphaColor;
      begin
        var Rec := TAlphaColorF.Create(TargetColor);
        if (Rec.R = OldColorRec.R) and (Rec.G = OldColorRec.G) and (Rec.B = OldColorRec.B) then
        begin
          Rec.R := NewColorRec.R;
          Rec.G := NewColorRec.G;
          Rec.B := NewColorRec.B;
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
        {$IFDEF LINUX}
        if not Edit2.Text.IsEmpty then
          Control.TextSettings.Font.Family := Edit2.Text;
        {$ENDIF}
      end
      else if Item is TText then
      begin
        {$IFDEF LINUX}
        if not Edit2.Text.IsEmpty then
          (Item as TText).TextSettings.Font.Family := Edit2.Text;
        {$ENDIF}
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
  ForAll(Style,
    procedure(Item: TFmxObject)
    begin
      Item.TagString := '';
    end);
  //
end;

end.

