unit WinUI3.RADIDE;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, WinUI3.Form,
  FMX.Menus, FMX.Layouts, FMX.TabControl, FMX.ExtCtrls, FMX.StdCtrls,
  FMX.ListBox, FMX.TreeView, FMX.Controls.Presentation, FMX.Memo.Types,
  FMX.ScrollBox, FMX.Memo, FMX.Edit, FMX.ComboEdit, FMX.Objects,
  System.ImageList, FMX.ImgList, FMX.RichEdit.Style;

type
  TFormIDE = class(TWinUIForm)
    Layout1: TLayout;
    Layout2: TLayout;
    Layout3: TLayout;
    Expander1: TExpander;
    ListBox1: TListBox;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    ListBoxItem4: TListBoxItem;
    ListBoxItem5: TListBoxItem;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    Layout4: TLayout;
    Label1: TLabel;
    Button1: TButton;
    TreeView1: TTreeView;
    TreeViewItem1: TTreeViewItem;
    TreeViewItem2: TTreeViewItem;
    TreeViewItem3: TTreeViewItem;
    TreeViewItem4: TTreeViewItem;
    TreeViewItem5: TTreeViewItem;
    TreeViewItem6: TTreeViewItem;
    TreeViewItem7: TTreeViewItem;
    TreeViewItem8: TTreeViewItem;
    TreeViewItem9: TTreeViewItem;
    TreeViewItem10: TTreeViewItem;
    TreeViewItem11: TTreeViewItem;
    TreeViewItem12: TTreeViewItem;
    Layout5: TLayout;
    Label3: TLabel;
    Button3: TButton;
    TreeView2: TTreeView;
    TreeViewItem13: TTreeViewItem;
    TabControl2: TTabControl;
    TabItemCode: TTabItem;
    TabItemDesign: TTabItem;
    TabItemHistory: TTabItem;
    TabControl3: TTabControl;
    TabItem4: TTabItem;
    PlotGrid2: TPlotGrid;
    TabItem5: TTabItem;
    PlotGrid3: TPlotGrid;
    TabItem6: TTabItem;
    Layout6: TLayout;
    Line1: TLine;
    ComboEdit1: TComboEdit;
    TreeViewItem14: TTreeViewItem;
    Layout7: TLayout;
    Line2: TLine;
    Edit1: TEdit;
    TreeViewItem16: TTreeViewItem;
    Layout8: TLayout;
    Line3: TLine;
    ComboEdit2: TComboEdit;
    CheckBox1: TCheckBox;
    TreeViewItem17: TTreeViewItem;
    Layout9: TLayout;
    Line4: TLine;
    ComboEdit3: TComboEdit;
    CheckBox2: TCheckBox;
    TreeViewItem15: TTreeViewItem;
    Layout10: TLayout;
    Line5: TLine;
    ComboEdit4: TComboEdit;
    CheckBox3: TCheckBox;
    TreeViewItem18: TTreeViewItem;
    Layout11: TLayout;
    Line6: TLine;
    ComboEdit5: TComboEdit;
    CheckBox4: TCheckBox;
    TreeViewItem19: TTreeViewItem;
    Layout12: TLayout;
    Line7: TLine;
    ComboEdit6: TComboEdit;
    CheckBox5: TCheckBox;
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    Memo2: TMemo;
    TabItem2: TTabItem;
    Memo1: TMemo;
    TabItem3: TTabItem;
    ImageList1: TImageList;
    Panel1: TPanel;
    Line8: TLine;
    Panel2: TPanel;
    Layout14: TLayout;
    Label2: TLabel;
    Button2: TButton;
    TreeView3: TTreeView;
    TreeViewItem20: TTreeViewItem;
    TreeViewItem21: TTreeViewItem;
    TreeViewItem22: TTreeViewItem;
    TreeViewItem23: TTreeViewItem;
    TreeViewItem24: TTreeViewItem;
    TreeViewItem28: TTreeViewItem;
    TreeViewItem29: TTreeViewItem;
    TreeViewItem31: TTreeViewItem;
    Layout15: TLayout;
    Label4: TLabel;
    Line9: TLine;
    Button4: TButton;
    ComboEdit7: TComboEdit;
    TabControl4: TTabControl;
    TabItem7: TTabItem;
    TabItem8: TTabItem;
    TreeViewItem25: TTreeViewItem;
    TreeViewItem26: TTreeViewItem;
    TreeView5: TTreeView;
    TreeViewItem27: TTreeViewItem;
    TreeViewItem30: TTreeViewItem;
    TreeViewItem32: TTreeViewItem;
    TreeViewItem33: TTreeViewItem;
    TreeViewItem34: TTreeViewItem;
    TreeViewItem35: TTreeViewItem;
    TreeViewItem36: TTreeViewItem;
    TreeViewItem37: TTreeViewItem;
    TreeViewItem38: TTreeViewItem;
    TreeViewItem39: TTreeViewItem;
    TreeViewItem40: TTreeViewItem;
    TreeViewItem41: TTreeViewItem;
    TreeViewItem42: TTreeViewItem;
    TreeViewItem43: TTreeViewItem;
    TreeViewItem44: TTreeViewItem;
    TreeViewItem45: TTreeViewItem;
    TreeViewItem46: TTreeViewItem;
    TreeViewItem47: TTreeViewItem;
    Selection1: TSelection;
    Rectangle1: TRectangle;
    Selection2: TSelection;
    Button5: TButton;
    ScrollBox1: TScrollBox;
    MenuBar2: TMenuBar;
    MenuItem34: TMenuItem;
    MenuItem35: TMenuItem;
    MenuItem36: TMenuItem;
    MenuItem37: TMenuItem;
    MenuItem38: TMenuItem;
    MenuItem39: TMenuItem;
    MenuItem40: TMenuItem;
    MenuItem41: TMenuItem;
    MenuItem42: TMenuItem;
    MenuItem43: TMenuItem;
    MenuItem44: TMenuItem;
    MenuItem45: TMenuItem;
    MenuItem46: TMenuItem;
    MenuItem47: TMenuItem;
    MenuItem48: TMenuItem;
    MenuItem49: TMenuItem;
    MenuItem50: TMenuItem;
    MenuItem51: TMenuItem;
    MenuItem52: TMenuItem;
    MenuItem53: TMenuItem;
    MenuItem54: TMenuItem;
    MenuItem55: TMenuItem;
    MenuItem56: TMenuItem;
    MenuItem57: TMenuItem;
    MenuItem58: TMenuItem;
    MenuItem59: TMenuItem;
    MenuItem60: TMenuItem;
    MenuItem61: TMenuItem;
    MenuItem62: TMenuItem;
    MenuItem63: TMenuItem;
    MenuItem64: TMenuItem;
    MenuItem65: TMenuItem;
    MenuItem66: TMenuItem;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Selection2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PlotGrid2DragEnter(Sender: TObject; const Data: TDragObject; const Point: TPointF);
    procedure PlotGrid2DragDrop(Sender: TObject; const Data: TDragObject; const Point: TPointF);
    procedure PlotGrid2DragOver(Sender: TObject; const Data: TDragObject; const Point: TPointF; var Operation: TDragOperation);
    procedure Memo2PresentationNameChoosing(Sender: TObject; var PresenterName: string);
  private
    procedure FOnSelEnter(Sender: TObject);
    procedure FOnSelExit(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormIDE: TFormIDE;

implementation

uses
  WinUI3.Main;

{$R *.fmx}

procedure TFormIDE.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
end;

procedure TFormIDE.FormCreate(Sender: TObject);
begin
  (Memo2.Presentation as TRichEditStyled).SetCodeSyntaxName('pascal', Memo2.Font, Memo2.FontColor);
  PlotGrid2.CanFocus := True;
  Selection2.CanFocus := True;
  Selection2.OnEnter := FOnSelEnter;
  Selection2.OnExit := FOnSelExit;
end;

procedure TFormIDE.Memo2PresentationNameChoosing(Sender: TObject; var PresenterName: string);
begin
  PresenterName := 'RichEditStyled';
end;

procedure TFormIDE.PlotGrid2DragDrop(Sender: TObject; const Data: TDragObject; const Point: TPointF);
type
  TControlClass = class of TControl;
begin
  var Item := Data.Source as TTreeViewItem;
  var NewItem := GetClass(Item.Text);
  if NewItem <> nil then
  begin
    if NewItem.InheritsFrom(TComponent) then
    begin
      if NewItem.InheritsFrom(TControl) then
      begin
        var Sel := TSelection.Create(PlotGrid2);
        Sel.Parent := PlotGrid2;
        Sel.Position.Point := Point;
        Sel.CanFocus := True;
        Sel.OnEnter := FOnSelEnter;
        Sel.OnExit := FOnSelExit;

        var Control := TControlClass(NewItem).Create(Sel);
        Control.Parent := Sel;
        Sel.Size.Size := Control.Size.Size;
        Control.Align := TAlignLayout.Client;
        Control.HitTest := False;
        if Control is TPresentedTextControl then
          TPresentedTextControl(Control).Text := Control.ClassName.TrimLeft(['T']);

        Sel.SetFocus;
      end;
    end;
  end;
end;

procedure TFormIDE.PlotGrid2DragEnter(Sender: TObject; const Data: TDragObject; const Point: TPointF);
begin
  //
end;

procedure TFormIDE.PlotGrid2DragOver(Sender: TObject; const Data: TDragObject; const Point: TPointF; var Operation: TDragOperation);
begin
  if Data.Source is TTreeViewItem then
    Operation := TDragOperation.Link;
end;

procedure TFormIDE.FOnSelEnter(Sender: TObject);
var
  Sel: TSelection absolute Sender;
begin
  Sel.HideSelection := False;
end;

procedure TFormIDE.FOnSelExit(Sender: TObject);
var
  Sel: TSelection absolute Sender;
begin
  Sel.HideSelection := True;
end;

procedure TFormIDE.Selection2Click(Sender: TObject);
var
  Sel: TSelection absolute Sender;
begin
  //Sel.HideSelection := False;
end;

end.

