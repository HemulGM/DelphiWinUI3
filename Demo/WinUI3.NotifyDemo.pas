unit WinUI3.NotifyDemo;

interface

uses
  System.Classes, System.SysUtils,
  FMX.Win.NotificationManager,
  FMX.Forms;

type
  TNotifyDemo = class(TComponent)
  private
    FNotifyManager: TNotificationManager;
    procedure NotifActivated(Sender: TNotification; Arguments: string; UserInput: TUserInputMap);
    procedure NotifDismissed(Sender: TNotification; Reason: TToastDismissReason);
  public
    constructor Create(AOwner: TComponent); override;
    procedure ShowDemo;
  end;

implementation

uses
  System.IOUtils, WinUI3.Dialogs;

{ TNotifyDemo }

constructor TNotifyDemo.Create(AOwner: TComponent);
begin
  inherited;
  try
    FNotifyManager := TNotificationManager.Create(Self, 'WinUI3.Delphi.Test');

    FNotifyManager.ApplicationName := 'WinUI 3 Demo Application';
    FNotifyManager.ShowInSettings := True;
    FNotifyManager.ApplicationIcon := TPath.Combine(TPath.GetLibraryPath, 'Assets\Header-WinUIGallery.png');
  except
    FNotifyManager := nil;
  end;
end;

procedure TNotifyDemo.NotifActivated(Sender: TNotification; Arguments: string; UserInput: TUserInputMap);
begin
  ShowUIMessage(Owner as TForm, Arguments);
  if Arguments = 'view' then
  begin
    // Get value of edit box (if there is one with this id)
    var Value := UserInput.GetStringValue('editbox-id');
    ShowUIMessage(Owner as TForm, 'NotifActivated', Value);
  end;
end;

procedure TNotifyDemo.NotifDismissed(Sender: TNotification; Reason: TToastDismissReason);
begin
  ShowUIMessage(Owner as TForm, 'NotifDismissed', Ord(Reason).ToString);
end;

procedure TNotifyDemo.ShowDemo;
begin
  const DefImg = 'C:\Windows\System32\@facial-recognition-windows-hello.gif';

  var NotifyContent := TToastContentBuilder.Create
    .UseButtonStyle(True)
    .AddText(TToastText.Create.Text('{title}'))
    .AddText(TToastText.Create.Text('This is the Windows 10+ notifications engine for Delphi'))
    .AddGroup(TToastGroup.Create.SubGroups([
    TToastSubGroup.Create
    .HintWeight(1)
    .AddText(TToastText.Create.Text('Mon').HintAlign(TToastTextAlign.Center))
    .AddImage(TToastImage.Create.Src(DefImg).HintRemoveMargin(True))
    .AddText(TToastText.Create.Text('63°').HintAlign(TToastTextAlign.Center))
    .AddText(TToastText.Create.Text('42°').HintAlign(TToastTextAlign.Center).HintStyle(TToastTextStyle.CaptionSubtle)),
    TToastSubGroup.Create
    .HintWeight(1)
    .AddText(TToastText.Create.Text('Tue').HintAlign(TToastTextAlign.Center))
    .AddImage(TToastImage.Create.Src(DefImg).HintRemoveMargin(True))
    .AddText(TToastText.Create.Text('57°').HintAlign(TToastTextAlign.Center))
    .AddText(TToastText.Create.Text('38°').HintAlign(TToastTextAlign.Center).HintStyle(TToastTextStyle.CaptionSubtle)),
    TToastSubGroup.Create
    .HintWeight(1)
    .AddText(TToastText.Create.Text('Wed').HintAlign(TToastTextAlign.Center))
    .AddImage(TToastImage.Create.Src(DefImg).HintRemoveMargin(True))
    .AddText(TToastText.Create.Text('59°').HintAlign(TToastTextAlign.Center))
    .AddText(TToastText.Create.Text('43°').HintAlign(TToastTextAlign.Center).HintStyle(TToastTextStyle.CaptionSubtle)),
    TToastSubGroup.Create
    .HintWeight(1)
    .AddText(TToastText.Create.Text('Thu').HintAlign(TToastTextAlign.Center))
    .AddImage(TToastImage.Create.Src(DefImg).HintRemoveMargin(True))
    .AddText(TToastText.Create.Text('62°').HintAlign(TToastTextAlign.Center))
    .AddText(TToastText.Create.Text('42°').HintAlign(TToastTextAlign.Center).HintStyle(TToastTextStyle.CaptionSubtle)),
    TToastSubGroup.Create
    .HintWeight(1)
    .AddText(TToastText.Create.Text('Fri').HintAlign(TToastTextAlign.Center))
    .AddImage(TToastImage.Create.Src(DefImg).HintRemoveMargin(True))
    .AddText(TToastText.Create.Text('71°').HintAlign(TToastTextAlign.Center))
    .AddText(TToastText.Create.Text('66°').HintAlign(TToastTextAlign.Center).HintStyle(TToastTextStyle.CaptionSubtle))
    ]))
    .Audio(TToastAudio.Create.Src(TSoundEventValue.NotificationSMS).Loop(False))
    .AddInputBox(TToastTextBox.Create.Id('editbox-id').Title('Title').PlaceholderContent('Enter name'))
    .AddSelectionBox(TToastSelectionBox.Create.Id('combo').Title('Choose').Items([
    TToastSelectionBoxItem.Create('id_1', 'Yes'),
    TToastSelectionBoxItem.Create('id_2', 'No')
    ]))
    .AddButton(TToastAction.Create.Content('Cancel').ActivationType(TActivationType.Foreground).Arguments('cancel').HintButtonStyle(TToastActionButtonStyle.Critical))
    .AddButton(TToastAction.Create.Content('View more').ActivationType(TActivationType.Foreground).Arguments('view').HintInputId('editbox-id'));

  var Notif: TNotification;
  Notif := TNotification.Create(FNotifyManager, NotifyContent);
  Notif.Tag := 'notification1';
  // Data binded values
  Notif.Data['title'] := 'Hello world!';
  Notif.Data['download-pos'] := '0';
  // Events (must be defined in your form class)
  Notif.OnActivated := NotifActivated;
  Notif.OnDismissed := NotifDismissed;

  FNotifyManager.ShowNotification(Notif);

  {
  // Update
  const DownloadValue = Notif.Data['download-pos'].ToSingle + 0.1;
  Notif.Data['download-pos'] := DownloadValue.ToString;
  if DownloadValue >= 1 then
    Notif.Data['title'] := 'Download finalised!';

  FNotifyManager.UpdateNotification(Notif);  }
end;

end.

