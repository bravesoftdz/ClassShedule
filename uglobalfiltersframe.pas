unit UGlobalFiltersFrame;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, StdCtrls, UExtendedFilterFrame,
  UMiniSortingFrame, UBasicFrame;

type

  { TGlobalFiltersFrame }

  TGlobalFiltersFrame = class(TBasicFrame)
    ExtendedFilterFrame1: TExtendedFilterFrame;
    Label_Filtering: TLabel;
    Label_Sorting: TLabel;
    MiniSortingFrame1: TMiniSortingFrame;
    function GetFilterFinal: string;
  private
    { private declarations }
  public
    { public declarations }
  end;

implementation

{$R *.lfm}

{ TGlobalFiltersFrame }

function TGlobalFiltersFrame.GetFilterFinal: string;
begin
  Result := ExtendedFilterFrame1.GetFilterFinal
          + MiniSortingFrame1.GetFilterFinal;
end;

end.

