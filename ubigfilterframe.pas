unit UBigFilterFrame;

{$mode objfpc}{$H+}

interface

uses
  FileCtrl, UMiniFilterFrame, Buttons, UMiniSortingFrame, Classes, UBasicFrame;

type

  { TBigFilterFrame }

  TBigFilterFrame = class(TBasicFrame)
    CB_Operation: TFilterComboBox;
    MiniFilterFrame1: TMiniFilterFrame;
    SB_DelFrame: TSpeedButton;
    function GetFilterFinal: string; override;
  private
    { private declarations }
  public
    { public declarations }
  end;

implementation

{$R *.lfm}

{ TBigFilterFrame }

function TBigFilterFrame.GetFilterFinal: string;
begin
  Result := GetFilterString(CB_Operation) + MiniFilterFrame1.GetFilterFinal;
end;

end.

