unit UPropertyForm;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, sqldb, db, Forms, Controls, Buttons, ExtCtrls, UMetadata,
  UEdits, UDataModule, IBConnection, USQLCompatible, Dialogs, DBGrids,
  Classes, DbCtrls;

type

  { TPropertyF }

  TPropertyF = class(TForm)
    Datasource_Prop: TDatasource;
    Control_P: TPanel;
    Property_P: TPanel;
    SB_Cancel: TSpeedButton;
    SB_Save: TSpeedButton;
    SQLQuery_Prop: TSQLQuery;
    ParentSQLQuery: TSQLQuery;
    constructor CreateOnly(TheOwner: TWinControl; SQLQuery: TSQLQuery);
    constructor CreateAndAdd(TheOwner: TWinControl; SQLQuery: TSQLQuery);
    constructor CreateAndEdit(TheOwner: TWinControl; SQLQuery: TSQLQuery);
    constructor CreateAndDel(TheOwner: TWinControl; SQLQuery: TSQLQuery);
    constructor CreateAndTVAdd(TheOwner: TWinControl; SQLQuery: TSQLQuery;
      StrListT, StrListV: TStringList);
    procedure SetCreateEdits;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure ExecSQLQuery;
    procedure SB_SaveClick(Sender: TObject);
    procedure SB_CancelClick(Sender: TObject);
  private
    { private declarations }
    SafeQuery: string;
  public
    { public declarations }
  end;

implementation

{$R *.lfm}

constructor TPropertyF.CreateOnly(TheOwner: TWinControl; SQLQuery: TSQLQuery);
begin
  Tag := TheOwner.Tag;
  inherited Create(TheOwner);
  ParentSQLQuery := SQLQuery;
  Caption := 'Редактор полей таблицы "'
           + TablesData.Tables[Tag].TabSecondName + '"';
  SetCreateEdits;
  SafeQuery := RefreshQuery(GetBigFieldsWhere(Tag, SQLQuery), SQLQuery_Prop);
end;

procedure TPropertyF.SetCreateEdits;
var
  I: integer;
  ProP: TPanel;
begin
  ProP := Property_P;
  with TablesData.Tables[Tag], ScheduleDM do
    for I := 0 to High(TabNameArr) do
      with TabNameArr[I] do
        if ColFToPColVisible then begin
          CreateLabel(ProP, 10, 12 + 31 * I, 10, 21, ColFToPColSName);
          CreateLookupCombobox(ProP, 150, 10 + 31 * I, 200, 21, Datasource_Prop,
            CreateDatasource(ProP,
              CreateQuery(ProP, IBConnection_Main, SQLTransaction_Main,
                'SELECT * FROM ' + ColFToPTab + ';')
              ),
            ColFirstName, ColFToPCol, ColFToPColFName, ColFToPColFName);
        end
        else begin // Желательно преределать условие
          CreateLabel(ProP, 10, 12 + 31 * I, 10, 21, ColSecondName);
          CreateEdit(ProP, 150, 10 + 31 * I, 200, 21,
                     Datasource_Prop, ColFirstName, ColFirstName);
        end;
end;

procedure TPropertyF.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction := caFree;
end;

//------------------------- Вызов редакторов записей ---------------------------

constructor TPropertyF.CreateAndAdd(TheOwner: TWinControl; SQLQuery: TSQLQuery);
begin
  CreateOnly(TheOwner, SQLQuery);
  SQLQuery_Prop.Insert;
end;

constructor TPropertyF.CreateAndEdit(TheOwner: TWinControl; SQLQuery: TSQLQuery);
begin
  CreateOnly(TheOwner, SQLQuery);
end;

constructor TPropertyF.CreateAndDel(TheOwner: TWinControl; SQLQuery: TSQLQuery);
begin
  CreateOnly(TheOwner, SQLQuery);
  SQLQuery_Prop.Delete;
  SB_SaveClick(Self);
end;

constructor TPropertyF.CreateAndTVAdd(TheOwner: TWinControl;
  SQLQuery: TSQLQuery; StrListT, StrListV: TStringList);

  procedure SetLoop(AStr: string; DBLoopCB: TDBLookupComboBox);
  var
    I: integer;
  begin
    with DBLoopCB do
      for I := 0 to Items.Count - 1 do
        if Items[I] = AStr then begin
          ItemIndex := I; // Тонкий момент
          Field.Value := KeyValue;
          exit;
        end;
  end;

var
  I, J: integer;
begin
  CreateAndAdd(TheOwner, SQLQuery);

  with Property_P do
    for I := 0 to ControlCount - 1 do
      for J := 0 to StrListT.Count - 1 do
        if Controls[I].Name = StrListT[J] then begin
          if Controls[I] is TDBLookupComboBox then
            SetLoop(StrListV[J], TDBLookupComboBox(Controls[I]));
          if Controls[I] is TDBEdit then
            TDBEdit(Controls[I]).Text := StrListV[J];
          // Раскомментуриуйте, если нужно жестко закрепить значение поля
          // Controls[I].Enabled := False;
          break;
        end;
end;

//------------------------- Обновление Справочника -----------------------------

procedure TPropertyF.ExecSQLQuery;
begin
  ParentSQLQuery.Close;
  ParentSQLQuery.Open;
end;

//------------------------- Кнопки Сохранения и Отмены -------------------------

procedure TPropertyF.SB_SaveClick(Sender: TObject);
begin
  try
    SQLQuery_Prop.ApplyUpdates;
    ScheduleDM.SQLTransaction_Main.Commit; //Завершение транзакции
    ExecSQLQuery;
    Close;
  except
    on E: EDatabaseError do begin
      if Pos('-violation of FOREIGN KEY', E.Message) > 0 then
        MessageDlg('Нельзя удалить первичный ключ', mtError, [mbOK], 0)
      else
      if Pos('-violation of PRIMARY or UNIQUE KEY', E.Message) > 0 then
        MessageDlg('Нарушено свойство уникальности полей', mtError, [mbOK], 0)
      else
      if Pos('is required, but not supplied', E.Message) > 0 then
        MessageDlg('Заполните пустые поля', mtError, [mbOK], 0);
    end;
  end;
end;

procedure TPropertyF.SB_CancelClick(Sender: TObject);
begin
  ScheduleDM.SQLTransaction_Main.Rollback; //Откат транзакции
  ExecSQLQuery;
  Close;
end;

end.

