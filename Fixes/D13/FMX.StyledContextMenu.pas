unit FMX.StyledContextMenu;

interface

uses
  System.Classes, FMX.Types, FMX.Menus;

const
  CutStyleName = 'cut'; //Do not localize
  CopyStyleName = 'copy'; //Do not localize
  PasteStyleName = 'paste'; //Do not localize
  DeleteStyleName = 'delete'; //Do not localize
  SelectAllStyleName = 'selectall'; //Do not localize
  UndoStyleName = 'undo'; //Do not localize
  RedoStyleName = 'redo'; //Do not localize

procedure LocalizeDefPopupMenu(PopupMenu: TPopupMenu);

procedure LocalizeDefMenuItem(MenuItem: TMenuItem);

implementation

procedure LocalizeDefMenuItem(MenuItem: TMenuItem);
begin
  if MenuItem.StyleName = CopyStyleName then
  begin
    MenuItem.StyleLookup := 'menuitemstyle_copy';
    MenuItem.ShortCut := TextToShortCut('Ctrl+C');
  end
  else if MenuItem.StyleName = CutStyleName then
  begin
    MenuItem.StyleLookup := 'menuitemstyle_cut';
    MenuItem.ShortCut := TextToShortCut('Ctrl+X');
  end
  else if MenuItem.StyleName = PasteStyleName then
  begin
    MenuItem.StyleLookup := 'menuitemstyle_paste';
    MenuItem.ShortCut := TextToShortCut('Ctrl+V');
  end
  else if MenuItem.StyleName = DeleteStyleName then
  begin
    MenuItem.StyleLookup := 'menuitemstyle_delete';
    MenuItem.ShortCut := TextToShortCut('Ctrl+Del');
  end
  else if MenuItem.StyleName = UndoStyleName then
  begin
    MenuItem.StyleLookup := 'menuitemstyle_undo';
    MenuItem.ShortCut := TextToShortCut('Ctrl+Z');
  end
  else if MenuItem.StyleName = RedoStyleName then
  begin
    MenuItem.StyleLookup := 'menuitemstyle_redo';
    //MenuItem.ShortCut := TextToShortCut('Ctrl+Y');
  end
  else if MenuItem.StyleName = SelectAllStyleName then
  begin
    MenuItem.StyleLookup := 'menuitemstyle_selectall';
    MenuItem.ShortCut := TextToShortCut('Ctrl+A');
  end;
end;

procedure LocalizeDefPopupMenu(PopupMenu: TPopupMenu);
begin
  for var i := 0 to Pred(PopupMenu.ItemsCount) do
    LocalizeDefMenuItem(PopupMenu.Items[i]);
end;

end.

