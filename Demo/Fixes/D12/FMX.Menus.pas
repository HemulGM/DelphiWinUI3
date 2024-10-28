{*******************************************************}
{                                                       }
{              Delphi FireMonkey Platform               }
{                                                       }
{ Copyright(c) 2011-2024 Embarcadero Technologies, Inc. }
{              All rights reserved                      }
{                                                       }
{*******************************************************}

unit FMX.Menus;

interface

{$SCOPEDENUMS ON}

uses
  System.Classes, System.Types, System.UITypes, System.Messaging, System.ImageList, FMX.Types, FMX.Forms, FMX.ActnList,
  FMX.Controls, FMX.Graphics, FMX.ImgList, FMX.Objects;

type

  TStartMenuLoopMessage = class(System.Messaging.TMessage)
  private
    FRoot: IRoot;
  public
    constructor Create(const ARoot: IRoot);
    property Root: IRoot read FRoot;
  end;

{ Menus }

  TMenuItem = class;
  TMainMenu = class;

  /// <summary>For internal use only.</summary>
  IMenuView = interface(IControl)
    ['{C211C5EA-789A-48C3-9739-900782101C51}']
    function GetLoop: Boolean;
    procedure SetLoop(const Value: Boolean);
    function GetParentView: IMenuView;
    procedure SetParentView(const Value: IMenuView);
    function GetChildView: IMenuView;
    procedure SetChildView(const Value: IMenuView);
    function GetSelected: TMenuItem;
    procedure SetSelected(const Value: TMenuItem);
    function GetIsMenuBar: Boolean;
    function GetItemsCount: Integer;
    function GetItem(const AIndex: Integer): TFmxObject;
    { access }
    property IsMenuBar: Boolean read GetIsMenuBar;
    property Loop: Boolean read GetLoop write SetLoop;
    property ParentView: IMenuView read GetParentView write SetParentView;
    property ChildView: IMenuView read GetChildView write SetChildView;
    property Selected: TMenuItem read GetSelected write SetSelected;
  end;

  IFMXMenuService = interface(IInterface)
    ['{8338685D-26BB-4421-AE54-1DC8456DC2A0}']
    procedure StartMenuLoop(const AView: IMenuView);
    function ShortCutToText(ShortCut: TShortCut): string;
    procedure ShortCutToKey(ShortCut: TShortCut; var Key: Word; var Shift: TShiftState);
    function TextToShortCut(Text: string): Integer;
    procedure CreateOSMenu(AForm: TCommonCustomForm; const AMenu: IItemsContainer);
    procedure UpdateMenuItem(const AItem: IItemsContainer; AChange: TMenuItemChanges);
    procedure DestroyMenuItem(const AItem: IItemsContainer);
    function IsMenuBarOnWindowBorder: boolean;
    procedure UpdateMenuBar;
  end;

  TMenuItemBitmap = class (TBitmap)
  private
    FMenuItem: TMenuItem;
  protected
    procedure DoChange; override;
  public
    property MenuItem: TMenuItem read FMenuItem;
  end;

{ TMenuItem }
  /// <summary> This class describe the role and functionality of a menu item.
  ///  This object is used to populate different types of menus defined in FMX:
  ///  main menu, menu bar, popup menu.
  /// </summary>
  TMenuItem = class(TTextControl, IItemsContainer, INativeControl, IGroupName, IGlyph, IKeyShortcut, IIsChecked)
  private
    FContent: TContent;
    FNoItemsContent: TFmxObject;
    FIsSelected: Boolean;
    FPopupTimer: TTimer;
    FShortCut: TShortCut;
    FShortCutObject: TText;
    FSubmarkObject: TControl;
    FCheckmarkObject: TControl;
    FCheckBackgroundObject: TControl;
    FGlyphObject: TControl;
    FOldGlyphObjectVisible: Boolean;
    FOldGlyphAutoHide: Boolean;
    FOldGlyphVisible: Boolean;
    FOldCheckmarkVisible: Boolean;
    FOldCheckmarkStyleVisible: Boolean;
    FBitmapObject: TControl;
    FOldBitmapVisible: Boolean;
    FCheckMarkStyle: TControl;
    FOldFShortCutVisible: Boolean;
    FOldSubmarkVisible: Boolean;
    FShown: Boolean;
    FGlyph: TGlyph;
    FHandle: TFmxHandle;
    FIsChecked: Boolean;
    FBitmap: TBitmap;
    FAutoCheck: Boolean;
    FRadioItem: Boolean;
    FGroupName: string;
    FMenuService: IFMXMenuService;
    FClickImmediately: Boolean;
    FImageLink: TGlyphImageLink;
    [Weak] FImages: TCustomImageList;
    FSubMenuVisible: Boolean;
    FImageOffset: Single;
    FIsMenuBarItem: Boolean;
    FIsMenuBarItemCached: Boolean;
    procedure SetIsSelected(const Value: Boolean);
    function GetMenuView: IMenuView;
    procedure DoPopupTimer(Sender: TObject);
    procedure SetShortCut(const Value: TShortCut);
    function GetShortCut: TShortCut;
    function ShortCutStored: Boolean;
    procedure SetBitmap(const Value: TBitmap);
    procedure TurnSiblingsOff;
    function GetRadioItem: Boolean;
    procedure SetRadioItem(const Value: Boolean);
    function GetIsChecked: boolean;
    procedure SetIsChecked(const Value: boolean);
    function IsCheckedStored: boolean;
    function GetGroupName: string;
    procedure SetGroupName(const Value: string);
    function GroupNameStored: boolean;
    function GetGroupIndex: Integer;
    procedure SetGroupIndex(const Value: Integer);
    procedure UpdateGroup(const Value: string);
    function RadioItemStored: Boolean;
    function GetAutoCheck: Boolean;
    procedure SetAutoCheck(const Value: Boolean);
    function AutoCheckStored: Boolean;
    procedure AddNoItemObject(const AObject: TFmxObject);
    function GetHandle: TFmxHandle;
    procedure SetHandle(const Value: TFmxHandle);
    function GetHandleSupported: boolean;
    function GetItems(const Index: Integer): TMenuItem;
    procedure DoUpdateMenu;
    procedure UpdateVisibleObjects;
    function GetImages: TCustomImageList;
    procedure SetImages(const Value: TCustomImageList);
    { IGlyph }
    function GetImageIndex: TImageIndex;
    procedure SetImageIndex(const Value: TImageIndex);
    function GetImageList: TBaseImageList; inline;
    procedure SetImageList(const Value: TBaseImageList);
    function IGlyph.GetImages = GetImageList;
    procedure IGlyph.SetImages = SetImageList;
    function HasOffsetOfGlyph: Boolean;
    function HasOffsetOfBitmap: Boolean;
    procedure InitItem(const CleanAutoHide: Boolean; const Left, Top, Width, Height: Single);
    function GetParentMenuItem: TMenuItem;
    function GetMainMenu: TMainMenu;
    function GetIsSeparator: Boolean;
  protected
    /// <summary>Overrides TTextControl.DoFilterControlText.</summary>
    function DoFilterControlText(const AText: string): string; override;
    { IAcceleratorKeyReciever / TTextControl }
    /// <summary>Overrides TTextControl.CanTriggerAcceleratorKey.</summary>
    function CanTriggerAcceleratorKey: Boolean; override;
    procedure TriggerAcceleratorKey; override;
    procedure DoAddObject(const AObject: TFmxObject); override;
    procedure DoInsertObject(Index: Integer; const AObject: TFmxObject); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Single); override;
    procedure Click; override;
    procedure DefineProperties(Filer: TFiler); override;
    procedure SetText(const Value: string); override;
    function EnterChildren(AObject: IControl): Boolean; override;
    procedure ActionChange(Sender: TBasicAction; CheckDefaults: Boolean); override;
    function GetVisibleItemsCount: Integer;
    function GetDefaultStyleLookupName: string; override;
    procedure Move; override;
    procedure Resize; override;
    procedure DoBitmapChanged; virtual;
    function CalcVisibleObjectsItemSize(const ACanvas: TCanvas; APointF: TPointF): TPointF;
    /// <summary> Should be called when you change an instance or reference to instance of <b>TBaseImageList</b> or the
    /// <b>ImageIndex</b> property
    /// <para>See also <b>FMX.ActnList.IGlyph</b></para></summary>
    procedure ImagesChanged; virtual;
    /// <summary> Determines whether the <b>ImageIndex</b> property needs to be stored in the fmx-file</summary>
    /// <returns> <c>True</c> if the <b>ImageIndex</b> property needs to be stored in the fmx-file</returns>
    function ImageIndexStored: Boolean; virtual;
    procedure SetParent(const Value: TFmxObject); override;
    procedure ParentChanged; override;
    { style }
    procedure ApplyStyle; override;
    procedure FreeStyle; override;
    { IItemContainer }
    function GetItemsCount: Integer;
    function GetItem(const AIndex: Integer): TFmxObject;
    procedure SetVisible(const AValue: Boolean); override;
    procedure SetEnabled(const Value: Boolean); override;
    procedure DialogKey(var Key: Word; Shift: TShiftState); override;
    /// <summary> Determines whether the item is child of <see cref="FMX.Menus|TMenuBar">TMenuBar</see> control.
    /// The appearance of these menu items is different from all the others. For example: the default style is
    /// <c>'menubaritemstyle'</c> </summary>
    function IsMenuBarItem: Boolean;
    { OS Menu }
    property Handle: TFmxHandle read GetHandle write SetHandle;
    /// <summary> The additional text offset to the right which is determined by the width of the picture</summary>
    property ImageOffset: Single read FImageOffset;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Clear;
    { menu }
    function CalcSize: TPointF;
    function CalcRenderSize: TPointF;
    function CanBeClicked: Boolean;
    /// <summary>Returns parent menu item.</summary>
    property ParentMenuItem: TMenuItem read GetParentMenuItem;
    /// <summary>Returns the main menu to which the menu item is attached.</summary>
    property MainMenu: TMainMenu read GetMainMenu;
    { menus }
    procedure Popup;
    procedure NeedPopup;
    function HavePopup: Boolean;
    property View: IMenuView read GetMenuView;
    property ItemsCount: Integer read GetItemsCount;
    property Items[const AIndex: Integer]: TMenuItem read GetItems;
    property IsSelected: Boolean read FIsSelected write SetIsSelected;
    /// <summary>Returns true, if current menu item is separator.</summary>
    property IsSeparator: Boolean read GetIsSeparator;
    ///<summary>The list of images. Can be <c>nil</c>. <para>See also <b>FMX.ActnList.IGlyph</b></para></summary>
    property Images: TCustomImageList read GetImages;
  published
    property Action;
    property Bitmap: TBitmap read FBitmap write SetBitmap;
    property Enabled;
    property Locked;
    property Padding;
    property Opacity;
    property Margins;
    property PopupMenu;
    property AutoCheck: Boolean read GetAutoCheck write SetAutoCheck stored AutoCheckStored default False;
    property GroupIndex: Integer read GetGroupIndex write SetGroupIndex stored GroupNameStored default 0;
    property RadioItem: Boolean read GetRadioItem write SetRadioItem stored RadioItemStored default False;
    property IsChecked: Boolean read FIsChecked write SetIsChecked stored IsCheckedStored default False;
    property ShortCut: TShortCut read GetShortCut write SetShortCut stored ShortCutStored;
    property StyleLookup;
    property Text;
    property TouchTargetExpansion;
    property Visible default True;
    ///<summary> Zero based index of an image. The default is <c>-1</c>.
    ///<para> See also <b>FMX.ActnList.IGlyph</b></para></summary>
    ///<remarks> If non-existing index is specified, an image is not drawn and no exception is raised</remarks>
    property ImageIndex: TImageIndex read GetImageIndex write SetImageIndex stored ImageIndexStored;
    {events}
    property OnApplyStyleLookup;
    property OnFreeStyle;
    property OnClick;
  end;

{ TPopupMenu }
   ///<summary> This class implement a popup type menu. To open this popupmenu you
   /// to specify the call Popup(X, Y) where X, Y are the top left coordinates of the 
   /// menu placement rectangle. 
   ///</summary>
  [ComponentPlatformsAttribute(pfidWindows or pfidOSX or pfidLinux)]
  TPopupMenu = class(TCustomPopupMenu, IItemsContainer, IGlyph)
  public const
    DefaultUseParentScale = True;
  private
    FContent: TContent;
    FNoItemsContent: TFmxObject;
    FPopupPoint: TPointF;
    FMenuService: IFMXMenuService;
    FImageLink: TGlyphImageLink;
    FUseParentScale: Boolean;
    [Weak] FImages: TCustomImageList;
    procedure AddNoItemObject(const AObject: TFmxObject);
    { IItemContainer }
    function GetItemsCount: Integer;
    function GetItem(const AIndex: Integer): TFmxObject;
    function GetObject: TFmxObject;
    function GetItems(const Index: Integer): TMenuItem;
    function GetImages: TCustomImageList;
    procedure SetImages(const Value: TCustomImageList);
    { IGlyph }
    function GetImageIndex: TImageIndex;
    procedure SetImageIndex(const Value: TImageIndex);
    function GetImageList: TBaseImageList; inline;
    procedure SetImageList(const Value: TBaseImageList);
    function IGlyph.GetImages = GetImageList;
    procedure IGlyph.SetImages = SetImageList;
  protected
    procedure DoAddObject(const AObject: TFmxObject); override;
    procedure DoInsertObject(Index: Integer; const AObject: TFmxObject); override;
    procedure DoRemoveObject(const AObject: TFmxObject); override;
    procedure Loaded; override;
    /// <summary> Should be called when you change an instance or reference to instance of <b>TBaseImageList</b> or the
    /// <b>ImageIndex</b> property
    /// <para>See also <b>FMX.ActnList.IGlyph</b></para></summary>
    procedure ImagesChanged; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Clear;
    procedure CloseMenu; inline;
    procedure Popup(X, Y: Single); override;
    property PopupPoint: TPointF read FPopupPoint;
    procedure DialogKey(var Key: Word; Shift: TShiftState);
    property ItemsCount: Integer read GetItemsCount;
    property Items[const AIndex: Integer]: TMenuItem read GetItems;
  published
    ///<summary> The list of images. Can be <c>nil</c>. <para>See also <b>FMX.ActnList.IGlyph</b></para></summary>
    property Images: TCustomImageList read GetImages write SetImages;
    property UseParentScale: Boolean read FUseParentScale write FUseParentScale default DefaultUseParentScale;
    property OnPopup;
  end;

{ TMenuBar }
  ///<summary> This class implement a menu on a bar. The user can set the position
  ///  of the bar. This type of the menu can be tansform in the main meu of an
  /// application if USEOsMenu is set to True.
  ///</summary>
  [ComponentPlatformsAttribute(pfidWindows or pfidOSX or pfidLinux)]
  TMenuBar = class(TStyledControl, IItemsContainer, INativeControl, IMenuView, IGlyph)
  private
    FContent: TContent;
    FContentLayout: TControl;
    FNoItemsContent: TControl;
    { IMenuView }
    FLoop: Boolean;
    FParentView: IMenuView;
    FChildView: IMenuView;
    FSelected: TMenuItem;
    FMenuService: IFMXMenuService;
    FExplicitVisible: Boolean;
    FUpdatingVisible: Boolean;
    FImageLink: TGlyphImageLink;
    [Weak] FImages: TCustomImageList;
    function GetLoop: Boolean;
    procedure SetLoop(const Value: Boolean);
    function GetParentView: IMenuView;
    procedure SetParentView(const Value: IMenuView);
    function GetChildView: IMenuView;
    procedure SetChildView(const Value: IMenuView);
    function GetSelected: TMenuItem;
    procedure SetSelected(const Value: TMenuItem);
    function GetIsMenuBar: Boolean;
    { IItemsContainer }
    function GetItemsCount: Integer;
    function GetItem(const AIndex: Integer): TFmxObject;
    { }
    procedure AddNoItemObject(AObject: TFmxObject);
    function GetHandle: TFmxHandle;
    procedure SetHandle(const Value: TFmxHandle);
    function GetHandleSupported: boolean;
    function GetItems(const Index: Integer): TMenuItem;
    procedure UpdateVisible;
    procedure StartMenuLoopMessage(const Sender: TObject; const M: TMessage);
    function GetImages: TCustomImageList;
    procedure SetImages(const Value: TCustomImageList);
    { IGlyph }
    function GetImageIndex: TImageIndex;
    procedure SetImageIndex(const Value: TImageIndex);
    function GetImageList: TBaseImageList; inline;
    procedure SetImageList(const Value: TBaseImageList);
    function IGlyph.GetImages = GetImageList;
    procedure IGlyph.SetImages = SetImageList;
  protected
    function GetMenuItem(const AIndex: Integer): TMenuItem;
    procedure DefineProperties(Filer: TFiler); override;
    procedure DoRealign; override;
    procedure DoAddObject(const AObject: TFmxObject); override;
    procedure DoInsertObject(Index: Integer; const AObject: TFmxObject); override;
    procedure DoRemoveObject(const AObject: TFmxObject); override;
    procedure DialogKey(var Key: Word; Shift: TShiftState); override;
    procedure DoUpdateOSMenu(const Sender: TObject);
    procedure SetVisible(const Value: Boolean); override;
    /// <summary> Should be called when you change an instance or reference to instance of <b>TBaseImageList</b> or the
    /// <b>ImageIndex</b> property
    /// <para>See also <b>FMX.ActnList.IGlyph</b></para></summary>
    procedure ImagesChanged; virtual;
    { TComponent }
    procedure Loaded; override;
    { TStyledControl }
    function GetDefaultStyleLookupName: string; override;
    procedure ApplyStyle; override;
    procedure FreeStyle; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure StartMenuLoop;
    procedure Clear;
    property ItemsCount: Integer read GetItemsCount;
    property Items[const AIndex: Integer]: TMenuItem read GetItems;
  published
    property Anchors;
    property Align default TAlignLayout.Top;
    property ClipChildren;
    property ClipParent;
    property Cursor;
    property DragMode;
    property EnableDragHighlight;
    property Enabled;
    ///<summary> The list of images. Can be <c>nil</c>. <para>See also <b>FMX.ActnList.IGlyph</b></para></summary>
    property Images: TCustomImageList read GetImages write SetImages;
    property Locked;
    property Height;
    property HelpContext;
    property HelpKeyword;
    property HelpType;
    property Padding;
    property Opacity;
    property Margins;
    property PopupMenu;
    property Position;
    property RotationAngle;
    property RotationCenter;
    property Scale;
    property Size;
    property StyleLookup;
    property TabOrder;
    property TouchTargetExpansion;
    property Visible default True;
    property Width;
    { events }
    property OnApplyStyleLookup;
    property OnFreeStyle;
    { Drag and Drop events }
    property OnDragEnter;
    property OnDragLeave;
    property OnDragOver;
    property OnDragDrop;
    property OnDragEnd;
    {Mouse events}
    property OnCanFocus;
    property OnClick;

    property OnMouseMove;
    property OnMouseWheel;
    property OnMouseEnter;
    property OnMouseLeave;

    property OnPainting;
    property OnPaint;
    property OnResize;
    property OnResized;
  end;

{ TMainMenu }
  ///<summary> This class implements the principal menu of an application. On
  ///  Windows is situated on the most top level of the application form. On MAC
  ///  this menu appear outside the application form in the main menu of the OS
  ///  with respect to the application.
  ///</summary>
  [ComponentPlatformsAttribute(pfidWindows or pfidOSX or pfidLinux)]
  TMainMenu = class(TFmxObject, IItemsContainer, INativeControl, IGlyph)
  private
    FMenuService: IFMXMenuService;
    FHandle: TFmxHandle;
    FStyleChangedId: TMessageSubscriptionId;
    FOldForm: TCommonCustomForm;
    FImageLink: TGlyphImageLink;
    [Weak] FImages: TCustomImageList;
    procedure StyleChangedHandler(const Sender: TObject; const Msg : TMessage);
    { IItemContainer }
    function GetItemsCount: Integer;
    function GetItem(const AIndex: Integer): TFmxObject;
    function GetObject: TFmxObject;
    function GetHandle: TFmxHandle;
    procedure SetHandle(const Value: TFmxHandle);
    function GetHandleSupported: boolean;
    function ParentForm: TCommonCustomForm;
    function GetImages: TCustomImageList;
    procedure SetImages(const Value: TCustomImageList);
    { IGlyph }
    function GetImageIndex: TImageIndex;
    procedure SetImageIndex(const Value: TImageIndex);
    function GetImageList: TBaseImageList; inline;
    procedure SetImageList(const Value: TBaseImageList);
    function IGlyph.GetImages = GetImageList;
    procedure IGlyph.SetImages = SetImageList;
  protected
    procedure ParentChanged; override;
    procedure DoRecreateOSMenu(const Form: TCommonCustomForm); virtual;
    procedure DoAddObject(const AObject: TFmxObject); override;
    procedure DoInsertObject(Index: Integer; const AObject: TFmxObject); override;
    procedure DoRemoveObject(const AObject: TFmxObject); override;
    procedure Loaded; override;
    /// <summary> Should be called when you change an instance or reference to instance of <b>TBaseImageList</b> or the
    /// <b>ImageIndex</b> property
    /// <para>See also <b>FMX.ActnList.IGlyph</b></para></summary>
    procedure ImagesChanged; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure BeforeDestruction; override;
    procedure RecreateOSMenu;
    procedure Exchange(const AObject1, AObject2: TFmxObject); override;
    //added to enable the shortcut functionality of main menu items
    procedure DialogKey(var Key: Word; Shift: TShiftState);
    property ItemsCount: Integer read GetItemsCount;
    property Items[const AIndex: Integer]: TFmxObject read GetItem;
  published
    ///<summary> The list of images. Can be <c>nil</c>. <para>See also <b>FMX.ActnList.IGlyph</b></para></summary>
    property Images: TCustomImageList read GetImages write SetImages;
  end;

function TextToShortCut(const Text: string): Integer;

implementation

uses
  System.SysConst, System.RTLConsts, System.SysUtils, System.Actions, System.Generics.Collections, System.Math,
  FMX.Consts, FMX.Dialogs, FMX.DialogService, FMX.Platform, FMX.Utils, FMX.AcceleratorKey, FMX.Styles,
  DelphiWindowStyle.FMX, FMX.StyledContextMenu, WinUI3.Utils;

const
  DefaultMenuItemSeparatorHeight = 8;
  DefaultMenuItemHeight = 23;

var
  GMainMenu: TFmxObject;

function TextToShortCut(const Text: string): Integer;
begin
  Result := FMX.ActnList.TextToShortCut(Text);
end;

procedure UpdateGlyph(const Owner: TComponent; const Child: TFmxObject);
var
  OwnerGlyph: IGlyph;
begin
  if Child is TMenuItem then
  begin
    if Supports(Owner, IGlyph, OwnerGlyph) and (OwnerGlyph.Images is TCustomImageList) then
      TMenuItem(Child).SetImages(TCustomImageList(OwnerGlyph.Images))
    else
      TMenuItem(Child).SetImages(nil);
  end;
end;

{$REGION 'implementation of TClickList'}
type
  TClickList = class (TComponent)
  public const
    TimerInterval: Integer = 20;
  private
    FMenuItemList: TList<Pointer>;
    FTimers: TList<TTimer>;
    procedure AddTimer;
    procedure RemoveTimer(const ATimer: TTimer);
    procedure UpdateTimers;
    procedure DoClicks(Sender: TObject);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Add(const MenuItem: TMenuItem);
    procedure Remove(const MenuItem: TMenuItem);
    function Contains(const MenuItem: TMenuItem): Boolean;
  end;

var
  vClickList: TClickList;

{ TClickList }

constructor TClickList.Create(AOwner: TComponent);
begin
  inherited;
  FMenuItemList := TList<Pointer>.Create;
end;

destructor TClickList.Destroy;
begin
  UpdateTimers;
  FreeAndNil(FMenuItemList);
  inherited;
end;

procedure TClickList.AddTimer;
var
  NewTimer: TTimer;
begin
  if not (csDestroying in ComponentState) then
  begin
    if FTimers = nil then
      FTimers := TList<TTimer>.Create;
    NewTimer := TTimer.Create(Self);
    NewTimer.Interval := TimerInterval;
    NewTimer.OnTimer := DoClicks;
    FTimers.Add(NewTimer);
    NewTimer.Enabled := True;
  end;
end;

procedure TClickList.RemoveTimer(const ATimer: TTimer);
begin
  if FTimers <> nil then
  begin
    FTimers.Remove(ATimer);
    if FTimers.Count = 0 then
      FreeAndNil(FTimers);
  end;
end;

procedure TClickList.UpdateTimers;
var
  ItemCount: Integer;
begin
  ItemCount := 0;
  if not (csDestroying in ComponentState) then
  begin
    if FMenuItemList <> nil then
      ItemCount := FMenuItemList.Count;
    if ItemCount > 0 then
      while (FTimers = nil) or (FTimers.Count < ItemCount) do
        AddTimer;
  end;
  while (FTimers <> nil) and (FTimers.Count > ItemCount) do
    FTimers.Last.Free;
end;

procedure TClickList.DoClicks(Sender: TObject);
var
  MenuItem: TMenuItem;
begin
  if Sender is TTimer then
  begin
    TTimer(Sender).Enabled := False;
    try
      RemoveTimer(TTimer(Sender));
      if (FMenuItemList <> nil) and (FMenuItemList.Count > 0) then
      begin
        MenuItem := FMenuItemList[0];
        FMenuItemList.Delete(0);
        RemoveFreeNotification(MenuItem);
        MenuItem.FClickImmediately := True;
        try
          MenuItem.Click;
        finally
          MenuItem.FClickImmediately := False;
        end;
      end;
    finally
      TFmxObject(Sender).Free;
    end;
  end;
end;

procedure TClickList.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if Operation = opRemove then
  begin
    if AComponent is TMenuItem then
      FMenuItemList.Remove(AComponent)
    else if AComponent is TTimer then
      RemoveTimer(TTimer(AComponent));
  end;
end;

procedure TClickList.Add(const MenuItem: TMenuItem);
begin
  if MenuItem <> nil then
  begin
    FreeNotification(MenuItem);
    FMenuItemList.Add(MenuItem);
    UpdateTimers;
  end;
end;

procedure TClickList.Remove(const MenuItem: TMenuItem);
begin
  if MenuItem <> nil then
  begin
    FMenuItemList.Remove(MenuItem);
    RemoveFreeNotification(MenuItem);
    UpdateTimers;
  end;
end;

function TClickList.Contains(const MenuItem: TMenuItem): Boolean;
begin
  Result := FMenuItemList.Contains(MenuItem);
end;

{$ENDREGION}

type
  TAutopopupMenuTimer = class (TTimer)
  private
    FOldItem: TMenuItem;
    FOldPoint: TPoint;
    FMouseSleeps: Boolean;
    FActive: Boolean;
    FOldTime: TDateTime;
    FStartCount: Integer;
    FDelay: Integer;
    procedure SetDelay(const Value: Integer);
    procedure SetOldItem(const Value: TMenuItem);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure ProcTimer(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    procedure Start;
    procedure Stop;
    property OldItem: TMenuItem read FOldItem write SetOldItem;
    property Delay: Integer read FDelay write SetDelay;
  end;

{ TAutopopupMenuTimer }

constructor TAutopopupMenuTimer.Create(AOwner: TComponent);
var
  SystemInfoSrv: IFMXSystemInformationService;
begin
  inherited;
  Enabled := False;
  FDelay := 0;
  if TPlatformServices.Current.SupportsPlatformService(IFMXSystemInformationService, SystemInfoSrv) then
    FDelay := SystemInfoSrv.GetMenuShowDelay;
  if FDelay <= 0 then
    FDelay := 200;
  Interval := Max(FDelay div 20, 10);
  OnTimer := ProcTimer;
end;

procedure TAutopopupMenuTimer.SetDelay(const Value: Integer);
begin
  if FDelay <> Value then
  begin
    FDelay := Value;
    ProcTimer(self);
  end;
end;

procedure TAutopopupMenuTimer.SetOldItem(const Value: TMenuItem);
begin
  if FOldItem <> Value then
  begin
    if FOldItem <> nil then
      TComponent(FOldItem).RemoveFreeNotification(Self);
    FOldItem := Value;
    if FOldItem <> nil then
      TComponent(FOldItem).FreeNotification(self);
    FOldTime := Now;
  end;
end;

procedure TAutopopupMenuTimer.Start;
var
  MouseSvc: IFMXMouseService;
begin
  if (FStartCount > 0) or TPlatformServices.Current.SupportsPlatformService(IFMXMouseService, MouseSvc) then
    Inc(FStartCount);
  if FStartCount >= 1 then
    Enabled := True;
end;

procedure TAutopopupMenuTimer.Stop;
begin
  if FStartCount > 0 then
  begin
    Dec(FStartCount);
    if FStartCount = 0 then
      Enabled := False;
  end;
end;

procedure TAutopopupMenuTimer.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if Operation = opRemove then
  begin
    if AComponent = FOldItem then
    begin
      FOldItem := nil;
      FOldTime := Now;
    end;
  end;
end;

procedure TAutopopupMenuTimer.ProcTimer(Sender: TObject);
var
  P: TPointF;
  NewPoint: TPoint;
  I, DTime: Integer;
  Control: IControl;
  ViewObject: TFmxObject;
  NewItem: TMenuItem;
  CurrentTime: TDateTime;
  Form: TCommonCustomForm;
  NewView: IMenuView;
  CurrentView: IMenuView;
  SubViewFound: Boolean;
  LDelay: Integer;
  function FormFound(const Form: TCommonCustomForm): TCommonCustomForm;
  var
    R: TRect;
  begin
    Result := nil;
    if Form.Visible then
    begin
      if Form is TCustomPopupForm then
        R := TRect.Create(TCustomPopupForm(Form).ScreenContentRect.Round)
      else
        R := TRect.Create(TPoint.Create(Form.Left, Form.Top), Form.Width, Form.Height);
      if R.Contains(NewPoint) then
        Result := Form;
    end;
  end;
begin
  P := Screen.MousePos;
  CurrentTime := Now;
  DTime := Round(Min(MaxInt, (CurrentTime - FOldTime) * MSecsPerDay));
  LDelay := Delay;
  NewPoint := TPoint.Create(Round(P.X), Round(P.Y));
  try
    if FOldPoint = NewPoint then
      FMouseSleeps := True
    else
    begin
      if FMouseSleeps then
      begin
        // Skip the search menu item once, in the case of accidental movement of the mouse over another menu item.
        FMouseSleeps := False;
        Exit;
      end;
    end;
    NewItem := nil;
    Form := nil;
    for I := Screen.PopupFormCount - 1 downto 0 do
    begin
      Form := FormFound(Screen.PopupForms[I]);
      if Form <> nil then
        Break;
    end;
    if Form = nil then
      for I := Screen.FormCount - 1 downto 0 do
      if Screen.Forms[I].FormStyle = TFormStyle.StayOnTop then
      begin
        Form := FormFound(Screen.Forms[I]);
        if Form <> nil then
          Break;
      end;
    if Form = nil then
      for I := Screen.FormCount - 1 downto 0 do
      if Screen.Forms[I].FormStyle <> TFormStyle.StayOnTop then
      begin
        Form := FormFound(Screen.Forms[I]);
        if Form <> nil then
          Break;
      end;
    if Form <> nil then
    begin
      Control := Form.ObjectAtPoint(P);
      if (Control <> nil) and (Control.GetObject is TMenuItem) then
      begin
        SubViewFound := False;
        NewItem := TMenuItem(Control.GetObject);
        if (NewItem <> nil) and (not NewItem.IsSelected) then
        begin
          NewView := NewItem.View;
          if NewView <> nil then
          begin
            CurrentView := NewView;
            while CurrentView.ChildView <> nil do
              CurrentView := CurrentView.ChildView;
            while CurrentView <> NewView do
            begin
              CurrentView.Loop := False;
              ViewObject := CurrentView.GetObject;
              if (ViewObject <> nil) and (ViewObject.Parent is TPopup) then
                TPopup(ViewObject.Parent).IsOpen := False;
              SubViewFound := True;
              CurrentView := CurrentView.ParentView;
            end;
          end;
        end;
        if SubViewFound then
        begin
          FActive := True;
          OldItem := NewItem;
          Exit;
        end;
      end;
    end;
    if NewItem <> FOldItem then
    begin
      OldItem := NewItem;
    end
    else
    begin
      if (FOldItem <> nil) and ((Form.FormStyle = TFormStyle.Popup) or FActive) then
      begin
        if FActive then
        begin
          if Form.FormStyle = TFormStyle.Popup then
            LDelay := LDelay div 3
          else
            LDelay := 0;
        end;
        if (DTime > LDelay) then
        begin
          FOldItem.NeedPopup;
          FOldTime := CurrentTime;
          FActive := False;
        end;
      end;
    end;
  finally
    FOldPoint := NewPoint;
  end;
end;

var
  vAutopopupMenuTimer: TAutopopupMenuTimer;

procedure StartAutopopupMenuTimer;
begin
  if vAutopopupMenuTimer = nil then
    vAutopopupMenuTimer := TAutopopupMenuTimer.Create(nil);
  vAutopopupMenuTimer.Start;
end;

procedure StopAutopopupMenuTimer;
begin
  if vAutopopupMenuTimer <> nil then
    vAutopopupMenuTimer.Stop;
end;

type

  TMenuItemContent = class(TContent)
  protected
    procedure DoRealign; override;
    procedure DoAddObject(const AObject: TFmxObject); override;
    procedure DoInsertObject(Index: Integer; const AObject: TFmxObject); override;
  public
  end;

  TMenuViewContent = class(TContent)
  protected
    procedure DoRealign; override;
    procedure DoAddObject(const AObject: TFmxObject); override;
    procedure DoInsertObject(Index: Integer; const AObject: TFmxObject); override;
  public
  end;

  TPopupMenuContent = class(TContent)
  protected
    procedure DoRealign; override;
    procedure DoAddObject(const AObject: TFmxObject); override;
    procedure DoInsertObject(Index: Integer; const AObject: TFmxObject); override;
  public
  end;

  TMenuBarContent = class(TContent)
  protected
    procedure DoRealign; override;
    procedure DoAddObject(const AObject: TFmxObject); override;
    procedure DoInsertObject(Index: Integer; const AObject: TFmxObject); override;
    procedure DoRemoveObject(const AObject: TFmxObject); override;
  public
  end;

  ///<summary> This class implement the getter/setter methods from IMenuView interface and
  /// overrides some related style methods.
  ///</summary>
  TMenuView = class(TStyledControl, IMenuView)
  private
    FContent: TContent;
    FContentLayout: TControl;
    FNoItemsContent: TControl;
    FLoop: Boolean;
    FParentView, FChildView: IMenuView;
    FSelected: TMenuItem;
    procedure AddNoItemObject(AObject: TFmxObject);
    { IMenuView }
    function GetLoop: Boolean;
    procedure SetLoop(const Value: Boolean);
    function GetParentView: IMenuView;
    procedure SetParentView(const Value: IMenuView);
    function GetChildView: IMenuView;
    procedure SetChildView(const Value: IMenuView);
    function GetSelected: TMenuItem;
    procedure SetSelected(const Value: TMenuItem);
    function GetIsMenuBar: Boolean;
    function GetItemsCount: Integer;
    function GetItem(const AIndex: Integer): TFmxObject;
  protected
    procedure DoRealign; override;
    procedure DoAddObject(const AObject: TFmxObject); override;
    { TStyledControl }
    procedure ApplyStyle; override;
    procedure FreeStyle; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

{ TMenuItemContent }

procedure TMenuItemContent.DoAddObject(const AObject: TFmxObject);
begin
  if not (AObject is TMenuItem) and (Parent is TMenuItem) then
    TMenuItem(Parent).AddNoItemObject(AObject)
  else
  begin
    UpdateGlyph(Owner, AObject);
    inherited;
  end;
end;

procedure TMenuItemContent.DoInsertObject(Index: Integer; const AObject: TFmxObject);
begin
  if not (AObject is TMenuItem) and (Parent is TMenuItem) then
    TMenuItem(Parent).AddNoItemObject(AObject)
  else
  begin
    UpdateGlyph(Owner, AObject);
    inherited;
  end;
end;


procedure TMenuItemContent.DoRealign;
begin
end;

{ TMenuItemBitmap }

procedure TMenuItemBitmap.DoChange;
begin
  if FMenuItem <> nil then
    FMenuItem.DoBitmapChanged;
  inherited;
end;

type
  TPopupOfMenu = class(TPopup)
  protected
    FClearBG: Boolean;
    procedure OnFormShow(Sender: TObject);
    function CreatePopupForm: TFmxObject; override;
    constructor Create(AOwner: TComponent); override;
  end;

{ TPopupOfMenu }

constructor TPopupOfMenu.Create(AOwner: TComponent);
begin
  inherited;
  FClearBG := IsWin11OrNewest;
end;

function TPopupOfMenu.CreatePopupForm: TFmxObject;
begin
  Result := inherited;
  if Result is TCustomPopupForm then
    TCustomPopupForm(Result).OnShow := OnFormShow;
end;

procedure TPopupOfMenu.OnFormShow(Sender: TObject);
begin
  if not IsWin11OrNewest then
    //TCustomPopupForm(Sender).SetAccentPolicy(TColorRec.Black)
  else
    TCustomPopupForm(Sender).SetAccentPolicy(TColorRec.Null);
  TCustomPopupForm(Sender).MouseCapture;
end;

{ TMenuItem }

constructor TMenuItem.Create(AOwner: TComponent);
begin
  inherited;
  TPlatformServices.Current.SupportsPlatformService(IFMXMenuService, FMenuService);
  FContent := TMenuItemContent.Create(Self);
  FContent.Parent := Self;
  FContent.Stored := False;
  FContent.Locked := True;
  FContent.HitTest := False;
  FContent.Visible := False;
  FImageLink := TGlyphImageLink.Create(Self);
  TextAlign := TTextAlign.Leading;
  WordWrap := False;
  FBitmap := TMenuItemBitmap.Create(0, 0);
  TMenuItemBitmap(FBitmap).FMenuItem := self;
end;

procedure TMenuItem.DefineProperties(Filer: TFiler);
begin
  inherited;
  Filer.DefineProperty('TabOrder', IgnoreIntegerValue, nil, False);
  Filer.DefineProperty('Align', IgnoreIntegerValue, nil, False);
  Filer.DefineProperty('Height', IgnoreFloatValue, nil, False);
  Filer.DefineProperty('Width', IgnoreFloatValue, nil, False);
  Filer.DefineProperty('Position.X',IgnoreFloatValue, nil, False);
  Filer.DefineProperty('Position.Y', IgnoreFloatValue, nil, False);
  Filer.DefineProperty('RotationAngle', IgnoreFloatValue, nil, False);
  Filer.DefineProperty('RotationCenter.X', IgnoreFloatValue, nil, False);
  Filer.DefineProperty('Scale.X', IgnoreFloatValue, nil, False);
  Filer.DefineProperty('Scale.Y', IgnoreFloatValue, nil, False);
  Filer.DefineProperty('WordWrap', IgnoreBooleanValue, nil, False);
  Filer.DefineProperty('IsSelected', IgnoreBooleanValue, nil, False);
  Filer.DefineProperty('HitTest', IgnoreBooleanValue, nil, False);
  Filer.DefineProperty('Cursor', IgnoreBooleanValue, nil, False);
end;

destructor TMenuItem.Destroy;
begin
  Handle := 0;
  FreeAndNil(FBitmap);
  FreeAndNil(FImageLink);
  FreeAndNil(FContent);
  FMenuService := nil;
  inherited;
end;

function TMenuItem.GetHandleSupported: boolean;
var P: TFmxObject;
begin
  Result := false;
  if (csDesigning in ComponentState) then Exit;
  P := self;
  while P.Parent <> nil do
  begin
    if P.Parent is TContent then
      P := P.Parent;
    if (P is TMenuBar) then
    begin
      Result := False;
      break;
    end
    else if (P is TMainMenu) then
    begin
      Result := True;
      break;
    end;
    P := P.Parent;
  end;
end;

function TMenuItem.GetHandle: TFmxHandle;
begin
  Result := FHandle;
end;

procedure TMenuItem.SetHandle(const Value: TFmxHandle);
begin
  if Value <> FHandle then
  begin
    if (FHandle <> 0) and (FMenuService <> nil) then
      FMenuService.DestroyMenuItem(Self);
    FHandle := Value;
    UpdateVisibleObjects;
  end;
end;

procedure TMenuItem.DialogKey(var Key: Word; Shift: TShiftState);
var
  k: Word;
  I: Integer;
  SState: TShiftState;
  UseInherit: boolean;
begin
  if (Key > 0) and Enabled and (FMenuService <> nil) then
  begin
    UseInherit := (ActionClient and (Action is TCustomAction)) or (ShortCut = 0);
    if UseInherit and (ShortCut <> 0) then
    begin
      I := 0;
      UseInherit := TCustomAction(Action).ShortCut = ShortCut;
      while (not UseInherit) and
            (I < TCustomAction(Action).SecondaryShortCuts.Count) do
      begin
        UseInherit := TCustomAction(Action).SecondaryShortCuts.ShortCuts[I] = ShortCut;
        inc(I);
      end;
    end;
    if UseInherit then
      inherited DialogKey(Key, Shift)
    else if FMenuService <> nil then
    begin
      FMenuService.ShortCutToKey(ShortCut, k, SState);
      if (Key = k) and (Shift = SState) then
      begin
        Click;
        Key:=0;
      end;
    end;
  end;
  if Key > 0 then
    for I := 0 to ItemsCount - 1 do
    begin
      Items[I].DialogKey(Key, Shift);
      if Key = 0 then
        Break;
    end;
end;

function TMenuItem.EnterChildren(AObject: IControl): Boolean;
begin
  inherited EnterChildren(AObject);
  IsSelected := True;
  Result := True;
end;

function TMenuItem.GetMainMenu: TMainMenu;
var
  ObjectTmp: TFmxObject;
begin
  ObjectTmp := Parent;
  while (ObjectTmp is TFmxObject) and not (ObjectTmp is TMainMenu) do
    ObjectTmp := ObjectTmp.Parent;
  Result := ObjectTmp as TMainMenu;
end;

function TMenuItem.GetMenuView: IMenuView;
var
  P: TFmxObject;
  View: IMenuView;
begin
  Result := nil;
  P := Parent;
  while P <> nil do
  begin
    if IInterface(P).QueryInterface(IMenuView, View) = S_OK then
    begin
      Result := View;
      Break;
    end;
    P := P.Parent;
  end;
end;

function TMenuItem.GetParentMenuItem: TMenuItem;
var
  ObjectTmp: TFmxObject;
begin
  ObjectTmp := Parent;
  while not (ObjectTmp is TMenuItem) and (ObjectTmp <> nil) do
    ObjectTmp := ObjectTmp.Parent;

  Result := ObjectTmp as TMenuItem;
end;

function TMenuItem.GetVisibleItemsCount: Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to FContent.ChildrenCount - 1 do
    if (FContent.Children[i] is TMenuItem) and TMenuItem(FContent.Children[I]).Visible then
      Result := Result + 1;
end;

procedure TMenuItem.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Single);
begin
  inherited;
  if Button = TMouseButton.mbLeft then
    NeedPopup;
end;

procedure TMenuItem.Move;
begin
  inherited;
  if (csDesigning in ComponentState) and (Parent is TMenuBarContent) then
    TMenuBarContent(Parent).Realign;
end;

procedure TMenuItem.Resize;
begin
  inherited;
  if (csDesigning in ComponentState) and (Parent is TMenuBarContent) then
    TMenuBarContent(Parent).Realign;
end;

procedure TMenuItem.DoPopupTimer(Sender: TObject);
begin
  FPopupTimer.Enabled := False;
  Popup;
end;

procedure TMenuItem.NeedPopup;
begin
  if not HavePopup then
    Exit;
  if FPopupTimer = nil then
    FPopupTimer := TTimer.Create(nil);
  FPopupTimer.Parent := Self;
  FPopupTimer.Interval := 1;
  FPopupTimer.OnTimer := DoPopupTimer;
  FPopupTimer.Enabled := True;
end;

procedure TMenuItem.SetBitmap(const Value: TBitmap);
begin
  FBitmap.Assign(Value);
end;

procedure TMenuItem.TriggerAcceleratorKey;
begin
  if HavePopup then
    NeedPopup
  else if CanBeClicked then
    Click;
end;

procedure TMenuItem.TurnSiblingsOff;
var
  I: Integer;
  Item: TMenuItem;
  LParent: IItemsContainer;
  LItem: TFmxObject;
  LGroup: IGroupName;

  function ParentMenuItem: IItemsContainer;
  var
    P: TFmxObject;
  begin
    P := Parent;
    Result := nil;
    while P <> nil do
    begin
      if Supports(P, IItemsContainer, Result) then
        Break
      else
        P := P.Parent;
    end;
  end;

begin
  LParent := ParentMenuItem;
  if (LParent <> nil) and (LParent.GetItemsCount > 0) then
    for I := 0 to LParent.GetItemsCount - 1 do
    begin
      LItem := LParent.GetItem(I);
      if Supports(LItem, IGroupName, LGroup) and (LGroup.GroupName = IntToStr(GroupIndex)) and (LItem <> Self) then
      begin
        if LItem is TMenuItem then
        begin
          Item := TMenuItem(LItem);
          if Item.RadioItem and (Item.GroupIndex = GroupIndex) then
            Item.IsChecked := False;
        end
        else
          LGroup.IsChecked := False;
      end
    end
  else if View <> nil then
    for I := 0 to View.GetItemsCount - 1 do
    begin
      Item := TMenuItem(View.GetItem(I));
      if (Item <> Self) and Item.FRadioItem and (Item.GroupIndex = GroupIndex) then
        Item.SetIsChecked(False);
    end;
end;

procedure TMenuItem.SetIsSelected(const Value: Boolean);
begin
  if FIsSelected <> Value then
  begin
    FIsSelected := Value;
    StartTriggerAnimation(Self, 'IsSelected');
    ApplyTriggerEffect(Self, 'IsSelected');
    if View <> nil then
      View.Selected := Self;
  end;
end;

procedure TMenuItem.SetShortCut(const Value: TShortCut);
begin
  if FShortCut <> Value then
  begin
    FShortCut := Value;
    if (Action is TCustomAction) then
      TCustomAction(Action).ShortCut := Value;
    if IsHandleValid(Handle) and (FMenuService <> nil) then
      FMenuService.UpdateMenuItem(Self, [TMenuItemChange.Shortcut]);
  end;
end;

function TMenuItem.GetShortCut: TShortCut;
begin
  if Action is TCustomAction then
    Result := TCustomAction(Action).ShortCut
  else
    Result := FShortCut;
end;

function TMenuItem.ShortCutStored: Boolean;
begin
  Result := (not (Action is TCustomAction)) and (ShortCut <> 0);
end;

procedure TMenuItem.SetText(const Value: string);
var
  AlignRoot: IAlignRoot;
begin
  if Text <> Value then
  begin
    inherited;
    if IsHandleValid(Handle) and (FMenuService <> nil) then
      FMenuService.UpdateMenuItem(Self, [TMenuItemChange.Text])
    else
      if (View <> nil) and Supports(View, IAlignRoot, AlignRoot) then
        AlignRoot.Realign;
  end;
end;

procedure TMenuItem.SetEnabled(const Value: Boolean);
begin
  if Value <> Enabled then
  begin
    inherited;
    if FMenuService <> nil then
      FMenuService.UpdateMenuItem(Self, [TMenuItemChange.Enabled]);
    if TextObject <> nil then
      TextObject.Width := TextObject.Width + 1;
  end;
end;


procedure TMenuItem.SetVisible(const AValue: Boolean);
begin
  if Visible <> AValue then
  begin
    inherited;
    if (Parent is TMenuBarContent) and (FMenuService <> nil) then
      TMenuBarContent(Parent).DoRealign;
    if FMenuService <> nil then
      FMenuService.UpdateMenuItem(Self, [TMenuItemChange.Visible]);
  end;
end;

procedure TMenuItem.AddNoItemObject(const AObject: TFmxObject);
begin
  if FNoItemsContent = nil then
  begin
    FNoItemsContent := TFmxObject.Create(nil);
    FNoItemsContent.Parent := Self;
    FNoItemsContent.Stored := False;
  end;
  FNoItemsContent.AddObject(AObject);
end;

procedure TMenuItem.DoBitmapChanged;
begin
  UpdateVisibleObjects;
  if ([csLoading, csDestroying, csDesigning] * ComponentState = []) and (FMenuService <> nil) then
    FMenuService.UpdateMenuItem(Self, [TMenuItemChange.Bitmap]);
end;

function TMenuItem.DoFilterControlText(const AText: string): string;
begin
  if TPlatformServices.Current.SupportsPlatformService(IFMXAcceleratorKeyRegistryService) then
    Result := AText
  else
    Result := DelAmp(AText);
end;

procedure TMenuItem.DoUpdateMenu;
var
  LParent: TFmxObject;
begin
  if not (csLoading in ComponentState) and (FMenuService <> nil) then
  begin
    LParent := Parent;
    while (LParent <> nil) and not (LParent is TMainMenu) do
      LParent := LParent.Parent;
    if LParent is TMainMenu then
      TMainMenu(LParent).RecreateOSMenu
    else
      FMenuService.UpdateMenuItem(Self, [TMenuItemChange.Enabled, TMenuItemChange.Visible, TMenuItemChange.Text,
        TMenuItemChange.Shortcut, TMenuItemChange.Checked, TMenuItemChange.Bitmap]);
  end;
end;

procedure TMenuItem.DoAddObject(const AObject: TFmxObject);
begin
  if (FContent <> nil) and (AObject is TMenuItem) then
  begin
    TMenuItem(AObject).Locked := True;
    TMenuItem(AObject).Handle := 0;
    FContent.AddObject(AObject);
    DoUpdateMenu;
  end
  else
    inherited;
end;

procedure TMenuItem.DoInsertObject(Index: Integer; const AObject: TFmxObject);
begin
  if (FContent <> nil) and (AObject is TMenuItem) then
  begin
    TMenuItem(AObject).Locked := True;
    TMenuItem(AObject).Handle := 0;
    FContent.InsertObject(Index, AObject);
    DoUpdateMenu;
  end
  else
    inherited;
end;

procedure TMenuItem.ApplyStyle;
begin
  inherited;
  FIsMenuBarItemCached := False;
  StartAutopopupMenuTimer;
  { Glyph }
  if FindStyleResource<TControl>('glyph', FGlyphObject) then
  begin
    FOldGlyphObjectVisible := FGlyphObject.Visible;
    FGlyphObject.HitTest := False;
  end;
  if FindStyleResource<TGlyph>('glyphstyle', FGlyph) then
  begin
    FOldGlyphVisible := FGlyph.Visible;
    FOldGlyphAutoHide := FGlyph.AutoHide;
  end;
  { Checkmark }
  if FindStyleResource<TControl>('checkmark', FCheckmarkObject) then
  begin
    FOldCheckmarkVisible := FCheckmarkObject.Visible;
    FCheckmarkObject.Visible := False;
  end;
  { Checkmark background }
  FindStyleResource<TControl>('checkbackground', FCheckBackgroundObject);
  { Bitmap }
  if FindStyleResource<TControl>('bitmap', FBitmapObject) then
  begin
    if FBitmapObject is TImage then
      FOldBitmapVisible := FBitmapObject.Visible;
    FBitmapObject.HitTest := False;
  end;
  { Checkmark Style }
  if FindStyleResource<TControl>('checkmarkstyle', FCheckMarkStyle) then
    FOldCheckmarkStyleVisible := FCheckMarkStyle.Visible;
  { Shortcut }
  if FindStyleResource<TText>('shortcut', FShortCutObject) then
    FOldFShortCutVisible := FShortCutObject.Visible;
  { Sub mark}
  if FindStyleResource<TControl>('submark', FSubmarkObject) then
  begin
    FOldSubmarkVisible := FSubmarkObject.Visible;
    FSubmarkObject.Visible := False;
  end;
  ImagesChanged;
end;

procedure TMenuItem.FreeStyle;
begin
  inherited;
  FIsMenuBarItemCached := False;
  FShown := False;
  StopAutopopupMenuTimer;
  if FGlyphObject <> nil then
  begin
    FGlyphObject.Visible := FOldGlyphObjectVisible;
    FGlyphObject := nil;
  end;
  if FGlyph <> nil then
  begin
    FGlyph.ImageIndex := -1;
    FGlyph.Images := nil;
    FGlyph.AutoHide := FOldGlyphAutoHide;
    FGlyph.Visible := FOldGlyphVisible;
    FGlyph := nil;
  end;
  if FCheckmarkObject <> nil then
  begin
    FCheckmarkObject.Visible := FOldCheckmarkVisible;
    FCheckmarkObject := nil;
  end;
  FCheckBackgroundObject := nil;
  if FBitmapObject <> nil then
  begin
    if FBitmapObject is TImage then
      FBitmapObject.Visible := FOldBitmapVisible;
    FBitmapObject := nil;
  end;
  if FCheckMarkStyle <> nil then
  begin
    FCheckMarkStyle.Visible := FOldCheckmarkStyleVisible;
    FCheckMarkStyle := nil;
  end;
  if FShortCutObject <> nil then
  begin
    FShortCutObject.Visible := FOldFShortCutVisible;
    FShortCutObject := nil;
  end;
  if FSubmarkObject <> nil then
  begin
    FSubmarkObject.Visible := FOldSubmarkVisible;
    FSubmarkObject := nil;
  end;
end;

function TMenuItem.IsMenuBarItem: Boolean;
var
  LIsChild: Boolean;
  LParent: TFmxObject;
  Content: IContent;
  ItemsContainer: IItemsContainer;
begin
  if not FIsMenuBarItemCached then
  begin
    LIsChild := False;
    LParent := Self;
    while not LIsChild and (LParent.Parent <> nil) and ((LParent.Parent.GetInterface(IContent, Content) or
      LParent.Parent.GetInterface(IItemsContainer, ItemsContainer))) do
    begin
      LParent := LParent.Parent;
      LIsChild := LParent is TMenuItem;
      if Supports(LParent, IRoot) then
        Break;
    end;
    FIsMenuBarItem := not LIsChild and (View <> nil) and (View.IsMenuBar);
    FIsMenuBarItemCached := True;
  end;
  Result := FIsMenuBarItem;
end;

function TMenuItem.GetDefaultStyleLookupName: string;
begin
  if IsSeparator then
    Result := SSeparatorStyle
  else if IsMenuBarItem then
    Result := SMainItemStyle
  else
    Result := inherited;
end;

function TMenuItem.CalcSize: TPointF;
begin
  ApplyStyleLookup;
  UpdateVisibleObjects;
  Result := CalcRenderSize;
end;

function TMenuItem.CalcRenderSize: TPointF;

  function GetBasicItemHeight: Single;
  var
    HeightObject: TStyleTag;
  begin
    if FindStyleResource<TStyleTag>('height',  HeightObject) then
      Result := HeightObject.TagFloat
    else if IsSeparator then
      Result := DefaultMenuItemSeparatorHeight
    else
      Result := DefaultMenuItemHeight;
  end;

var
  C: TCanvas;
begin
  if IsSeparator then
  begin
    Result := TPointF.Create(0, GetBasicItemHeight);
    Exit;
  end;
  if Canvas = nil then
    C := TCanvasManager.MeasureCanvas
  else
    C := Canvas;

  Result := TPointF.Create(0, GetBasicItemHeight);
  Result := CalcVisibleObjectsItemSize(C, Result);
end;

function TMenuItem.HasOffsetOfGlyph: Boolean;
begin
  Result := (FGlyph <> nil) and FGlyph.BitmapExists and not FGlyphObject.IsChild(FGlyph);
end;

function TMenuItem.HasOffsetOfBitmap: Boolean;
begin
  Result := (FBitmapObject <> nil) and FBitmapObject.Visible and not FGlyphObject.IsChild(FBitmapObject);
end;

procedure TMenuItem.InitItem(const CleanAutoHide: Boolean; const Left, Top, Width, Height: Single);
begin
  if FGlyph <> nil then
  begin
    if CleanAutoHide and not HasOffsetOfBitmap then
    begin
      FGlyph.AutoHide := False;
      FGlyph.Visible := True;
    end
    else
      FGlyph.AutoHide := True;
  end;
  BoundsRect := Margins.PaddingRect(TRectF.Create(TPointF.Create(Left, Top), Width, Height));
end;

function TMenuItem.CalcVisibleObjectsItemSize(const ACanvas: TCanvas; APointF: TPointF): TPointF;
begin
  if IsSeparator then
  begin
    Result := TPointF.Create(0, DefaultMenuItemSeparatorHeight);
    FImageOffset := 0;
  end
  else
  begin
    Result := APointF;
    if (FGlyphObject <> nil) and FGlyphObject.Visible then
      Result.X := Result.X + FGlyphObject.Width + FGlyphObject.Margins.Left + FGlyphObject.Margins.Right;
    if (TextObject <> nil) and (TextObject is TText) then
    begin
      ACanvas.Font.Assign(TText(TextObject).Font);
      TText(TextObject).Width := Round(ACanvas.TextWidth(DelAmp(Text)));
      Result.X := Result.X + TText(TextObject).Width + TControl(TextObject).Margins.Left +
        TControl(TextObject).Margins.Right;
    end;
    if (FShortCutObject <> nil) and FShortCutObject.Visible and (FMenuService <> nil) then
    begin
      ACanvas.Font.Assign(FShortCutObject.Font);
      FShortCutObject.Width := Round(ACanvas.TextWidth(FMenuService.ShortCutToText(ShortCut)));
      Result.X := Result.X + FShortCutObject.Width + FShortCutObject.Margins.Left +
        FShortCutObject.Margins.Right;
    end;
    if (FSubmarkObject <> nil) and FSubmarkObject.Visible then
      Result.X := Result.X + FSubmarkObject.Width + FSubmarkObject.Margins.Left + FSubmarkObject.Margins.Right;

    if HasOffsetOfGlyph then
      FImageOffset := FGlyph.Width
    else if HasOffsetOfBitmap then
      FImageOffset := FBitmapObject.Width
    else
      FImageOffset := 0;
  end;
end;

function TMenuItem.CanBeClicked: Boolean;
begin
  Result := Enabled and not IsSeparator;
end;

function TMenuItem.CanTriggerAcceleratorKey: Boolean;
begin
  Result := IsMenuBarItem;
end;

procedure TMenuItem.Clear;
begin
  FContent.DeleteChildren;
end;

procedure TMenuItem.Click;
begin
  // HGM: hack for menuitems in style of menuitem
  if StyleName <> '' then
  begin
    inherited;
    Exit;
  end;
  // HGM end
  if FClickImmediately then
  begin
    if not (ActionClient and (Action is TCustomAction) and (TCustomAction(Action).AutoCheck)) then
    begin
      if AutoCheck and ((RadioItem and not IsChecked) or not RadioItem) then
          IsChecked := not IsChecked;
    end;
    // else work is done by Action
    inherited;
  end
  else
  begin
    DoMouseLeave;
    if vClickList = nil then
      vClickList := TClickList.Create(nil);
    vClickList.Add(self);
  end;
end;

procedure TMenuItem.SetParent(const Value: TFmxObject);
var
  Container: IItemsContainer;
  Msg: string;
begin
  if (Value <> nil) and (csDesigning in ComponentState) and not Value.GetInterface(IItemsContainer, Container) then
  begin
    FIsMenuBarItemCached := False;
    Msg := Format(SUnsupportedInterface, [Value.ClassName, 'IItemsContainer']);
    TDialogService.MessageDialog(Msg, TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], TMsgDlgBtn.mbOK, 0,
      procedure(const AResult: TModalResult)
      begin
        Abort;
      end)
  end
  else
    inherited;
end;

procedure TMenuItem.ParentChanged;
var
  LParent: TFmxObject;
begin
  inherited;
  LParent := Parent;
  while (LParent <> nil) and not (LParent is TMainMenu) do
    LParent := LParent.Parent;
  if LParent is TMainMenu then
    SetImages(TMainMenu(LParent).Images);
end;

procedure TMenuItem.Popup;
const
  DefaultMenuSize = 200;
var
  Popup: TPopup;
  Menu: TMenuView;
  Item: TMenuItem;
  I: Integer;
  LOffset: TPointF;
begin
  if FSubMenuVisible or (FContent = nil) or (FContent.ChildrenCount = 0) then
    Exit;

  IsSelected := True;
  FSubMenuVisible := True;
  try
    Popup := TPopupOfMenu.Create(Self);
    Popup.Parent := Parent;
    Menu := TMenuView.Create(nil);
    Menu.Parent := Popup;
    try
      if View <> nil then
      begin
        View.ChildView := Menu;
        Menu.FParentView := View;
      end;
      // set style
      if Scene <> nil then
      begin
        Popup.SetNewScene(Scene);
        if Scene.StyleBook <> nil then
          Popup.StyleBook := Scene.StyleBook;
      end;
      Menu.Size.Size := TSize.Create(DefaultMenuSize, DefaultMenuSize);
      // create popup
      Popup.PlacementTarget := Self;
      if IsMenuBarItem then
        Popup.Placement := TPlacement.Bottom
      else
        Popup.Placement := TPlacement.Right;
      // copy items to menu
      Menu.BeginUpdate;
      try
        for I := 0 to GetItemsCount - 1 do
        begin
          Item := TMenuItem(GetItem(0));
          Item.Parent := Menu;
          LocalizeDefMenuItem(Item);
        end;
      finally
        Menu.EndUpdate;
      end;
      if TPopupOfMenu(Popup).FClearBG then
        Menu.StylesData['bg.Opacity'] := 0.1;
      // calc size
      Popup.BoundsRect := TRectF.Create(0, 0, Menu.Width, Menu.Height);

      LOffset := Menu.ConvertLocalPointFrom(Menu.FContentLayout, TPointF.Zero);
      if not IsMenuBarItem then
      begin
        Popup.HorizontalOffset := -LOffset.X;
        Popup.VerticalOffset := -LOffset.Y;
      end;
      Menu.Align := TAlignLayout.Client;
      // show
      Popup.Popup;
      // start loop
      if FMenuService <> nil then
        FMenuService.StartMenuLoop(Menu);
    finally
      // copy back
      FContent.BeginUpdate;
      try
        for I := 0 to Menu.GetItemsCount - 1 do
        begin
          Item := TMenuItem(Menu.GetItem(0));
          Item.Parent := FContent;
        end;
      finally
        FContent.EndUpdate;
      end;
      // hide popup
      Popup.IsOpen := False;
      // hide
      if View <> nil then
      begin
        View.Selected := nil;
        View.ChildView := nil;
        Menu.FParentView := nil;
      end;
      Menu.Visible := False;
      FreeAndNil(Menu);
      IsSelected := False;
      FreeAndNil(Popup);
    end;
  finally
    FSubMenuVisible := False;
  end;
end;

function TMenuItem.IsCheckedStored: boolean;
begin
  Result := not (ActionClient and (ActionLink <> nil) and ActionLink.CheckedLinked and (Action is TContainedAction));
end;

procedure TMenuItem.SetIsChecked(const Value: Boolean);
begin
  if FIsChecked <> Value then
  begin
    if not IsCheckedStored then
    begin
      FIsChecked := Value;
      TContainedAction(Action).Checked := FIsChecked;
    end
    else
    begin
      FIsChecked := Value;
      if Value and FRadioItem then
        TurnSiblingsOff;
    end;
    if IsHandleValid(Handle) then
    begin
      if FMenuService <> nil then
        FMenuService.UpdateMenuItem(Self, [TMenuItemChange.Checked]);
    end
    else
      UpdateVisibleObjects;
  end;
end;

function TMenuItem.GetGroupName: string;
begin
  if RadioItem then
    Result := FGroupName
  else
    Result := '';
end;

function TMenuItem.GroupNameStored: boolean;
begin
  if ActionClient and (ActionLink <> nil) and (Action is TContainedAction) then
    Result := not ActionLink.GroupIndexLinked
  else
    Result := (FGroupName <> '') and (FGroupName <> '0') and (FGroupName <> '-1');
end;

procedure TMenuItem.UpdateGroup(const Value: string);
var
  I: Integer;
  S: string;
begin
  S := Value.Trim;
  if FGroupName <> S then
  begin
    I := 0;
    if S.IsEmpty or TryStrToInt(S, I) then
    begin
      FGroupName := S;
      if ActionClient and (ActionLink <> nil) and (Action is TContainedAction) then
        TContainedAction(Action).GroupIndex := I;
    end
    else
    begin
      if ActionClient and (ActionLink <> nil) and (Action is TContainedAction) then
        raise EComponentError.Create(sArgumentInvalid);
      FGroupName := Value;
    end;
  end;
end;

procedure TMenuItem.SetGroupName(const Value: string);
begin
  if FGroupName <> Value then
    UpdateGroup(Value);
end;

function TMenuItem.GetAutoCheck: Boolean;
begin
  if (Action is TContainedAction) then
    Result := TContainedAction(Action).AutoCheck
  else
    Result := FAutoCheck;
end;

function TMenuItem.AutoCheckStored: Boolean;
begin
  Result := not (Action is TContainedAction);
end;

procedure TMenuItem.SetAutoCheck(const Value: Boolean);
begin
  FAutoCheck := Value;
  if (Action is TContainedAction) then
    TContainedAction(Action).AutoCheck := FAutoCheck;
end;

function TMenuItem.GetGroupIndex: Integer;
var
  I, Code: Integer;
begin
  if FGroupName = '' then
    Result := 0
  else
  begin
    Val(FGroupName, I, Code);
    if Code = 0 then
      Result := I
    else
      Result := -1;
  end;
end;

procedure TMenuItem.SetGroupIndex(const Value: Integer);
var V: string;
begin
  V := inttostr(Value);
  SetGroupName(V);
end;

function TMenuItem.RadioItemStored: Boolean;
begin
  Result := not (Action is TContainedAction);
end;

function TMenuItem.GetRadioItem: Boolean;
begin
  //
  if (Action is TContainedAction) then
    Result := (TContainedAction(Action).GroupIndex <> 0)
  else
    Result := FRadioItem;
end;

procedure TMenuItem.SetRadioItem(const Value: Boolean);
begin
  if FRadioItem <> Value then
  begin
    FRadioItem := Value;
    if (Action is TContainedAction) then Exit;
    if FIsChecked and FRadioItem then
      TurnSiblingsOff;
  end;
end;

procedure TMenuItem.ActionChange(Sender: TBasicAction; CheckDefaults: Boolean);
begin
  inherited;
  if Sender is TCustomAction then
  begin
    if (not CheckDefaults) or (not IsChecked) then
      IsChecked := TCustomAction(Sender).Checked;
    if (not CheckDefaults) or (FGroupName.IsEmpty) or (FGroupName = '0') then
      SetGroupName(IntToStr(TCustomAction(Sender).GroupIndex));
    if (not CheckDefaults) and ((Images = nil) or ((TCustomAction(Sender).ActionList <> nil) and
      (TCustomAction(Sender).ActionList.Images = Images))) then
      ImageIndex := TCustomAction(Sender).ImageIndex;
    if (not CheckDefaults) or (ShortCut = 0) then
      ShortCut := TCustomAction(Sender).ShortCut;
  end;
end;

function TMenuItem.HavePopup: Boolean;
begin
  Result := GetVisibleItemsCount > 0;
end;

procedure TMenuItem.UpdateVisibleObjects;
var
  GlyphEmpty, GlyphObjectVisible, OldDisableAlign: Boolean;
  AlignRoot: IAlignRoot;
  I: Integer;
begin
  if StyleState <> TStyleState.Applied then
    Exit;
  OldDisableAlign := FDisableAlign;
  try
    FDisableAlign := True;
    if FGlyph <> nil then
    begin
      FGlyph.BeginUpdate;
      try
        FGlyph.Images := TCustomImageList(FImageLink.Images);
        FGlyph.ImageIndex := FImageLink.ImageIndex;
        FGlyph.IsChanged := True;
      finally
        FGlyph.EndUpdate;
      end;
      GlyphEmpty := (FGlyph.Images = nil) or not FGlyph.BitmapExists;
    end
    else
      GlyphEmpty := True;

    if FBitmapObject <> nil then
    begin
      FBitmapObject.Visible := not FBitmap.IsEmpty and GlyphEmpty and (Handle = 0);
      if FBitmapObject is TImage then
        if FBitmapObject.Visible then
          TImage(FBitmapObject).Bitmap.Assign(FBitmap)
        else
        begin
          TImage(FBitmapObject).Bitmap.Assign(nil);
          for I := 0 to TImage(FBitmapObject).MultiResBitmap.Count - 1 do
            TImage(FBitmapObject).MultiResBitmap[I].Dormant := True;
        end;
    end;

    if FCheckMarkStyle <> nil then
      FCheckMarkStyle.Visible := (FCheckBackgroundObject = nil) or (GlyphEmpty and (Handle = 0) and
        ((FBitmapObject = nil) or not FBitmapObject.Visible));

    if FCheckmarkObject <> nil then
      if IsMenuBarItem then
        FCheckmarkObject.Visible := False
      else
      begin
        FCheckmarkObject.Visible := FShown or IsChecked;
        if not FShown then
          FShown := (Root <> nil) and (Root.GetObject is TCustomPopupForm) and TCustomPopupForm(Root.GetObject).Visible;
        ApplyTriggerEffect(Self, 'IsChecked');
        StartTriggerAnimation(Self, 'IsChecked');
      end;

    if FGlyphObject <> nil then
    begin
      if (FCheckMarkStyle <> nil) and FGlyphObject.IsChild(FCheckMarkStyle) then
        FGlyphObject.Visible := True
      else
      begin
        GlyphObjectVisible := not FBitmap.IsEmpty or not GlyphEmpty or not IsMenuBarItem;
        if FGlyphObject.Visible <> GlyphObjectVisible then
        begin
          FGlyphObject.Visible := not FBitmap.IsEmpty or not GlyphEmpty or not IsMenuBarItem;
          if IsMenuBarItem and not FDisableAlign and View.GetObject.GetInterface(IAlignRoot, AlignRoot) then
            AlignRoot.Realign;
        end;
      end;
    end;
    if FShortCutObject <> nil then
    begin
      FShortCutObject.Visible := (View <> nil) and not View.GetIsMenuBar;
      if FShortCutObject.Visible and (FShortCutObject <> nil) and (FMenuService <> nil) then
      begin
        FShortCutObject.Text := FMenuService.ShortCutToText(ShortCut);
        FShortCutObject.WordWrap := False;
      end
      else
        FShortCutObject.Text := string.Empty;
    end;
    if FSubmarkObject <> nil then
      FSubmarkObject.Visible := (View <> nil) and not View.GetIsMenuBar and (GetVisibleItemsCount > 0);
  finally
    FDisableAlign := OldDisableAlign;
  end;
end;

function TMenuItem.GetItem(const AIndex: Integer): TFmxObject;
begin
  Result := FContent.Controls[AIndex];
end;

function TMenuItem.GetItems(const Index: Integer): TMenuItem;
var Obj: TFmxObject;
begin
  Obj := GetItem(Index);
  if not (Obj is TMenuItem) then
    raise EInvalidCast.Create(SInvalidCast);
  Result := TMenuItem(Obj);
end;

function TMenuItem.GetItemsCount: Integer;
begin
  Result := FContent.ControlsCount;
end;

function TMenuItem.GetIsChecked: boolean;
begin
  Result := FIsChecked;
end;

function TMenuItem.GetIsSeparator: Boolean;
begin
  Result := Text = SMenuSeparator;
end;

function TMenuItem.ImageIndexStored: Boolean;
begin
  Result := ActionClient or (ImageIndex <> -1);
end;

procedure TMenuItem.ImagesChanged;
var
  I: Integer;
begin
  if FImages <> FImageLink.Images then
  begin
    FImages := TCustomImageList(FImageLink.Images);
    for I := 0 to ItemsCount - 1 do
      Items[I].SetImages(FImages);
  end;
  DoBitmapChanged;
end;

function TMenuItem.GetImageIndex: TImageIndex;
begin
  Result := FImageLink.ImageIndex;
end;

procedure TMenuItem.SetImageIndex(const Value: TImageIndex);
begin
  FImageLink.ImageIndex := Value;
end;

function TMenuItem.GetImageList: TBaseImageList;
begin
  Result := GetImages;
end;

procedure TMenuItem.SetImageList(const Value: TBaseImageList);
begin
  // Use method SetImages in parent menu.
end;

function TMenuItem.GetImages: TCustomImageList;
begin
  Result := TCustomImageList(FImageLink.Images);
end;

procedure TMenuItem.SetImages(const Value: TCustomImageList);
begin
  FImageLink.Images := Value;
end;

{ TMenuViewContent }

procedure TMenuViewContent.DoAddObject(const AObject: TFmxObject);
begin
  if not (AObject is TMenuItem) and (Parent is TMenuView) then
    TMenuView(Parent).AddNoItemObject(AObject)
  else
    inherited;
end;

procedure TMenuViewContent.DoInsertObject(Index: Integer; const AObject: TFmxObject);
begin
  if not (AObject is TMenuItem) and (Parent is TMenuView) then
    TMenuView(Parent).AddNoItemObject(AObject)
  else
    inherited;
end;

procedure TMenuViewContent.DoRealign;
begin
end;

{ TMenuView }

constructor TMenuView.Create(AOwner: TComponent);
begin
  inherited;
  FContent := TMenuViewContent.Create(Self);
  FContent.Parent := Self;
  FContent.Stored := False;
  FContent.Locked := True;
  FContent.HitTest := False;
end;

destructor TMenuView.Destroy;
begin
  inherited;
end;

procedure TMenuView.AddNoItemObject(AObject: TFmxObject);
begin
  if FNoItemsContent = nil then
  begin
    FNoItemsContent := TControl.Create(nil);
    FNoItemsContent.Parent := Self;
    FNoItemsContent.Stored := False;
    FNoItemsContent.Locked := True;
    FNoItemsContent.HitTest := False;
  end;
  FNoItemsContent.AddObject(AObject);
end;

procedure TMenuView.DoAddObject(const AObject: TFmxObject);
begin
  if (FContent <> nil) and (AObject is TMenuItem) then
  begin
    TMenuItem(AObject).Handle := 0;
    FContent.AddObject(AObject);
  end
  else
    inherited;
end;

procedure TMenuView.ApplyStyle;
begin
  inherited;
  FindStyleResource<TControl>('content', FContentLayout);
end;

procedure TMenuView.FreeStyle;
begin
  inherited;
  FContentLayout := nil;
end;

function TMenuView.GetChildView: IMenuView;
begin
  Result := FChildView;
end;

function TMenuView.GetIsMenuBar: Boolean;
begin
  Result := False;
end;

function TMenuView.GetLoop: Boolean;
begin
  Result := FLoop;
end;

function TMenuView.GetParentView: IMenuView;
begin
  Result := FParentView;
end;

function TMenuView.GetSelected: TMenuItem;
begin
  Result := FSelected;
end;

{ IMenuItemsContainer }

function TMenuView.GetItemsCount: Integer;
begin
  Result := FContent.ControlsCount;
end;

function TMenuView.GetItem(const AIndex: Integer): TFmxObject;
begin
  Result := FContent.Controls[AIndex];
end;

procedure TMenuView.DoRealign;
var
  MarginR, ContentR: TRectF;
  P: TPointF;
  I: Integer;
  Size: TPointF;
  Sizes: TDictionary<TMenuItem, TSizeF>;
  Item: TMenuItem;
  ResControl: TControl;
  ImageOffset: Single;
begin
  if FUpdating > 0 then
    Exit;
  if csLoading in ComponentState then
    Exit;
  if FDisableAlign then
    Exit;
  Sizes := nil;
  FDisableAlign := True;
  try
    ApplyStyleLookup;
    ResControl := ResourceControl;
    if (FContentLayout <> nil) and (ResControl <> nil) then
    begin
      ResControl.BoundsRect := TRectF.Create(0, 0, Width, Height);
      ContentR.TopLeft := ConvertLocalPointFrom(FContentLayout, TPointF.Zero);
      P := ConvertLocalPointFrom(FContentLayout, TPointF.Create(FContentLayout.Width, FContentLayout.Height));
      ContentR.BottomRight := TPointF.Create(Self.Width - P.X, Self.Height - P.Y);
    end
    else
      ContentR := TRectF.Empty;

    if ResourceControl <> nil then
      MarginR := TRectF.Create(ResControl.Padding.Rect)
    else
      MarginR := TRectF.Empty;
    { calc items size }
    Size := TPointF.Zero;
    ImageOffset:= 0;
    if FContent.ControlsCount > 0 then
    begin
      Sizes := TDictionary<TMenuItem, TSizeF>.Create;
      for I := 0 to FContent.ControlsCount - 1 do
        if FContent.Controls[I] is TMenuItem then
        begin
          Item := TMenuItem(FContent.Controls[I]);
          if Item.Visible or Item.ShowInDesigner then
          begin
            P := Item.CalcSize;
            ImageOffset := Max(ImageOffset, Item.ImageOffset);
            Sizes.Add(Item, P);
            Size.Y := Size.Y + P.Y + Item.Margins.Top + Item.Margins.Bottom;
            Size.X := Max(Size.X, P.X + Item.Margins.Left + Item.Margins.Right);
          end;
        end;
    end;
    Size.X := Size.X + ImageOffset;
    SetBounds(Position.X, Position.Y, Size.X + ContentR.Left + ContentR.Right,
          Size.Y + ContentR.Top + ContentR.Bottom);
    FContent.SetBounds(MarginR.Left, MarginR.Top, MarginR.Left + Size.X, MarginR.Top + Size.Y);
    if ResControl <> nil then
      ResControl.SetBounds(MarginR.Left, MarginR.Top, Self.Width - MarginR.Left - MarginR.Right,
        Self.Height - MarginR.Top - MarginR.Bottom);
    { align }
    Size := TPointF.Zero;
    if Sizes <> nil then
      for I := 0 to FContent.ControlsCount - 1 do
        if FContent.Controls[I] is TMenuItem then
        begin
          Item := TMenuItem(FContent.Controls[I]);
          if Item.Visible or Item.ShowInDesigner then
          begin
            P := Sizes[Item];
            Item.InitItem(ImageOffset > 0, ContentR.Left, ContentR.Top + Size.Y,
              Self.Width - ContentR.Left - ContentR.Right, P.Y);
            Size.Y := Size.Y + Item.Height + Item.Margins.Top + Item.Margins.Bottom;
          end;
        end;
  finally
    FDisableAlign := False;
    Sizes.Free;
  end;
end;

procedure TMenuView.SetChildView(const Value: IMenuView);
begin
  FChildView := Value;
end;

procedure TMenuView.SetLoop(const Value: Boolean);
begin
  FLoop := Value;
  Repaint;
end;

procedure TMenuView.SetParentView(const Value: IMenuView);
begin
  FParentView := Value;
end;

procedure TMenuView.SetSelected(const Value: TMenuItem);
begin
  if FSelected <> Value then
  begin
    if FSelected <> nil then
      FSelected.IsSelected := False;
    FSelected := Value;
    if FSelected <> nil then
      FSelected.IsSelected := True;
  end;
end;

{ TPopupMenuContent }

procedure TPopupMenuContent.DoAddObject(const AObject: TFmxObject);
begin
  if not (AObject is TMenuItem) and (Parent is TPopupMenu) then
    TPopupMenu(Parent).AddNoItemObject(AObject)
  else
  begin
    UpdateGlyph(Owner, AObject);
    inherited;
  end;
end;

procedure TPopupMenuContent.DoInsertObject(Index: Integer; const AObject: TFmxObject);
begin
  if not (AObject is TMenuItem) and (Parent is TPopupMenu) then
    TPopupMenu(Parent).AddNoItemObject(AObject)
  else
  begin
    UpdateGlyph(Owner, AObject);
    inherited;
  end;
end;

procedure TPopupMenuContent.DoRealign;
begin
end;

{ TPopupMenu }

constructor TPopupMenu.Create(AOwner: TComponent);
begin
  inherited;
  TPlatformServices.Current.SupportsPlatformService(IFMXMenuService, FMenuService);
  FImageLink := TGlyphImageLink.Create(Self);
  FContent := TPopupMenuContent.Create(Self);
  FContent.Parent := Self;
  FContent.Stored := False;
  FContent.Locked := True;
  FContent.HitTest := False;
  FContent.Visible := False;
  FUseParentScale := DefaultUseParentScale;
end;

destructor TPopupMenu.Destroy;
begin
  FMenuService := nil;
  FreeAndNil(FImageLink);
  inherited;
end;

procedure TPopupMenu.DialogKey(var Key: Word; Shift: TShiftState);
var
  I: Integer;
  MItem: TMenuItem;
begin
  for I := GetItemsCount - 1 downto 0 do
  begin
    MItem:= TMenuItem(GetItem(I));
    MItem.DialogKey(Key, Shift);
  end;
end;

{ IItemContainer }

function TPopupMenu.GetItem(const AIndex: Integer): TFmxObject;
begin
  Result := TMenuItem(FContent.Controls[AIndex]);
end;

function TPopupMenu.GetItems(const Index: Integer): TMenuItem;
var
  Obj: TFmxObject;
begin
  Obj := GetItem(Index);
  if not (Obj is TMenuItem) then
    raise EInvalidCast.Create(SInvalidCast);
  Result := TMenuItem(Obj);
end;

function TPopupMenu.GetItemsCount: Integer;
begin
  Result := FContent.ControlsCount;
end;

function TPopupMenu.GetObject: TFmxObject;
begin
  Result := Self;
end;

procedure TPopupMenu.AddNoItemObject(const AObject: TFmxObject);
begin
  if FNoItemsContent = nil then
  begin
    FNoItemsContent := TFmxObject.Create(nil);
    FNoItemsContent.Parent := Self;
    FNoItemsContent.Stored := False;
  end;
  FNoItemsContent.AddObject(AObject);
end;

procedure TPopupMenu.DoAddObject(const AObject: TFmxObject);
begin
  if AObject is TMenuItem then
    FContent.AddObject(AObject)
  else
    inherited;
end;

procedure TPopupMenu.DoInsertObject(Index: Integer; const AObject: TFmxObject);
begin
  if AObject is TMenuItem then
    FContent.InsertObject(Index, AObject)
  else
    inherited;
end;

procedure TPopupMenu.DoRemoveObject(const AObject: TFmxObject); 
begin
  if AObject is TMenuItem then
    FContent.RemoveObject(AObject)
  else
    inherited;
end;

procedure TPopupMenu.Clear;
begin
  FContent.DeleteChildren;
end;

procedure TPopupMenu.CloseMenu;
begin
end;

procedure TPopupMenu.Popup(X, Y: Single);

  function HasVisibleItems: Boolean;
  var
    I: Integer;
  begin
    for I := 0 to GetItemsCount - 1 do
      if Items[I].Visible then
        Exit(True);
    Result := False;
  end;

var
  Popup: TPopup;
  Menu: TMenuView;
  Item: TMenuItem;
  I: Integer;
  LTop: Single;
  TempPopupPoint: TPointF;
  LBoundsRect: TRect;
  ScreenService: IFMXScreenService;
  List: TList<TMenuItem>;
begin
  DoPopup;
  if not HasVisibleItems then
    Exit;
  FPopupPoint := TPointF.Create(X, Y);
  Popup := TPopupOfMenu.Create(nil);
  Menu := TMenuView.Create(nil);
  try
    // create popup
    if PopupComponent is TFmxObject then
      Popup.Parent := TFmxObject(PopupComponent)
    else
      Popup.Parent := Parent;
    if Parent is TMenuBar then
      Popup.Placement := TPlacement.Bottom
    else
      Popup.Placement := TPlacement.Right;
    Popup.UseParentScale := FUseParentScale;
    // create menu
    Menu.Parent := Popup;
    // copy items to menu
    Menu.BeginUpdate;
    try
      List := TList<TMenuItem>.Create;
      try
        for I := 0 to GetItemsCount - 1 do
          List.Add(Items[I]);
        LTop := Menu.Padding.Top;
        for I := 0 to List.Count - 1 do
        begin
          LTop := LTop + List[I].Margins.Top;
          List[I].Parent := Menu;
          LocalizeDefMenuItem(List[I]);
          List[I].Position.Y := LTop;
          LTop := LTop + List[I].Margins.Bottom + List[I].Height;
        end;
      finally
        FreeAndNil(List);
      end;
    finally
      Menu.EndUpdate;
    end;
    if TPopupOfMenu(Popup).FClearBG then
      Menu.StylesData['bg.Opacity'] := 0.1;
    // calc size
    Popup.BoundsRect := TRectF.Create(0, 0, Menu.Width, Menu.Height);

    Popup.PlacementRectangle.Left := X;
    Popup.PlacementRectangle.Top := Y;
    Popup.Placement := TPlacement.Absolute;
    if not (csDesigning in ComponentState) then
    begin
      // recalculate the position for the popup in order to be entirely visible
      if (Screen <> nil) and Screen.MultiDisplaySupported then
        LBoundsRect := Screen.DisplayFromPoint(Popup.PlacementRectangle.Rect.TopLeft).WorkArea.Round
      else if TPlatformServices.Current.SupportsPlatformService(IFMXScreenService, ScreenService) then
        LBoundsRect := TRectF.Create(0, 0, ScreenService.GetScreenSize.X, ScreenService.GetScreenSize.Y).Round;
      if LBoundsRect.Contains(TPointF.Create(X, Y).Round) then
      begin
        TempPopupPoint.X := Popup.PlacementRectangle.Left + Popup.Width;
        TempPopupPoint.Y := Popup.PlacementRectangle.Top + Popup.Height;
        //bottom
        if TempPopupPoint.Y > LBoundsRect.Bottom  then
          Popup.PlacementRectangle.Top := Max(LBoundsRect.Top, Popup.PlacementRectangle.Top - (TempPopupPoint.Y - LBoundsRect.Bottom));
        //right
        if TempPopupPoint.X > LBoundsRect.Right then
          Popup.PlacementRectangle.Left := Max(LBoundsRect.Left, Popup.PlacementRectangle.Left - (TempPopupPoint.X - LBoundsRect.Right));
      end;
      Popup.PlacementRectangle.Right := Popup.PlacementRectangle.Left + Menu.Width * Popup.AbsoluteScale.X;
      Popup.PlacementRectangle.Bottom := Popup.PlacementRectangle.Top + Menu.Height * Popup.AbsoluteScale.Y;
    end;
    // show
    Popup.Popup;
    // start loop
    if FMenuService <> nil then
      FMenuService.StartMenuLoop(Menu);
    // copy back
    for I := 0 to Menu.GetItemsCount - 1 do
    begin
      Item := TMenuItem(Menu.GetItem(0));
      Item.Parent := Self;
    end;
  finally
    // hide popup
    Popup.IsOpen := False;
    Menu.Visible := False;
    FreeAndNil(Menu);
    FreeAndNil(Popup);
  end;
end;

procedure TPopupMenu.Loaded;
begin
  inherited;
  ImagesChanged;
end;

procedure TPopupMenu.ImagesChanged;
var
  I: Integer;
begin
  if (FImages <> FImageLink.Images) and ([csDestroying, csLoading] * ComponentState = []) then
  begin
    FImages := TCustomImageList(FImageLink.Images);
    for I := 0 to ItemsCount - 1 do
      Items[I].SetImages(FImages);
  end;
end;

function TPopupMenu.GetImages: TCustomImageList;
begin
  Result := TCustomImageList(FImageLink.Images);
end;

procedure TPopupMenu.SetImages(const Value: TCustomImageList);
begin
  FImageLink.Images := Value;
end;

function TPopupMenu.GetImageIndex: TImageIndex;
begin
  Result := -1;
end;

procedure TPopupMenu.SetImageIndex(const Value: TImageIndex);
begin
  // none
end;

function TPopupMenu.GetImageList: TBaseImageList;
begin
  Result := GetImages;
end;

procedure TPopupMenu.SetImageList(const Value: TBaseImageList);
begin
  ValidateInheritance(Value, TCustomImageList);
  SetImages(TCustomImageList(Value));
end;

{ TMenuBarContent }

procedure TMenuBarContent.DoAddObject(const AObject: TFmxObject);
begin
  if not (AObject is TMenuItem) then
    TMenuBar(Parent).AddNoItemObject(AObject)
  else
  begin
    UpdateGlyph(Owner, AObject);
    inherited;
  end;
end;

procedure TMenuBarContent.DoInsertObject(Index: Integer; const AObject: TFmxObject);
begin
  if not (AObject is TMenuItem) then
    TMenuBar(Parent).AddNoItemObject(AObject)
  else
  begin
    UpdateGlyph(Owner, AObject);
    inherited;
  end;
end;

procedure TMenuBarContent.DoRealign;
begin
  TMenuBar(Parent).Realign;
end;

procedure TMenuBarContent.DoRemoveObject(const AObject: TFmxObject);
begin
  inherited;
  if (AObject is TMenuItem) then
    TMenuBar(Parent).Realign;
end;

{ TMenuBar }

procedure TMenuBar.Clear;
begin
  FContent.DeleteChildren;
  FContent.Repaint;
end;

constructor TMenuBar.Create(AOwner: TComponent);
begin
  inherited;
  TPlatformServices.Current.SupportsPlatformService(IFMXMenuService, FMenuService);
  FImageLink := TGlyphImageLink.Create(Self);
  FContent := TMenuBarContent.Create(Self);
  FContent.Parent := Self;
  FContent.Stored := False;
  FContent.Locked := True;
  FContent.HitTest := False;
  FContent.Align := TAlignLayout.Contents;
  Width := 500;
  Height := 24;
  Align := TAlignLayout.Top;
  SetAcceptsControls(False);
  FExplicitVisible := Visible;
  TMessageManager.DefaultManager.SubscribeToMessage(TStartMenuLoopMessage, StartMenuLoopMessage);
end;

procedure TMenuBar.DefineProperties(Filer: TFiler);
begin
  inherited;
  Filer.DefineProperty('HitTest', IgnoreBooleanValue, nil, False);
end;

destructor TMenuBar.Destroy;
var
  NeedClear: boolean;
begin
  TMessageManager.DefaultManager.Unsubscribe(TStartMenuLoopMessage, StartMenuLoopMessage);
  FMenuService := nil;
  NeedClear := GMainMenu = self;
  FreeAndNil(FImageLink);
  inherited;
  if NeedClear then
    GMainMenu := nil;
end;

procedure TMenuBar.DialogKey(var Key: Word; Shift: TShiftState);
begin
  inherited DialogKey(Key, Shift);
end;

procedure TMenuBar.AddNoItemObject(AObject: TFmxObject);
begin
  if FNoItemsContent = nil then
  begin
    FNoItemsContent := TControl.Create(nil);
    FNoItemsContent.Parent := Self;
    FNoItemsContent.Stored := False;
    FNoItemsContent.Locked := True;
    FNoItemsContent.HitTest := False;
    FNoItemsContent.Align := TAlignLayout.Contents;
  end;
  FNoItemsContent.AddObject(AObject);
end;

procedure TMenuBar.DoAddObject(const AObject: TFmxObject);
begin
  inherited;
  if AObject is TMenuItem then
  begin
    TMenuItem(AObject).Handle := 0;
    FContent.AddObject(AObject);
    DoRealign;
  end;
end;

procedure TMenuBar.DoInsertObject(Index: Integer; const AObject: TFmxObject);
begin
  inherited;
  if AObject is TMenuItem then
  begin
    TMenuItem(AObject).Handle := 0;
    FContent.InsertObject(Index, AObject);
    Realign;
  end;
end;

procedure TMenuBar.ApplyStyle;
begin
  inherited;
  if FindStyleResource<TControl>('content', FContentLayout) then
    Realign;
end;

procedure TMenuBar.FreeStyle;
begin
  inherited;
  FContentLayout := nil;
end;

function TMenuBar.GetChildView: IMenuView;
begin
  Result := FChildView;
end;

function TMenuBar.GetDefaultStyleLookupName: string;
begin
  Result := 'menubarstyle';
end;

function TMenuBar.GetHandle: TFmxHandle;
begin
  Result := 0;
end;

procedure TMenuBar.SetHandle(const Value: TFmxHandle);
begin
end;

function TMenuBar.GetHandleSupported: boolean;
begin
  Result := False;
end;

function TMenuBar.GetIsMenuBar: Boolean;
begin
  Result := True;
end;

function TMenuBar.GetItem(const AIndex: Integer): TFmxObject;
begin
  Result := FContent.Controls[AIndex];
end;

function TMenuBar.GetItems(const Index: Integer): TMenuItem;
var
  Obj: TFmxObject;
begin
  Obj := GetItem(Index);
  if not (Obj is TMenuItem) then
    raise EInvalidCast.Create(SInvalidCast);
  Result := TMenuItem(Obj);
end;

function TMenuBar.GetItemsCount: Integer;
begin
  Result := FContent.ControlsCount;
end;

function TMenuBar.GetLoop: Boolean;
begin
  Result := FLoop;
end;

function TMenuBar.GetMenuItem(const AIndex: Integer): TMenuItem;
begin
  Result := TMenuItem(GetItem(AIndex));
end;

procedure TMenuBar.SetChildView(const Value: IMenuView);
begin
  FChildView := Value;
end;

procedure TMenuBar.SetLoop(const Value: Boolean);
begin
  FLoop := Value;
  Repaint;
end;

procedure TMenuBar.SetParentView(const Value: IMenuView);
begin
  FParentView := Value;
end;

procedure TMenuBar.SetSelected(const Value: TMenuItem);
begin
  if FSelected <> Value then
  begin
    if FSelected <> nil then
      FSelected.IsSelected := False;
    FSelected := Value;
    if FSelected <> nil then
      FSelected.IsSelected := True;
  end;
end;

procedure TMenuBar.SetVisible(const Value: Boolean);
begin
  inherited;
  if not FUpdatingVisible then
    FExplicitVisible := Visible;
end;

procedure TMenuBar.UpdateVisible;
var
  LForm: TCommonCustomForm;
  LVisible: Boolean;
begin
  if not (csLoading in ComponentState) and not FUpdatingVisible and (FMenuService <> nil) then
  begin
    FUpdatingVisible := True;
    try
      if (Root is TCommonCustomForm) then
      begin
        if (GMainMenu = nil) or (GMainMenu = Self) then
        begin
          LForm := TCommonCustomForm(Root);
          LVisible := not ((not (csDesigning in LForm.ComponentState)) and FMenuService.IsMenuBarOnWindowBorder and
            ((GMainMenu = Self) and LForm.Border.IsSupported));
        end
        else
          LVisible := True;

        if LVisible and (GMainMenu = Self) then
          GMainMenu := nil;
        Visible := LVisible and FExplicitVisible;
      end
      else
        Visible := False;
    finally
      FUpdatingVisible := False;
    end;
  end;
end;

type
  TOpenCustomForm = class(TCommonCustomForm)

  end;

procedure TMenuBar.StartMenuLoopMessage(const Sender : TObject; const M : TMessage);
begin
  if TStartMenuLoopMessage(M).Root = Root then
    StartMenuLoop;
end;

procedure TMenuBar.StartMenuLoop;
begin
  if FMenuService <> nil then
    FMenuService.StartMenuLoop(Self);
end;

function TMenuBar.GetParentView: IMenuView;
begin
  Result := FParentView;
end;

function TMenuBar.GetSelected: TMenuItem;
begin
  Result := FSelected;
end;

procedure TMenuBar.DoUpdateOSMenu;
var
  Form: TCommonCustomForm;
begin
  Form := nil;
  if not (csLoading in ComponentState) and not (csDesigning in ComponentState) then
  begin
    if (Root <> nil) and (Root.GetObject is TCommonCustomForm) then
      Form := TCommonCustomForm(Root.GetObject);
    UpdateVisible;
    if not Visible and (Form <> nil) and (FMenuService <> nil) and (FMenuService.IsMenuBarOnWindowBorder) then
    begin
      GMainMenu := self;
      Form.RecreateOsMenu;
    end;
    if Form <> nil then
      TOpenCustomForm(Form).Realign;
  end;
end;

procedure TMenuBar.Loaded;
begin
  inherited;
  ImagesChanged;
  DoUpdateOSMenu(nil);
end;

procedure TMenuBar.DoRealign;
var
  ContentR: TRectF;
  P: TPointF;
  i: Integer;
  CurX: Single;
  Item: TMenuItem;
begin
  if (FUpdating = 0) and
     (not(csLoading in ComponentState)) and
     (not FDisableAlign) then
  begin
    inherited;
    FDisableAlign := True;
    try
      if FContentLayout <> nil then
      begin
        ContentR.TopLeft := ConvertLocalPointFrom(FContentLayout, TPointF.Zero);
        P := ConvertLocalPointFrom(FContentLayout, TPointF.Create(FContentLayout.Width, FContentLayout.Height));
        ContentR.BottomRight := PointF(Self.Width - P.X, Self.Height - P.Y);
      end
      else
        ContentR := RectF(0, 0, 0, 0);
      CurX := 0;
      for i := 0 to ItemsCount - 1 do
      begin
        Item := Items[I];
        if Item.Visible or Item.ShowInDesigner then
        begin
          P := Item.CalcSize;
          Item.SetBounds(ContentR.Left + CurX, ContentR.Top + Item.Margins.Top, P.X - Item.Margins.Left - Item.Margins.Right,
            Self.Height - Item.Margins.Top - Item.Margins.Bottom - ContentR.Top - ContentR.Bottom);
          CurX := CurX + Item.Width + Item.Margins.Left + Item.Margins.Right;
        end;
      end;
    finally
      FDisableAlign := False;
    end;
  end
  else
    inherited;
end;

procedure TMenuBar.DoRemoveObject(const AObject: TFmxObject);
begin
  inherited;
  if (AObject is TMenuItem) then
  begin
    FContent.RemoveObject(AObject);
    Realign;
  end;
end;

procedure TMenuBar.ImagesChanged;
var
  I: Integer;
begin
  if (FImages <> FImageLink.Images) and ([csDestroying, csLoading] * ComponentState = []) then
  begin
    FImages := TCustomImageList(FImageLink.Images);
    for I := 0 to ItemsCount - 1 do
      Items[I].SetImages(FImages);
  end;
end;

function TMenuBar.GetImages: TCustomImageList;
begin
  Result := TCustomImageList(FImageLink.Images);
end;

procedure TMenuBar.SetImages(const Value: TCustomImageList);
begin
  FImageLink.Images := Value;
end;

function TMenuBar.GetImageIndex: TImageIndex;
begin
  Result := -1;
end;

procedure TMenuBar.SetImageIndex(const Value: TImageIndex);
begin
  // none
end;

function TMenuBar.GetImageList: TBaseImageList;
begin
  Result := GetImages;
end;

procedure TMenuBar.SetImageList(const Value: TBaseImageList);
begin
  ValidateInheritance(Value, TCustomImageList);
  SetImages(TCustomImageList(Value));
end;

{ TMainMenu }

constructor TMainMenu.Create(AOwner: TComponent);
begin
  inherited;
  if (GMainMenu <> nil) and not (csDesigning in ComponentState) then
    raise EComponentError.Create(StrESingleMainMenu);
  FImageLink := TGlyphImageLink.Create(Self);
  TPlatformServices.Current.SupportsPlatformService(IFMXMenuService, FMenuService);
  GMainMenu := Self;
  FStyleChangedId := TMessageManager.DefaultManager.SubscribeToMessage(TStyleChangedMessage, StyleChangedHandler);
end;

destructor TMainMenu.Destroy;
var
  NeedClear: Boolean;
begin
  TMessageManager.DefaultManager.Unsubscribe(TStyleChangedMessage, FStyleChangedId);
  NeedClear := GMainMenu = Self;
  if FMenuService <> nil then
    FMenuService.UpdateMenuBar;
  FMenuService := nil;
  FreeAndNil(FImageLink);
  inherited;
  if NeedClear then
    GMainMenu := nil;
end;

procedure TMainMenu.BeforeDestruction;
begin
  inherited;
  SetHandle(0);
end;

procedure TMainMenu.DialogKey(var Key: Word; Shift: TShiftState);
var
  I: Integer;
  MItem: TMenuItem;
begin
  for I := GetItemsCount - 1 downto 0 do
  begin
    MItem:= TMenuItem(GetItem(I));
    MItem.DialogKey(Key, Shift);
  end;
end;

procedure TMainMenu.DoRecreateOSMenu(const Form: TCommonCustomForm);
begin
  if FMenuService <> nil then
    FMenuService.CreateOSMenu(Form, Self);
end;

procedure TMainMenu.RecreateOSMenu;
var
  Form: TOpenCustomForm;
begin
  if [csDestroying] * ComponentState = [] then
  begin
    if (Root <> nil) and (Root.GetObject is TCommonCustomForm) then
    begin
      Form := TOpenCustomForm(Root.GetObject);
      if Form.MainMenu = Self then
        DoRecreateOSMenu(Form);
    end;
  end;
end;

procedure TMainMenu.DoAddObject(const AObject: TFmxObject);
begin
  if not (AObject is TMenuItem) then
    raise EComponentError.Create(SMainMenuSupportsOnlyTMenuItems);
  inherited;
  if not (csDesigning in ComponentState) then
  begin
    TMenuItem(AObject).Handle := 0;
    RecreateOSMenu;
  end;
end;

procedure TMainMenu.DoInsertObject(Index: Integer; const AObject: TFmxObject);
begin
  if not(AObject is TMenuItem) then
    raise EComponentError.Create(SMainMenuSupportsOnlyTMenuItems);
  inherited;
  if not (csDesigning in ComponentState) then
  begin
    TMenuItem(AObject).Handle := 0;
    RecreateOSMenu;
  end;
end;

procedure TMainMenu.DoRemoveObject(const AObject: TFmxObject);
begin
  inherited;
  if not (csDesigning in ComponentState) then
    RecreateOSMenu;
end;

procedure TMainMenu.Exchange(const AObject1, AObject2: TFmxObject);
begin
  inherited;
  if [csUpdating, csDesigning] * ComponentState = [] then
    RecreateOSMenu;
end;

function TMainMenu.ParentForm: TCommonCustomForm;
var
  LParent: TFmxObject;
begin
  LParent := Parent;
  while (LParent <> nil) and not (LParent is TCommonCustomForm) do
    LParent := LParent.Parent;
  Result := TCommonCustomForm(LParent);
end;

procedure TMainMenu.ParentChanged;
var
  NewForm: TCommonCustomForm;
begin
  inherited;
  NewForm := ParentForm;
  if FOldForm <> NewForm then
  begin
    try
      if FOldForm <> nil then
        TOpenCustomForm(FOldForm).RecreateOsMenu;
      if NewForm <> nil then
        TOpenCustomForm(NewForm).RecreateOsMenu;
    finally
      FOldForm := NewForm;
    end;
  end;
end;

function TMainMenu.GetHandle: TFmxHandle;
begin
  Result := FHandle;
end;

procedure TMainMenu.SetHandle(const Value: TFmxHandle);

  procedure ResetHandleForNestedMenuItems(const AContainer: IItemsContainer);
  var
    I: Integer;
    Item: TFmxObject;
    MenuItem: TMenuItem;
  begin
    for I := 0 to AContainer.GetItemsCount - 1 do
    begin
      Item := AContainer.GetItem(I);
      if Item is TMenuItem then
      begin
        MenuItem := TMenuItem(Item);
        MenuItem.Handle := 0;
        ResetHandleForNestedMenuItems(MenuItem);
      end;
    end;
  end;

begin
  if FHandle <> Value then
  begin
    // If we are destroying MainMenu, then keeping reference on native instances for nested menu items don't have sense,
    // becasue the menu items are controlled by the main menu. So we are destroying all nested menu items handles before.
    if Value = 0 then
      ResetHandleForNestedMenuItems(Self);

    if (FHandle <> 0) and (FMenuService <> nil) then
      FMenuService.DestroyMenuItem(Self);
    FHandle := Value;
  end;
end;

procedure TMainMenu.StyleChangedHandler(const Sender: TObject; const Msg: TMessage);
begin
  if not (csDesigning in ComponentState) then
    RecreateOSMenu;
end;

function TMainMenu.GetHandleSupported: boolean;
begin
  Result := not (csDesigning in ComponentState);
end;

procedure TMainMenu.Loaded;
begin
  inherited;
  ImagesChanged;
end;

procedure TMainMenu.ImagesChanged;
var
  I: Integer;
begin
  if (FImages <> FImageLink.Images) and ([csDestroying, csLoading] * ComponentState = []) then
  begin
    FImages := TCustomImageList(FImageLink.Images);
    for I := 0 to ItemsCount - 1 do
      if Items[I] is TMenuItem then
        TMenuItem(Items[I]).SetImages(FImages);
  end;
end;

function TMainMenu.GetItem(const AIndex: Integer): TFmxObject;
begin
  Result := Children[AIndex] as TMenuItem;
end;

function TMainMenu.GetItemsCount: Integer;
begin
  Result:= ChildrenCount;
end;

function TMainMenu.GetObject: TFmxObject;
begin
  Result := Self;
end;

function TMainMenu.GetImageIndex: TImageIndex;
begin
  Result := -1;
end;

procedure TMainMenu.SetImageIndex(const Value: TImageIndex);
begin
  // none
end;

function TMainMenu.GetImageList: TBaseImageList;
begin
  Result := GetImages;
end;

procedure TMainMenu.SetImageList(const Value: TBaseImageList);
begin
  ValidateInheritance(Value, TCustomImageList);
  SetImages(TCustomImageList(Value));
end;

function TMainMenu.GetImages: TCustomImageList;
begin
  Result := TCustomImageList(FImageLink.Images);
end;

procedure TMainMenu.SetImages(const Value: TCustomImageList);
begin
  FImageLink.Images := Value;
end;

{ TStartMenuLoopMessage }

constructor TStartMenuLoopMessage.Create(const ARoot: IRoot);
begin
  inherited Create;
  FRoot := ARoot;
end;

initialization
  vAutopopupMenuTimer := nil;
  vClickList := nil;
  GMainMenu := nil;
  RegisterFmxClasses([TMenuItem, TMenuView, TPopupMenu, TMainMenu, TMenuBar]);

finalization
  FreeAndNil(vAutopopupMenuTimer);
  FreeAndNil(vClickList);

end.
