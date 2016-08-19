unit Catalog;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, sqldb, FileUtil, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, DBGrids, StdCtrls, Buttons, Menus, Metadata, Grids, ButtonPanel,
  Editor;

type

  { TDirectory }

  TDirectory = class(TForm)
  private
    fTable: TTable;
  published
    DataSource: TDataSource;
    DBGrid: TDBGrid;
    GridPanel: TPanel;
    ControlPanel: TPanel;
    Add: TSpeedButton;
    Edit: TSpeedButton;
    Delete: TSpeedButton;
    Serch: TSpeedButton;
    Renewal: TSpeedButton;
    SQLQuery: TSQLQuery;
    procedure DBGridDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure AddClick(Sender: TObject);
    procedure DeleteClick(Sender: TObject);
    procedure EditClick(Sender: TObject);
    constructor Create(TheOwner: TComponent; aTable: TTable);
  end;

implementation

{$R *.lfm}

function GetJoinSQL(aTable: TTable): string;
var
  i: integer;
begin
  with aTable do begin
    Result := FrstName;
    for i := 0 to High(Columns) do
      with Columns[i] do
        if Primary then
          Result += ' INNER JOIN ' + PrmKey + ' ON '
                 + FrstName + '.' + FirstName + ' = '
                 + PrmKey + '.' + FrgKey;
  end;
end;

constructor TDirectory.Create(TheOwner: TComponent; aTable: TTable);
var
  i: integer;
begin
  inherited Create(TheOwner);
  fTable := aTable;
  with fTable do begin
    Caption := ScndName;
    // Подготовка таблицы (установка имен, ширины столбцов)
    for i := 0 to High(Columns) do
      with DBGrid.Columns.Add do begin
        if Columns[i].Primary then
          FieldName := Columns[i].TableKey
        else
          FieldName := Columns[i].FirstName;

        Title.Caption := Columns[i].SecondName;
        Width := 10 + Canvas.TextWidth(Title.Caption);
      end;
  end;
  SQLQuery.SQL.Append('SELECT * FROM ' +  GetJoinSQL(aTable));
  SQLQuery.Open;
end;

procedure TDirectory.DBGridDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  MaxWidth: integer = 10;
begin
  MaxWidth += Canvas.TextWidth(Column.Field.Text);
  if MaxWidth > Column.Width then
    Column.Width := MaxWidth;
end;

procedure TDirectory.DeleteClick(Sender: TObject);
var
  selected: integer;
begin
  selected := MessageDlg('Вы уверены, что хотите удалить выбранную запись?',
                           mtConfirmation, [mbYes, mbNo], 0);
  if selected = mrYes then
    TCellEditor.CreateAndDel(Self, fTable, SQLQuery).Free;
end;

procedure TDirectory.EditClick(Sender: TObject);
begin
  TCellEditor.CreateAndEdit(Self, fTable, SQLQuery).ShowModal;
end;

procedure TDirectory.AddClick(Sender: TObject);
begin
  TCellEditor.CreateAndAdd(Self, fTable, SQLQuery).ShowModal;
end;

end.

