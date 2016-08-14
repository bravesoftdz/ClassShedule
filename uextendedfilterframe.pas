unit UExtendedFilterFrame;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Buttons, UMiniFilterFrame,
  UBigFilterFrame, UBasicFrame;

type

  { TExtendedFilterFrame }

  TExtendedFilterFrame = class(TBasicFrame)
    MiniFilterFrame1: TMiniFilterFrame;
    SB_AddFrame: TSpeedButton;
    procedure SB_AddFrameClick(Sender: TObject);
    procedure SB_DelFrameClick(Sender: TObject);
    function GetFilterFinal: string;
  private
    { private declarations }
  public
    { public declarations }
  end;

implementation

{$R *.lfm}

{ TExtendedFilterFrame }

function TExtendedFilterFrame.GetFilterFinal: string;
var
  I: integer;
  QueryWhere, QuerySpace: string;
begin
  for I := 0 to ComponentCount - 1 do
    if Components[I] is TBasicFrame then begin
      QuerySpace += '(';
      QueryWhere += TBasicFrame(Components[I]).GetFilterFinal + ')';
    end;

  Result := ' WHERE '+ QuerySpace + QueryWhere;
end;

procedure TExtendedFilterFrame.SB_AddFrameClick(Sender: TObject);
var
  MaxHeigh: integer;
  MaxControl: TWinControl;
begin
  MaxControl := TWinControl(Components[(ComponentCount - 1)]);
  MaxHeigh := MaxControl.Top + MaxControl.Height;
  with TBigFilterFrame.CreatePos(Self, 0, MaxHeigh) do
    SB_DelFrame.OnClick := @SB_DelFrameClick;
end;

procedure TExtendedFilterFrame.SB_DelFrameClick(Sender: TObject);
var
  I, J: integer;
  DelFrame, OffsetFrame: TWinControl;
begin
  DelFrame := TWinControl(Sender).Parent; // Указатель на Фрейм-родиель
  for I := 0 to ComponentCount - 1 do
    if Components[I] = DelFrame then begin

      for J := I + 1 to ComponentCount - 1 do begin
        OffsetFrame := TWinControl(Components[J]);
        OffsetFrame.Top := OffsetFrame.Top - DelFrame.Height;
      end;

      DelFrame.Free;
      Exit;
    end;
end;

end.

