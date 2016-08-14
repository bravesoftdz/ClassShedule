unit UBasicFrame;

{$mode objfpc}{$H+}

interface

uses
  Classes, Forms, Controls, FileCtrl, Dialogs, Sysutils;

type

  { TBasicFilterFrame }

  TBasicFrame = class(TFrame)
    constructor Create(TheOwner: TComponent); override;
    constructor CreatePos(TheOwner: TComponent; ALeft, ATop: integer);

    function GetFilterString(AFilterCB: TFilterComboBox): string;
    function GetFilterFinal: string; virtual; abstract;
  private
    { private declarations }
  public
    { public declarations }
  end;

implementation

{ TBasicFilterFrame }

constructor TBasicFrame.Create(TheOwner: TComponent);
begin
  Tag := TheOwner.Tag;
  inherited Create(TheOwner);
  Parent := TWinControl(TheOwner);
  Name := 'BSC_' + IntToStr(Cardinal(Self)); // Lazarus не генерирует Name у Frame
                                             // генерируем сами
                                             // уникальность имени обеспечена
end;

constructor TBasicFrame.CreatePos(TheOwner: TComponent; ALeft, ATop: integer);
begin
  Create(TheOwner);
  Left := ALeft;
  Top := ATop;
end;

function TBasicFrame.GetFilterString(AFilterCB: TFilterComboBox): string;
var
  StrList: TStringList;
begin
  StrList := TStringList.Create;
  with AFilterCB do begin
    ConvertFilterToStrings(Filter, StrList, True, False, True);
    Result := StrList[ItemIndex];
  end;
  StrList.Free;
end;

end.

