unit WinUI3.YandexMusic;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, WinUI3.Form,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.Objects, FMX.Layouts,
  System.Notification;

{$SCOPEDENUMS ON}

type
  TLayoutMode = (Full, Middle, Mobile);

  TFormMusic = class(TWinUIForm)
    LayoutTop: TLayout;
    LayoutBottom: TLayout;
    LayoutCenter: TLayout;
    LayoutMain: TLayout;
    Rectangle1: TRectangle;
    LayoutMainInfo: TLayout;
    LayoutImage: TLayout;
    Label1: TLabel;
    Label2: TLabel;
    LayoutInfo: TLayout;
    Button1: TButton;
    ButtonMini: TButton;
    ButtonVolume: TButton;
    ButtonMore: TButton;
    ButtonDislike: TButton;
    ButtonLike: TButton;
    ButtonOptions: TButton;
    Button8: TButton;
    ButtonPlayPause: TButton;
    LayoutInfoDetail: TLayout;
    Rectangle2: TRectangle;
    Label3: TLabel;
    Label4: TLabel;
    Layout9: TLayout;
    Label5: TLabel;
    Label6: TLabel;
    Button10: TButton;
    Layout1: TLayout;
    TrackBar1: TTrackBar;
    StyleBookMusic: TStyleBook;
    TimerPlay: TTimer;
    LayoutInfoCenter: TLayout;
    LayoutInfoControls: TLayout;
    Button9: TButton;
    Button14: TButton;
    Button15: TButton;
    Button17: TButton;
    ButtonPlayPauseMain: TButton;
    Layout5: TLayout;
    TrackBar2: TTrackBar;
    LayoutMainPlay: TLayout;
    LayoutFooter: TLayout;
    LayoutHQ: TLayout;
    Button2: TButton;
    CornerButton1: TCornerButton;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure TimerPlayTimer(Sender: TObject);
    procedure ButtonPlayPauseClick(Sender: TObject);
    procedure LayoutBottomResize(Sender: TObject);
    procedure TrackBar2Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FLayoutMode: TLayoutMode;
    procedure SetLayoutMode(const Value: TLayoutMode);
    procedure UpdateLayoutMode;
  public
    property LayoutMode: TLayoutMode read FLayoutMode write SetLayoutMode;
  end;

var
  FormMusic: TFormMusic;

implementation

uses
  WinUI3.Main, System.Math, DelphiWindowStyle.FMX;

{$R *.fmx}

procedure TFormMusic.ButtonPlayPauseClick(Sender: TObject);
begin
  TimerPlay.Enabled := not TimerPlay.Enabled;
  if not TimerPlay.Enabled then
    ButtonPlayPause.StyleLookup := 'playtoolbutton'
  else
    ButtonPlayPause.StyleLookup := 'pausetoolbutton';
  ButtonPlayPauseMain.StyleLookup := ButtonPlayPause.StyleLookup;
end;

procedure TFormMusic.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
end;

procedure TFormMusic.FormCreate(Sender: TObject);
begin
  SetSystemBackdropType(TSystemBackdropType.DWMSBT_TRANSIENTWINDOW);
  FLayoutMode := TLayoutMode.Full;
  UpdateLayoutMode;
end;

procedure TFormMusic.UpdateLayoutMode;
begin
  case FLayoutMode of
    TLayoutMode.Full:
      begin
        LayoutBottom.Visible := True;
        LayoutInfoCenter.Visible := False;
        LayoutMainInfo.Height := 100;
        LayoutFooter.Visible := False;
      end;
    TLayoutMode.Middle:
      begin
        LayoutBottom.Visible := False;
        LayoutInfoCenter.Visible := True;
        LayoutMainInfo.Height := 200;
        LayoutMainPlay.Width := 2 * 50 + 80 + 4 + 4;
        ButtonPlayPauseMain.Width := 80;
        ButtonPlayPauseMain.Margins.Rect := TRectF.Create(4, -15, 4, -15);
        LayoutFooter.Visible := True;
      end;
    TLayoutMode.Mobile:
      begin
        LayoutBottom.Visible := False;
        LayoutInfoCenter.Visible := True;
        ButtonPlayPauseMain.Width := 50;
        LayoutMainPlay.Width := 3 * 50 + 4 + 4;
        ButtonPlayPauseMain.Margins.Rect := TRectF.Create(4, 0, 4, 0);
        LayoutMainInfo.Height := 200;
        LayoutFooter.Visible := True;
      end;
  end;
end;

procedure TFormMusic.FormResize(Sender: TObject);
begin
  if ClientWidth >= 730 then
    LayoutMode := TLayoutMode.Full
  else if ClientWidth >= 480 then
    LayoutMode := TLayoutMode.Middle
  else
    LayoutMode := TLayoutMode.Mobile;
  LayoutMain.Width := Min(432, LayoutCenter.Width);
  LayoutMain.Height := Min(LayoutMain.Width + LayoutMainInfo.Height, LayoutCenter.Height);
  LayoutImage.Height := Min(LayoutImage.Width, LayoutMain.Height - LayoutMainInfo.Height);
end;

procedure TFormMusic.LayoutBottomResize(Sender: TObject);
begin
  if LayoutBottom.Width < 950 then
  begin
    ButtonDislike.Visible := False;
    ButtonMore.Visible := False;
    ButtonMini.StyleLookup := ButtonMore.StyleLookup;
  end
  else
  begin
    ButtonDislike.Visible := True;
    ButtonMore.Visible := True;
    ButtonMini.StyleLookup := 'minitoolbutton';
  end;
  ButtonMore.Position.X := 1000;
end;

procedure TFormMusic.SetLayoutMode(const Value: TLayoutMode);
begin
  if FLayoutMode = Value then
    Exit;
  FLayoutMode := Value;
  UpdateLayoutMode;
end;

procedure TFormMusic.TimerPlayTimer(Sender: TObject);
begin
  if ButtonPlayPause.StyleLookup <> 'pausetoolbutton' then
  begin
    ButtonPlayPause.StyleLookup := 'pausetoolbutton';
    ButtonPlayPauseMain.StyleLookup := 'pausetoolbutton';
  end;
  TrackBar1.Value := TrackBar1.Value + 1;
  if TrackBar1.Value = 100 then
    TrackBar1.Value := 0;
  TrackBar2.Value := TrackBar1.Value;
end;

procedure TFormMusic.TrackBar2Change(Sender: TObject);
begin
  TrackBar1.Value := TrackBar2.Value;
end;

end.

