unit UMiniSortingFrame;

{$mode objfpc}{$H+}

interface

uses
  Classes, StdCtrls, FileCtrl, UMetadata, UBasicFrame, strutils, dialogs, sysUtils;

type

  { TMiniSortingFrame }

  TMiniSortingFrame = class(TBasicFrame)
    CB_Sort: TFilterComboBox;
    CB_TypeSort: TFilterComboBox;
    constructor Create(TheOwner: TComponent); override;
    function GetFilterFinal: string; override;
  private
    { private declarations }
  public
    { public declarations }
  end;

implementation

{$R *.lfm}

{ TMiniSortingFrame }

constructor TMiniSortingFrame.Create(TheOwner: TComponent);
const
  CQuery = '%s| ORDER BY %s.%s|';
var
  I: integer;
begin
  inherited Create(TheOwner);

  with TablesData.Tables[Tag], CB_Sort do begin
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

function TMiniSortingFrame.GetFilterFinal: string;
begin
  Result := GetFilterString(CB_Sort) + GetFilterString(CB_TypeSort);
end;

end.

