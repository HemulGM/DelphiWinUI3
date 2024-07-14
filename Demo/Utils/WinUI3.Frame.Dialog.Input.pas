unit WinUI3.Frame.Dialog.Input;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit, FMX.Controls.Presentation;

type
  TDialogInputParams = record
  private
    FTitle: string;
    FInputTitle: string;
    FCheckText: string;
    FCheckValue: Boolean;
    FButtons: TArray<string>;
    FFrameColor: TColor;
    FCanClose: Boolean;
    FAccentId: Integer;
    FDefaultId: Integer;
    FInputPrompt: string;
    FInputText: string;
  public
    property Title: string read FTitle write FTitle;
    property InputTitle: string read FInputTitle write FInputTitle;
    property InputPrompt: string read FInputPrompt write FInputPrompt;
    property InputText: string read FInputText write FInputText;
    property CheckText: string read FCheckText write FCheckText;
    property CheckValue: Boolean read FCheckValue write FCheckValue;
    property Buttons: TArray<string> read FButtons write FButtons;
    property AccentId: Integer read FAccentId write FAccentId;
    property DefaultId: Integer read FDefaultId write FDefaultId;
    property CanClose: Boolean read FCanClose write FCanClose;
    property FrameColor: TColor read FFrameColor write FFrameColor;
  end;

  TDialogInputResult = record
    Result: Integer;
    Input: string;
    IsChecked: Boolean;
  end;

  TFrameDialogInput = class(TFrame)
    LabelInputTitle: TLabel;
    EditInput: TEdit;
  private
    { Private declarations }
  public
    procedure Fill(Data: TDialogInputParams);
  end;

implementation

{$R *.fmx}

{ TFrameDialogInput }

procedure TFrameDialogInput.Fill(Data: TDialogInputParams);
begin
  LabelInputTitle.Text := Data.InputTitle;
  EditInput.TextPrompt := Data.InputPrompt;
  EditInput.Text := Data.InputText;
end;

end.

