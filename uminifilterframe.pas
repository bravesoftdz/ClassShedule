unit UMiniFilterFrame;

{$mode objfpc}{$H+}

interface

uses
  Classes, StdCtrls, FileCtrl, UMetadata, strutils, sysutils, UBasicFrame;

type

  { TMiniFilterFrame }

  TMiniFilterFrame = class(TBasicFrame)
    Edit_Value: TEdit;
    CB_Symbol: TFilterComboBox;
    CB_Columns: TFilterComboBox;
    constructor Create(TheOwner: TComponent); override;
    function GetFilterFinal: string; override;
  private
    { private declarations }
  public
    { public declarations }
  end;

implementation

{$R *.lfm}

{ TMiniFilterFrame }

constructor TMiniFilterFrame.Create(TheOwner: TComponent);
const
  CQuery = '%s|CAST(%s.%s AS VARCHAR(100))|';
var
  I: integer;
begin
  inherited Create(TheOwner);

  with TablesData.Tables[Tag], CB_Columns do begin
    for I := 0 to High(TabNameArr) do
      with TabNameArr[I] do begin
        if ColVisible then Filter := Filter +
          Format(CQuery, [ColSecondName, TabFirstName, ColFirstName]);
        if ColFToPColVisible then Filter := Filter +
          Format(CQuery, [ColFToPColSName, ColFToPTab, ColFToPColFName]);
      end;
    Filter := Copy(Filter, 1, Length(Filter) - 1);
  end;
end;

function TMiniFilterFrame.GetFilterFinal: string;

procedure LiteralDefender(var AStr: string);
begin
  AStr := AnsiReplaceStr(AStr, '`', '``');
  AStr := AnsiReplaceStr(AStr, '%', '`%');
  AStr := AnsiReplaceStr(AStr, '_', '`_');
end;

var
  Column, Symbol, Value: string;
begin
  Column := GetFilterString(CB_Columns);
  Symbol := GetFilterString(CB_Symbol);
  Value := Edit_Value.Text;

  Case CB_Symbol.Items[CB_Symbol.ItemIndex] of
    'Начинается',
    'Кончается',
    'Содержит': LiteralDefender(Value);
  end;

  Result := Format(Symbol, [Column, Value]);
end;

end.
