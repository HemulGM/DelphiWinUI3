unit WinUI3.Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Memo.Types,
  Data.Bind.Controls, System.Rtti, FMX.Grid.Style, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.Header,
  FMX.MagnifierGlass, FMX.ExtCtrls, FMX.StdCtrls, FMX.ListView, FMX.Colors,
  FMX.NumberBox, FMX.SpinBox, FMX.Grid, FMX.MultiView, FMX.Objects, FMX.Layouts,
  Fmx.Bind.Navigator, FMX.TreeView, FMX.ListBox, FMX.Calendar, FMX.DateTimeCtrls,
  FMX.Edit, FMX.ScrollBox, FMX.Memo, FMX.Memo.Style, FMX.EditBox,
  FMX.ComboEdit.Style, FMX.ComboTrackBar, FMX.ComboEdit,
  FMX.Controls.Presentation, FMX.TabControl, FMX.Menus, System.ImageList,
  FMX.ImgList, FMX.Effects, FMX.Filter.Effects, FMX.Switch.Style,
  Fmx.Bind.GenData, Data.Bind.GenData, System.Bindings.Outputs, Fmx.Bind.Editors,
  Data.Bind.EngExt, Fmx.Bind.DBEngExt, Data.Bind.Components,
  Data.Bind.ObjectScope, Fmx.Bind.Grid, Data.Bind.Grid, FMX.SearchBox,
  {$IFDEF MSWINDOWS}
  FMX.Win.NotificationManager, 
  {$ENDIF}
  FMX.Ani, FMX.ActnList, System.Actions, WinUI3.Form, WinUI3.Frame.Inner.InfoBar,
  WinUI3.Frame.Dialog.ColorPicker;

type
  TFormMain = class(TWinUIForm)
    ImageList: TImageList;
    ImageList24: TImageList;
    PopupMenu1: TPopupMenu;
    MenuItem2: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem22: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem15: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem16: TMenuItem;
    MenuItem17: TMenuItem;
    MenuItem18: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem19: TMenuItem;
    MenuItem20: TMenuItem;
    MenuItem21: TMenuItem;
    TabControlMain: TTabControl;
    TabItemButtons: TTabItem;
    ScrollBox1: TScrollBox;
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Label2: TLabel;
    Label3: TLabel;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Button16: TButton;
    Button17: TButton;
    Button18: TButton;
    TabItemStandart: TTabItem;
    ScrollBox2: TScrollBox;
    Panel2: TPanel;
    CheckBox1: TCheckBox;
    CheckBox3: TCheckBox;
    Label8: TLabel;
    Panel3: TPanel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    Label7: TLabel;
    Panel4: TPanel;
    ProgressBar1: TProgressBar;
    ProgressBar3: TProgressBar;
    ProgressBar5: TProgressBar;
    ProgressBar4: TProgressBar;
    Label6: TLabel;
    ProgressBar2: TProgressBar;
    ProgressBar6: TProgressBar;
    ProgressBar7: TProgressBar;
    ProgressBar8: TProgressBar;
    ProgressBar9: TProgressBar;
    Panel6: TPanel;
    Label9: TLabel;
    Panel7: TPanel;
    TrackBar1: TTrackBar;
    Label10: TLabel;
    TrackBar2: TTrackBar;
    TrackBar4: TTrackBar;
    TrackBar5: TTrackBar;
    Panel10: TPanel;
    ComboColorBox1: TComboColorBox;
    Label19: TLabel;
    ComboBox1: TComboBox;
    ComboEdit2: TComboEdit;
    Label27: TLabel;
    Label28: TLabel;
    ComboTrackBar1: TComboTrackBar;
    Label30: TLabel;
    TabItemInput: TTabItem;
    ScrollBox3: TScrollBox;
    Panel9: TPanel;
    Memo1: TMemo;
    Label17: TLabel;
    Memo2: TMemo;
    Panel8: TPanel;
    Label11: TLabel;
    Edit2: TEdit;
    Edit3: TEdit;
    ClearEditButton1: TClearEditButton;
    PasswordEditButton1: TPasswordEditButton;
    EllipsesEditButton1: TEllipsesEditButton;
    DropDownEditButton1: TDropDownEditButton;
    SpinEditButton1: TSpinEditButton;
    Edit4: TEdit;
    ClearEditButton2: TClearEditButton;
    TabItemDateTime: TTabItem;
    ScrollBox4: TScrollBox;
    Panel5: TPanel;
    Label15: TLabel;
    TimeEdit1: TTimeEdit;
    DateEdit1: TDateEdit;
    Calendar1: TCalendar;
    TabItemLists: TTabItem;
    ScrollBox5: TScrollBox;
    ListBox1: TListBox;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    ListBoxItem4: TListBoxItem;
    ListBoxItem5: TListBoxItem;
    ListBoxItem6: TListBoxItem;
    ListBoxItem7: TListBoxItem;
    ListBoxItem8: TListBoxItem;
    ListBoxItem9: TListBoxItem;
    ListBoxItem10: TListBoxItem;
    ListBoxItem11: TListBoxItem;
    ListBoxItem12: TListBoxItem;
    ListBoxItem13: TListBoxItem;
    ListBoxItem14: TListBoxItem;
    Label16: TLabel;
    ListBox2: TListBox;
    ListBoxItem15: TListBoxItem;
    ListBoxItem16: TListBoxItem;
    ListBoxItem17: TListBoxItem;
    ListBoxItem18: TListBoxItem;
    ListBoxItem19: TListBoxItem;
    ListBoxItem20: TListBoxItem;
    ListBoxItem21: TListBoxItem;
    ListBoxItem22: TListBoxItem;
    ListBoxItem23: TListBoxItem;
    ListBoxItem24: TListBoxItem;
    ListBoxItem25: TListBoxItem;
    ListBoxItem26: TListBoxItem;
    ListBoxItem27: TListBoxItem;
    ListBoxItem28: TListBoxItem;
    ListBox3: TListBox;
    ListBoxItem29: TListBoxItem;
    ListBoxItem30: TListBoxItem;
    ListBoxItem31: TListBoxItem;
    ListBoxItem32: TListBoxItem;
    ListBoxItem33: TListBoxItem;
    ListBoxItem34: TListBoxItem;
    ListBoxItem35: TListBoxItem;
    ListBoxItem36: TListBoxItem;
    ListBoxItem37: TListBoxItem;
    ListBoxItem38: TListBoxItem;
    ListBoxItem39: TListBoxItem;
    ListBoxItem40: TListBoxItem;
    ListBoxItem41: TListBoxItem;
    ListBoxItem42: TListBoxItem;
    ListBox4: TListBox;
    ListBoxItem43: TListBoxItem;
    ListBoxItem44: TListBoxItem;
    ListBoxItem45: TListBoxItem;
    ListBoxItem46: TListBoxItem;
    ListBoxItem47: TListBoxItem;
    ListBoxItem48: TListBoxItem;
    ListBoxItem49: TListBoxItem;
    ListBoxItem50: TListBoxItem;
    ListBoxItem51: TListBoxItem;
    ListBoxItem52: TListBoxItem;
    ListBoxItem53: TListBoxItem;
    ListBoxItem54: TListBoxItem;
    ListBoxItem55: TListBoxItem;
    ListBoxItem56: TListBoxItem;
    ListBox5: TListBox;
    ListBoxItem58: TListBoxItem;
    ListBoxItem59: TListBoxItem;
    ListBoxItem60: TListBoxItem;
    ListBoxItem61: TListBoxItem;
    ListBoxItem62: TListBoxItem;
    ListBoxItem63: TListBoxItem;
    ListBoxItem64: TListBoxItem;
    ListBoxItem65: TListBoxItem;
    ListBoxItem66: TListBoxItem;
    ListBoxItem67: TListBoxItem;
    ListBoxItem68: TListBoxItem;
    ListBoxItem69: TListBoxItem;
    ListBoxItem70: TListBoxItem;
    ListBox6: TListBox;
    ListBoxItem71: TListBoxItem;
    ListBoxItem72: TListBoxItem;
    ListBoxItem73: TListBoxItem;
    ListBoxItem74: TListBoxItem;
    ListBoxItem75: TListBoxItem;
    ListBoxItem76: TListBoxItem;
    ListBoxItem77: TListBoxItem;
    ListBoxItem78: TListBoxItem;
    ListBoxItem79: TListBoxItem;
    ListBoxItem80: TListBoxItem;
    ListBoxItem81: TListBoxItem;
    ListBoxItem82: TListBoxItem;
    ListBoxItem83: TListBoxItem;
    ListBoxItem84: TListBoxItem;
    TreeView1: TTreeView;
    TreeViewItem1: TTreeViewItem;
    TreeViewItem2: TTreeViewItem;
    TreeViewItem6: TTreeViewItem;
    TreeViewItem7: TTreeViewItem;
    TreeViewItem12: TTreeViewItem;
    TreeViewItem13: TTreeViewItem;
    TreeViewItem8: TTreeViewItem;
    TreeViewItem9: TTreeViewItem;
    TreeViewItem3: TTreeViewItem;
    TreeViewItem10: TTreeViewItem;
    TreeViewItem11: TTreeViewItem;
    TreeViewItem4: TTreeViewItem;
    TreeViewItem5: TTreeViewItem;
    ListBox7: TListBox;
    ListBoxItem85: TListBoxItem;
    ListBoxItem86: TListBoxItem;
    ListBoxItem87: TListBoxItem;
    ListBoxItem88: TListBoxItem;
    ListBoxItem89: TListBoxItem;
    ListBoxItem90: TListBoxItem;
    ListBoxItem91: TListBoxItem;
    ListBoxItem92: TListBoxItem;
    ListBoxItem93: TListBoxItem;
    ListBoxItem94: TListBoxItem;
    ListBoxItem95: TListBoxItem;
    ListBoxItem96: TListBoxItem;
    ListBoxItem97: TListBoxItem;
    ListBoxItem98: TListBoxItem;
    ListBox8: TListBox;
    ListBoxItem100: TListBoxItem;
    ListBoxItem101: TListBoxItem;
    ListBoxItem102: TListBoxItem;
    ListBoxItem103: TListBoxItem;
    ListBoxItem104: TListBoxItem;
    ListBoxItem105: TListBoxItem;
    ListBoxItem106: TListBoxItem;
    ListBoxItem107: TListBoxItem;
    ListBoxItem108: TListBoxItem;
    ListBoxItem109: TListBoxItem;
    ListBoxItem110: TListBoxItem;
    ListBoxItem111: TListBoxItem;
    ListBoxItem112: TListBoxItem;
    TabItemActions: TTabItem;
    ScrollBox6: TScrollBox;
    Panel11: TPanel;
    Label21: TLabel;
    CornerButton1: TCornerButton;
    CornerButton2: TCornerButton;
    CornerButton3: TCornerButton;
    CornerButton4: TCornerButton;
    CornerButton5: TCornerButton;
    CornerButton6: TCornerButton;
    Button99: TButton;
    Label57: TLabel;
    Button100: TButton;
    Button101: TButton;
    Button102: TButton;
    Button103: TButton;
    Button104: TButton;
    Button105: TButton;
    Button106: TButton;
    Button107: TButton;
    Button108: TButton;
    Button109: TButton;
    Button110: TButton;
    Button111: TButton;
    Button112: TButton;
    Button113: TButton;
    Button118: TButton;
    Button119: TButton;
    BindNavigator1: TBindNavigator;
    Label58: TLabel;
    BindNavigator2: TBindNavigator;
    Button120: TButton;
    Button121: TButton;
    Button122: TButton;
    Button123: TButton;
    Button124: TButton;
    Button125: TButton;
    Button126: TButton;
    Button127: TButton;
    Button128: TButton;
    Button114: TButton;
    Button115: TButton;
    Button116: TButton;
    Button117: TButton;
    Button131: TButton;
    Button132: TButton;
    Button133: TButton;
    Button134: TButton;
    Button135: TButton;
    Button136: TButton;
    Button137: TButton;
    Button138: TButton;
    Button139: TButton;
    Button140: TButton;
    Button141: TButton;
    Button142: TButton;
    Button143: TButton;
    Button144: TButton;
    Button145: TButton;
    Button146: TButton;
    Button147: TButton;
    Button148: TButton;
    Button149: TButton;
    Button150: TButton;
    Button151: TButton;
    Button152: TButton;
    Button153: TButton;
    Button154: TButton;
    Button155: TButton;
    Button156: TButton;
    Button157: TButton;
    Button158: TButton;
    Button160: TButton;
    TabItemSplitter: TTabItem;
    Layout1: TLayout;
    Rectangle3: TRectangle;
    Rectangle4: TRectangle;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    Splitter3: TSplitter;
    Rectangle6: TRectangle;
    Rectangle5: TRectangle;
    Rectangle7: TRectangle;
    Splitter4: TSplitter;
    TabItemGrid: TTabItem;
    StringGrid1: TStringGrid;
    Grid1: TGrid;
    TabItemAniIndicator: TTabItem;
    AniIndicator1: TAniIndicator;
    AniIndicator2: TAniIndicator;
    AniIndicator3: TAniIndicator;
    AniIndicator4: TAniIndicator;
    TabItemOther: TTabItem;
    CalloutPanel1: TCalloutPanel;
    StatusBar1: TStatusBar;
    PopupBox1: TPopupBox;
    Label51: TLabel;
    Label54: TLabel;
    GroupBox1: TGroupBox;
    Label55: TLabel;
    TabItemMore: TTabItem;
    DropTarget1: TDropTarget;
    DropTarget2: TDropTarget;
    DropTarget3: TDropTarget;
    Header1: THeader;
    HeaderItem1: THeaderItem;
    HeaderItem2: THeaderItem;
    HeaderItem3: THeaderItem;
    HeaderItem4: THeaderItem;
    TabItemMultiView: TTabItem;
    TabControl3: TTabControl;
    TabItem16: TTabItem;
    Rectangle8: TRectangle;
    Label33: TLabel;
    MultiView1: TMultiView;
    Button56: TButton;
    Button66: TButton;
    Button70: TButton;
    Button71: TButton;
    Button72: TButton;
    Button73: TButton;
    Button74: TButton;
    Panel14: TPanel;
    Panel15: TPanel;
    TabItem17: TTabItem;
    Rectangle9: TRectangle;
    Label34: TLabel;
    MultiView3: TMultiView;
    Button64: TButton;
    Button75: TButton;
    Button76: TButton;
    Button77: TButton;
    Button78: TButton;
    Button79: TButton;
    Button80: TButton;
    Panel16: TPanel;
    Panel17: TPanel;
    TabItem18: TTabItem;
    Rectangle10: TRectangle;
    Label35: TLabel;
    Button68: TButton;
    MultiView4: TMultiView;
    Button81: TButton;
    Button82: TButton;
    Button83: TButton;
    Button84: TButton;
    Button85: TButton;
    Button86: TButton;
    Layout11: TLayout;
    Label43: TLabel;
    Panel18: TPanel;
    Panel19: TPanel;
    TabItem19: TTabItem;
    Rectangle11: TRectangle;
    Label36: TLabel;
    Button69: TButton;
    MultiView5: TMultiView;
    Button87: TButton;
    Button88: TButton;
    Button89: TButton;
    Button90: TButton;
    Button91: TButton;
    Button92: TButton;
    Layout12: TLayout;
    Label45: TLabel;
    Panel20: TPanel;
    Panel21: TPanel;
    TabItem20: TTabItem;
    Rectangle12: TRectangle;
    Label37: TLabel;
    MultiView6: TMultiView;
    Button93: TButton;
    Button94: TButton;
    Button95: TButton;
    Button96: TButton;
    Button97: TButton;
    Button98: TButton;
    Layout13: TLayout;
    Label47: TLabel;
    Panel22: TPanel;
    Panel23: TPanel;
    Label4: TLabel;
    Button10: TButton;
    Button11: TButton;
    Button12: TButton;
    Button13: TButton;
    Panel26: TPanel;
    Button14: TButton;
    Button15: TButton;
    Label5: TLabel;
    Button19: TButton;
    Button20: TButton;
    Button21: TButton;
    Button22: TButton;
    Label18: TLabel;
    Label20: TLabel;
    Label26: TLabel;
    Switch1: TSwitch;
    CheckBox4: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox9: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox7: TCheckBox;
    CheckBox8: TCheckBox;
    Switch2: TSwitch;
    Switch3: TSwitch;
    TabItemExpander: TTabItem;
    Button40: TButton;
    Button23: TButton;
    Button36: TButton;
    CheckBox2: TCheckBox;
    CheckBox10: TCheckBox;
    Panel27: TPanel;
    Panel28: TPanel;
    Button39: TButton;
    ComboColorBox2: TComboColorBox;
    TrackBar3: TTrackBar;
    TrackBar6: TTrackBar;
    TrackBar7: TTrackBar;
    PrototypeBindSource1: TPrototypeBindSource;
    BindingsList1: TBindingsList;
    LinkGridToDataSourcePrototypeBindSource1: TLinkGridToDataSource;
    LinkGridToDataSourcePrototypeBindSource12: TLinkGridToDataSource;
    VertScrollBoxCarusel: TVertScrollBox;
    Expander1: TExpander;
    Layout14: TLayout;
    Label29: TLabel;
    Button42: TButton;
    Label53: TLabel;
    Line1: TLine;
    Layout15: TLayout;
    Label59: TLabel;
    Button43: TButton;
    Layout16: TLayout;
    Line3: TLine;
    Label60: TLabel;
    Button44: TButton;
    Layout17: TLayout;
    Line4: TLine;
    Label61: TLabel;
    Button45: TButton;
    Layout18: TLayout;
    Panel29: TPanel;
    Expander2: TExpander;
    MenuBar1: TMenuBar;
    MenuItem32: TMenuItem;
    MenuItem33: TMenuItem;
    MenuItem34: TMenuItem;
    MenuItem35: TMenuItem;
    MenuItem36: TMenuItem;
    MenuItem37: TMenuItem;
    MenuItem38: TMenuItem;
    MenuItem39: TMenuItem;
    MenuItem40: TMenuItem;
    Layout19: TLayout;
    Label13: TLabel;
    Label12: TLabel;
    CalloutPanel2: TCalloutPanel;
    Layout20: TLayout;
    Label14: TLabel;
    Label62: TLabel;
    ButtonTaskTest: TButton;
    Label63: TLabel;
    Path1: TPath;
    Button41: TButton;
    Button46: TButton;
    SearchEditButton2: TSearchEditButton;
    Edit1: TEdit;
    ClearEditButton3: TClearEditButton;
    EditSearch: TEdit;
    ClearEditButton4: TClearEditButton;
    EditButton1: TEditButton;
    Button47: TButton;
    Button159: TButton;
    Button166: TButton;
    Label49: TLabel;
    SpinBox1: TSpinBox;
    Label25: TLabel;
    NumberBox1: TNumberBox;
    TabItemColors: TTabItem;
    ColorPanel2: TColorPanel;
    ColorPicker1: TColorPicker;
    ColorBox1: TColorBox;
    ColorQuad1: TColorQuad;
    HueTrackBar1: THueTrackBar;
    AlphaTrackBar1: TAlphaTrackBar;
    BWTrackBar1: TBWTrackBar;
    GradientEdit1: TGradientEdit;
    ComboColorBox3: TComboColorBox;
    ColorButton3: TColorButton;
    ColorComboBox1: TColorComboBox;
    ColorListBox1: TColorListBox;
    Label50: TLabel;
    AniIndicator5: TAniIndicator;
    AniIndicator6: TAniIndicator;
    TreeViewItem14: TTreeViewItem;
    TreeViewItem15: TTreeViewItem;
    TreeViewItem16: TTreeViewItem;
    TreeViewItem17: TTreeViewItem;
    TreeViewItem18: TTreeViewItem;
    TreeViewItem19: TTreeViewItem;
    TreeViewItem20: TTreeViewItem;
    TreeViewItem21: TTreeViewItem;
    TreeViewItem22: TTreeViewItem;
    TreeViewItem23: TTreeViewItem;
    TreeViewItem24: TTreeViewItem;
    TreeViewItem25: TTreeViewItem;
    TreeViewItem26: TTreeViewItem;
    TreeViewItem27: TTreeViewItem;
    Selection1: TSelection;
    SelectionPoint1: TSelectionPoint;
    SearchBox1: TSearchBox;
    TabItemTabs: TTabItem;
    TabControl2: TTabControl;
    TabItem7: TTabItem;
    TabItem11: TTabItem;
    TabItem12: TTabItem;
    TabItem13: TTabItem;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Panel25: TPanel;
    Layout2: TLayout;
    Label22: TLabel;
    Layout3: TLayout;
    ColorButton1: TColorButton;
    ColorButton2: TColorButton;
    ColorButton4: TColorButton;
    ColorButton5: TColorButton;
    ColorButton6: TColorButton;
    ColorButton7: TColorButton;
    Layout4: TLayout;
    Layout5: TLayout;
    Label23: TLabel;
    Layout6: TLayout;
    PathTestLine: TPath;
    Layout7: TLayout;
    TrackBarLineSize: TTrackBar;
    Button29: TButton;
    Button30: TButton;
    Button31: TButton;
    Button32: TButton;
    Button33: TButton;
    Button34: TButton;
    Button35: TButton;
    Button37: TButton;
    Button38: TButton;
    Button48: TButton;
    Button49: TButton;
    Button50: TButton;
    Button51: TButton;
    Button52: TButton;
    Button53: TButton;
    Button54: TButton;
    Button55: TButton;
    Button57: TButton;
    Button58: TButton;
    Button59: TButton;
    Button60: TButton;
    Button61: TButton;
    Button62: TButton;
    Button67: TButton;
    Layout8: TLayout;
    Layout9: TLayout;
    Button130: TButton;
    Button161: TButton;
    Button162: TButton;
    Button163: TButton;
    Button164: TButton;
    Button165: TButton;
    Button167: TButton;
    Button168: TButton;
    Button169: TButton;
    Button170: TButton;
    Button171: TButton;
    Button172: TButton;
    Button173: TButton;
    Button174: TButton;
    Button175: TButton;
    Button176: TButton;
    Button177: TButton;
    Button178: TButton;
    Button179: TButton;
    Button180: TButton;
    Button181: TButton;
    Button182: TButton;
    Button183: TButton;
    Button184: TButton;
    Layout10: TLayout;
    Layout21: TLayout;
    HorzScrollBoxSpin: THorzScrollBox;
    Panel12: TPanel;
    Button186: TButton;
    Button187: TButton;
    Label24: TLabel;
    Path2: TPath;
    SpinBox2: TSpinBox;
    PrototypeBindSource2: TPrototypeBindSource;
    ListBox9: TListBox;
    SearchBox2: TSearchBox;
    LinkListControlToField2: TLinkListControlToField;
    ListView1: TListView;
    LinkListControlToField1: TLinkListControlToField;
    TabItemNotify: TTabItem;
    ButtonNotify: TButton;
    Image5: TImage;
    MagnifierGlass1: TMagnifierGlass;
    MagnifierGlass2: TMagnifierGlass;
    MagnifierGlass3: TMagnifierGlass;
    Label31: TLabel;
    ActionList: TActionList;
    ActionAdd: TAction;
    TabItemLabels: TTabItem;
    Label32: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    Label42: TLabel;
    Label44: TLabel;
    VertScrollBox1: TVertScrollBox;
    Panel30: TPanel;
    Label46: TLabel;
    Path3: TPath;
    Label52: TLabel;
    Label56: TLabel;
    Label64: TLabel;
    Button65: TButton;
    Layout22: TLayout;
    Line2: TLine;
    Label65: TLabel;
    Label66: TLabel;
    Label67: TLabel;
    Path4: TPath;
    Panel31: TPanel;
    Layout23: TLayout;
    Panel32: TPanel;
    Line5: TLine;
    Label68: TLabel;
    Label69: TLabel;
    Button188: TButton;
    Path5: TPath;
    Label70: TLabel;
    Label72: TLabel;
    Path6: TPath;
    Panel33: TPanel;
    Layout24: TLayout;
    Layout25: TLayout;
    Panel34: TPanel;
    Layout26: TLayout;
    Panel35: TPanel;
    Panel36: TPanel;
    Button185: TButton;
    Button189: TButton;
    Button190: TButton;
    Button191: TButton;
    Button192: TButton;
    Layout27: TLayout;
    Layout28: TLayout;
    Label71: TLabel;
    Label73: TLabel;
    Label74: TLabel;
    Label75: TLabel;
    Label76: TLabel;
    Label77: TLabel;
    Label78: TLabel;
    Label79: TLabel;
    Label80: TLabel;
    Label81: TLabel;
    Label82: TLabel;
    Label83: TLabel;
    Label84: TLabel;
    Label85: TLabel;
    Label86: TLabel;
    Label87: TLabel;
    Label88: TLabel;
    Label89: TLabel;
    EditExampleCap: TEdit;
    EditExampleBody: TEdit;
    EditExampleBodyS: TEdit;
    EditExampleSubT: TEdit;
    EditExampleTitle: TEdit;
    EditExampleTitleL: TEdit;
    EditExampleDisplay: TEdit;
    EditButton2: TEditButton;
    EditButton3: TEditButton;
    EditButton4: TEditButton;
    EditButton5: TEditButton;
    EditButton6: TEditButton;
    EditButton7: TEditButton;
    EditButton8: TEditButton;
    TabItemDialogs: TTabItem;
    ButtonShare: TButton;
    ButtonDialogText1: TButton;
    ButtonDialogText2: TButton;
    ButtonDialogSM: TButton;
    ButtonDialogFrame: TButton;
    ButtonDialogInput: TButton;
    ButtonDialogColorPicker: TButton;
    ButtonDialogSMLarge: TButton;
    ButtonDialogColorPickerAlpha: TButton;
    LayoutContent: TLayout;
    TimerEndLaunch: TTimer;
    LayoutLauncher: TLayout;
    Image6: TImage;
    AniIndicator7: TAniIndicator;
    ButtonMoreFluentIcons: TButton;
    ListBox10: TListBox;
    ListBoxItem57: TListBoxItem;
    ListBoxItem99: TListBoxItem;
    ImageList32: TImageList;
    ListBoxItem113: TListBoxItem;
    ListBoxItem114: TListBoxItem;
    ListBoxItem115: TListBoxItem;
    ListBoxItem116: TListBoxItem;
    ListBoxItem117: TListBoxItem;
    ListBox11: TListBox;
    ListBoxItem118: TListBoxItem;
    ListBoxItem119: TListBoxItem;
    ListBoxItem120: TListBoxItem;
    ListBoxItem121: TListBoxItem;
    ListBoxItem122: TListBoxItem;
    ListBoxItem123: TListBoxItem;
    ListBoxItem124: TListBoxItem;
    Button63: TButton;
    Button193: TButton;
    Button194: TButton;
    Button195: TButton;
    Button196: TButton;
    Button197: TButton;
    Button198: TButton;
    Button199: TButton;
    Button200: TButton;
    Button201: TButton;
    Button202: TButton;
    Button203: TButton;
    Button204: TButton;
    Button205: TButton;
    Button206: TButton;
    Button207: TButton;
    PopupSearch: TPopup;
    ListBoxSearch: TListBox;
    ListBoxItem125: TListBoxItem;
    TabItem1: TTabItem;
    MultiView2: TMultiView;
    Button208: TButton;
    Button209: TButton;
    Button210: TButton;
    Button211: TButton;
    Button212: TButton;
    Button213: TButton;
    Button214: TButton;
    Panel37: TPanel;
    Panel38: TPanel;
    Rectangle17: TRectangle;
    Label90: TLabel;
    Label91: TLabel;
    Label92: TLabel;
    TabControl4: TTabControl;
    TabItem27: TTabItem;
    Rectangle1: TRectangle;
    TabItem28: TTabItem;
    Rectangle2: TRectangle;
    TabItem29: TTabItem;
    Rectangle13: TRectangle;
    TabControl5: TTabControl;
    TabItem31: TTabItem;
    Rectangle14: TRectangle;
    TabItem32: TTabItem;
    Rectangle15: TRectangle;
    TabItem33: TTabItem;
    Rectangle16: TRectangle;
    TabControl1: TTabControl;
    TabItem2: TTabItem;
    TabItem3: TTabItem;
    TabItem4: TTabItem;
    Panel40: TPanel;
    Panel41: TPanel;
    TabItem5: TTabItem;
    Panel39: TPanel;
    Panel42: TPanel;
    Layout29: TLayout;
    Label93: TLabel;
    Button215: TButton;
    Panel43: TPanel;
    Layout30: TLayout;
    Label94: TLabel;
    Panel44: TPanel;
    Layout31: TLayout;
    Label95: TLabel;
    Button217: TButton;
    Panel45: TPanel;
    Layout32: TLayout;
    Label96: TLabel;
    Button218: TButton;
    Panel46: TPanel;
    Layout33: TLayout;
    Label97: TLabel;
    Button219: TButton;
    Panel47: TPanel;
    Layout34: TLayout;
    Label98: TLabel;
    Panel48: TPanel;
    Button216: TButton;
    FlowLayout1: TFlowLayout;
    Button220: TButton;
    Button221: TButton;
    Button222: TButton;
    FlowLayout2: TFlowLayout;
    Button223: TButton;
    Button224: TButton;
    Button225: TButton;
    Button226: TButton;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    Button227: TButton;
    Button228: TButton;
    Button229: TButton;
    Button230: TButton;
    Button231: TButton;
    Button232: TButton;
    Button233: TButton;
    Button234: TButton;
    Button235: TButton;
    Button236: TButton;
    Button237: TButton;
    Button238: TButton;
    Button239: TButton;
    Layout35: TLayout;
    Rectangle18: TRectangle;
    Rectangle19: TRectangle;
    Splitter5: TSplitter;
    Splitter6: TSplitter;
    Splitter7: TSplitter;
    Rectangle20: TRectangle;
    Rectangle21: TRectangle;
    Rectangle22: TRectangle;
    Splitter8: TSplitter;
    Layout36: TLayout;
    Expander7: TExpander;
    ButtonButton: TButton;
    ButtonCheckBox: TButton;
    ButtonColorPicker: TButton;
    ButtonComboBox: TButton;
    ButtonDropDownButton: TButton;
    ButtonHyperlinkButton: TButton;
    ButtonInputValidation: TButton;
    ButtonRadioButton: TButton;
    Expander3: TExpander;
    Button244: TButton;
    Button245: TButton;
    Button246: TButton;
    Button247: TButton;
    Button248: TButton;
    Button249: TButton;
    Button250: TButton;
    Button251: TButton;
    Expander4: TExpander;
    Button252: TButton;
    Button253: TButton;
    Button254: TButton;
    Button255: TButton;
    Button256: TButton;
    Button257: TButton;
    Button258: TButton;
    Button259: TButton;
    Expander5: TExpander;
    Button260: TButton;
    Button261: TButton;
    Button262: TButton;
    Button263: TButton;
    Button264: TButton;
    Button265: TButton;
    Button266: TButton;
    Button267: TButton;
    Expander6: TExpander;
    Button268: TButton;
    Button269: TButton;
    Button270: TButton;
    Button271: TButton;
    Button272: TButton;
    Button273: TButton;
    Button274: TButton;
    Button275: TButton;
    Expander8: TExpander;
    Button276: TButton;
    Button277: TButton;
    Button278: TButton;
    Button279: TButton;
    Button280: TButton;
    Button281: TButton;
    Button282: TButton;
    Button283: TButton;
    VertScrollBox2: TVertScrollBox;
    Panel49: TPanel;
    ArcDial2: TArcDial;
    Label48: TLabel;
    ArcDial1: TArcDial;
    ArcDial3: TArcDial;
    AniIndicator8: TAniIndicator;
    Label99: TLabel;
    Panel50: TPanel;
    Label100: TLabel;
    ButtonInfoBarShow: TButton;
    EditInfoBarTitle: TEdit;
    MemoInfoBarBody: TMemo;
    PopupBoxInfoBarType: TPopupBox;
    PopupBoxInfoBarPos: TPopupBox;
    CheckBoxInfoBarCanClose: TCheckBox;
    EditInfoBarAction: TEdit;
    CheckBoxInfoBarHyper: TCheckBox;
    CheckBoxInfoBarActionIsClose: TCheckBox;
    SpinBoxInfoBarAC: TSpinBox;
    Label101: TLabel;
    PanelStoreMenu: TPanel;
    Button284: TButton;
    Button285: TButton;
    Button286: TButton;
    Button287: TButton;
    Button288: TButton;
    ImageListIcons: TImageList;
    Label102: TLabel;
    Label103: TLabel;
    EditWrongTest: TEdit;
    EditButton9: TEditButton;
    LabelWrongTest: TLabel;
    Panel51: TPanel;
    HorzScrollBoxFilter: THorzScrollBox;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    RadioButton6: TRadioButton;
    RadioButton7: TRadioButton;
    RadioButton8: TRadioButton;
    RadioButton9: TRadioButton;
    RadioButton10: TRadioButton;
    Button289: TButton;
    Button290: TButton;
    ButtonScrollFilterLeft: TButton;
    ButtonScrollFilterRight: TButton;
    Layout37: TLayout;
    Panel52: TPanel;
    Expander9: TExpander;
    TabControl6: TTabControl;
    TabItem6: TTabItem;
    TabItem8: TTabItem;
    Memo3: TMemo;
    Memo4: TMemo;
    VertScrollBox3: TVertScrollBox;
    Label104: TLabel;
    CalloutPanel3: TCalloutPanel;
    Layout38: TLayout;
    Label105: TLabel;
    Label106: TLabel;
    CalloutPanel4: TCalloutPanel;
    Layout39: TLayout;
    Label107: TLabel;
    Label108: TLabel;
    ImageViewer1: TImageViewer;
    PlotGrid1: TPlotGrid;
    CheckBoxInfoBarAsPanel: TCheckBox;
    ColorAnimation1: TColorAnimation;
    StyleBookWinUI3: TStyleBook;
    Layout40: TLayout;
    ButtonMenuHome: TButton;
    ButtonMenuButtons: TButton;
    ButtonMenuStandart: TButton;
    ButtonMenuLabels: TButton;
    ButtonMenuDT: TButton;
    ButtonMenuInput: TButton;
    ButtonMenuActions: TButton;
    VertScrollBoxMenu: TVertScrollBox;
    ButtonMenuLists: TButton;
    ButtonMenuSplitter: TButton;
    ButtonMenuMore: TButton;
    ButtonMenuGrid: TButton;
    ButtonMenuIndicators: TButton;
    ButtonMenuOther: TButton;
    ButtonMenuMultiView: TButton;
    ButtonMenuExpander: TButton;
    ButtonMenuTabControl: TButton;
    ButtonMenuColors: TButton;
    ButtonMenuNotify: TButton;
    ButtonMenuDialogs: TButton;
    Panel53: TPanel;
    ButtonMenuMenus: TButton;
    TabItemMenus: TTabItem;
    ToolBar1: TToolBar;
    Button24: TButton;
    Button25: TButton;
    Button26: TButton;
    Button27: TButton;
    Button28: TButton;
    Panel13: TPanel;
    ToolBar2: TToolBar;
    Button296: TButton;
    Button297: TButton;
    Button298: TButton;
    Button299: TButton;
    Button240: TButton;
    TabItemHome: TTabItem;
    TabControlView: TTabControl;
    TabItem23: TTabItem;
    TabItem24: TTabItem;
    TabItem25: TTabItem;
    TabItem26: TTabItem;
    TabItemAdd: TTabItem;
    ScrollBox7: TScrollBox;
    ColorPanel1: TColorPanel;
    ColorPanel3: TColorPanel;
    Button129: TButton;
    ListBox13: TListBox;
    ListBoxItem131: TListBoxItem;
    ListBoxItem133: TListBoxItem;
    ListBoxItem134: TListBoxItem;
    MetropolisUIListBoxItem6: TMetropolisUIListBoxItem;
    ListBoxHeader2: TListBoxHeader;
    SearchBox4: TSearchBox;
    ListBoxGroupHeader6: TListBoxGroupHeader;
    ListBoxItem132: TListBoxItem;
    ListBoxItem135: TListBoxItem;
    ListBoxItem136: TListBoxItem;
    ListBoxItem137: TListBoxItem;
    ListBoxGroupFooter6: TListBoxGroupFooter;
    Button241: TButton;
    Button242: TButton;
    Button243: TButton;
    Button291: TButton;
    Label109: TLabel;
    Label110: TLabel;
    Label111: TLabel;
    Label112: TLabel;
    Label113: TLabel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    Label114: TLabel;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    ScrollBox8: TScrollBox;
    FlowLayoutBasic: TFlowLayout;
    ButtonDemoGallery: TButton;
    ButtonDemoMusic: TButton;
    ButtonDemoIDE: TButton;
    ImageListDemo: TImageList;
    MenuItem23: TMenuItem;
    MenuItem1: TMenuItem;
    PopupMenuRich: TPopupMenu;
    MenuItem24: TMenuItem;
    MenuItem25: TMenuItem;
    MenuItem45: TMenuItem;
    MenuItem52: TMenuItem;
    MenuItem53: TMenuItem;
    MenuItem26: TMenuItem;
    LayoutCaption: TLayout;
    LayoutHead: TLayout;
    Layout41: TLayout;
    Layout42: TLayout;
    Image7: TImage;
    Label115: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure VertScrollBoxCaruselViewportPositionChange(Sender: TObject; const OldViewportPosition, NewViewportPosition: TPointF; const ContentSizeChanged: Boolean);
    procedure TabItemAddClick(Sender: TObject);
    procedure ColorComboBox1Change(Sender: TObject);
    procedure ColorButton1Click(Sender: TObject);
    procedure TrackBarLineSizeChange(Sender: TObject);
    procedure HorzScrollBoxSpinViewportPositionChange(Sender: TObject; const OldViewportPosition, NewViewportPosition: TPointF; const ContentSizeChanged: Boolean);
    procedure DropTarget1Dropped(Sender: TObject; const Data: TDragObject; const Point: TPointF);
    procedure ButtonNotifyClick(Sender: TObject);
    procedure ActionAddExecute(Sender: TObject);
    procedure EditButton2Click(Sender: TObject);
    procedure EditButton3Click(Sender: TObject);
    procedure EditButton4Click(Sender: TObject);
    procedure EditButton5Click(Sender: TObject);
    procedure EditButton6Click(Sender: TObject);
    procedure EditButton7Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure EditButton8Click(Sender: TObject);
    procedure ButtonShareClick(Sender: TObject);
    procedure ButtonDialogText1Click(Sender: TObject);
    procedure ButtonDialogText2Click(Sender: TObject);
    procedure ButtonDialogSMClick(Sender: TObject);
    procedure ButtonDialogFrameClick(Sender: TObject);
    procedure ButtonDialogInputClick(Sender: TObject);
    procedure ButtonDialogColorPickerClick(Sender: TObject);
    procedure ButtonDialogSMLargeClick(Sender: TObject);
    procedure ButtonDialogColorPickerAlphaClick(Sender: TObject);
    procedure TimerEndLaunchTimer(Sender: TObject);
    procedure ButtonMoreFluentIconsClick(Sender: TObject);
    procedure EditSearchChangeTracking(Sender: TObject);
    procedure EditSearchKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure EditSearchKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure ListBoxSearchKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure Button240Click(Sender: TObject);
    procedure Button241Click(Sender: TObject);
    procedure Button242Click(Sender: TObject);
    procedure Button243Click(Sender: TObject);
    procedure ButtonInfoBarShowClick(Sender: TObject);
    procedure Button284Click(Sender: TObject);
    procedure EditWrongTestChangeTracking(Sender: TObject);
    procedure HorzScrollBoxFilterViewportPositionChange(Sender: TObject; const OldViewportPosition, NewViewportPosition: TPointF; const ContentSizeChanged: Boolean);
    procedure ButtonScrollFilterLeftClick(Sender: TObject);
    procedure ButtonScrollFilterRightClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ButtonMenuActionsClick(Sender: TObject);
    procedure TabControlMainChange(Sender: TObject);
    procedure ButtonMenuActionsMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure ColorPanel1Change(Sender: TObject);
    procedure Button223Click(Sender: TObject);
    procedure ButtonDemoGalleryClick(Sender: TObject);
    procedure ButtonDemoMusicClick(Sender: TObject);
    procedure ButtonDemoIDEClick(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure ArcDial2KeyDown(Sender: TObject; var Key: Word; var KeyChar: WideChar; Shift: TShiftState);
  private
    {$IFDEF MSWINDOWS}
    FNotifyManager: TNotificationManager;
    procedure NotifActivated(Sender: TNotification; Arguments: string; UserInput: TUserInputMap);
    procedure NotifDismissed(Sender: TNotification; Reason: TToastDismissReason);
    {$ENDIF}
  private
    procedure FOnTabCloseClick(Sender: TObject);
    procedure TabViewTest;
    procedure CreateNotificationCenter;
    procedure FSearchItemClick(Sender: TObject);
    procedure TryOpenTabByName(const Text: string);
    procedure FOnSubMenuClick(Sender: TObject);
    procedure FOnButton15SplitClick(Sender: TObject);
  end;

var
  FormMain: TFormMain;

implementation

uses
  DelphiWindowStyle.FMX, FMX.BehaviorManager, System.Math, System.IOUtils,
  System.Messaging, FMX.Utils, System.Threading, WinUI3.Gallery, FMX.Platform,
  WinUI3.Frame.Dialog.Test, WinUI3.Dialogs, WinUI3.YandexMusic, WinUI3.RADIDE;

{$R *.fmx}

procedure TFormMain.ActionAddExecute(Sender: TObject);
begin
  ShowUIMessage(Self, 'Add somthing');
end;

procedure TFormMain.ButtonDemoGalleryClick(Sender: TObject);
begin
  ButtonDemoGallery.StylesData['indicator.Visible'] := False;
  TFormGallery.Create(Application).Show;
end;

procedure TFormMain.ButtonDemoIDEClick(Sender: TObject);
begin
  ButtonDemoIDE.StylesData['indicator.Visible'] := False;
  TFormIDE.Create(Application).Show;
end;

procedure TFormMain.ButtonDemoMusicClick(Sender: TObject);
begin
  ButtonDemoMusic.StylesData['indicator.Visible'] := False;
  TFormMusic.Create(Application).Show;
end;

procedure TFormMain.ButtonDialogColorPickerAlphaClick(Sender: TObject);
begin
  var Params: TDialogColorParams;
  Params.Title := 'Change color';
  Params.Color := TAlphaColors.Alpha;
  Params.Alpha := True;
  //Params.CheckText := 'Accept?';
  //Params.CheckValue := True;
  Params.Buttons := ['Ok', 'Cancel'];
  Params.AccentId := 0;
  Params.DefaultId := 1;
  Params.CanClose := True;

  var Res := TWinUIDialog.Show(Self, Params);
  ShowUIMessage(Self, 'Info',
    'Selected button is ' + Res.Result.ToString + #13#10 +
    'Check is ' + Res.IsChecked.ToString + #13#10 +
    'Color: "#' + IntToHex(Res.Color, 8) + '"');
end;

procedure TFormMain.ButtonDialogColorPickerClick(Sender: TObject);
begin
  var Params: TDialogColorParams;
  Params.Title := 'Change color';
  Params.Color := TAlphaColors.Coral;
  Params.Alpha := False;
  //Params.CheckText := 'Accept?';
  //Params.CheckValue := True;
  Params.Buttons := ['Ok', 'Cancel'];
  Params.AccentId := 0;
  Params.DefaultId := 1;
  Params.CanClose := True;

  var Res := TWinUIDialog.Show(Self, Params);
  ShowUIMessage(Self, 'Info',
    'Selected button is ' + Res.Result.ToString + #13#10 +
    'Check is ' + Res.IsChecked.ToString + #13#10 +
    'Color: "#' + IntToHex(Res.Color, 8) + '"');
end;

procedure TFormMain.ButtonDialogFrameClick(Sender: TObject);
begin   {
  var Frame := TFrameTestDialog.Create(Self);
  try
    var Res := TWinUIDialog.Show(Self, 'Install apps', Frame, ['OK', 'Fine', 'Close'], -1, 1, True);
    if Res <> MR_AUTOCLOSE then
      Frame.Free;
  except
    Frame.Free; //TFrameTestDialog - self free and auto close dialog
  end;   }

  var Frame := TFrameTestDialog.Create(Self);
  try
    TWinUIDialog.ShowInline(Self,
      procedure(Res: Integer)
      begin
        if Res <> MR_AUTOCLOSE then
          Frame.Free;
      end,
      'Install apps', Frame, ['OK', 'Fine', 'Close'], -1, 1, True);
  except
    Frame.Free; //TFrameTestDialog - self free and auto close dialog
  end;
end;

procedure TFormMain.ButtonDialogInputClick(Sender: TObject);
begin
  var Params: TDialogInputParams;
  Params.Title := 'Lorem substring';
  Params.InputTitle := 'Enter your name';
  Params.InputPrompt := 'Mark';
  Params.InputText := '';
  Params.CheckText := 'Accept?';
  Params.CheckValue := True;
  Params.Buttons := ['Done', 'Cancel'];
  Params.AccentId := 0;
  Params.DefaultId := 1;
  Params.CanClose := True;

  var Res := TWinUIDialog.Show(Self, Params);
  ShowUIMessage(Self, 'Info',
    'Selected button is ' + Res.Result.ToString + #13#10 +
    'Check is ' + Res.IsChecked.ToString + #13#10 +
    'Input: "' + Res.Input + '"');
end;

procedure TFormMain.ButtonDialogSMClick(Sender: TObject);
begin
  ShowUIMessage(Self, 'Your title', 'Simple show message text dialog');
end;

procedure TFormMain.ButtonDialogSMLargeClick(Sender: TObject);
begin
  ShowUIMessage(Self, 'Info', Memo1.Text + #13#10#13#10 + Memo2.Text);
end;

procedure TFormMain.ButtonDialogText1Click(Sender: TObject);
begin
  var Res := TWinUIDialog.Show(Self, 'Title', Memo1.Text,
    ['Yes', 'No'], 0, 1, False, TColors.Red);
  ShowUIMessage(Self, 'Info', 'Selected button is ' + Res.ToString);
end;

procedure TFormMain.ButtonDialogText2Click(Sender: TObject);
begin                 {
  var Params: TDialogTextParams;
  Params.Title := 'Lorem substring';
  Params.Body := Memo1.Text.Substring(0, 100);
  Params.CheckText := 'Save work on disk?';
  Params.CheckValue := True;
  Params.Buttons := ['Yes', 'No', 'Cancel'];
  Params.AccentId := 0;
  Params.DefaultId := 2;
  Params.CanClose := False;

  var Res := TWinUIDialog.Show(Self, Params);
  ShowUIMessage(Self, 'Info', 'Selected button is ' + Res.Result.ToString + #13#10 + 'Check is ' + Res.IsChecked.ToString); }


  var Params: TDialogTextParams;
  Params.Title := 'Lorem substring';
  Params.Body := Memo1.Text.Substring(0, 100);
  Params.CheckText := 'Save work on disk?';
  Params.CheckValue := True;
  Params.Buttons := ['Yes', 'No', 'Cancel'];
  Params.AccentId := 0;
  Params.DefaultId := 2;
  Params.FrameColor := TColors.Cornflowerblue;
  Params.CanClose := False;

  TWinUIDialog.ShowInline(Self,
    procedure(Res: TDialogResult)
    begin
      ShowUIMessage(Self, 'Info', 'Selected button is ' + Res.Result.ToString + #13#10 + 'Check is ' + Res.IsChecked.ToString);
    end,
    Params);
end;

procedure TFormMain.ButtonMenuActionsClick(Sender: TObject);
begin
  TabControlMain.ActiveTab := TabControlMain.Tabs[(Sender as TButton).Tag];
end;

procedure TFormMain.ButtonMenuActionsMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  TabControlMainChange(nil);
end;

procedure TFormMain.ButtonMoreFluentIconsClick(Sender: TObject);
begin
  //https://icones.js.org/collection/fluent
end;

procedure TFormMain.ArcDial2KeyDown(Sender: TObject; var Key: Word; var KeyChar: WideChar; Shift: TShiftState);
begin
  case Key of
    vkDown, vkLeft:
      ArcDial2.Value := ArcDial2.Value - Max(ArcDial2.Frequency, 1);
    vkUp, vkRight:
      ArcDial2.Value := ArcDial2.Value + Max(ArcDial2.Frequency, 1);
  end;
end;

procedure TFormMain.Button223Click(Sender: TObject);
begin
  TTask.Run(
    procedure
    begin
      Button1.BeginInvoke(
        procedure
        begin
          Button1.Text := 'Test';
        end, Button1);
    end);
end;

procedure TFormMain.Button240Click(Sender: TObject);
begin
  //mica
  SetWindowCaptionColor(TColors.Null);
  SetSystemBackdropType(TSystemBackdropType.DWMSBT_MAINWINDOW);
  SetExtendFrameIntoClientArea(TRect.Create(-1, -1, -1, -1));
  Fill.Kind := TBrushKind.Solid;
  Fill.Color := TAlphaColorRec.Null;
end;

procedure TFormMain.Button241Click(Sender: TObject);
begin
  //tabbed
  SetWindowCaptionColor(TColors.Null);
  SetSystemBackdropType(TSystemBackdropType.DWMSBT_TABBEDWINDOW);
  SetExtendFrameIntoClientArea(TRect.Create(-1, -1, -1, -1));
  Fill.Kind := TBrushKind.Solid;
  Fill.Color := TAlphaColorRec.Null;
end;

procedure TFormMain.Button242Click(Sender: TObject);
begin
  //acrilyc
  SetWindowCaptionColor(TColors.Null);
  SetSystemBackdropType(TSystemBackdropType.DWMSBT_TRANSIENTWINDOW);
  SetExtendFrameIntoClientArea(TRect.Create(-1, -1, -1, -1));
  Fill.Kind := TBrushKind.Solid;
  Fill.Color := TAlphaColorRec.Null;
end;

procedure TFormMain.Button243Click(Sender: TObject);
begin
  //none
  SetSystemBackdropType(TSystemBackdropType.DWMSBT_DISABLE);
  SetExtendFrameIntoClientArea(TRect.Create(-1, -1, -1, -1));
  SetWindowCaptionColor($1C1C1C);
  Fill.Kind := TBrushKind.Solid;
  Fill.Color := $FF1C1C1C;
end;

procedure TFormMain.Button284Click(Sender: TObject);
begin
  for var Control in PanelStoreMenu.Controls do
    if Control is TButton then
      TButton(Control).IsPressed := Control = Sender;
end;

procedure TFormMain.ButtonInfoBarShowClick(Sender: TObject);
begin
  var Params: TInfoBarParams;
  Params.Title := EditInfoBarTitle.Text;
  Params.Body := MemoInfoBarBody.Text;
  Params.ActionText := EditInfoBarAction.Text;
  Params.CanClose := CheckBoxInfoBarCanClose.IsChecked;
  Params.InfoType := TInfoBarType(PopupBoxInfoBarType.ItemIndex);
  Params.BarPosition := TInfoBarPosition(PopupBoxInfoBarPos.ItemIndex);
  Params.ActionAsHyperLink := CheckBoxInfoBarHyper.IsChecked;
  Params.ActionIsClose := CheckBoxInfoBarActionIsClose.IsChecked;
  Params.AutoCloseDelay := Trunc(SpinBoxInfoBarAC.Value) * 1000;
  Params.AsPanel := CheckBoxInfoBarAsPanel.IsChecked;
  TWinUIDialog.ShowInfoBar(LayoutContent,
    procedure(WasAction: Boolean)
    begin
      if WasAction then
        ShowUIMessage(Self, 'Was action pressed');
    end, nil, Params);
end;

procedure TFormMain.ButtonShareClick(Sender: TObject);
begin
  {$IFDEF MSWINDOWS}
  TWinUIDialog.ShowShare(Self,
    procedure(Share: TShareContract)
    begin
      //Share.DataText := '...display WinRT UI objects that depend on CoreWindow.';
      //Share.FileList.Add('D:\Downloads\8521_christmas_ornament_icon.png');
      Share.FileList.Add('D:\Downloads\55.txt');
      Share.FileList.Add('D:\Downloads\9785977532891.zip');
      Share.DataTitle := 'In a desktop app...';
      Share.ApplicationName := 'WinUI 3 Test';
      //Share.ImageFile := 'D:\Downloads\75614.jpg';
      //Share.IconFile := 'D:\Downloads\75614.jpg';
      //Share.LogoFile := 'D:\Downloads\75614.jpg';
    end);
  {$ENDIF}
end;

procedure TFormMain.ButtonNotifyClick(Sender: TObject);
begin
  {$IFDEF MSWINDOWS}
  const DefImg = 'C:\Windows\System32\@facial-recognition-windows-hello.gif';

  var NotifyContent := TToastContentBuilder.Create
    .UseButtonStyle(True)
    .AddText(TToastText.Create.Text('{title}'))
    .AddText(TToastText.Create.Text('This is the Windows 10+ notifications engine for Delphi'))
    .AddGroup(TToastGroup.Create.SubGroups([
    TToastSubGroup.Create
    .HintWeight(1)
    .AddText(TToastText.Create.Text('Mon').HintAlign(TToastTextAlign.Center))
    .AddImage(TToastImage.Create.Src(DefImg).HintRemoveMargin(True))
    .AddText(TToastText.Create.Text('63°').HintAlign(TToastTextAlign.Center))
    .AddText(TToastText.Create.Text('42°').HintAlign(TToastTextAlign.Center).HintStyle(TToastTextStyle.CaptionSubtle)),
    TToastSubGroup.Create
    .HintWeight(1)
    .AddText(TToastText.Create.Text('Tue').HintAlign(TToastTextAlign.Center))
    .AddImage(TToastImage.Create.Src(DefImg).HintRemoveMargin(True))
    .AddText(TToastText.Create.Text('57°').HintAlign(TToastTextAlign.Center))
    .AddText(TToastText.Create.Text('38°').HintAlign(TToastTextAlign.Center).HintStyle(TToastTextStyle.CaptionSubtle)),
    TToastSubGroup.Create
    .HintWeight(1)
    .AddText(TToastText.Create.Text('Wed').HintAlign(TToastTextAlign.Center))
    .AddImage(TToastImage.Create.Src(DefImg).HintRemoveMargin(True))
    .AddText(TToastText.Create.Text('59°').HintAlign(TToastTextAlign.Center))
    .AddText(TToastText.Create.Text('43°').HintAlign(TToastTextAlign.Center).HintStyle(TToastTextStyle.CaptionSubtle)),
    TToastSubGroup.Create
    .HintWeight(1)
    .AddText(TToastText.Create.Text('Thu').HintAlign(TToastTextAlign.Center))
    .AddImage(TToastImage.Create.Src(DefImg).HintRemoveMargin(True))
    .AddText(TToastText.Create.Text('62°').HintAlign(TToastTextAlign.Center))
    .AddText(TToastText.Create.Text('42°').HintAlign(TToastTextAlign.Center).HintStyle(TToastTextStyle.CaptionSubtle)),
    TToastSubGroup.Create
    .HintWeight(1)
    .AddText(TToastText.Create.Text('Fri').HintAlign(TToastTextAlign.Center))
    .AddImage(TToastImage.Create.Src(DefImg).HintRemoveMargin(True))
    .AddText(TToastText.Create.Text('71°').HintAlign(TToastTextAlign.Center))
    .AddText(TToastText.Create.Text('66°').HintAlign(TToastTextAlign.Center).HintStyle(TToastTextStyle.CaptionSubtle))
    ]))
    .Audio(TToastAudio.Create.Src(TSoundEventValue.NotificationSMS).Loop(False))
    .AddInputBox(TToastTextBox.Create.Id('editbox-id').Title('Title').PlaceholderContent('Enter name'))
    .AddSelectionBox(TToastSelectionBox.Create.Id('combo').Title('Choose').Items([
    TToastSelectionBoxItem.Create('id_1', 'Yes'),
    TToastSelectionBoxItem.Create('id_2', 'No')
    ]))
    .AddButton(TToastAction.Create.Content('Cancel').ActivationType(TActivationType.Foreground).Arguments('cancel').HintButtonStyle(TToastActionButtonStyle.Critical))
    .AddButton(TToastAction.Create.Content('View more').ActivationType(TActivationType.Foreground).Arguments('view').HintInputId('editbox-id'));

  var Notif: TNotification;
  Notif := TNotification.Create(FNotifyManager, NotifyContent);
  Notif.Tag := 'notification1';
  // Data binded values
  Notif.Data['title'] := 'Hello world!';
  Notif.Data['download-pos'] := '0';
  // Events (must be defined in your form class)
  Notif.OnActivated := NotifActivated;
  Notif.OnDismissed := NotifDismissed;

  FNotifyManager.ShowNotification(Notif);

  {
  // Update
  const DownloadValue = Notif.Data['download-pos'].ToSingle + 0.1;
  Notif.Data['download-pos'] := DownloadValue.ToString;
  if DownloadValue >= 1 then
    Notif.Data['title'] := 'Download finalised!';

  FNotifyManager.UpdateNotification(Notif);  }
  {$ENDIF}
end;

{$IFDEF MSWINDOWS}

procedure TFormMain.NotifActivated(Sender: TNotification; Arguments: string; UserInput: TUserInputMap);
begin
  if Arguments = 'view' then
  begin
    // Get value of edit box (if there is one with this id)
    var Value := UserInput.GetStringValue('editbox-id');
    ShowUIMessage(Self, 'NotifActivated', Value);
  end;
end;

procedure TFormMain.NotifDismissed(Sender: TNotification; Reason: TToastDismissReason);
begin
  ShowUIMessage(Self, 'NotifDismissed', Ord(Reason).ToString);
end;

{$ENDIF}

procedure TFormMain.ColorButton1Click(Sender: TObject);
begin
  //
  PathTestLine.Stroke.Color := (Sender as TColorButton).Color;
  for var Control in (Sender as TControl).ParentControl.Controls do
    if Control is TColorButton then
    begin
      TColorButton(Control).IsPressed := Sender = Control;
    end;
end;

procedure TFormMain.ColorComboBox1Change(Sender: TObject);
begin
  ColorButton3.Color := ColorComboBox1.Color;
end;

procedure TFormMain.ColorPanel1Change(Sender: TObject);
begin
  Fill.Kind := TBrushKind.Gradient;
  Fill.Gradient.Color := ColorPanel1.Color;
  Fill.Gradient.Color1 := ColorPanel3.Color;
end;

procedure TFormMain.DropTarget1Dropped(Sender: TObject; const Data: TDragObject; const Point: TPointF);
begin
  if Length(Data.Files) > 0 then
    DropTarget1.Text := Data.Files[0];
end;

procedure TFormMain.EditButton2Click(Sender: TObject);
begin
  EditExampleCap.SelectAll;
  EditExampleCap.CopyToClipboard;
  EditExampleCap.SelLength := 0;
end;

procedure TFormMain.EditButton3Click(Sender: TObject);
begin
  EditExampleBody.SelectAll;
  EditExampleBody.CopyToClipboard;
  EditExampleBody.SelLength := 0;
end;

procedure TFormMain.EditButton4Click(Sender: TObject);
begin
  EditExampleBodyS.SelectAll;
  EditExampleBodyS.CopyToClipboard;
  EditExampleBodyS.SelLength := 0;
end;

procedure TFormMain.EditButton5Click(Sender: TObject);
begin
  EditExampleSubT.SelectAll;
  EditExampleSubT.CopyToClipboard;
  EditExampleSubT.SelLength := 0;
end;

procedure TFormMain.EditButton6Click(Sender: TObject);
begin
  EditExampleTitle.SelectAll;
  EditExampleTitle.CopyToClipboard;
  EditExampleTitle.SelLength := 0;
end;

procedure TFormMain.EditButton7Click(Sender: TObject);
begin
  EditExampleTitleL.SelectAll;
  EditExampleTitleL.CopyToClipboard;
  EditExampleTitleL.SelLength := 0;
end;

procedure TFormMain.EditButton8Click(Sender: TObject);
begin
  EditExampleDisplay.SelectAll;
  EditExampleDisplay.CopyToClipboard;
  EditExampleDisplay.SelLength := 0;
end;

procedure TFormMain.FSearchItemClick(Sender: TObject);
begin
  EditSearch.Text := (Sender as TListBoxItem).Text;
  if not PopupSearch.ClosingAnimation then
    PopupSearch.IsOpen := False;
  TryOpenTabByName(EditSearch.Text);
end;

procedure TFormMain.EditSearchChangeTracking(Sender: TObject);
begin
  if EditSearch.Tag = 100 then
    Exit;
  if not EditSearch.Text.IsEmpty then
  begin
    var SearchText := EditSearch.Text;
    if (EditSearch.SelLength > 0) and (EditSearch.SelStart = 0) then
      SearchText := EditSearch.Text.Substring(0, EditSearch.SelLength);
    SearchText := SearchText.ToLower;
    var SameItem := '';
    ListBoxSearch.BeginUpdate;
    try
      ListBoxSearch.Clear;
      ListBoxSearch.Enabled := True;
      for var i := 0 to TabControlMain.TabCount - 1 do
      begin
        if TabControlMain.Tabs[i].Text.ToLower.Contains(SearchText) then
        begin
          if SameItem.IsEmpty then
            if TabControlMain.Tabs[i].Text.ToLower.StartsWith(SearchText) then
              SameItem := TabControlMain.Tabs[i].Text;
          var Item := TListBoxItem.Create(ListBoxSearch);
          Item.Text := TabControlMain.Tabs[i].Text;
          Item.HitTest := True;
          Item.OnClick := FSearchItemClick;
          ListBoxSearch.AddObject(Item);
        end;
      end;
    finally
      ListBoxSearch.EndUpdate;
    end;
    if not SameItem.IsEmpty then
    begin
      var AutoFill := SameItem.Remove(0, EditSearch.Text.Length);
      if EditSearch.TagString.Length >= EditSearch.Text.Length then
        AutoFill := '';
      EditSearch.TagString := EditSearch.Text;
      if not AutoFill.IsEmpty then
      begin
        EditSearch.Tag := 100;
        var L := EditSearch.Text.Length;
        EditSearch.Text := EditSearch.Text + AutoFill;
        EditSearch.SelStart := L;
        EditSearch.SelLength := AutoFill.Length;
        EditSearch.Tag := 0;
      end;
    end
    else
      EditSearch.TagString := EditSearch.Text;
    if ListBoxSearch.Count <= 0 then
    begin
      if PopupSearch.IsOpen then
      begin
        var Item := TListBoxItem.Create(ListBoxSearch);
        Item.Text := 'Not found';
        Item.Enabled := False;
        Item.HitTest := True;
        Item.OnClick := nil;
        ListBoxSearch.Enabled := False;
        ListBoxSearch.AddObject(Item);
      end;
    end;
    PopupSearch.Height := Min(ListBoxSearch.Count * ListBoxSearch.ItemHeight, ListBoxSearch.ItemHeight * 6) + ListBoxSearch.Margins.Top + ListBoxSearch.Margins.Bottom;
    if not PopupSearch.IsOpen then
    begin
      PopupSearch.VerticalOffset := -1;
      PopupSearch.PlacementTarget := EditSearch;
      PopupSearch.Width := EditSearch.Width;
      PopupSearch.Placement := TPlacement.Bottom;
      PopupSearch.IsOpen := True;
    end;
  end
  else
    PopupSearch.IsOpen := False;
end;

procedure TFormMain.EditSearchKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  if Key = vkEscape then
    PopupSearch.IsOpen := False;
  if PopupSearch.IsOpen and ListBoxSearch.Enabled and (Key in [vkUp, vkDown, vkReturn]) then
    (ListBoxSearch as IControl).KeyDown(Key, KeyChar, Shift);
end;

procedure TFormMain.EditSearchKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  if PopupSearch.IsOpen and ListBoxSearch.Enabled and (Key in [vkUp, vkDown]) then
    (ListBoxSearch as IControl).KeyUp(Key, KeyChar, Shift)
  else if PopupSearch.IsOpen and ListBoxSearch.Enabled and (Key in [vkReturn]) and Assigned(ListBoxSearch.Selected) then
    (ListBoxSearch as IControl).KeyUp(Key, KeyChar, Shift)
  else if Key = vkReturn then
    TryOpenTabByName(EditSearch.Text);
end;

procedure TFormMain.EditWrongTestChangeTracking(Sender: TObject);
begin
  LabelWrongTest.Visible := EditWrongTest.Text.Length < 3;
  Invalidate;
end;

procedure TFormMain.TryOpenTabByName(const Text: string);
begin
  for var i := 0 to TabControlMain.TabCount - 1 do
    if TabControlMain.Tabs[i].Text = Text then
    begin
      TabControlMain.TabIndex := i;
      Exit;
    end;
  for var i := 0 to TabControlMain.TabCount - 1 do
    if TabControlMain.Tabs[i].Text.ToLower = Text.ToLower then
    begin
      TabControlMain.TabIndex := i;
      Exit;
    end;
end;

procedure TFormMain.FormActivate(Sender: TObject);
begin
  //Fill.Kind := TBrushKind.Gradient;
end;

procedure TFormMain.FormDeactivate(Sender: TObject);
begin
  //Fill.Kind := TBrushKind.None;
end;

procedure TFormMain.FormDestroy(Sender: TObject);
begin
  //
end;

procedure TFormMain.HorzScrollBoxFilterViewportPositionChange(Sender: TObject; const OldViewportPosition, NewViewportPosition: TPointF; const ContentSizeChanged: Boolean);
begin
  ButtonScrollFilterLeft.Visible := NewViewportPosition.X <> 0;
  ButtonScrollFilterRight.Visible := NewViewportPosition.X + HorzScrollBoxFilter.Width < HorzScrollBoxFilter.ContentBounds.Width;
end;

procedure TFormMain.ButtonScrollFilterLeftClick(Sender: TObject);
begin
  HorzScrollBoxFilter.AniCalculations.MouseWheel(-HorzScrollBoxFilter.Width / 3, 0);
end;

procedure TFormMain.ButtonScrollFilterRightClick(Sender: TObject);
begin
  HorzScrollBoxFilter.AniCalculations.MouseWheel(+HorzScrollBoxFilter.Width / 3, 0);
end;

procedure TFormMain.HorzScrollBoxSpinViewportPositionChange(Sender: TObject; const OldViewportPosition, NewViewportPosition: TPointF; const ContentSizeChanged: Boolean);
begin
  var VH := HorzScrollBoxSpin.Width / 2;
  var MaxOffset := 30;
  for var Control in HorzScrollBoxSpin.Content.Controls do
  begin
    if Control.Position.X + Control.Width < NewViewportPosition.X then
      Continue;
    if Control.Position.X > NewViewportPosition.X + HorzScrollBoxSpin.Width then
      Continue;
    var Offset: Single;
    var OffPos := (Control.Position.X + Control.Width / 2) - NewViewportPosition.X;
    var Distance := Abs(OffPos - VH);
    Offset := Min(Control.Width - 10, (Distance / VH) * MaxOffset);
    Control.Margins.Rect := TRectF.Create(Control.Margins.Left, Offset, Control.Margins.Right, Offset);
    if Control is TButton then
    begin
      (Control as TButton).StyledSettings := (Control as TButton).StyledSettings - [TStyledSetting.Size];
      (Control as TButton).TextSettings.Font.Size := 14 * Max(0.6, ((MaxOffset - Offset) / MaxOffset));
      (Control as TButton).Opacity := Max(0.4, ((MaxOffset - Offset) / MaxOffset));
    end;
  end;
end;

procedure TFormMain.ListBoxSearchKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  if Key = vkReturn then
    if Assigned(ListBoxSearch.Selected) then
      FSearchItemClick(ListBoxSearch.Selected);
end;

procedure TFormMain.MenuItem1Click(Sender: TObject);
begin
  //
end;

procedure TFormMain.TabControlMainChange(Sender: TObject);
begin
  if not Assigned(TabControlMain.ActiveTab) then
    Exit;
  for var Control in VertScrollBoxMenu.Content.Controls do
    if Control is TButton then
      TButton(Control).IsPressed := Control.Tag = TabControlMain.ActiveTab.Index;
end;

procedure TFormMain.TabItemAddClick(Sender: TObject);
begin
  if TabControlView.ActiveTab = TabItemAdd then
  begin
    var Tab := TabControlView.Add;
    Tab.AutoSize := False;
    Tab.Width := 180;
    Tab.StyleLookup := 'tabitemstyle_view';
    Tab.IsSelected := True;
    Tab.StylesData['close.OnClick'] := TValue.From<TNotifyEvent>(FOnTabCloseClick);
    Tab.Text := 'Tab name ' + TabControlView.Tag.ToString;
    TabControlView.Tag := TabControlView.Tag + 1;
    TabItemAdd.Index := TabControlView.TabCount - 1;
  end;
end;

procedure TFormMain.FOnTabCloseClick(Sender: TObject);
begin
  var Btn := Sender as TControl;
  //
  var Tab := TFMXObjectHelper.GetNearestParentOfClass<TTabItem>(Btn);
  if Assigned(Tab) then
    Tab.Release;
end;

procedure TFormMain.VertScrollBoxCaruselViewportPositionChange(Sender: TObject; const OldViewportPosition, NewViewportPosition: TPointF; const ContentSizeChanged: Boolean);
begin
  var VH := VertScrollBoxCarusel.Height / 2;
  var MaxOffset := 40;
  for var Control in VertScrollBoxCarusel.Content.Controls do
  begin
    if Control.Position.Y + Control.Height < NewViewportPosition.Y then
      Continue;
    if Control.Position.Y > NewViewportPosition.Y + VertScrollBoxCarusel.Height then
      Continue;
    var Offset: Single;
    var OffPos := (Control.Position.Y + Control.Height / 2) - NewViewportPosition.Y;
    var Distance := Abs(OffPos - VH);
    Offset := Min(Control.Width - 10, (Distance / VH) * MaxOffset);
    Control.Margins.Rect := TRectF.Create(Offset, Control.Margins.Top, Offset, Control.Margins.Bottom);
    if Control is TButton then
    begin
      (Control as TButton).StyledSettings := (Control as TButton).StyledSettings - [TStyledSetting.Size];
      (Control as TButton).TextSettings.Font.Size := 14 * Max(0.6, ((MaxOffset - Offset) / MaxOffset));
      (Control as TButton).Opacity := Max(0.4, ((MaxOffset - Offset) / MaxOffset));
    end;
  end;
end;

procedure TFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //
end;

procedure TFormMain.FOnSubMenuClick(Sender: TObject);
begin
  ShowUIMessage(Self, (Sender as TMenuItem).StyleName);
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  CaptionControls := [LayoutCaption, LayoutHead];
  HideTitleBar := True;
  ScrollBox1.AniCalculations.Animation := True;
  ScrollBox2.AniCalculations.Animation := True;
  ScrollBox3.AniCalculations.Animation := True;
  ScrollBox4.AniCalculations.Animation := True;
  ScrollBox5.AniCalculations.Animation := True;
  ScrollBox6.AniCalculations.Animation := True;
  ScrollBox7.AniCalculations.Animation := True;
  VertScrollBox2.AniCalculations.Animation := True;
  VertScrollBoxCarusel.AniCalculations.Animation := True;
  VertScrollBox1.AniCalculations.Animation := True;
  VertScrollBox3.AniCalculations.Animation := True;
  VertScrollBoxMenu.AniCalculations.Animation := True;
  HorzScrollBoxSpin.AniCalculations.Animation := True;
  Grid1.AniCalculations.Animation := True;
  StringGrid1.AniCalculations.Animation := True;
  Memo1.ScrollAnimation := TBehaviorBoolean.True;
  Memo2.ScrollAnimation := TBehaviorBoolean.True;
  Memo3.ScrollAnimation := TBehaviorBoolean.True;
  Memo4.ScrollAnimation := TBehaviorBoolean.True;
  MemoInfoBarBody.ScrollAnimation := TBehaviorBoolean.True;

  ListBox1.AniCalculations.Animation := True;
  ListBox2.AniCalculations.Animation := True;
  ListBox3.AniCalculations.Animation := True;
  ListBox4.AniCalculations.Animation := True;
  ListBox5.AniCalculations.Animation := True;
  ListBox6.AniCalculations.Animation := True;
  ListBox7.AniCalculations.Animation := True;
  ListBox8.AniCalculations.Animation := True;
  ListBox9.AniCalculations.Animation := True;
  ListBox10.AniCalculations.Animation := True;
  ListBox11.AniCalculations.Animation := True;
  ListBox13.AniCalculations.Animation := True;
  TreeView1.AniCalculations.Animation := True;
  ColorListBox1.AniCalculations.Animation := True;
  ListBoxSearch.AniCalculations.Animation := True;
  HorzScrollBoxFilter.AniCalculations.Animation := True;

  ButtonDemoGallery.StylesData['detail'] := 'Open demo window';
  ButtonDemoIDE.StylesData['detail'] := 'Open demo window';
  ButtonDemoMusic.StylesData['detail'] := 'Open demo window';

  ArcDial2.CanFocus := True;

  MenuItem1.DisableDisappear := True;
  MenuItem1.StylesData['copy.OnClick'] := TValue.From<TNotifyEvent>(FOnSubMenuClick);
  MenuItem1.StylesData['copy.ClickImmediately'] := True;
  MenuItem1.StylesData['cut.OnClick'] := TValue.From<TNotifyEvent>(FOnSubMenuClick);
  MenuItem1.StylesData['paste.OnClick'] := TValue.From<TNotifyEvent>(FOnSubMenuClick);
  MenuItem1.StylesData['delete.OnClick'] := TValue.From<TNotifyEvent>(FOnSubMenuClick);

  MenuItem24.StylesData['bold.TextSettings.HorzAlign'] := TValue.From<TTextAlign>(TTextAlign.Center);
  MenuItem24.StylesData['italic.TextSettings.HorzAlign'] := TValue.From<TTextAlign>(TTextAlign.Center);
  MenuItem24.StylesData['underline.TextSettings.HorzAlign'] := TValue.From<TTextAlign>(TTextAlign.Center);

  for var i := 0 to VertScrollBoxCarusel.Content.ControlsCount - 1 do
    if VertScrollBoxCarusel.Content.Controls[i] is TButton then
      (VertScrollBoxCarusel.Content.Controls[i] as TButton).Text := ColorListBox1.ListItems[i].Text;

  for var i := 0 to HorzScrollBoxSpin.Content.ControlsCount - 1 do
    if HorzScrollBoxSpin.Content.Controls[i] is TButton then
      (HorzScrollBoxSpin.Content.Controls[i] as TButton).Text := ColorListBox1.ListItems[i].Text;
  TabViewTest;
  CreateNotificationCenter;

  Button15.StylesData['arrow.OnClick'] := TValue.From<TNotifyEvent>(FOnButton15SplitClick);

  TabControlMain.ActiveTab := TabItemButtons;
  TabControlMain.ActiveTab := TabItemHome;

  BeginLauncher(
    procedure
    begin
      LayoutContent.Visible := False;
      LayoutLauncher.Visible := True;
      TimerEndLaunch.Enabled := True;
    end);
end;

procedure TFormMain.FOnButton15SplitClick(Sender: TObject);
begin
  var Pt := Button15.AbsoluteRect.TopLeft;
  Pt := ClientToScreen(Pt);
  PopupMenu1.Popup(Pt.X + 8, Pt.Y + Button15.Height + 16);
end;

procedure TFormMain.CreateNotificationCenter;
begin
  {$IFDEF MSWINDOWS}
  FNotifyManager := TNotificationManager.Create(Self, 'WinUI3.Delphi.Test');

  FNotifyManager.ApplicationName := 'WinUI 3 Demo Application';
  FNotifyManager.ShowInSettings := True;
  FNotifyManager.ApplicationIcon := TPath.Combine(TPath.GetLibraryPath, 'Assets\Header-WinUIGallery.png');
  {$ENDIF}
end;

procedure TFormMain.TabViewTest;
begin
  for var i := TabControlView.TabCount - 1 downto 0 do
    if TabControlView.Tabs[i] <> TabItemAdd then
      TabControlView.Delete(i);
end;

procedure TFormMain.TimerEndLaunchTimer(Sender: TObject);
begin
  TimerEndLaunch.Enabled := False;
  EndLauncher(
    procedure
    begin
      LayoutContent.Visible := True;
      LayoutLauncher.Visible := False;
    end);
end;

procedure TFormMain.TrackBarLineSizeChange(Sender: TObject);
begin
  PathTestLine.Stroke.Thickness := TrackBarLineSize.Value;
end;

initialization
  ReportMemoryLeaksOnShutdown := True;

end.

