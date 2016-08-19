unit BoxFrm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, sqldb, FileUtil, Forms, Controls, StdCtrls, DbCtrls,
  NameFrm, Dialogs, Metadata;

type
  TBoxFrame = class(TNamedFrame)
    ListSource: TDataSource;
    DBLComboBox: TDBLookupComboBox;
    FieldName: TLabel;
    SQLQuery: TSQLQuery;
    constructor Create(TheOwner: TWinControl; aColumn: TColumns);
  end;

implementation

{$R *.lfm}

constructor TBoxFrame.Create(TheOwner: TWinControl; aColumn: TColumns);
begin
  inherited Create(TheOwner);
  FieldName.Caption := aColumn.SecondName;
  DBLComboBox.DataField := aColumn.FirstName;
  DBLComboBox.KeyField := aColumn.FrgKey;
  DBLComboBox.ListField := aColumn.TableKey;
  SQLQuery.SQL.Append('SELECT * FROM ' + aColumn.PrmKey);
  SQLQuery.Open;
end;

end.

