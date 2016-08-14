unit UGlobalRowColFrame;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, FileCtrl, StdCtrls, UBasicFrame, UMetadata, USQLCompatible;

type

  { TGlobalRowColFrame }

  TGlobalRowColFrame = class(TBasicFrame)
    CB_Cols: TFilterComboBox;
    CB_Rows: TFilterComboBox;
    Label_Cols: TLabel;
    Labe_Rows: TLabel;
    function GetFilterCreate: string;
    function GetFilterRowsFinal: string;
    function GetFilterColsFinal: string;
    function GetFilterRowColTabN(ARow, ACol: string): string;
    function GetFilterFromName(AStr: string): string;
    function GetFilterRowsFirstN: string;
    function GetfilterColsFirstN: string;
    constructor Create(TheOwner: TComponent); override;
    function GetFilterFromFirstName(AStr: string): string;
    function GetFilterRowsCaption: string;
    function GetFilterColsCaption: string;
  private
    { private declarations }
  public
    { public declarations }
  end;

implementation

{$R *.lfm}

function TGlobalRowColFrame.GetFilterFromName(AStr: string): string;
const
  CLQuery = Length('SELECT DISTINCT  ');
  CFrom = 'FROM';
begin
  Result := Copy(AStr,  CLQuery,  Pos(CFrom, AStr) - CLQuery - 1);
end;

function TGlobalRowColFrame.GetFilterFromFirstName(AStr: string): string;
const
  Dot = '.';
begin
  Result := AStr;
  Delete(Result, 1, Pos(Dot, Result));
end;

function TGlobalRowColFrame.GetFilterRowsCaption: string;
begin
  Result := CB_Rows.Caption;
end;

function TGlobalRowColFrame.GetFilterColsCaption: string;
begin
  Result := CB_Cols.Caption;
end;

function TGlobalRowColFrame.GetFilterRowsFirstN: string;
begin
  Result := GetFilterFromFirstName(GetFilterFromName(GetFilterRowsFinal));
end;

function TGlobalRowColFrame.GetfilterColsFirstN: string;
begin
  Result := GetFilterFromFirstName(GetFilterFromName(GetFilterColsFinal));
end;

function TGlobalRowColFrame.GetFilterCreate: string;
const
  CQuery = '%s|SELECT DISTINCT %s.%s FROM %s|';
var
  I: integer;
  FromQuery: string;
begin
  FromQuery := GetBigJoin(Tag);
  with TablesData.Tables[Tag] do
    for I := 0 to High(TabNameArr) do
      with TabNameArr[I] do begin
        if ColVisible then
          Result += Format(CQuery, [ColSecondName, TabFirstName,
                                    ColFirstName, FromQuery]);
        if ColFToPColVisible then
          Result += Format(CQuery, [ColFToPColSName, ColFToPTab,
                                    ColFToPColFName, FromQuery]);
      end;

  Delete(Result, Length(Result), 1);
end;

function TGlobalRowColFrame.GetFilterRowsFinal: string;
begin
  Result := GetFilterString(CB_Rows);
end;

function TGlobalRowColFrame.GetFilterColsFinal: string;
begin
  Result := GetFilterString(CB_Cols);
end;

function TGlobalRowColFrame.GetFilterRowColTabN(ARow, ACol: string): string;
const
  CQuery = ' WHERE CAST(%s AS VARCHAR(100)) = ''%s''' +
           ' AND CAST(%s AS VARCHAR(100)) = ''%s''';
begin
  Result := Format(CQuery, [GetFilterFromName(GetFilterRowsFinal), ARow,
                            GetFilterFromName(GetFilterColsFinal), ACol]);
end;

constructor TGlobalRowColFrame.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);

  CB_Rows.Filter := GetFilterCreate;
  CB_Cols.Filter := CB_Rows.Filter;
end;

end.

