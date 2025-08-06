{*******************************************************}
{                                                       }
{              Delphi FireMonkey Platform               }
{                                                       }
{ Copyright(c) 2013-2024 Embarcadero Technologies, Inc. }
{              All rights reserved                      }
{                                                       }
{*******************************************************}

unit FMX.Calendar.Style;

interface

{$SCOPEDENUMS ON}

uses
  System.Classes, System.UITypes, FMX.ListBox, FMX.StdCtrls, FMX.ExtCtrls, FMX.Layouts, FMX.Controls,
  FMX.Presentation.Style, FMX.Calendar, FMX.Presentation.Messages, FMX.Controls.Presentation, FMX.Controls.Model;

type

{ TStyledCalendar }

  TStyledCalendar = class(TStyledPresentation)
  public const
    CountOfVisibleDays = 6 * 7;
  private               
    FNeedChange: Boolean;
    FDateTime: TDateTime;
    FFirstDayOfWeekNum: Integer;
    FDisableDayChange: Integer;
    FMonths: TPopupBox;
    FYears: TPopupBox;
    FWeeks: TGridLayout;
    FWeek: TGridLayout;
    FDays: TListBox;
    FToday: TButton;
    FPrev: TButton;
    FNext: TButton;
    procedure SetDate(Value: TDate);
    procedure SetDateTime(Value: TDateTime);
    function GetDate: TDate;
    function GetModel: TCalendarModel;
    procedure CalculateFirstDayOfWeek;
    procedure UpdateWeekWidth;
    procedure FOnYearsMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; var Handled: Boolean);
  protected
    { Messages from Model }
    procedure MMDateChanged(var AMessage: TDispatchMessageWithValue<TDateTime>); message MM_DATE_CHANGED;
    procedure MMWeekNumbersChanged(var AMessage: TDispatchMessageWithValue<Boolean>); message MM_WEEKNUMBERS_CHANGED;
    procedure MMFirstDayOfWeekChanged(var AMessage: TDispatchMessageWithValue<TCalDayOfWeek>); message MM_FIRSTDAYOFWEEK_CHANGED;
    procedure MMFirstWeekModeChanged(var AMessage: TDispatchMessageWithValue<TCalFirstWeekMode>); message MM_FIRSTWEEKMODE_CHANGED;
    { Messages from PresentationProxy }
    procedure PMInit(var AMessage: TDispatchMessage); message PM_INIT;
  protected
    /// <summary>Returns item index of item in FDays, which corresponds first day of current month</summary>
    function DefineItemIndexOfFirstDayInCurrentMonth: Integer;
    /// <summary>Fills years in <c>Years</c></summary>
    procedure FillYears; virtual;
    /// <summary>Fills week numbers in <c>Weeks</c></summary>
    procedure FillWeeksNumbers; virtual;
    /// <summary>Fills titles of days in current month in <c>Week</c></summary>
    procedure FillWeekDays; virtual;
    /// <summary>Fills days in current month in <c>Days</c></summary>
    procedure FillDays; virtual;
    /// <summary>Fills years, months, days, week numbers and etc.</summary>
    procedure FillCalendar;
    /// <summary>Updates height of items in Days and Week numbers lists</summary>
    procedure UpdateWeeksDaysItemHeight;
    { Styles }
    procedure ApplyStyle; override;
    procedure FreeStyle; override;
    { Events }
    procedure DoChange; virtual;
    procedure DoDateSelected; virtual;
    procedure DoRealign; override;
    { Handlers }
    procedure DoPrevClick(Sender: TObject);
    procedure DoNextClick(Sender: TObject);
    procedure DoTodayClick(Sender: TObject);
    procedure DoMonthChange(Sender: TObject);
    procedure DoYearChange(Sender: TObject);
    procedure DoDayChange(Sender: TObject);
    procedure DoDayClick(const Sender: TCustomListBox; const Item: TListBoxItem);
    procedure DoDaysMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure DoDaysMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    { inherited }
    procedure KeyDown(var Key: Word; var KeyChar: WideChar; Shift: TShiftState); override;
    procedure MouseWheel(Shift: TShiftState; WheelDelta: Integer; var Handled: Boolean); override;
    /// <summary>Defines <c>TCalendar</c> model class</summary>
    function DefineModelClass: TDataModelClass; override;
    /// <summary>Should we invoke OnChange, OnDateSelected events or not. If value more then 0, we shan't.</summary>
    property DisableDayChange: Integer read FDisableDayChange;
  public
    /// <summary>Tries to find TListBoxItem, which corresponds a specified date. If current moneth doesn't have
    /// the ADateTime, it will returns nil</summary>
    function TryFindDayItem(const ADateTime: TDateTime): TListBoxItem;
    /// <summary>Current date in presentation</summary>
    property Date: TDate read GetDate write SetDate;
    /// <summary>Number of first day of week in vurrent locale and according <c>Model.FirstDayOfWeek</c></summary>
    property FirstDayOfWeek: Integer read FFirstDayOfWeekNum;
    /// <summary>Model of <c>TCalendar</c></summary>
    property Model: TCalendarModel read GetModel;
    { Access to style objects }
    /// <summary>List of years.</summary>
    /// <remarks>If style doesn't contain this element, it will return nil</remarks>
    property Years: TPopupBox read FYears;
    /// <summary>List of months.</summary>
    /// <remarks>If style doesn't contain this element, it will return nil</remarks>
    property Month: TPopupBox read FMonths;
    /// <summary>Grid of weeks numbers.</summary>
    /// <remarks>If style doesn't contain this element, it will return nil</remarks>
    property Weeks: TGridLayout read FWeeks;
    /// <summary>Grid of week day's titles.</summary>
    /// <remarks>If style doesn't contain this element, it will return nil</remarks>
    property Week: TGridLayout read FWeek;
    /// <summary>Grid of days.</summary>
    /// <remarks>If style doesn't contain this element, it will return nil</remarks>
    property Days: TListBox read FDays;
    /// <summary>Today button.</summary>
    /// <remarks>If style doesn't contain this element, it will return nil</remarks>
    property Today: TButton read FToday;
    /// <summary>Previous month button.</summary>
    /// <remarks>If style doesn't contain this element, it will return nil</remarks>
    property Prev: TButton read FPrev;
    /// <summary>Mext month button.</summary>
    /// <remarks>If style doesn't contain this element, it will return nil</remarks>
    property Next: TButton read FNext;
  end;

implementation

uses
  System.SysUtils, System.DateUtils, System.Math, FMX.Types, FMX.Platform, FMX.Presentation.Factory, FMX.ActnList;

type
  TDayItem = class(TListBoxItem)
  private
    FDate: TDateTime;
  public
    property Date: TDateTime read FDate write FDate;
  end;

{ TStyledCalendar }

procedure TStyledCalendar.ApplyStyle;

  function FindButtonAndAssignClickHandler(const AResourceName: string; const AClick: TNotifyEvent): TButton;
  var
    Button: TButton;
  begin
    if FindStyleResource<TButton>(AResourceName, Button) then
    begin
      Button.CanParentFocus := True;
      Button.OnClick := AClick;
      Result := Button;
    end
    else
      Result := nil;
  end;

var
  I: Integer;
  LLabel: TLabel;
  LItem: TListBoxItem;
  MonthName: string;
begin
  inherited;
  // When user clicks on style elements or listbox with days, we need to transfer focus style to presentation.
  // For this purpose we set CanParentFocus.
  ResourceControl.CanParentFocus := True;

  FPrev := FindButtonAndAssignClickHandler('prev', DoPrevClick);
  FNext := FindButtonAndAssignClickHandler('next', DoNextClick);
  FToday := FindButtonAndAssignClickHandler('today', DoTodayClick);
  if FToday <> nil then
    FToday.RepeatClick := False;

  // Months
  if FindStyleResource<TPopupBox>('months', FMonths) then
  begin
    FMonths.CanParentFocus := True;
    FMonths.BeginUpdate;
    try
      FMonths.Items.Clear; 
      for MonthName in FormatSettings.LongMonthNames do
        FMonths.Items.Add(MonthName);
      FMonths.ItemIndex := MonthOf(FDateTime) - 1;
    finally
      FMonths.EndUpdate;
    end;
    FMonths.OnChange := DoMonthChange;
  end;

  // Years
  if FindStyleResource<TPopupBox>('years', FYears) then
  begin
    FYears.CanParentFocus := True;
    FYears.OnMouseWheel := FOnYearsMouseWheel;
    FYears.BeginUpdate;
    try
      FillYears;
    finally
      FYears.EndUpdate;
    end;
    FYears.OnChange := DoYearChange;
  end;

  // Week
  if FindStyleResource<TGridLayout>('week', FWeek) then
  begin
    FWeek.CanParentFocus := True;
    FWeek.BeginUpdate;
    try
      for I := 0 to DaysPerWeek - 1 do
      begin
        LLabel := TLabel.Create(Self);
        LLabel.Parent := FWeek;
        LLabel.Locked := True;
        LLabel.Stored := False;
        LLabel.TextAlign := TTextAlign.Center;
        LLabel.WordWrap := False;
        LLabel.StyleLookup := 'calendarlabelstyle';
      end;
      UpdateWeekWidth;
      FillWeekDays;
    finally
      FWeek.EndUpdate;
    end;
  end;

  // Days
  if FindStyleResource<TListBox>('days', FDays) then
  begin
    FDays.AniCalculations.TouchTracking := [];
    FDays.CanParentFocus := True;
    FDays.BeginUpdate;
    try
      FDays.Clear;
      for I := 1 to CountOfVisibleDays do
      begin
        LItem := TDayItem.Create(Self);
        LItem.Parent := FDays;
        LItem.Locked := True;
        LItem.Stored := False;
        LItem.TextAlign := TTextAlign.Center;
        LItem.StyledSettings := LItem.StyledSettings - [TStyledSetting.Other];
        LItem.WordWrap := False;
      end;
      FillDays;
      UpdateWeeksDaysItemHeight;
    finally
      FDays.EndUpdate;
    end;
    FDays.OnMouseDown := DoDaysMouseDown;
    FDays.OnMouseUp := DoDaysMouseUp;
    FDays.OnChange := DoDayChange;
    FDays.OnItemClick := DoDayClick;
  end;

  // Weeks
  if FindStyleResource<TGridLayout>('weeks', FWeeks) then
  begin
    FWeeks.CanParentFocus := True;
    FWeeks.Visible := Model.WeekNumbers;
    FWeeks.ItemWidth := FWeeks.Width;
    FWeeks.DeleteChildren;
    FWeeks.BeginUpdate;
    try
      for I := 0 to 5 do
      begin
        LLabel := TLabel.Create(Self);
        LLabel.Parent := FWeeks;
        LLabel.Locked := True;
        LLabel.Stored := False;
        LLabel.TextAlign := TTextAlign.Center;
        LLabel.WordWrap := False;
      end;
      FillWeeksNumbers;
    finally
      FWeeks.EndUpdate;
    end;
  end;
end;

procedure TStyledCalendar.CalculateFirstDayOfWeek;
var
  LocaleService: IFMXLocaleService;
begin
  if Model.FirstDayOfWeek = TCalDayOfWeek.dowLocaleDefault then
  begin
    if TPlatformServices.Current.SupportsPlatformService(IFMXLocaleService, LocaleService) then
      FFirstDayOfWeekNum := LocaleService.GetFirstWeekday
    else
      FFirstDayOfWeekNum := DayMonday;
  end
  else
    FFirstDayOfWeekNum := Ord(Model.FirstDayOfWeek) + 1;
end;

function TStyledCalendar.DefineItemIndexOfFirstDayInCurrentMonth: Integer;
var
  Interval: Integer;
  BeginDate: TDateTime;
begin
  Interval := DaysPerWeek - FirstDayOfWeek;
  BeginDate := RecodeDay(FDateTime, 1);
  Result := (Interval + DayOfTheWeek(BeginDate)) mod DaysPerWeek + 1;
end;

function TStyledCalendar.DefineModelClass: TDataModelClass;
begin
  Result := TCalendarModel;
end;

procedure TStyledCalendar.DoChange;
begin
  Model.DisableNotify;
  try
    Model.DateTime := Date;
  finally
    Model.EnableNotify;
  end;

  if (FDisableDayChange = 0) and Assigned(Model.OnChange) then
    Model.OnChange(PresentedControl);
end;

procedure TStyledCalendar.DoDateSelected;
begin
  if Assigned(Model.OnDateSelected) then
    Model.OnDateSelected(PresentedControl);
end;

procedure TStyledCalendar.DoDayChange(Sender: TObject);
begin
  if (FDays = nil) or (FDays.Selected = nil) then
    Exit;
  Date := (FDays.Selected as TDayItem).Date;
  if FDisableDayChange = 0 then
    DoDateSelected;
  FDays.ItemDown := nil;
end;

procedure TStyledCalendar.DoDayClick(const Sender: TCustomListBox; const Item: TListBoxItem);
begin
  if Assigned(Model.OnDayClick) then
    Model.OnDayClick(PresentedControl);
end;

procedure TStyledCalendar.DoDaysMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  if FDisableDayChange = 0 then
    Inc(FDisableDayChange);
end;

procedure TStyledCalendar.DoDaysMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  if FDisableDayChange > 0 then
  begin
    Dec(FDisableDayChange);
    if (FDisableDayChange = 0) and FNeedChange then
    begin
      FNeedChange := False;
      DoChange;
      DoDateSelected;
    end;
  end;
end;

procedure TStyledCalendar.DoMonthChange(Sender: TObject);
var
  AYear, AMonth, ADay: Word;
  DaysInMonth: Word;
begin
  DecodeDate(FDateTime, AYear, AMonth, ADay);
  DaysInMonth := DaysInAMonth(AYear, FMonths.ItemIndex + 1);
  ADay := Min(ADay, DaysInMonth);
  Date := EncodeDate(AYear, FMonths.ItemIndex + 1, ADay);
  DoChange;
end;

procedure TStyledCalendar.DoNextClick(Sender: TObject);
begin
  Date := IncMonth(Date);
  DoChange;
end;

procedure TStyledCalendar.DoPrevClick(Sender: TObject);
begin
  Date := IncMonth(Date, -1);
  DoChange;
end;

procedure TStyledCalendar.DoRealign;
begin
  inherited;
  UpdateWeekWidth;
  UpdateWeeksDaysItemHeight;
end;

procedure TStyledCalendar.DoTodayClick(Sender: TObject);
begin
  Date := Now;
  DoChange;
  if FDisableDayChange = 0 then
    DoDateSelected;
end;

procedure TStyledCalendar.DoYearChange(Sender: TObject);
var
  AYear, AMonth, ADay: Word;
begin
  DecodeDate(FDateTime, AYear, AMonth, ADay);
  ADay := Min(ADay, DaysInAMonth(FYears.Text.ToInteger, AMonth));
  Date := EncodeDate(FYears.Text.ToInteger, AMonth, ADay);
  DoChange;
end;

procedure TStyledCalendar.FillDays;
const
  DisabledDaysOpacity = 0.3;
  EnabledDaysOpacity = 1;
var
  First: Word;

  function DefinePreviousMonth: Word;
  begin
    Result := MonthOf(FDateTime) - 1;
    if Result < MonthJanuary then
      Result := MonthDecember;
  end;

  function DefineNextMonth: Word;
  begin
    Result := MonthOf(FDateTime) + 1;
    if Result > MonthDecember then
      Result := MonthJanuary;
  end;

  function DefineYearOfPreviousMonth: Word;
  begin
    if DefinePreviousMonth = MonthDecember then
      Result := YearOf(FDateTime) - 1
    else
      Result := YearOf(FDateTime);
  end;

  function DefineYearOfNextMonth: Word;
  begin
    if DefineNextMonth = MonthJanuary then
      Result := YearOf(FDateTime) + 1
    else
      Result := YearOf(FDateTime);
  end;

  procedure FillDaysOfPreviousMonth;
  var
    PrevMonth: Word;
    Year: Word;
    DaysInMonthTmp: Word;
    I: Integer;
    Item: TDayItem;
    Day: Word;
    PrevYear: Word;
  begin
    Year := YearOf(FDateTime);
    PrevYear := DefineYearOfPreviousMonth;
    PrevMonth := DefinePreviousMonth;
    DaysInMonthTmp := DaysInAMonth(Year, PrevMonth);
    for I := 1 to First - 1 do
    begin
      Item := FDays.ListItems[I - 1] as TDayItem;
      Item.Opacity := DisabledDaysOpacity;
      Day := DaysInMonthTmp - (First - 1) + I;
      Item.Text := Day.ToString;
      Item.Date := EncodeDate(PrevYear, PrevMonth, Day);
    end;
  end;

  procedure FillDaysOfCurrentMonth;
  var
    DaysInMonthTmp: Word;
    I: Word;
    Item: TDayItem;
    Day: Word;
  begin
    DaysInMonthTmp := DaysInMonth(FDateTime);
    for I := First to First + DaysInMonthTmp - 1 do
    begin
      Item := FDays.ListItems[I - 1] as TDayItem;
      Item.Opacity := EnabledDaysOpacity;
      Day := I - First + 1;
      Item.Text := Day.ToString;
      Item.Date := RecodeDay(FDateTime, Day);
    end;
  end;

  procedure FillDaysOfNextMonth;
  var
    DaysInMonthTmp: Word;
    I: Word;
    Item: TDayItem;
    NextMonth: Word;
    NextYear: Word;
    Day: Word;
  begin
    DaysInMonthTmp := DaysInMonth(FDateTime);
    NextMonth := DefineNextMonth;
    NextYear := DefineYearOfNextMonth;
    for I := First + DaysInMonthTmp to FDays.Count do
    begin
      Item := FDays.ListItems[I - 1] as TDayItem;
      Item.Opacity := DisabledDaysOpacity;
      Day := I - First - DaysInMonthTmp + 1;
      Item.Text := Day.ToString;
      Item.Date := EncodeDate(NextYear, NextMonth, Day);
    end;
  end;

begin
  if (FDays = nil) or (FDays.Count <> CountOfVisibleDays) then
    Exit;

  First := DefineItemIndexOfFirstDayInCurrentMonth;

  FillDaysOfPreviousMonth;
  FillDaysOfCurrentMonth;
  FillDaysOfNextMonth;

  FDays.ItemIndex := (First - 1) + DayOf(FDateTime) - 1;
end;

procedure TStyledCalendar.FillCalendar;
begin
  if IsUpdating then
    Exit;

  FDisableDayChange := FDisableDayChange + 1;
  try
    FillWeekDays;
    FillDays;
    FillYears;
    FillWeeksNumbers;
    if FMonths <> nil then
      FMonths.ItemIndex := MonthOf(FDateTime) - 1;
  finally
    FDisableDayChange := FDisableDayChange - 1;
  end;
end;

procedure TStyledCalendar.UpdateWeeksDaysItemHeight;
const 
  DaysLines = 6;
begin
  if FDays <> nil then
    FDays.ItemHeight := FDays.Height / DaysLines;
  if FWeeks <> nil then
    FWeeks.ItemHeight := FWeeks.Height / DaysLines;
end;

procedure TStyledCalendar.FillWeekDays;
var
  I: Integer;
  Day: Integer;
  CaptionControl: ICaption;
begin
  if FWeek = nil then
    Exit;

  for I := 0 to DaysPerWeek - 1 do
    if Supports(FWeek.Controls[I], ICaption, CaptionControl) then
    begin
      Day := (I + FFirstDayOfWeekNum) mod DaysPerWeek;
      CaptionControl.Text := FormatSettings.ShortDayNames[1 + Day];
    end;
end;

function WeekNumber(FirstDateOfWeek: TDateTime; FirstWeekMode: TCalFirstWeekMode): Integer;
var
  Days: Integer;
  Month, Year: Word;
  TopDate: TDate;
begin
  if FirstWeekMode = TCalFirstWeekMode.ISO8601 then
    Exit(WeekOfTheYear(FirstDateOfWeek));

  Month := MonthOf(FirstDateOfWeek);
  Year := YearOf(FirstDateOfWeek);

  if (Month = 12) and (Year < YearOf(IncDay(FirstDateOfWeek, 6))) then // First week of January
  begin
    if FirstWeekMode = TCalFirstWeekMode.FirstDayOfYear then
      Exit(1);
    Days := DaysBetween(FirstDateOfWeek, EncodeDate(Year + 1, 1, 1));
    if FirstWeekMode = TCalFirstWeekMode.FirstWeekOf4Days then
    begin
      if Days <= 3 then
        Exit(1);
    end
    else if Days > 6 then
      Exit(1);
  end;

  Result := DayOfTheYear(FirstDateOfWeek);
  TopDate := IncDay(FirstDateOfWeek, - 7 * ((Result div 7) + 1));
  Days := DaysBetween(TopDate, EncodeDate(Year, 1, 1));

  if FirstWeekMode = TCalFirstWeekMode.FirstFullWeekOfYear then
  begin
    if Days > 7 then
      Dec(Result, 7);
  end
  else if FirstWeekMode = TCalFirstWeekMode.FirstDayOfYear then
  begin
    Inc(Result, Days mod 7);
  end
  else if FirstWeekMode = TCalFirstWeekMode.FirstWeekOf4Days then
  begin
    if Days <= 3 then
      Inc(Result, 7);
  end;

  Result := (Result div 7) + 1;
end;

procedure TStyledCalendar.FillWeeksNumbers;
var
  FirstDateOfWeek: TDateTime;
  FirstWeekMode: TCalFirstWeekMode;
  CaptionControl: ICaption;
begin
  if FWeeks = nil then
    Exit;

  FWeeks.Visible := Model.WeekNumbers;

  if not Model.WeekNumbers then
    Exit;

  if FDays.Count = 0 then
    Exit;

  FirstDateOfWeek := DateOf((FDays.ListItems[0] as TDayItem).Date);
  FirstWeekMode := Model.FirstWeekMode;
  for var I := 0 to FWeeks.ControlsCount - 1 do
  begin
    if Supports(FWeeks.Controls[I], ICaption, CaptionControl) then
      CaptionControl.Text := WeekNumber(FirstDateOfWeek, FirstWeekMode).ToString;
    FirstDateOfWeek := IncDay(FirstDateOfWeek, 7);
  end;
end;

procedure TStyledCalendar.FillYears;
const
  HalfCountOfYearsInPopupBox = 5;
var
  SavedYearChanged: TNotifyEvent;
  Year: Integer;
  SelectedYear: Word;
  BeginYear: Integer;
begin
  if FYears = nil then
    Exit;

  SavedYearChanged := FYears.OnChange;
  FYears.OnChange := nil;
  try
    FYears.BeginUpdate;
    try
      FYears.Items.Clear;
      SelectedYear := YearOf(FDateTime);
      BeginYear := Max(1, SelectedYear - HalfCountOfYearsInPopupBox);
      for Year := BeginYear to BeginYear + 2 * HalfCountOfYearsInPopupBox do
        FYears.Items.Add(Year.ToString);
      FYears.Text := SelectedYear.ToString;
    finally
      FYears.EndUpdate;
    end;
  finally
    FYears.OnChange := SavedYearChanged;
  end;
end;

procedure TStyledCalendar.FOnYearsMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; var Handled: Boolean);
begin
  if not Handled then
  begin
    if WheelDelta > 0 then
      Date := IncYear(Date, -1)
    else
      Date := IncYear(Date);
    Handled := True;
  end;
end;

procedure TStyledCalendar.FreeStyle;
begin
  inherited;
  if FPrev <> nil then
    FPrev.OnClick := nil;
  FPrev := nil;
  if FToday <> nil then
    FToday.OnClick := nil;
  FToday := nil;
  if FNext <> nil then
    FNext.OnClick := nil;
  FNext := nil;
  if FMonths <> nil then
    FMonths.OnChange := nil;
  FMonths := nil;
  if FYears <> nil then
    FYears.OnChange := nil;
  FYears := nil;
  FWeek := nil;
  FWeeks := nil;
  if FDays <> nil then
  begin
    FDays.OnMouseDown := nil;
    FDays.OnMouseUp := nil;
    FDays.OnChange := nil;
    FDays.OnItemClick := nil;
  end;
  FDays := nil;
end;

function TStyledCalendar.GetDate: TDate;
begin
  Result := Trunc(FDateTime);
end;

function TStyledCalendar.GetModel: TCalendarModel;
begin
  Result := inherited GetModel<TCalendarModel>;
end;

procedure TStyledCalendar.KeyDown(var Key: Word; var KeyChar: WideChar; Shift: TShiftState);
begin
  inherited;
  case Key of
    vkLeft:
      begin
        if ([ssCtrl, ssCommand] * Shift) <> [] then
          Date := IncMonth(Date, -1)
        else
          Date := IncDay(Date, -1);
        DoChange;
        Key := 0;
        KeyChar := #0;
      end;
    vkRight:
      begin
        if ([ssCtrl, ssCommand] * Shift) <> [] then
          Date := IncMonth(Date)
        else
          Date := IncDay(Date);
        DoChange;
        Key := 0;
        KeyChar := #0;
      end;
    vkUp:
      if ([ssCtrl, ssCommand] * Shift) = [] then
      begin
        Date := IncDay(Date, -7);
        DoChange;
        Key := 0;
        KeyChar := #0;
      end;
    vkDown:
      if ([ssCtrl, ssCommand] * Shift) = [] then
      begin
        Date := IncDay(Date, 7);
        DoChange;
        Key := 0;
        KeyChar := #0;
      end;
  end;
end;

procedure TStyledCalendar.MouseWheel(Shift: TShiftState; WheelDelta: Integer; var Handled: Boolean);
begin
  inherited;
  if not Handled then
  begin
    if WheelDelta > 0 then
      Date := IncMonth(Date, -1)
    else
      Date := IncMonth(Date);
    Handled := True;
  end;
end;

procedure TStyledCalendar.PMInit(var AMessage: TDispatchMessage);
begin
  BeginUpdate;
  try
    Date := Model.DateTime;
  finally
    EndUpdate;
  end;
  CalculateFirstDayOfWeek;
  FillCalendar;
end;

procedure TStyledCalendar.SetDate(Value: TDate);
begin
  FDisableDayChange := FDisableDayChange + 1;
  try
    ReplaceTime(TDateTime(Value), FDateTime);
    try
      SetDateTime(Value);
    except
      SetDateTime(FDateTime);
      raise;
    end;
  finally
    FDisableDayChange := FDisableDayChange - 1;
  end;
end;

procedure TStyledCalendar.SetDateTime(Value: TDateTime);
begin
  if not SameDateTime(FDateTime, Value) then
  begin
    FDateTime := Value;
    if not (csDestroying in ComponentState) then
    begin
      FillCalendar;
      if FDisableDayChange = 0 then
        DoChange
      else
        FNeedChange := True;
    end;
  end;
end;

function TStyledCalendar.TryFindDayItem(const ADateTime: TDateTime): TListBoxItem;
var
  FirstVisibleDayItem: TDayItem;
  LastVisibleDayItem: TDayItem;
  I: Integer;
begin
  Result := nil;
  if (FDays = nil) or (FDays.Count = 0) then
    Exit;

  FirstVisibleDayItem := FDays.ListItems[0] as TDayItem;
  LastVisibleDayItem := FDays.ListItems[FDays.Count - 1] as TDayItem;

  if DateInRange(ADateTime, FirstVisibleDayItem.Date, LastVisibleDayItem.Date) then
    for I := 0 to FDays.Count - 1 do
      if SameDate(TDayItem(FDays.ListItems[I]).Date, ADateTime) then
        Exit(FDays.ListItems[I]);
end;

procedure TStyledCalendar.UpdateWeekWidth;
begin
  if FWeek <> nil then
    FWeek.ItemWidth := Floor(FWeek.Width / DaysPerWeek);
end;

procedure TStyledCalendar.MMDateChanged(var AMessage: TDispatchMessageWithValue<TDateTime>);
begin
  SetDateTime(AMessage.Value);
end;

procedure TStyledCalendar.MMFirstDayOfWeekChanged(var AMessage: TDispatchMessageWithValue<TCalDayOfWeek>);
begin
  CalculateFirstDayOfWeek;
  FillCalendar;
end;

procedure TStyledCalendar.MMFirstWeekModeChanged(
  var AMessage: TDispatchMessageWithValue<TCalFirstWeekMode>);
begin
  FillCalendar;
end;

procedure TStyledCalendar.MMWeekNumbersChanged(var AMessage: TDispatchMessageWithValue<Boolean>);
begin
  FillCalendar;
  Realign;
end;

initialization
  TPresentationProxyFactory.Current.Register(TCalendar, TControlType.Styled, TStyledPresentationProxy<TStyledCalendar>);
finalization
  TPresentationProxyFactory.Current.Unregister(TCalendar, TControlType.Styled, TStyledPresentationProxy<TStyledCalendar>);
end.
