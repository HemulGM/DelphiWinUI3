﻿program WinUI3Style;

uses
  System.StartUpCopy,
  FMX.Forms,
  WinUI3.Main in 'WinUI3.Main.pas' {FormMain},
  WinUI3.Gallery in 'WinUI3.Gallery.pas' {FormGallery},
  FMX.StyledContextMenu in 'Fixes\D12\FMX.StyledContextMenu.pas',
  {$IFDEF MSWINDOWS}
  FMX.Win.Notification.Helper in '..\WindowsNotificationManager\FMX.Win.Notification.Helper.pas',
  FMX.Win.NotificationManager in '..\WindowsNotificationManager\FMX.Win.NotificationManager.pas',
  DelphiWindowStyle.Core.Win in '..\DelphiWindowStyle\DelphiWindowStyle.Core.Win.pas',
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
  FMX.Menus in 'Fixes\D12\FMX.Menus.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.

