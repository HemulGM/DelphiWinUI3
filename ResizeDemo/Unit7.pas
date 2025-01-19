unit Unit7;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts;

{$SCOPEDENUMS ON}
type
  TResizeDirection = (Left, Right, Top, Bottom, TopLeft, TopRight, BottomLeft, BottomRight);

  TForm7 = class(TForm)
    LayoutLeft: TLayout;
    LayoutRight: TLayout;
    LayoutTop: TLayout;
    LayoutBottom: TLayout;
    LayoutBL: TLayout;
    LayoutBR: TLayout;
    LayoutTL: TLayout;
    LayoutTR: TLayout;
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure LayoutLeftMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure LayoutLeftMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure LayoutBRMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure LayoutBLMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure LayoutBottomMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure LayoutTopMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure LayoutRightMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure LayoutTLMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure LayoutTRMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure FormSaveState(Sender: TObject);
  private
    FMousePos, FDownPos: TPointF;
    FResizeSize, FDownSize: TRectF;
    FResizing: Boolean;
    FResizeDirect: TResizeDirection;
    procedure StartWindowResize(Direct: TResizeDirection); reintroduce;
  public
    procedure MouseMove(Shift: TShiftState; AFormX, AFormY: Single); override;
  end;

var
  Form7: TForm7;

implementation

{$R *.fmx}

procedure TForm7.FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  StartWindowDrag;
end;

procedure TForm7.FormSaveState(Sender: TObject);
begin
  //
end;

procedure TForm7.LayoutBLMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  StartWindowResize(TResizeDirection.BottomLeft);
end;

procedure TForm7.LayoutBottomMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  StartWindowResize(TResizeDirection.Bottom);
end;

procedure TForm7.LayoutBRMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  StartWindowResize(TResizeDirection.BottomRight);
end;

procedure TForm7.LayoutLeftMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  StartWindowResize(TResizeDirection.Left);
end;

procedure TForm7.LayoutLeftMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  if FResizing then
  begin
    FResizing := False;
    ReleaseCapture;
  end;
end;

procedure TForm7.LayoutRightMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  StartWindowResize(TResizeDirection.Right);
end;

procedure TForm7.LayoutTLMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  StartWindowResize(TResizeDirection.TopLeft);
end;

procedure TForm7.LayoutTopMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  StartWindowResize(TResizeDirection.Top);
end;

procedure TForm7.LayoutTRMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  StartWindowResize(TResizeDirection.TopRight);
end;

procedure TForm7.MouseMove(Shift: TShiftState; AFormX, AFormY: Single);
begin
  inherited;
  if FResizing then
  begin
    case FResizeDirect of
      TResizeDirection.Left:
        begin
          ;
        end;
      TResizeDirection.Right:
        begin
          FResizeSize.Right := Round(FResizeSize.Right + (AFormX - FMousePos.X));
        end;
      TResizeDirection.Top:
        begin
          FResizeSize.Top := Round(FResizeSize.Top + (AFormY - FMousePos.Y));
        end;
      TResizeDirection.Bottom:
        begin
          FResizeSize.Bottom := Round(FResizeSize.Bottom + (AFormY - FMousePos.Y));
        end;
      TResizeDirection.TopLeft:
        begin
          ;
        end;
      TResizeDirection.TopRight:
        begin

          FResizeSize.Right := Round(FResizeSize.Right + (AFormX - FMousePos.X));
        end;
      TResizeDirection.BottomLeft:
        begin
          FResizeSize.Left := Round(FResizeSize.Left + (AFormX - FMousePos.X));
          FResizeSize.Bottom := Round(FResizeSize.Bottom + (AFormY - FMousePos.Y));
        end;
      TResizeDirection.BottomRight:
        begin
          FResizeSize.Right := Round(FResizeSize.Right + (AFormX - FMousePos.X));
          FResizeSize.Bottom := Round(FResizeSize.Bottom + (AFormY - FMousePos.Y));
        end;
    end;

    SetBoundsF(Round(FResizeSize.Left), Round(FResizeSize.Top), Round(FResizeSize.Width), Round(FResizeSize.Height));
    FMousePos := PointF(AFormX, AFormY);
    Exit;
  end;
  FMousePos := PointF(AFormX, AFormY);
end;

procedure TForm7.StartWindowResize(Direct: TResizeDirection);
begin
  FResizing := True;
  FResizeDirect := Direct;
  FDownPos := FMousePos;
  FResizeSize := BoundsF;
  FDownSize := FResizeSize;
  MouseCapture;
end;

end.

