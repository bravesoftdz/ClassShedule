unit Main;

{$mode objfpc}{$H+}

interface

uses
  Classes, Forms, Menus, ExtCtrls, Metadata, Catalog;

type
  TDBMenuItem = class(TMenuItem)
  private
    fModalWin: TDirectory;
  public
    procedure MenuClick(Sender: TObject);
    constructor CreateMenu(TheOwner: TComponent);
  end;

  TClassShedule = class(TForm)
  published
    BackGround: TImage;
    MainMenu: TMainMenu;
    CatalogItem: TMenuItem;
    procedure FormCreate(Sender: TObject);
  end;

var
  ClassShedule: TClassShedule;

implementation

{$R *.lfm}

procedure TDBMenuItem.MenuClick(Sender: TObject);
begin
  if not Checked then begin
     fModalWin := TDirectory.CreateCatalog(Self);
     Checked := True;
  end;

  fModalWin.ShowOnTop;
end;

constructor TDBMenuItem.CreateMenu(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  Tag := TheOwner.Tag;
  Caption := Mdata.Tables[Tag].CaptionTable;
  OnClick := @MenuClick;
end;

procedure TClassShedule.FormCreate(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to High(Mdata.Tables) do begin
    Tag := i;
    CatalogItem.Add(TDBMenuItem.CreateMenu(Self));
  end;
end;

end.
