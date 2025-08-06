unit WinUI3.Frame.Dialog.Text;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Memo.Types, FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo,
  WinUI3.Frame.Dialog;

type
  TDialogTextParams = record
  private
    FTitle: string;
    FBody: string;
    FCheckText: string;
    FCheckValue: Boolean;
    FButtons: TArray<string>;
    FFrameColor: TColor;
    FCanClose: Boolean;
    FAccentId: Integer;
    FDefaultId: Integer;
  public
    property Title: string read FTitle write FTitle;
    property Body: string read FBody write FBody;
    property CheckText: string read FCheckText write FCheckText;
    property CheckValue: Boolean read FCheckValue write FCheckValue;
    property Buttons: TArray<string> read FButtons write FButtons;
    property AccentId: Integer read FAccentId write FAccentId;
    property DefaultId: Integer read FDefaultId write FDefaultId;
    property CanClose: Boolean read FCanClose write FCanClose;
    property FrameColor: TColor read FFrameColor write FFrameColor;
  end;

  TFrameDialogText = class(TFrame, ICanCopy)
    LabelBody: TLabel;
    procedure LabelBodyResize(Sender: TObject);
  private
  public
    constructor Create(AOwner: TComponent); override;
    procedure Copy;
    procedure Fill(Data: TDialogTextParams);
  end;

implementation

uses
  System.Math, FMX.Platform;

{$R *.fmx}

procedure TFrameDialogText.Copy;
begin
  var Clipboard: IFMXClipboardService;
  if TPlatformServices.Current.SupportsPlatformService(IFMXClipboardService, Clipboard) then
    Clipboard.SetClipboard(LabelBody.Text);
end;

constructor TFrameDialogText.Create(AOwner: TComponent);
begin
  inherited;
  Name := '';
end;

procedure TFrameDialogText.Fill(Data: TDialogTextParams);
begin
  LabelBody.Text := Data.Body;
end;

procedure TFrameDialogText.LabelBodyResize(Sender: TObject);
begin
  if csDestroying in ComponentState then
    Exit;
  if Canvas = nil then
    Exit;
  Width := Round(Max(320, Min(LabelBody.Canvas.TextWidth(LabelBody.Text), 540)));
  Height := LabelBody.Height;
end;

end.

