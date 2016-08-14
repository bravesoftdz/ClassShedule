unit UEdits;

{$mode objfpc}{$H+}

interface

uses
  DBCtrls, Controls, DB, sqldb, IBConnection, StdCtrls;

function CreateDatasource(AParent: TWinControl;
  ADataSet: TSQLQuery): TDataSource;
function CreateQuery(AParent: TWinControl; ADatabase: TIBConnection;
  ATransaction: TSQLTransaction; ASQLText: string): TSQLQuery;
function CreateLookupCombobox(AParent: TWinControl;
  ALeft, ATop, AWidth, AHeight: integer;
  ADataSource, AListSource: TDatasource;
  ADataField, AKeyFiled, AListFiled, AName: string): TDBLookupCombobox;
function CreateEdit(AParent: TWinControl;
  ALeft, ATop, AWidth, AHeight: integer; ADataSource: TDataSource;
  ADataField, AName: string): TDBEdit;
function CreateLabel(AParent: TWinControl;
  ALeft, ATop, AWidth, AHeight: integer; ACaption: string): TLabel;

implementation

function CreateDatasource(AParent: TWinControl;
  ADataSet: TSQLQuery): TDataSource;
begin
  Result := TDataSource.Create(AParent);
  with Result do begin
    DataSet := ADataSet;
  end;
end;

function CreateQuery(AParent: TWinControl; ADatabase: TIBConnection;
  ATransaction: TSQLTransaction; ASQLText: string): TSQLQuery;
begin
  Result := TSQLQuery.Create(AParent);
  with Result do begin
    Close;
    Database := ADatabase;
    Transaction := ATransaction;
    SQL.Text := ASQLText;
    Open;
  end;
end;

function CreateLookupCombobox(AParent: TWinControl;
  ALeft, ATop, AWidth, AHeight: integer;
  ADataSource, AListSource: TDatasource;
  ADataField, AKeyFiled, AListFiled, AName: string): TDBLookupCombobox;
begin
  Result := TDBLookupComboBox.Create(AParent);
  with Result do begin
    Name := AName;
    SetBounds(ALeft, ATop, AWidth, AHeight);
    DataSource := ADataSource;
    ListSource := AListSource;
    DataField := ADataField;
    KeyField := AKeyFiled;
    ListField := AListFiled;
    Parent := AParent;
  end;
end;

function CreateEdit(AParent: TWinControl;
  ALeft, ATop, AWidth, AHeight: integer; ADataSource: TDataSource;
  ADataField, AName: string): TDBEdit;
begin
  Result := TDBEdit.Create(AParent);
  with Result do begin
    Name := AName;
    SetBounds(ALeft, ATop, AWidth, AHeight);
    DataSource := ADataSource;
    DataField := ADataField;
    Parent := AParent;
  end;
end;

function CreateLabel(AParent: TWinControl;
  ALeft, ATop, AWidth, AHeight: integer; ACaption: string): TLabel;
begin
  Result := TLabel.Create(AParent);
  with Result do begin
    SetBounds(ALeft, ATop, AWidth, AHeight);
    Caption := ACaption;
    Parent := AParent;
  end;
end;

end.

