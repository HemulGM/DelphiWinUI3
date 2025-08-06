unit WinUI3.Gallery;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, System.ImageList,
  FMX.ImgList, FMX.MultiView, FMX.Objects, FMX.Edit, Data.Bind.EngExt,
  Fmx.Bind.DBEngExt, System.Rtti, System.Bindings.Outputs, Fmx.Bind.Editors,
  Data.Bind.Components, FMX.Ani, FMX.TabControl, System.Generics.Collections,
  FMX.Memo, WinUI3.Main, WinUI3.Form;

type
  TNavigationItem = record
    Button: TButton;
    Parent: TControl;
    Tab: TTabItem;
  end;

  TNavigation = TList<TNavigationItem>;

  TFormGallery = class(TWinUIForm)
    ButtonHome: TButton;
    ButtonAll: TButton;
    ButtonDateTime: TButton;
    ButtonCollections: TButton;
    ButtonBasic: TButton;
    ButtonSettings: TButton;
    Panel15: TPanel;
    ImageListIcons: TImageList;
    LayoutClient: TLayout;
    LayoutMenu: TLayout;
    ButtonMenu: TButton;
    VertScrollBoxMenu: TVertScrollBox;
    ButtonDialogs: TButton;
    ButtonLayout: TButton;
    Panel1: TPanel;
    LayoutContent: TLayout;
    PanelBG: TPanel;
    LayoutPaths: TLayout;
    PathHome: TPath;
    PathSystem: TPath;
    PathBasic: TPath;
    PathDateTime: TPath;
    PathWindowing: TPath;
    PathCollections: TPath;
    PathAll: TPath;
    PathText: TPath;
    PathStatusInfo: TPath;
    PathDialogs: TPath;
    PathScroll: TPath;
    PathDesignGuid: TPath;
    PathLayout: TPath;
    PathStyles: TPath;
    PathSettings: TPath;
    PathNav: TPath;
    PathMotion: TPath;
    ButtonMedia: TButton;
    ButtonMenus: TButton;
    ButtonMotions: TButton;
    ButtonNav: TButton;
    ButtonScrolling: TButton;
    ButtonStatusInfo: TButton;
    ButtonStyles: TButton;
    ButtonSystem: TButton;
    ButtonText: TButton;
    ButtonWindowing: TButton;
    PathMedia: TPath;
    PathMenus: TPath;
    LayoutSearch: TLayout;
    ButtonSearch: TButton;
    PathSearch: TPath;
    EditSearch: TEdit;
    SearchEditButton1: TSearchEditButton;
    ButtonDesignGuid: TButton;
    LayoutFooter: TLayout;
    LayoutMenuView: TLayout;
    FloatAnimationMenu: TFloatAnimation;
    TabControlMain: TTabControl;
    TabItemHome: TTabItem;
    TabItemDesign: TTabItem;
    TabItemAll: TTabItem;
    TabItemBasic: TTabItem;
    TabItemCollect: TTabItem;
    TabItemDateTime: TTabItem;
    TabItemDialogs: TTabItem;
    TabItemLayout: TTabItem;
    TabItemMedia: TTabItem;
    TabItemMenus: TTabItem;
    TabItemMotions: TTabItem;
    TabItemNav: TTabItem;
    TabItemScroll: TTabItem;
    TabItemStatus: TTabItem;
    TabItemStyles: TTabItem;
    TabItemSystem: TTabItem;
    TabItemText: TTabItem;
    TabItemWindowsing: TTabItem;
    FlowLayoutBasic: TFlowLayout;
    VertScrollBoxBasic: TVertScrollBox;
    Button1: TButton;
    Layout1: TLayout;
    ImageListPreview: TImageList;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    Button11: TButton;
    Button12: TButton;
    Button13: TButton;
    Button14: TButton;
    Button15: TButton;
    Label1: TLabel;
    LayoutBasic: TLayout;
    TabItemSettings: TTabItem;
    ButtonButton: TButton;
    ButtonCheckBox: TButton;
    ButtonColorPicker: TButton;
    ButtonComboBox: TButton;
    ButtonDropDownButton: TButton;
    ButtonHyperlinkButton: TButton;
    ButtonInputValidation: TButton;
    ButtonRadioButton: TButton;
    ButtonRatingControl: TButton;
    ButtonToggleSplitButton: TButton;
    ButtonToggleButton: TButton;
    ButtonSplitButton: TButton;
    ButtonSlider: TButton;
    ButtonRepeatButton: TButton;
    ButtonToggleSwitch: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ButtonMenuClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure ButtonSearchClick(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure ButtonAllClick(Sender: TObject);
    procedure FloatAnimationMenuFinish(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FlowLayoutBasicResize(Sender: TObject);
    procedure ButtonBasicClick(Sender: TObject);
  private
    FIsMenuOpen: Boolean;
    FNavigation: TNavigation;
    procedure RegNav(Button: TButton; Parent: TControl; Tab: TTabItem; Path: TPath);
    procedure SetTab(Sender: TObject);
    procedure UpdateButtons(IsMenuOpen: Boolean);
  public
    property IsMenuOpen: Boolean read FIsMenuOpen;
  end;

var
  FormGallery: TFormGallery;

implementation

uses
  DelphiWindowStyle.FMX, System.Math;

{$R *.fmx}

procedure TFormGallery.ButtonAllClick(Sender: TObject);
begin
  TThread.ForceQueue(nil,
    procedure
    begin
      SetTab(Sender);
    end);
end;

procedure TFormGallery.ButtonBasicClick(Sender: TObject);
begin
  ButtonAllClick(ButtonBasic);
  if LayoutBasic.Height = ButtonBasic.Height then
    LayoutBasic.Height := LayoutBasic.ControlsCount * ButtonBasic.Height
  else
    LayoutBasic.Height := ButtonBasic.Height;
end;

procedure TFormGallery.ButtonMenuClick(Sender: TObject);
begin
  if ButtonMenu.Tag <> 0 then
    Exit;
  if IsMenuOpen then
  begin
    FIsMenuOpen := False;
    ButtonMenu.Tag := -1;
    EditSearch.Visible := False;
    ButtonSearch.Visible := True;
    VertScrollBoxMenu.ShowScrollBars := False;
    FloatAnimationMenu.StopAtCurrent;
    FloatAnimationMenu.Inverse := True;
    FloatAnimationMenu.Start;
    //LayoutMenuView.Width := 48;
  end
  else
  begin
    FIsMenuOpen := True;
    ButtonMenu.Tag := -1;
    ButtonSearch.Visible := False;
    EditSearch.Visible := True;
    FloatAnimationMenu.StopAtCurrent;
    FloatAnimationMenu.Inverse := False;
    FloatAnimationMenu.Start;
    //LayoutMenuView.Width := LayoutMenuView.Tag;
  end;
  if IsMenuOpen then
    LayoutContent.Width := Width - 320 - 16
  else
    LayoutContent.Width := Width - 48 - 16;
  UpdateButtons(FIsMenuOpen);
end;

procedure TFormGallery.UpdateButtons(IsMenuOpen: Boolean);
begin

end;

procedure TFormGallery.SetTab(Sender: TObject);
begin
  for var Item in FNavigation do
  begin
    Item.Button.IsPressed := Sender = Item.Button;
    if Item.Parent = Item.Button then
      Item.Button.IsPressed := True;
    if Sender = Item.Button then
      TabControlMain.ActiveTab := Item.Tab;
  end;
end;

procedure TFormGallery.ButtonSearchClick(Sender: TObject);
begin
  ButtonMenuClick(nil);
  if EditSearch.IsVisible then
    EditSearch.SetFocus;
end;

procedure TFormGallery.FloatAnimationMenuFinish(Sender: TObject);
begin
  ButtonMenu.Tag := 0;
  if FloatAnimationMenu.Inverse then
  begin
   //
  end
  else
  begin
    VertScrollBoxMenu.ShowScrollBars := True;
  end;
end;

procedure TFormGallery.FlowLayoutBasicResize(Sender: TObject);
begin
  var H := 0.0;
  for var Control in FlowLayoutBasic.Controls do
    H := Max(H, Control.BoundsRect.Bottom);
  FlowLayoutBasic.Height := H + FlowLayoutBasic.HorizontalGap;
end;

procedure TFormGallery.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
end;

procedure TFormGallery.FormCreate(Sender: TObject);
begin
  FNavigation := TList<TNavigationItem>.Create;

  VertScrollBoxMenu.AniCalculations.Animation := True;
  VertScrollBoxBasic.AniCalculations.Animation := True;
  TabControlMain.TabPosition := TTabPosition.None;

  FIsMenuOpen := False;
  LayoutMenuView.Width := 48;

  RegNav(ButtonHome, nil, TabItemHome, PathHome);
  RegNav(ButtonAll, nil, TabItemAll, PathAll);
  RegNav(ButtonDateTime, nil, TabItemDateTime, PathDateTime);
  RegNav(ButtonCollections, nil, TabItemCollect, PathCollections);
  RegNav(ButtonBasic, LayoutBasic, TabItemBasic, PathBasic);
  RegNav(ButtonDialogs, nil, TabItemDialogs, PathDialogs);
  RegNav(ButtonLayout, nil, TabItemLayout, PathLayout);
  RegNav(ButtonMedia, nil, TabItemMedia, PathMedia);
  RegNav(ButtonMenus, nil, TabItemMenus, PathMenus);
  RegNav(ButtonMotions, nil, TabItemMotions, PathMotion);
  RegNav(ButtonNav, nil, TabItemNav, PathNav);
  RegNav(ButtonScrolling, nil, TabItemScroll, PathScroll);
  RegNav(ButtonStatusInfo, nil, TabItemStatus, PathStatusInfo);
  RegNav(ButtonStyles, nil, TabItemStyles, PathStyles);
  RegNav(ButtonSystem, nil, TabItemSystem, PathSystem);
  RegNav(ButtonText, nil, TabItemText, PathText);
  RegNav(ButtonWindowing, nil, TabItemWindowsing, PathWindowing);
  RegNav(ButtonSettings, nil, TabItemSettings, PathSettings);
  RegNav(ButtonSearch, nil, nil, PathSearch);
  RegNav(ButtonDesignGuid, nil, TabItemDesign, PathDesignGuid);
end;

procedure TFormGallery.FormDestroy(Sender: TObject);
begin
  FNavigation.Free;
end;

procedure TFormGallery.FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  StartWindowDrag;
end;

procedure TFormGallery.FormResize(Sender: TObject);
begin
  if IsMenuOpen then
    LayoutContent.Width := Width - LayoutMenuView.Tag - 16
  else
    LayoutContent.Width := LayoutClient.Width;
end;

procedure TFormGallery.RegNav(Button: TButton; Parent: TControl; Tab: TTabItem; Path: TPath);
begin
  var Item: TNavigationItem;
  Item.Button := Button;
  Item.Parent := Parent;
  Item.Tab := Tab;
  Button.StylesData['path.Data.Data'] := Path.Data.Data;
  FNavigation.Add(Item);
end;

end.


