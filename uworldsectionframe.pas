unit UWorldSectionFrame;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, UGlobalRowColFrame,
  UGlobalFiltersFrame, UBasicFrame, USQLCompatible, Dialogs, UMetadata;

type

  { TWorldSectionFrame }

  TWorldSectionFrame = class(TBasicFrame)
    GlobalFiltersFrame1: TGlobalFiltersFrame;
    GlobalRowColFrame1: TGlobalRowColFrame;
    function GetColsQuery: string;
    function GetRowsQuery: string;
    function GetRowsFirstN: string;
    function GetColsFirstN: string;
    function GetCellQuery(ARow, ACol: string): string;
    function GetErrorQuery(AError: string; AValue: string): string;
    function GetDistErrorQuery(AError: string; AValue: string): string;
    function GetFilterRowsCaption: string;
    function GetFilterColsCaption: string;
  private
    { private declarations }
  public
    { public declarations }
  end;

implementation

{$R *.lfm}

{ TWorldSectionFrame }

function TWorldSectionFrame.GetColsQuery: string;
begin
  Result := GlobalRowColFrame1.GetFilterColsFinal
          + GlobalFiltersFrame1.GetFilterFinal;
end;

function TWorldSectionFrame.GetRowsQuery: string;
begin
  Result := GlobalRowColFrame1.GetFilterRowsFinal
          + GlobalFiltersFrame1.GetFilterFinal;
end;

function TWorldSectionFrame.GetRowsFirstN: string;
begin
  Result := GlobalRowColFrame1.GetFilterRowsFirstN;
end;

function TWorldSectionFrame.GetColsFirstN: string;
begin
  Result := GlobalRowColFrame1.GetfilterColsFirstN;
end;

function TWorldSectionFrame.GetFilterRowsCaption: string;
begin
  Result := GlobalRowColFrame1.GetFilterRowsCaption;
end;

function TWorldSectionFrame.GetFilterColsCaption: string;
begin
  Result := GlobalRowColFrame1.GetFilterColsCaption;
end;

function TWorldSectionFrame.GetErrorQuery(AError: string;
  AValue: string): string;
const
  CQu = '%s WHERE %s %s AND%s';
var
  QuFrom, QuWhereE, TabN: string;
begin
  TabN := TablesData.Tables[Tag].TabFirstName;
  QuFrom := GetBigSelectJoin(Tag);
  QuWhereE := GlobalFiltersFrame1.GetFilterFinal;
  Delete(QuWhereE, 1, 6);

  Result := Format(CQu, [QuFrom, TabN + '.' + AError, AValue, QuWhereE]);
end;

function TWorldSectionFrame.GetDistErrorQuery(AError: string;
  AValue: string): string;
const
  CQuery = Length('SELECT *');
  CQu = 'SELECT DISTINCT (%s)%s';
var
  TabN: string;
begin
  TabN := TablesData.Tables[Tag].TabFirstName;
  Result := GetErrorQuery(AError, AValue);
  Delete(Result, 1, CQuery);
  Result := Format(CQu, [TabN + '.' + AError, Result]);
end;

function TWorldSectionFrame.GetCellQuery(ARow, ACol: string): string;
var
  QuFrom, QuWhereB, QuWhereE: string;
begin
  QuFrom := GetBigSelectJoin(Tag);
  QuWhereB := GlobalRowColFrame1.GetFilterRowColTabN(ARow, ACol);
  QuWhereE := GlobalFiltersFrame1.GetFilterFinal;
  Delete(QuWhereE, 1, 6);
  Result := QuFrom + QuWhereB + ' AND' + QuWhereE;
end;

end.

