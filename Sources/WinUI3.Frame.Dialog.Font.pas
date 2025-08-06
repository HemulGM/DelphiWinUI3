unit WinUI3.Frame.Dialog.Font;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.EditBox, FMX.SpinBox, FMX.Controls.Presentation, FMX.Edit, FMX.SearchBox,
  FMX.Layouts, FMX.ListBox;

type
  TDialogFontParams = record
  private
    FTitle: string;
    FCheckText: string;
    FCheckValue: Boolean;
    FButtons: TArray<string>;
    FFrameColor: TColor;
    FCanClose: Boolean;
    FAccentId: Integer;
    FDefaultId: Integer;
    FFamily: TFontName;
    FStyleExt: TFontStyleExt;
    FSize: Single;
  public
    property Title: string read FTitle write FTitle;
    property CheckText: string read FCheckText write FCheckText;
    property CheckValue: Boolean read FCheckValue write FCheckValue;
    property Buttons: TArray<string> read FButtons write FButtons;
    property AccentId: Integer read FAccentId write FAccentId;
    property DefaultId: Integer read FDefaultId write FDefaultId;
    property CanClose: Boolean read FCanClose write FCanClose;
    property FrameColor: TColor read FFrameColor write FFrameColor;
    //
    property Family: TFontName read FFamily write FFamily;
    property Size: Single read FSize write FSize;
    property StyleExt: TFontStyleExt read FStyleExt write FStyleExt;
  end;

  TDialogFontResult = record
    Result: Integer;
    IsChecked: Boolean;
    //
    Family: TFontName;
    StyleExt: TFontStyleExt;
    Size: Single;
  end;

  TFrameDialogFont = class(TFrame)
    ListBoxFonts: TListBox;
    SearchBoxFont: TSearchBox;
    CheckBoxBold: TCheckBox;
    CheckBoxItalic: TCheckBox;
    CheckBoxUnderline: TCheckBox;
    CheckBoxStrikeout: TCheckBox;
    SpinBoxFontSize: TSpinBox;
    LabelFontSize: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Panel1: TPanel;
    LabelSample: TLabel;
    Label4: TLabel;
    procedure ListBoxFontsChange(Sender: TObject);
    procedure CheckBoxBoldChange(Sender: TObject);
    procedure ListBoxFontsApplyStyleLookup(Sender: TObject);
  private
    FFamily: TFontName;
    FStyleExt: TFontStyleExt;
    FSize: Single;
    FFilling: Boolean;
    procedure UpdateSelectedFont;
  public
    procedure Fill(Data: TDialogFontParams);
    property Family: TFontName read FFamily write FFamily;
    property Size: Single read FSize write FSize;
    property StyleExt: TFontStyleExt read FStyleExt write FStyleExt;
    constructor Create(AOwner: TComponent); override;
  end;

implementation

uses
  {$IFDEF MSWINDOWS}
  Winapi.Windows,
  {$ENDIF}
  {$IFDEF LINUX}
  FMUX.Api,
  {$ENDIF}
  {$IFDEF MACOS}
  MacApi.Appkit, Macapi.CoreFoundation, Macapi.Foundation,
  {$ENDIF}
  FMX.FontManager;

{$R *.fmx}

{$IFDEF MACOS}

procedure GetSystemFonts(FontList: TStringlist);
begin
  var Manager := TNsFontManager.Wrap(TNsFontManager.OCClass.sharedFontManager);
  var FontFamilies := Manager.availableFontFamilies;
  if Assigned(FontFamilies) then
    for var i := 0 to FontFamilies.Count - 1 do
      FontList.Add(string(TNSString.Wrap(FontFamilies.objectAtIndex(i)).UTF8String));
end;
{$ENDIF}

{$IFDEF LINUX}

procedure GetSystemFonts(FontList: TStringlist);
begin
  for var i := 0 to FmuxGetFontCount - 1 do
    FontList.Add(FmuxGetFontName(i));
end;
{$ENDIF}

{$IFDEF MSWINDOWS}

function EnumFontsList(var LogFont: TLogFont; var TextMetric: TTextMetric; FontType: Integer; Data: Pointer): Integer; stdcall;
begin
  var List := TStrings(Data);
  var FontName := string(LogFont.lfFaceName);
  if (List.Count = 0) or (AnsiCompareText(List[List.Count - 1], FontName) <> 0) then
    if not FontName.StartsWith('@') then
      List.Add(FontName);
  Result := 1;
end;

procedure GetSystemFonts(FontList: TStrings);
begin
  var Context := GetDC(0);
  var LFont: TLogFont;
  FillChar(LFont, SizeOf(LFont), 0);
  LFont.lfCharset := DEFAULT_CHARSET;
  EnumFontFamiliesEx(Context, LFont, @EnumFontsList, Winapi.Windows.LPARAM(FontList), 0);
  ReleaseDC(0, Context);
end;
{$ENDIF}

procedure TFrameDialogFont.CheckBoxBoldChange(Sender: TObject);
begin
  UpdateSelectedFont;
end;

constructor TFrameDialogFont.Create(AOwner: TComponent);
begin
  inherited;
  Name := '';
  var FontList := TStringList.Create;
  try
    GetSystemFonts(FontList);
    FontList.Sort;
    ListBoxFonts.BeginUpdate;
    try
      for var FontName in FontList do
      begin
        var Item := TListBoxItem.Create(ListBoxFonts);
        Item.Text := FontName;
        //Item.StyledSettings := Item.StyledSettings - [TStyledSetting.Family];
        //Item.TextSettings.Font.Family := FontName;
        ListBoxFonts.AddObject(Item);
      end;
    finally
      ListBoxFonts.EndUpdate;
    end;
  finally
    FontList.Free;
  end;
end;

procedure TFrameDialogFont.Fill(Data: TDialogFontParams);
begin
  FFilling := True;
  FFamily := Data.Family;
  FStyleExt := Data.StyleExt;
  FSize := Data.Size;
  for var i := 0 to ListBoxFonts.Count - 1 do
    if ListBoxFonts.ListItems[i].Text = FFamily then
    begin
      ListBoxFonts.ListItems[i].IsSelected := True;
      ListBoxFonts.ScrollToItem(ListBoxFonts.ListItems[i]);
      Break;
    end;
  SpinBoxFontSize.Value := FSize;
  CheckBoxBold.IsChecked := TFontStyle.fsBold in FStyleExt.SimpleStyle;
  CheckBoxItalic.IsChecked := TFontStyle.fsItalic in FStyleExt.SimpleStyle;
  CheckBoxUnderline.IsChecked := TFontStyle.fsUnderline in FStyleExt.SimpleStyle;
  CheckBoxStrikeout.IsChecked := TFontStyle.fsStrikeOut in FStyleExt.SimpleStyle;
  FFilling := False;
  UpdateSelectedFont;
end;

procedure TFrameDialogFont.ListBoxFontsApplyStyleLookup(Sender: TObject);
begin
  TThread.ForceQueue(nil,
    procedure
    begin
      ListBoxFonts.ScrollToItem(ListBoxFonts.Selected);
    end);
end;

procedure TFrameDialogFont.ListBoxFontsChange(Sender: TObject);
begin
  UpdateSelectedFont;
end;

procedure TFrameDialogFont.UpdateSelectedFont;
begin
  if FFilling then
    Exit;
  if not Assigned(ListBoxFonts.Selected) then
    Exit;
  FFamily := ListBoxFonts.Selected.Text;
  var Style: TFontStyles := [];
  if CheckBoxBold.IsChecked then
    Include(Style, TFontStyle.fsBold);
  if CheckBoxItalic.IsChecked then
    Include(Style, TFontStyle.fsItalic);
  if CheckBoxUnderline.IsChecked then
    Include(Style, TFontStyle.fsUnderline);
  if CheckBoxStrikeout.IsChecked then
    Include(Style, TFontStyle.fsStrikeOut);
  FStyleExt := TFontStyleExt.Create(Style);

  LabelSample.Font.Family := ListBoxFonts.Selected.Text;
  LabelSample.Font.StyleExt := FStyleExt;
end;

end.

