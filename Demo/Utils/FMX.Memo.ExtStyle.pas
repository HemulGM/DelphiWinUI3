unit FMX.Memo.ExtStyle;

interface

uses
  FMX.Text.TextEditor, FMX.Text.LinesLayout, FMX.TextLayout, FMX.Memo.Style.New,
  FMX.Controls.Presentation, FMX.Text, FMX.ScrollBox.Style, FMX.Controls,
  FMX.Graphics, System.UITypes, System.Generics.Collections;

type
  TMemoExtLinesLayout = class(TLinesLayout)
  protected
    FSelectedRange: TDictionary<Integer, TTextRange>;
    FSelectedColor: TAlphaColor;
    FNoHighlight: Boolean;
    procedure UpdateLayoutParams(const ALineIndex: Integer; const ALayout: TTextLayout); override;
    procedure SetNoHighlight(const Value: Boolean);
    procedure UpdateLayout;
  public
    constructor Create(const ALineSource: ITextLinesSource; const AScrollableContent: IScrollableContent);
    destructor Destroy; override;

    procedure ReplaceLine(const AIndex: Integer; const ALine: string); override;
    procedure SetSelectedTextColor(const Color: TAlphaColor);
  end;

  TMemoExtTextEditor = class(TTextEditor)
  protected
    procedure UpdateSelRanges;
    function CreateLinesLayout: TLinesLayout; override;
    procedure DoCaretPositionChanged; override;
    procedure DoSelectionChanged(const ASelStart, ALength: Integer); override;
  end;

  TMemoExtStyled = class(TStyledMemo)
  protected
    function CreateEditor: TTextEditor; override;
    procedure DoEnter; override;
    procedure DoExit; override;
  public
    procedure UpdateVisibleLayoutParams;
    procedure SetSelectedTextColor(const Color: TAlphaColor);
  end;

implementation

uses
  System.SysUtils, System.Math, FMX.Presentation.Style, FMX.Presentation.Factory;

{ TMemoExtTextEditor }

function TMemoExtTextEditor.CreateLinesLayout: TLinesLayout;
begin
  Result := TMemoExtLinesLayout.Create(Lines, ScrollableContent);
end;

procedure TMemoExtTextEditor.DoCaretPositionChanged;
begin
  inherited;
  UpdateSelRanges;
end;

procedure TMemoExtTextEditor.DoSelectionChanged(const ASelStart, ALength: Integer);
begin
  inherited;
  UpdateSelRanges;
end;

procedure TMemoExtTextEditor.UpdateSelRanges;
begin
  var SelRange := TMemoExtLinesLayout(LinesLayout).FSelectedRange;
  SelRange.Clear;
  var SelBegin := SelectionController.SelBegin;
  var SelEnd := SelectionController.SelEnd;
  if SelBegin.Line = SelEnd.Line then
    SelRange.Add(SelBegin.Line, TTextRange.Create(SelBegin.Pos, SelectionController.SelLength))
  else
  begin
    SelRange.Add(SelBegin.Line, TTextRange.Create(SelBegin.Pos, Lines.Lines[SelBegin.Line].Length));
    for var i := SelBegin.Line + 1 to SelEnd.Line - 1 do
      SelRange.Add(i, TTextRange.Create(0, Lines.Lines[i].Length));
    SelRange.Add(SelEnd.Line, TTextRange.Create(0, SelEnd.Pos));
  end;
  TMemoExtLinesLayout(LinesLayout).UpdateLayout;
end;

{ TMemoExtLinesLayout }

constructor TMemoExtLinesLayout.Create(const ALineSource: ITextLinesSource; const AScrollableContent: IScrollableContent);
begin
  inherited;
  FSelectedRange := TDictionary<Integer, TTextRange>.Create;
  FSelectedColor := TAlphaColorRec.White;
end;

destructor TMemoExtLinesLayout.Destroy;
begin
  FSelectedRange.Free;
  inherited;
end;

procedure TMemoExtLinesLayout.ReplaceLine(const AIndex: Integer; const ALine: string);
begin
  inherited;
  // We have to reapply style attributes after line modification
  Items[AIndex].InvalidateLayout;
end;

procedure TMemoExtLinesLayout.SetNoHighlight(const Value: Boolean);
begin
  FNoHighlight := Value;
  UpdateLayout;
end;

procedure TMemoExtLinesLayout.SetSelectedTextColor(const Color: TAlphaColor);
begin
  FSelectedColor := Color;
end;

procedure TMemoExtLinesLayout.UpdateLayout;
begin
  if (FirstVisibleLineIndex = -1) or (LastVisibleLineIndex = -1) or IsUpdating then
    Exit;
  for var i := FirstVisibleLineIndex to LastVisibleLineIndex do
    if Assigned(Items[i]) then
      Items[i].InvalidateLayout;
  Realign;
end;

procedure TMemoExtLinesLayout.UpdateLayoutParams(const ALineIndex: Integer; const ALayout: TTextLayout);
begin
  ALayout.BeginUpdate;
  try
    inherited;
    ALayout.ClearAttributes;
    if (FSelectedColor = TAlphaColorRec.Null) or FNoHighlight then
      Exit;
    if FSelectedRange.ContainsKey(ALineIndex) then
    begin
      var Attr: TTextAttribute;
      Attr.Font := TextSettings.Font;
      Attr.Color := FSelectedColor;

      ALayout.AddAttribute(FSelectedRange[ALineIndex], Attr);
    end;
  finally
    ALayout.EndUpdate;
  end;
end;

{ TMemoExtStyled }

function TMemoExtStyled.CreateEditor: TTextEditor;
begin
  Result := TMemoExtTextEditor.Create(Self, Memo.Content, Model, Self);
end;

procedure TMemoExtStyled.UpdateVisibleLayoutParams;
begin
  for var I := 0 to Editor.LinesLayout.Count - 1 do
  begin
    var Line := Editor.LinesLayout.Items[I];
    if Line.Layout <> nil then
      TMemoExtLinesLayout(Editor.LinesLayout).UpdateLayoutParams(I, Line.Layout);
  end;
end;

procedure TMemoExtStyled.DoEnter;
begin
  inherited;
  TMemoExtLinesLayout(Editor.LinesLayout).SetNoHighlight(False);
end;

procedure TMemoExtStyled.DoExit;
begin
  inherited;
  TMemoExtLinesLayout(Editor.LinesLayout).SetNoHighlight(True);
end;

procedure TMemoExtStyled.SetSelectedTextColor(const Color: TAlphaColor);
begin
  TMemoExtLinesLayout(Editor.LinesLayout).SetSelectedTextColor(Color);
  UpdateVisibleLayoutParams;
end;

initialization
  TPresentationProxyFactory.Current.Register('MemoExtStyled', TStyledPresentationProxy<TMemoExtStyled>);
  //TPresentationProxyFactory.Current.Replace('MemoStyled', TStyledPresentationProxy<TMemoExtStyled>);

finalization
  TPresentationProxyFactory.Current.Unregister('MemoExtStyled', TStyledPresentationProxy<TMemoExtStyled>);

end.

