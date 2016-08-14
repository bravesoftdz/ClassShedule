unit UDirectoryForm;

{$mode objfpc}{$H+}

interface

uses
  sqldb, db, Forms, Controls, Dialogs, DBGrids, Buttons, UPropertyForm,
  UMetadata, Menus, ExtCtrls, Grids, USQLCompatible, Classes,
  UGlobalFiltersFrame;

type

  { TDirectoryF }

  TDirectoryF = class(TForm)
    Datasource_Dir: TDatasource;
    DBGrid_Dir: TDBGrid;
    GlobalFiltersFrame1: TGlobalFiltersFrame;
    Control_P: TPanel;
    Grid_P: TPanel;
    SB_Add: TSpeedButton;
    SB_Del: TSpeedButton;
    SB_Edit: TSpeedButton;

    SB_Find: TSpeedButton;
    SB_Refresh: TSpeedButton;

    SQLQuery_Dir: TSQLQuery;
    Schedule_Menu_Item: TMenuItem;
    constructor CreateAndShow(TheOwner: TMenuItem);
    constructor CreateNoQuery(aQuery: TSQLQuery);
    procedure FormClose(Sender: TObject; CloseAction: TCloseAction);
    procedure SetGridBeforeJoin;
    procedure SB_AddClick(Sender: TObject);
    procedure SB_DelClick(Sender: TObject);
    procedure SB_EditClick(Sender: TObject);
    procedure SB_FindClick(Sender: TObject);
    procedure SB_RefreshClick(Sender: TObject);
    constructor CreateTVAdd(aQuery: TSQLQuery; StrListT, StrListV: TStringList);
  private
    { private declarations }
    SafeQuery: string;
  public
    { public declarations }
  end;

implementation

{$R *.lfm}

{ TDirectoryF }

constructor TDirectoryF.CreateAndShow(TheOwner: TMenuItem);
begin
  Tag := TheOwner.Tag;
  inherited Create(TheOwner);
  Caption := TablesData.Tables[Tag].TabSecondName;
  Schedule_Menu_Item := TheOwner;

  if TablesData.Tables[Tag].TabReadOnly then begin
    SB_Add.Enabled := False;
    SB_Del.Enabled := False;
    SB_Edit.Enabled := False;
  end;

  SetGridBeforeJoin;
  SafeQuery := RefreshQuery(GetBigSelectJoin(Tag), SQLQuery_Dir);
  Show;
end;

constructor TDirectoryF.CreateNoQuery(aQuery: TSQLQuery);
begin
  Tag := aQuery.Tag;
  inherited Create(aQuery);
  Caption := TablesData.Tables[Tag].TabSecondName;

  SB_Find.Free;
  SB_Refresh.Free;
  GlobalFiltersFrame1.Free;
  SQLQuery_Dir.Free;

  SQLQuery_Dir := aQuery;

  Datasource_Dir.DataSet := SQLQuery_Dir;

  SetGridBeforeJoin;
  SafeQuery := SQLQuery_Dir.SQL.Text;
end;

procedure TDirectoryF.FormClose(Sender: TObject; CloseAction: TCloseAction);
begin
  if Assigned(Schedule_Menu_Item) then
    Schedule_Menu_Item.Checked := False;
  CloseAction := caFree;
end;

procedure TDirectoryF.SetGridBeforeJoin;
var
  I: integer;
begin
  with TablesData.Tables[Tag] do
    for I := 0 to High(TabNameArr) do
      with TabNameArr[I] do begin
        with DBGrid_Dir.Columns.Add do begin
          FieldName := ColFirstName;
          Title.Caption := ColSecondName;
          Width := ColWidth;
          Visible := ColVisible;
        end;
        with DBGrid_Dir.Columns.Add do begin
          FieldName := ColFToPColFName;
          Title.Caption := ColFToPColSName;
          Width := ColFToPColWidth;
          Visible := ColFToPColVisible;
        end;
      end;
end;

//------------------------- Редактирование записей -----------------------------

procedure TDirectoryF.SB_AddClick(Sender: TObject);
begin
  TPropertyF.CreateAndAdd(Self, SQLQuery_Dir).ShowModal;
end;

procedure TDirectoryF.SB_EditClick(Sender: TObject);
begin
  TPropertyF.CreateAndEdit(Self, SQLQuery_Dir).ShowModal;
end;

procedure TDirectoryF.SB_DelClick(Sender: TObject);
var
  BSelected: integer;
begin
  BSelected := MessageDlg('Вы уверены, что хотите удалить выбранную запись?',
                           mtConfirmation, [mbYes, mbNo], 0);
  if BSelected = mrYes then
    TPropertyF.CreateAndDel(Self, SQLQuery_Dir).Free;
end;

constructor TDirectoryF.CreateTVAdd(aQuery: TSQLQuery;
  StrListT, StrListV: TStringList);
begin
  CreateNoQuery(aQuery);
  TPropertyF.CreateAndTVAdd(Self, SQLQuery_Dir, StrListT, StrListV).ShowModal;
end;

//------------------------- Фильтрация записей ---------------------------------

procedure TDirectoryF.SB_FindClick(Sender: TObject);
begin
  RefreshQuery(SafeQuery + GlobalFiltersFrame1.GetFilterFinal, SQLQuery_Dir);
end;

procedure TDirectoryF.SB_RefreshClick(Sender: TObject);
begin
  RefreshQuery(SafeQuery, SQLQuery_Dir);
end;

end.



