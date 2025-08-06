program WinUI3Style;

uses
  System.StartUpCopy,
  FMX.Forms,
  {$IFDEF ANDROID}
  FMX.Skia,
  {$ENDIF }
  FMX.Types,
  WinUI3.Main in 'WinUI3.Main.pas' {FormMain},
  WinUI3.Gallery in 'WinUI3.Gallery.pas' {FormGallery},
  WinUI3.NotifyDemo in 'WinUI3.NotifyDemo.pas',
  WinUI3.Frame.Dialog.Test in 'WinUI3.Frame.Dialog.Test.pas' {FrameTestDialog: TFrame},
  WinUI3.YandexMusic in 'WinUI3.YandexMusic.pas' {FormMusic},
  WinUI3.RADIDE in 'WinUI3.RADIDE.pas' {FormIDE},
  FMX.RichEdit.Style in 'Utils\FMX.RichEdit.Style.pas',
  FMX.RichEdit.Code in 'Utils\Code\FMX.RichEdit.Code.pas',
  FMX.RichEdit.Code.Pascal in 'Utils\Code\FMX.RichEdit.Code.Pascal.pas',
  WinUI3.Browser in 'WinUI3.Browser.pas' {FormBrowser},
  WinUI3.MultiView.CustomPresentation in 'Utils\WinUI3.MultiView.CustomPresentation.pas',
  FMX.Calendar.Style in '..\Fixes\D12\FMX.Calendar.Style.pas',
  FMX.Menus in '..\Fixes\D12\FMX.Menus.pas',
  FMX.MultiView.Presentations in '..\Fixes\D12\FMX.MultiView.Presentations.pas',
  FMX.StyledContextMenu in '..\Fixes\D12\FMX.StyledContextMenu.pas';

{$R *.res}

begin
  //GlobalUseDirect2D := False; //(for xp)
  {$IFDEF ANDROID}
  GlobalUseSkia := True;
  {$ENDIF}
  Application.Initialize;
  Application.FormFactor.Orientations := [TFormOrientation.Portrait, TFormOrientation.InvertedPortrait, TFormOrientation.Landscape, TFormOrientation.InvertedLandscape];
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.

