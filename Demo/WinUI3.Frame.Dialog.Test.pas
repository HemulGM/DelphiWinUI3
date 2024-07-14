unit WinUI3.Frame.Dialog.Test;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Objects;

type
  TFrameTestDialog = class(TFrame)
    Image1: TImage;
    Label1: TLabel;
    AniIndicator1: TAniIndicator;
    Image2: TImage;
    Label2: TLabel;
    AniIndicator2: TAniIndicator;
    Image3: TImage;
    Label3: TLabel;
    AniIndicator3: TAniIndicator;
    Timer1: TTimer;
    Image4: TImage;
    Label4: TLabel;
    AniIndicator4: TAniIndicator;
    Image5: TImage;
    Label5: TLabel;
    AniIndicator5: TAniIndicator;
    Image6: TImage;
    Label6: TLabel;
    AniIndicator6: TAniIndicator;
    ProgressBar1: TProgressBar;
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.fmx}

constructor TFrameTestDialog.Create(AOwner: TComponent);
begin
  inherited;
  Name := '';
  Height := 65;
end;

procedure TFrameTestDialog.Timer1Timer(Sender: TObject);
begin
  if Height = 65 then
    Height := 180
  else if Height = 180 then
  begin
    AniIndicator1.Visible := False;
    ProgressBar1.Visible := True;
    Height := 353;
  end
  else
    DisposeOf;
end;

end.

