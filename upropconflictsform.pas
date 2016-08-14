unit UPropConflictsForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  CheckLst, StdCtrls, UMetadata;

type

  { TPropConflictsF }

  TPropConflictsF = class(TForm)
    Label_Text: TLabel;
    ListBox1_Conf: TListBox;
    List_P: TPanel;
    Property_P: TPanel;
    constructor CreateOnly(TheOwner: TWinControl);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FillFields;
  private
    { private declarations }
  public
    { public declarations }
  end;

implementation

{$R *.lfm}

constructor TPropConflictsF.CreateOnly(TheOwner: TWinControl);
begin
  Tag := TheOwner.Tag;
  inherited Create(TheOwner);
  Caption := 'Список существующих конфликтов таблицы "'
           + TablesData.Tables[Tag].TabSecondName + '"';
  FillFields;
end;

procedure TPropConflictsF.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  CloseAction := caFree;
end;

procedure TPropConflictsF.FillFields;
var
  I: integer;
begin
  with TablesData.Tables[Tag] do
    for I := 0 to High(ErrNameArr) do
      with ErrNameArr[I] do begin
        ListBox1_Conf.AddItem(ErrSecondName, nil);
      end;
end;

end.

