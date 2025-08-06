unit WinUI3.Utils;

interface

uses
  FMX.Types, System.Generics.Collections, System.UITypes;

type
  TRingTabList = class(TAggregatedObject, ITabList)
  strict private
    FTabList: TList<IControl>;
    procedure CreateTabList;
    function ParentIsRoot: Boolean;
  protected
    function IsAddable(const TabStop: IControl): Boolean; virtual;
  public
    constructor Create(const TabStopController: ITabStopController);
    destructor Destroy; override;
    procedure Clear;
    procedure Add(const TabStop: IControl); virtual;
    procedure Remove(const TabStop: IControl); virtual;
    procedure Update(const TabStop: IControl; const NewValue: TTabOrder);
    function IndexOf(const TabStop: IControl): Integer; virtual;
    function GetCount: Integer; virtual;
    function GetItem(const Index: Integer): IControl; virtual;
    function GetTabOrder(const TabStop: IControl): TTabOrder;
    function FindNextTabStop(const ACurrent: IControl; const AMoveForward: Boolean; const AClimb: Boolean): IControl;
  end;

function IsWin11OrNewest: Boolean;

implementation

uses
  System.SysUtils, System.Math;

function IsWin11OrNewest: Boolean;
begin
  Result := TOSVersion.Check(10) and (TOSVersion.Build > 22000);
  Result := Result or TOSVersion.Check(11);
end;

{ TRingTabList }

constructor TRingTabList.Create(const TabStopController: ITabStopController);
begin
  inherited Create(TabStopController);
end;

destructor TRingTabList.Destroy;
begin
  FTabList.Free;
  inherited Destroy;
end;

procedure TRingTabList.Clear;
begin
  if FTabList <> nil then
    FTabList.Clear;
end;

procedure TRingTabList.CreateTabList;
begin
  if FTabList = nil then
    FTabList := TList<IControl>.Create;
end;

function TRingTabList.IsAddable(const TabStop: IControl): Boolean;
begin
  Result := TabStop.GetObject.Stored and not Supports(TabStop, IContent);
end;

procedure TRingTabList.Add(const TabStop: IControl);
begin
  if IsAddable(TabStop) then
  begin
    CreateTabList;
    FTabList.Add(TabStop);
  end;
end;

procedure TRingTabList.Remove(const TabStop: IControl);
begin
  if FTabList <> nil then
    FTabList.Remove(TabStop);
end;

procedure TRingTabList.Update(const TabStop: IControl; const NewValue: TTabOrder);
var
  OldValue: TTabOrder;
  I: Integer;
  OldCount: Integer;
  TempControl: IControl;
begin
  CreateTabList;

  if NewValue = -1 then
    Remove(TabStop)
  else if IsAddable(TabStop) then
  begin
    if IndexOf(TabStop) = -1 then
      Add(TabStop);

    if NewValue >= FTabList.Count then
    begin
      OldCount := FTabList.Count;
      FTabList.Count := NewValue + 1;
      for I := OldCount to FTabList.Count - 1 do
        FTabList[I] := nil;
    end;

    OldValue := GetTabOrder(TabStop);

    if InRange(NewValue, 0, FTabList.Count - 1) and (OldValue >= 0) then
    begin
      TempControl := FTabList[OldValue];
      FTabList.Delete(OldValue);
      if (NewValue < FTabList.Count) and (FTabList[NewValue] = nil) then
        FTabList[NewValue] := TempControl
      else
        FTabList.Insert(NewValue, TempControl);
    end;
  end;
end;

function TRingTabList.FindNextTabStop(const ACurrent: IControl; const AMoveForward: Boolean; const AClimb: Boolean): IControl;

  function Advance(const X: Integer; const ASize: Integer; const AMoveForward: Boolean; const ARing: Boolean): Integer;
  const
    AdvanceAdd: array[Boolean] of Integer = (-1, 1);
  begin
    Result := X + AdvanceAdd[AMoveForward];
    if ARing then
    begin
      if Result < 0 then
        Result := ASize - 1
      else if Result >= ASize then
        Result := 0;
    end
    else if (Result < 0) or (Result >= ASize) then
      Result := -1;
  end;

  function IsTabStop(const C: IControl): Boolean;
  begin
    Result := (C <> nil) and C.CheckForAllowFocus and C.TabStop;
  end;

  function NextTabStop(const AInitial: IControl; const ATabIndex: Integer): IControl;
  var
    AsNode: ITabStopController;
    I: Integer;
    TabIndex: Integer;
  begin
    Result := AInitial;
    // If result is satisfactory, exit immediately
    if IsTabStop(Result) then
      Exit(Result);
    // If we're climbing up, the current result is to be taken as starting point
    if not AClimb and (ACurrent <> nil) then
      Result := ACurrent;

    TabIndex := ATabIndex;
    for I := 0 to GetCount do
    begin
      if Supports(Result, ITabStopController, AsNode) then
        Result := AsNode.TabList.FindNextTabStop(nil, AMoveForward, False);
      if Result = nil then
      begin
        TabIndex := Advance(TabIndex, GetCount, AMoveForward, ParentIsRoot);
        if TabIndex = -1 then
          Break
        else
          Result := GetItem(TabIndex);
      end;
      if IsTabStop(Result) then
        Break;
    end;
  end;

  function PrevTabStop(const AInitial: IControl; const ATabIndex: Integer): IControl;
  var
    AsNode: ITabStopController;
    Nested: IControl;
    I: Integer;
    TabIndex: Integer;
  begin
    Result := AInitial;
    // Result = rightmost or current
    TabIndex := ATabIndex;
    for I := 0 to GetCount do
    begin
      // go as deep as we can down the rightmost branch
      if Supports(Result, ITabStopController, AsNode) then
        Nested := AsNode.TabList.FindNextTabStop(nil, False, False);
      if Nested <> nil then
        Exit(Nested)
      else
      begin
        if not IsTabStop(Result) then
        begin
          TabIndex := Advance(TabIndex, GetCount, False, ParentIsRoot);
          if TabIndex = -1 then
            if AClimb then
              Exit(ACurrent)
            else
              Exit(nil)
          else
            Result := GetItem(TabIndex)
        end;
      end;
      if IsTabStop(Result) then
        Break;
    end;
  end;

var
  TabIndex: Integer;
begin
  Result := nil;
  if GetCount = 0 then
    Exit;

  // If Current = nil: find a starting point
  if ACurrent = nil then
  begin
    if AMoveForward then
      TabIndex := 0
    else
      TabIndex := GetCount - 1;
    Result := GetItem(TabIndex);
  end
  else
    TabIndex := IndexOf(ACurrent);

  if AMoveForward then
    Result := NextTabStop(Result, TabIndex)
  else
    Result := PrevTabStop(Result, TabIndex);
  if not IsTabStop(Result) then
    Result := nil;
end;

function TRingTabList.IndexOf(const TabStop: IControl): Integer;
begin
  if FTabList = nil then
    Result := -1
  else
    Result := FTabList.IndexOf(TabStop);
end;

function TRingTabList.ParentIsRoot: Boolean;
begin
  Result := True; //not Supports(Controller, IControl);
end;

function TRingTabList.GetCount: Integer;
begin
  if FTabList = nil then
    Exit(0);
  Result := FTabList.Count;
end;

function TRingTabList.GetItem(const Index: Integer): IControl;
begin
  if FTabList = nil then
    Exit(nil);
  Result := FTabList[Index];
end;

function TRingTabList.GetTabOrder(const TabStop: IControl): TTabOrder;
begin
  Result := IndexOf(TabStop);
end;

end.

