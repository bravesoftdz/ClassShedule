unit UConflictForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  ComCtrls, StdCtrls, DBGrids, UMetadata, sqldb, db, UWorldSectionFrame,
  USQLCompatible, UDataModule, UDirectoryForm, types, strutils;

type

  { TConflictsF }

  TConflictsF = class(TForm)
    Label_Text: TLabel;
    Property_P: TPanel;
    TreeView_Errors: TTreeView;
    Tree_P: TPanel;
    ErrorQuery: TWorldSectionFrame;
    constructor CreateOnly(TheOwner: TWinControl; ErrSQLQu: TWorldSectionFrame);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FillTree;
    procedure TreeView_ErrorsMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PrepareQuery(var AQuery: TSQLQuery);
  private
    { private declarations }
  public
    { public declarations }
  end;

implementation

{$R *.lfm}

{ TConflictsF }

constructor TConflictsF.CreateOnly(TheOwner: TWinControl;
  ErrSQLQu: TWorldSectionFrame);
begin
  Tag := TheOwner.Tag;
  inherited Create(TheOwner);
  Caption := 'Дерево конфликтов таблицы "'
           + TablesData.Tables[Tag].TabSecondName + '"';

  ErrorQuery := ErrSQLQu;
  FillTree;
end;

procedure TConflictsF.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction := caFree;
end;

procedure TConflictsF.PrepareQuery(var AQuery: TSQLQuery);
begin
  AQuery := TSQLQuery.Create(Self);
  AQuery.DataBase := ScheduleDM.IBConnection_Main;
  AQuery.Tag := Tag;
end;

procedure TConflictsF.FillTree;
var
  I, J, L, N: integer;
  SQLQuE, SQLQuEr, SQLQuErr: TSQLQuery;
  ChildText, ChildTextInt: string;
  Master, Slave: TTreeNode;
begin
  with TablesData.Tables[Tag] do
    for I := 0 to High(ErrNameArr) do
      with ErrNameArr[I], ErrorQuery do begin
        PrepareQuery(SQLQuE);
        RefreshQuery(GetErrorQuery(ErrFirstName, '> 0'), SQLQuE);

        if SQLQuE.RecordCount > 0 then begin
            Master := TreeView_Errors.Items.AddObject(nil, ErrSecondName, SQLQuE);

            PrepareQuery(SQLQuEr);
            RefreshQuery(GetDistErrorQuery(ErrFirstName, '> 0'), SQLQuEr);

            for J := 1 to SQLQuEr.RecordCount do begin

              PrepareQuery(SQLQuErr);
              RefreshQuery(GetErrorQuery(ErrFirstName, '= ' + SQlQuEr.Fields[0].AsString), SQLQuErr);

              ChildText := '';
              for L := 0 to High(ErrColumns) do
                ChildText += SQLQuErr.FieldByName(ErrColumns[L]).AsString + ', ';
              Delete(ChildText, Length(ChildText) - 1, 2);

              Slave := TreeView_Errors.Items.AddChildObject(Master, ChildText, SQLQuErr);

              for N := 1 to SQLQuErr.RecordCount do begin
                ChildTextInt := '';
                for L := 0 to High(TabNameArr) do
                  with TabNameArr[L] do begin
                    if ColVisible then
                      ChildTextInt += SQLQuErr.FieldByName(ColFirstName).AsString + ', ';
                    if ColFToPColVisible then
                      ChildTextInt += SQLQuErr.FieldByName(ColFToPColFName).AsString + ', ';
                  end;
                Delete(ChildTextInt, Length(ChildTextInt) - 1, 2);
                TreeView_Errors.Items.AddChildObject(Slave, ChildTextInt, Pointer(N));
                SQLQuErr.Next;
              end;

              SQLQuEr.Next;
            end;

            SQLQuEr.Free;
          end
        else
          SQLQuE.Free;
      end;
end;

procedure TConflictsF.TreeView_ErrorsMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  I : Integer;
  Quer: TSQLQuery;
  Node: TTreeNode;
begin
  Node := TreeView_Errors.GetNodeAt(X, Y);
  if (Node = nil) or (Button <> mbRight) then exit;
  TreeView_Errors.Selected := Node;
  case Node.Level of
    0..1: begin
      Quer := TSQLQuery(Node.Data);
      TDirectoryF.CreateNoQuery(Quer).ShowModal;
    end;
    2: begin
      Quer := TSQLQuery(Node.Parent.Data);
      Quer.First;
      for I := 2 to Integer(Node.Data) do
        Quer.Next;
      TDirectoryF.CreateNoQuery(Quer).SB_EditClick(Quer);
    end;
  end;
  for I := ComponentCount - 1  downto 0 do
    if Components[I] is TSQLQuery then
      Components[I].Free;
  TreeView_Errors.Items.Clear;
  FillTree;
end;



end.

