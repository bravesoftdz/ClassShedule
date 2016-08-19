unit EditFrm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, StdCtrls, DbCtrls, NameFrm,
  Metadata;

type
  TEditFrame = class(TNamedFrame)
    FieldEditor: TDBEdit;
    FieldName: TLabel;
    constructor Create(TheOwner: TWinControl; aColumn: TColumns);
  end;

implementation

{$R *.lfm}

constructor TEditFrame.Create(TheOwner: TWinControl; aColumn: TColumns);
begin
  inherited Create(TheOwner);
  FieldName.Caption := aColumn.SecondName;
  FieldEditor.DataField := aColumn.FirstName;
end;

end.

