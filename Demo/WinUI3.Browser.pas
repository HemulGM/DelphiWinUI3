unit WinUI3.Browser;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, WinUI3.Form,
  FMX.TabControl, FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls,
  FMX.WebBrowser, FMX.Edit;

type
  TFormBrowser = class(TWinUIForm)
    TabControlView: TTabControl;
    TabItem23: TTabItem;
    LayoutTitleContent: TLayout;
    LayoutTitle: TLayout;
    LayoutClient: TLayout;
    LayoutTabs: TLayout;
    HorzScrollBoxTabs: THorzScrollBox;
    LayoutIcon: TLayout;
    LayoutAdd: TLayout;
    Button8: TButton;
    WebBrowser1: TWebBrowser;
    LayoutNavigation: TLayout;
    EditURL: TEdit;
    ButtonBack: TButton;
    ButtonRefresh: TButton;
    EditButton1: TEditButton;
    Button11: TButton;
    RadioButton1: TRadioButton;
    RadioButton5: TRadioButton;
    RadioButton6: TRadioButton;
    RadioButton7: TRadioButton;
    RadioButton8: TRadioButton;
    Panel1: TPanel;
    LayoutContent: TLayout;
    procedure TabItemAddClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure LayoutTabsResize(Sender: TObject);
    procedure ButtonBackClick(Sender: TObject);
    procedure ButtonRefreshClick(Sender: TObject);
    procedure EditURLKeyUp(Sender: TObject; var Key: Word; var KeyChar: WideChar; Shift: TShiftState);
    procedure WebBrowser1DidFinishLoad(ASender: TObject);
    procedure WebBrowser1DidStartLoad(ASender: TObject);
    procedure WebBrowser1ShouldStartLoadWithRequest(ASender: TObject; const URL: string);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    procedure FOnTabCloseClick(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormBrowser: TFormBrowser;

implementation

uses
  WinUI3.Main, System.Rtti, System.Math, FMX.Utils;

{$R *.fmx}

procedure TFormBrowser.ButtonBackClick(Sender: TObject);
begin
  WebBrowser1.GoBack;
  WebBrowser1DidStartLoad(nil);
end;

procedure TFormBrowser.ButtonRefreshClick(Sender: TObject);
begin
  WebBrowser1.Reload;
  WebBrowser1DidStartLoad(nil);
end;

procedure TFormBrowser.EditURLKeyUp(Sender: TObject; var Key: Word; var KeyChar: WideChar; Shift: TShiftState);
begin
  if Key = vkReturn then
  begin
    WebBrowser1.Navigate(EditURL.Text);
    WebBrowser1DidStartLoad(nil);
  end;
end;

procedure TFormBrowser.FOnTabCloseClick(Sender: TObject);
begin
  var Btn := Sender as TControl;
  //
  var Tab := TFMXObjectHelper.GetNearestParentOfClass<TTabItem>(Btn);
  if Assigned(Tab) then
    Tab.Release;
end;

procedure TFormBrowser.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
end;

procedure TFormBrowser.FormCreate(Sender: TObject);
begin
  HorzScrollBoxTabs.AniCalculations.Animation := True;
  CaptionControls := [LayoutTitle, TabControlView];
  OffsetControls := [LayoutTitle, LayoutClient];
  //TitleControls := [LabelTitle];
  HideTitleBar := True;
end;

procedure TFormBrowser.LayoutTabsResize(Sender: TObject);
begin
  var W: Single := 0.0;
  for var Control in HorzScrollBoxTabs.Content.Controls do
    W := W + Control.Width;
  var SysBtnSize := 140;
  var AllowedWidth := LayoutTabs.Width - (LayoutAdd.Width + LayoutIcon.Width + SysBtnSize);
  HorzScrollBoxTabs.Width := Min(W, AllowedWidth);
end;

procedure TFormBrowser.TabItemAddClick(Sender: TObject);
begin
  var Tab := TabControlView.Add;
  Tab.AutoSize := False;
  Tab.Width := 180;
  Tab.StyleLookup := 'tabitemstyle_view';
  Tab.IsSelected := True;
  Tab.StylesData['close.OnClick'] := TValue.From<TNotifyEvent>(FOnTabCloseClick);
  Tab.Text := 'Tab name ' + TabControlView.Tag.ToString;
  TabControlView.Tag := TabControlView.Tag + 1;
end;

procedure TFormBrowser.WebBrowser1DidFinishLoad(ASender: TObject);
begin
  RadioButton1.StylesData['ani.Enabled'] := False;
  RadioButton1.StylesData['ani.Visible'] := False;
  RadioButton1.StylesData['glyphstyle.Visible'] := True;
end;

procedure TFormBrowser.WebBrowser1DidStartLoad(ASender: TObject);
begin
  RadioButton1.StylesData['ani.Visible'] := True;
  RadioButton1.StylesData['ani.Enabled'] := True;
  RadioButton1.StylesData['glyphstyle.Visible'] := False;
end;

procedure TFormBrowser.WebBrowser1ShouldStartLoadWithRequest(ASender: TObject; const URL: string);
begin
  WebBrowser1DidStartLoad(nil);
  EditURL.Text := URL;
  RadioButton1.Text := URL;
end;

end.

