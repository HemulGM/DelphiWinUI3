program WinUI3Style;

uses
  System.StartUpCopy,
  FMX.Forms,
  WinUI3.Main in 'WinUI3.Main.pas' {FormMain},
  WinUI3.Gallery in 'WinUI3.Gallery.pas' {FormGallery},
  FMX.StyledContextMenu in 'Fixes\D12\FMX.StyledContextMenu.pas',
  {$IFDEF MSWINDOWS}
  DelphiWindowStyle.Core.Win in '..\DelphiWindowStyle\DelphiWindowStyle.Core.Win.pas',
  FMX.Win.NotificationManager in '..\WindowsNotificationManager\FMX.Win.NotificationManager.pas',
  FMX.Win.Notification.XML in '..\WindowsNotificationManager\FMX.Win.Notification.XML.pas',
  FMX.Windows.Dispatch in '..\FMXWindowsDispatch\FMX.Windows.Dispatch.pas',
  {$ENDIF }
  DelphiWindowStyle.FMX in '..\DelphiWindowStyle\DelphiWindowStyle.FMX.pas',
  DelphiWindowStyle.Types in '..\DelphiWindowStyle\DelphiWindowStyle.Types.pas',
  WinUI3.Frame.Dialog.Test in 'WinUI3.Frame.Dialog.Test.pas' {FrameTestDialog: TFrame},
  WinUI3.Frame.Dialog in 'Utils\WinUI3.Frame.Dialog.pas' {FrameDialog: TFrame},
  WinUI3.Form.Dialog in 'Utils\WinUI3.Form.Dialog.pas' {FormDialogs},
  WinUI3.Frame.Dialog.Text in 'Utils\WinUI3.Frame.Dialog.Text.pas' {FrameDialogText: TFrame},
  WinUI3.Dialogs.DataTransferManager in 'Utils\WinUI3.Dialogs.DataTransferManager.pas',
  WinUI3.Frame.Dialog.Input in 'Utils\WinUI3.Frame.Dialog.Input.pas' {FrameDialogInput: TFrame},
  WinUI3.Frame.Dialog.ColorPicker in 'Utils\WinUI3.Frame.Dialog.ColorPicker.pas' {FrameDialogColorPicker: TFrame},
  HGM.ColorUtils in 'Utils\HGM.ColorUtils.pas',
  WinUI3.Form in 'Utils\WinUI3.Form.pas',
  WinUI3.Utils in 'Utils\WinUI3.Utils.pas',
  WinUI3.Frame.Inner.Dialog in 'Utils\WinUI3.Frame.Inner.Dialog.pas' {FrameInnerDialog: TFrame},
  WinUI3.Dialogs in 'Utils\WinUI3.Dialogs.pas',
  WinUI3.Frame.Inner.InfoBar in 'Utils\WinUI3.Frame.Inner.InfoBar.pas' {FrameInnerInfoBar: TFrame},
  WinUI3.Frame.Inner.InfoBarPanel in 'Utils\WinUI3.Frame.Inner.InfoBarPanel.pas' {FrameInfoBarPanel: TFrame},
  WinUI3.YandexMusic in 'WinUI3.YandexMusic.pas' {FormMusic},
  FMX.Windows.Hints in '..\FMXWindowsHint\FMX.Windows.Hints.pas',
  WinUI3.RADIDE in 'WinUI3.RADIDE.pas' {FormIDE},
  FMX.RichEdit.Style in 'Utils\FMX.RichEdit.Style.pas',
  ChatGPT.Code in 'Utils\Code\ChatGPT.Code.pas',
  ChatGPT.Code.Pascal in 'Utils\Code\ChatGPT.Code.Pascal.pas',
  FMX.Menus in 'Fixes\D12\FMX.Menus.pas',
  WinUI3.Browser in 'WinUI3.Browser.pas' {FormBrowser},
  WinUI.MultiView.CustomPresentation in 'Utils\WinUI.MultiView.CustomPresentation.pas',
  FMX.Calendar.Style in 'Fixes\D12\FMX.Calendar.Style.pas',
  FMX.MultiView.Presentations in 'Fixes\D12\FMX.MultiView.Presentations.pas',
  WinUI3.NotifyDemo in 'WinUI3.NotifyDemo.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.

