unit USQLCompatible;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, UMetadata, DBGrids, sqldb, db, UEdits, FileCtrl, Dialogs;

function GetBigJoin(ATag: integer): string;
function GetBigSelectJoin(ATag: integer): string;

function GetBigWhere(ATag: integer; ASQLQuery: TSQLQuery): string;
function GetBigSelectWhere(ATag: integer;  ASQLQuery: TSQLQuery): string;

function GetBigSelection(ATag: integer): string;
function GetBigSelectionJoin(ATag: integer): string;
function GetBigSelectionWhere(ATag: integer;  ASQLQuery: TSQLQuery): string;

function GetBigFields(ATag: integer): string;
function GetBigFieldsJoin(ATag: integer): string;
function GetBigFieldsWhere(ATag: integer;  ASQLQuery: TSQLQuery): string;

function RefreshQuery(ASQL: string; ASQLQuery: TSQLQuery): string;

function GetFilterStr(SaveD: TSaveDialog): string;

implementation

function GetBigJoin(ATag: integer): string;
var
  I: integer;
begin
  with TablesData.Tables[ATag] do begin
    Result := TabFirstName;
    for I := 0 to High(TabNameArr) do
      with TabNameArr[I] do
        if ColFToPColVisible then begin
          Result += ' INNER JOIN ' + ColFToPTab + ' ON '
                 + TabFirstName + '.' + ColFirstName + ' = '
                 + ColFToPTab + '.' + ColFToPCol;
        end;
  end;
end;

function GetBigSelectJoin(ATag: integer): string;
begin
  Result := 'SELECT * FROM ' + GetBigJoin(ATag);
end;

function GetBigWhere(ATag: integer; ASQLQuery: TSQLQuery): string;
const CQuery = ' CAST(%s.%s AS VARCHAR(100)) = ''%s'' AND';
var
  I: integer;
  Value: string;
begin
  with TablesData.Tables[ATag] do begin
    Result := ' WHERE';
    for I := 0 to High(TabNameArr) do
      with TabNameArr[I] do begin
        Value := ASQLQuery.FieldByName(ColFirstName).AsString;
        Result += Format(CQuery, [TabFirstName, ColFirstName, Value]);
      end;
  end;
  Delete(Result, Length(Result) - 3, 4);
end;

function GetBigSelectWhere(ATag: integer; ASQLQuery: TSQLQuery): string;
begin
  Result := 'SELECT * FROM ' + TablesData.Tables[ATag].TabFirstName
          + GetBigWhere(ATag, ASQLQuery);
end;

function GetBigSelection(ATag: integer): string;
var
  I: integer;
  FromQuery: string;
begin
  Result := 'SELECT ';
  with TablesData.Tables[ATag] do
    for I := 0 to High(TabNameArr) do
      with TabNameArr[I] do begin
        if ColVisible then
          Result += TabFirstName + '.' + ColFirstName + ', ';
        if ColFToPColVisible then
          Result += ColFToPTab + '.' + ColFToPColFName + ', ';
      end;

  Delete(Result, Length(Result) - 1, 2);
end;

function GetBigSelectionJoin(ATag: integer): string;
begin
  Result := GetBigSelection(ATag) + ' FROM ' + GetBigJoin(ATag);
end;

function GetBigSelectionWhere(ATag: integer; ASQLQuery: TSQLQuery): string;
begin
  Result := GetBigSelection(ATag) + ' FROM ' + TablesData.Tables[ATag].TabFirstName
          + GetBigWhere(ATag, ASQLQuery);
end;

function GetBigFields(ATag: integer): string;
var
  I: integer;
  FromQuery: string;
begin
  Result := 'SELECT ';
  with TablesData.Tables[ATag] do
    for I := 0 to High(TabNameArr) do
      with TabNameArr[I] do begin
        if ColVisible then
          Result += ColFirstName + ', ';
        if ColFToPColVisible then
          Result += ColFirstName + ', ';
      end;

  Delete(Result, Length(Result) - 1, 2);
end;

function GetBigFieldsJoin(ATag: integer): string;
begin
  Result := GetBigFields(ATag) + ' FROM ' + GetBigJoin(ATag);
end;

function GetBigFieldsWhere(ATag: integer; ASQLQuery: TSQLQuery): string;
begin
  Result := GetBigFields(ATag) + ' FROM ' + TablesData.Tables[ATag].TabFirstName
          + GetBigWhere(ATag, ASQLQuery);
end;

function RefreshQuery(ASQL: string; ASQLQuery: TSQLQuery): string;
begin
  Result := ASQL;
  with ASQLQuery do begin
    Close;
    SQL.Text := ASQL;
    Open;
  end;
end;

function GetFilterStr(SaveD: TSaveDialog): string;
var
  StrList: TStringList;
begin
  StrList := TStringList.Create;
  with SaveD do begin
    TFilterComboBox.ConvertFilterToStrings(Filter, StrList, True, False, True);
    Result := StrList[FilterIndex - 1];
  end;
  StrList.Free;
end;

end.

