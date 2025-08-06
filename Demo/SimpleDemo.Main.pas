unit SimpleDemo.Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, WinUI3.Form,
  FMX.ListBox, FMX.Layouts, FMX.StdCtrls, FMX.Controls.Presentation, FMX.Edit,
  FMX.Objects, FMX.Memo.Types, FMX.ScrollBox, FMX.Memo, FMX.BehaviorManager;

type
  TFontBehavior = class(TInterfacedObject, IFontBehavior)
    procedure GetDefaultFontFamily(const Context: TFmxObject; var FontFamily: string);
    procedure GetDefaultFontSize(const Context: TFmxObject; var FontSize: Single);
  end;

  TForm7 = class(TWinUIForm)
    StyleBookWinUI3: TStyleBook;
    ListBox1: TListBox;
    VertScrollBox1: TVertScrollBox;
    Layout1: TLayout;
    Layout2: TLayout;
    Layout3: TLayout;
    Layout4: TLayout;
    Layout5: TLayout;
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
    ListBoxItem15: TListBoxItem;
    ListBoxItem16: TListBoxItem;
    ListBoxItem17: TListBoxItem;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    Panel1: TPanel;
    ListBoxItem18: TListBoxItem;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Edit1: TEdit;
    EllipsesEditButton1: TEllipsesEditButton;
    EditButton1: TEditButton;
    EditButton2: TEditButton;
    Layout6: TLayout;
    Layout7: TLayout;
    Label2: TLabel;
    StyleBookChat: TStyleBook;
    Label3: TLabel;
    Image1: TImage;
    Layout8: TLayout;
    Layout9: TLayout;
    Image2: TImage;
    Label4: TLabel;
    Label5: TLabel;
    Layout10: TLayout;
    Layout11: TLayout;
    Image3: TImage;
    Label6: TLabel;
    Label7: TLabel;
    Layout12: TLayout;
    Layout13: TLayout;
    Image4: TImage;
    Label8: TLabel;
    Label9: TLabel;
    Layout14: TLayout;
    Layout15: TLayout;
    Image5: TImage;
    Label10: TLabel;
    Label11: TLabel;
    Layout16: TLayout;
    Layout17: TLayout;
    Image6: TImage;
    Label12: TLabel;
    Label13: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form7: TForm7;

implementation


{$R *.fmx}

{ TFontBehavior }

procedure TFontBehavior.GetDefaultFontFamily(const Context: TFmxObject; var FontFamily: string);
begin
  FontFamily := 'Consolas';
end;

procedure TFontBehavior.GetDefaultFontSize(const Context: TFmxObject; var FontSize: Single);
begin
  FontSize := 14;
end;

procedure TForm7.FormCreate(Sender: TObject);
begin
  TBehaviorServices.Current.AddBehaviorService(IFontBehavior, TFontBehavior.Create);
end;

end.

