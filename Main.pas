unit Main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ExtCtrls, DBGrids, DbCtrls, Metadata, Catalog, db, sqldb;

type
  TDBMenuItem = class(TMenuItem)
  private
    fModalWin: TDirectory;
    fTable: TTable;
  public
    procedure MenuClick(Sender: TObject);
    constructor CreateMenu(TheOwner: TComponent; aTable: TTable);
  end;

  TClassShedule = class(TForm)
    BackGround: TImage;
    MainMenu: TMainMenu;
    Catalog: TMenuItem;
    procedure FormCreate(Sender: TObject);
  end;

var
  ClassShedule: TClassShedule;

implementation

{$R *.lfm}

procedure TDBMenuItem.MenuClick(Sender: TObject);
begin
  if not Checked then begin
     fModalWin := TDirectory.Create(Self, fTable);
     Checked := true;
  end;

  fModalWin.ShowOnTop;
end;

constructor TDBMenuItem.CreateMenu(TheOwner: TComponent; aTable: TTable);
begin
  inherited Create(TheOwner);
  fTable := aTable;
  Caption := aTable.ScndName;
  OnClick := @MenuClick;
end;

procedure TClassShedule.FormCreate(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to High(Mdata.Tables) do
    Catalog.Add(TDBMenuItem.CreateMenu(Self, Mdata.Tables[i]));
end;

end.
