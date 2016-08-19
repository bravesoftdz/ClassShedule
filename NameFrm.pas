unit NameFrm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls;

type
  TNamedFrame = class(TFrame)
    constructor Create(TheOwner: TWinControl);
  end;

implementation

constructor TNamedFrame.Create(TheOwner: TWinControl);
begin
  Tag := TheOwner.Tag;
  inherited Create(TheOwner);
  Parent := TheOwner;
  Name := '_' + IntToStr(Cardinal(Self));
end;

end.

