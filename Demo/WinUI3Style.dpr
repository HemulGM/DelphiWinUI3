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
  FMX.Menus in '..\Fixes\D13\FMX.Menus.pas',
  FMX.Memo.ExtStyle in 'Utils\FMX.Memo.ExtStyle.pas',
  FMX.Platform.Win in '..\Fixes\D13\FMX.Platform.Win.pas',
  HGM.ColorUtils in '..\Sources\HGM.ColorUtils.pas',
  WinUI3.Dialogs.DataTransferManager in '..\Sources\WinUI3.Dialogs.DataTransferManager.pas',
  WinUI3.Dialogs in '..\Sources\WinUI3.Dialogs.pas',
  WinUI3.Form.Dialog in '..\Sources\WinUI3.Form.Dialog.pas' {FormDialogs},
  WinUI3.Form in '..\Sources\WinUI3.Form.pas',
  WinUI3.Frame.Dialog.ColorPicker in '..\Sources\WinUI3.Frame.Dialog.ColorPicker.pas' {FrameDialogColorPicker: TFrame},
  WinUI3.Frame.Dialog.Font in '..\Sources\WinUI3.Frame.Dialog.Font.pas' {FrameDialogFont: TFrame},
  WinUI3.Frame.Dialog.Input in '..\Sources\WinUI3.Frame.Dialog.Input.pas' {FrameDialogInput: TFrame},
  WinUI3.Frame.Dialog in '..\Sources\WinUI3.Frame.Dialog.pas' {FrameDialog: TFrame},
  WinUI3.Frame.Dialog.Text in '..\Sources\WinUI3.Frame.Dialog.Text.pas' {FrameDialogText: TFrame},
  WinUI3.Frame.Inner.Dialog in '..\Sources\WinUI3.Frame.Inner.Dialog.pas' {FrameInnerDialog: TFrame},
  WinUI3.Frame.Inner.InfoBar in '..\Sources\WinUI3.Frame.Inner.InfoBar.pas' {FrameInnerInfoBar: TFrame},
  WinUI3.Style in '..\Sources\WinUI3.Style.pas',
  WinUI3.DM in 'WinUI3.DM.pas' {DataModuleRes: TDataModule};

{$R *.res}

begin
  //GlobalUseDirect2D := False; //(for xp)
  {$IFDEF ANDROID}
  GlobalUseSkia := True;
  {$ENDIF}
  Application.Initialize;
  Application.FormFactor.Orientations := [TFormOrientation.Portrait, TFormOrientation.InvertedPortrait, TFormOrientation.Landscape, TFormOrientation.InvertedLandscape];
  Application.CreateForm(TFormMain, FormMain);
  Application.CreateForm(TFormDialogs, FormDialogs);
  Application.CreateForm(TDataModuleRes, DataModuleRes);
  Application.Run;
end.

