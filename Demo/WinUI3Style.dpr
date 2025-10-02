program WinUI3Style;

uses
  System.StartUpCopy,
  FMX.Forms,
  {$IFDEF ANDROID}
  FMX.Skia,
  {$ENDIF }
  FMX.Types,
  FMX.Graphics,
  FMX.Platform,
  WinUI3.Main in 'WinUI3.Main.pas' {FormMain},
  WinUI3.Gallery in 'WinUI3.Gallery.pas' {FormGallery},
  {$IFDEF MSWINDOWS}
  WinUI3.NotifyDemo in 'WinUI3.NotifyDemo.pas',
  {$ENDIF }
  WinUI3.Frame.Dialog.Test in 'WinUI3.Frame.Dialog.Test.pas' {FrameTestDialog: TFrame},
  WinUI3.YandexMusic in 'WinUI3.YandexMusic.pas' {FormMusic},
  WinUI3.RADIDE in 'WinUI3.RADIDE.pas' {FormIDE},
  FMX.RichEdit.Style in 'Utils\FMX.RichEdit.Style.pas',
  FMX.RichEdit.Code in 'Utils\Code\FMX.RichEdit.Code.pas',
  FMX.RichEdit.Code.Pascal in 'Utils\Code\FMX.RichEdit.Code.Pascal.pas',
  WinUI3.Browser in 'WinUI3.Browser.pas' {FormBrowser},
  WinUI3.MultiView.CustomPresentation in 'Utils\WinUI3.MultiView.CustomPresentation.pas',
  FMX.Calendar.Style in '..\Fixes\D12\FMX.Calendar.Style.pas',
  FMX.MultiView.Presentations in '..\Fixes\D12\FMX.MultiView.Presentations.pas',
  FMX.StyledContextMenu in '..\Fixes\D12\FMX.StyledContextMenu.pas',
  FMX.Windows.Hints in '..\FMXWindowsHint\FMX.Windows.Hints.pas',
  FMX.Menus in '..\Fixes\D13\FMX.Menus.pas';

type
  TFMXSystemFontService = class(TInterfacedObject, IFMXSystemFontService)
    function GetDefaultFontFamilyName: string;
    function GetDefaultFontSize: Single;
  end;

{$R *.res}

{ TFMXSystemFontService }

function TFMXSystemFontService.GetDefaultFontFamilyName: string;
begin
  Result := 'Segoe UI';
end;

function TFMXSystemFontService.GetDefaultFontSize: Single;
begin
  Result := 10;
end;

begin
  //var FontServ := TFMXSystemFontService.Create;
  //TPlatformServices.Current.AddPlatformService(IFMXSystemFontService, FontServ);
  //GlobalUseDirect2D := False; //(for xp)
  {$IFDEF ANDROID}
  GlobalUseSkia := True;
  {$ENDIF}
  Application.Initialize;
  Application.FormFactor.Orientations := [TFormOrientation.Portrait, TFormOrientation.InvertedPortrait, TFormOrientation.Landscape, TFormOrientation.InvertedLandscape];
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
  //FontServ.Free;
end.

