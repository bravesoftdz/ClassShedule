unit UTimetableForm;

{$mode objfpc}{$H+}

interface

uses
  sqldb, Forms, Controls, Graphics, Menus, Grids, Buttons, ExtCtrls, StdCtrls,
  CheckLst, Dialogs, UMetadata, UButtons, windows, USQLCompatible, UExcel,
  UWorldSectionFrame, UDataModule, Classes, UPropConflictsForm, UConflictForm,
  UExcelConst, sysutils, UButtonsStatic;


type

  { TTimetableF }

  TQueryArr = array of array of TSQLQuery;

  TTimetableF = class(TForm)
    CB_Title: TCheckBox;
    CB_AutoCell: TCheckBox;
    CB_AutoCell2: TCheckBox;
    CLB_Field: TCheckListBox;
    DG_Timetable: TDrawGrid;
    Control_P: TPanel;
    Grid_P: TPanel;
    GB_Settings: TGroupBox;
    Label_Definition: TLabel;
    MainMenu_Timetable: TMainMenu;
    Menu_SaveAs: TMenuItem;
    Menu_ListConflicts: TMenuItem;
    Menu_TreeConflicts: TMenuItem;
    Menu_Conflicts: TMenuItem;
    Menu_File: TMenuItem;
    PopupMenu_Timetable: TPopupMenu;
    SaveDialog_Timetable: TSaveDialog;
    SB_Select: TSpeedButton;
    SQLQuery_Timetable: TSQLQuery;
    WorldSectionFrame1: TWorldSectionFrame;
    procedure DG_TimetableDrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
    procedure DG_TimetableMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure DG_TimetableMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure Menu_ListConflictsClick(Sender: TObject);
    procedure Menu_SaveAsClick(Sender: TObject);
    procedure Menu_TreeConflictsClick(Sender: TObject);
    procedure SB_SelectClick(Sender: TObject);
    function GetFieldsFromName(ARow, ACol: Integer): TStringList;
    function SetRowsColsArrays(AQuery: string): TStringList;
    procedure SetCLBFields;

    procedure ItemClick(Sender: TObject; Index: integer);
    procedure CellClick(Sender: TObject);
    constructor CreateOnly(TheOwner: TWinControl);
  private
    { private declarations }
    RowsName: TStringList;
    ColsName: TStringList;
    QuertArr: TQueryArr;
    procedure FillTheArray;
    procedure CleanTheArray;
    procedure SaveCreateFilter;
    procedure Save;
    function SaveHTML: string;
    function TextCreate(AItemStr: TStringList; Strip: string = #10): string;
    procedure TextShow(ACanv: TCanvas; AItemStr: TStringList; X, Y: integer);
  public
    { public declarations }
  end;

implementation

{$R *.lfm}

{ TTimetableF }

constructor TTimetableF.CreateOnly(TheOwner: TWinControl);
begin
  Tag := TheOwner.Tag; // Можно убрать
  inherited Create(TheOwner);
  Caption := TablesData.Tables[Tag].TabSecondName;

  SetCLBFields;
  SaveCreateFilter;
  DG_Timetable.FocusRectVisible := False;
end;

procedure TTimetableF.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction := caFree;
end;

procedure TTimetableF.Menu_ListConflictsClick(Sender: TObject);
begin
  TPropConflictsF.CreateOnly(Self).ShowModal;
end;

procedure TTimetableF.Menu_SaveAsClick(Sender: TObject);
begin
  Save;
end;

procedure TTimetableF.Menu_TreeConflictsClick(Sender: TObject);
begin
  TConflictsF.CreateOnly(Self, WorldSectionFrame1).ShowModal;
end;

//------------------------- Заполнение Query ячеек -----------------------------

procedure TTimetableF.FillTheArray;
var
  I, J: integer;
begin
  SetLength(QuertArr, RowsName.Count, ColsName.Count);
  for I := 0 to RowsName.Count - 1 do
    for J := 0 to ColsName.Count - 1 do begin
      QuertArr[I][J] := TSQLQuery.Create(Self);
      QuertArr[I][J].DataBase := ScheduleDM.IBConnection_Main;
      QuertArr[I][J].Tag := Tag;
      RefreshQuery(
        WorldSectionFrame1.GetCellQuery(RowsName[I], ColsName[J]),
        QuertArr[I][J]
      );
    end;
end;

procedure TTimetableF.CleanTheArray;
var
  I, J: integer;
begin
  for I := 0 to High(QuertArr) do
    for J := 0 to High(QuertArr[I]) do
      QuertArr[I][J].Free;

  SetLength(QuertArr, 0, 0);
end;

//------------------------- Сохраниение таблицы --------------------------------

function TTimetableF.SaveHTML: String;
var
  I, J: integer;
  StrList: TStringList;
  CellText: string;
begin
  StrList := TStringList.Create;

  Result := '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Strict//EN"'#10
          + '"http://www.qyos.am/TR/html4/strict.dtd">'#10
          + '<HTML>'#10
          + '  <HEAD>'#10
          + '    <META http-equiv="Content-Type" content="text/html; charset=utf-8">'#10
          + '    <TITLE>' + Caption + '</TITLE>'#10
          + '  </HEAD>'#10
          + '  <BODY>'#10

          + '    <TABLE CELLSPACING="0" CELLPADDING="0" BORDER="1">'#10
          + '      <TR>'#10
          + '        <TH  ROWSPAN = ' + IntToStr(CLB_Field.Count) + ' BGCOLOR="Gainsboro">Поля</TH>'#10
          + '        <TD>' + CLB_Field.Items[0] + '</TD>'#10
          + '      </TR>'#10;
  for I := 1 to CLB_Field.Count - 1 do
    Result +=
            '      <TR>'#10
          + '        <TD>' + CLB_Field.Items[I] + '</TD>'#10
          + '      </TR>'#10;

  Result += '      <TR>'#10
          + '        <TH BGCOLOR="Gainsboro">Строки</TH>'#10
          + '        <TD>' + WorldSectionFrame1.GetFilterRowsCaption + '</TD>'#10
          + '      </TR>'#10
          + '      <TR>'#10
          + '        <TH BGCOLOR="Gainsboro">Колонки</TH>'#10
          + '        <TD>' + WorldSectionFrame1.GetFilterColsCaption + '</TD>'#10
          + '      </TR>'#10
          + '      <TR>'#10
          + '        <TH BGCOLOR="Gainsboro"><br></TH>'#10;
  for I := 0 to ColsName.Count -1 do
    Result +=
            '        <TH BGCOLOR="Gainsboro">' + ColsName[I] + '</TH>'#10;
  Result += '      </TR>'#10;
  for I := 0 to RowsName.Count -1 do begin
    Result +=
            '      <TR>'#10
          + '        <TH BGCOLOR="Gainsboro">' + RowsName[I] + '</TH>'#10;
    for J := 0 to ColsName.Count -1 do begin
      CellText := TextCreate(GetFieldsFromName(I, J), '<br>');
      if CellText <> '' then
        Result +=
            '        <TD NOWRAP VALIGN="TOP" BGCOLOR="CornflowerBlue">' + CellText + '</TD>'#10
      else
        Result +=
            '        <TD><br></TD>'#10
    end;
    Result +=
            '      </TR>'#10;
  end;
  Result += '    </TABLE>'#10
          + '  </BODY>'#10
          + '</HTML>';
  StrList.Free;
end;

procedure TTimetableF.SaveCreateFilter;
begin
  if not CheckExcelInstall then exit;
  SaveDialog_Timetable.Filter := SaveDialog_Timetable.Filter +
    '|Веб-страница в одном файле (*.mht)|*.mht' +
    '|Таблица XML (*.xml)|*.xml' +
    '|Книга Microsoft Office Excel 2.0 (*.xls)|*.xls' +
    '|Книга Microsoft Office Excel 3.0 (*.xls)|*.xls' +
    '|Книга Microsoft Office Excel 4.0 (*.xls)|*.xls' +
    '|Книга Microsoft Office Excel 5.0 (*.xls)|*.xls' +
    '|Книга Microsoft Office Excel 95 (*.xls)|*.xls' +
    '|Книга Microsoft Office Excel 95/97 (*.xls)|*.xls';
end;

procedure TTimetableF.Save;

  procedure ComExecute(Charset: integer; Path: ansistring);
  begin
    try
      RunExcel;
      OpenWorkBook(ExtractFilePath(Application.ExeName) + 'TEMP.tmp');
      SaveWorkBook(Path, 1, Charset);
    finally
      StopExcel;
    end;
  end;

var
  TextF: TextFile;
  FileN, Exp: string;
  Path: ansistring;
begin
  with SaveDialog_Timetable do begin
    if not SaveDialog_Timetable.Execute then exit;
    FileN := SaveDialog_Timetable.FileName;
    Exp := GetFilterStr(SaveDialog_Timetable);
    Delete(Exp, 1, 1);

    Path := Utf8ToAnsi(ChangeFileExt(FileN, Exp));

    AssignFile(TextF, 'TEMP.tmp');
    Rewrite(TextF);
    Write(TextF, SaveHTML);
    CloseFile(TextF);

    case SaveDialog_Timetable.FilterIndex of
      1: CopyFile('TEMP.tmp', PChar(Path), True);
      2: ComExecute(xlWebArchive, Path);
      3: ComExecute(xlXMLSpreadsheet, Path);
      4: ComExecute(xlExcel2, Path);
      5: ComExecute(xlExcel3, Path);
      6: ComExecute(xlExcel4, Path);
      7: ComExecute(xlExcel5, Path);
      8: ComExecute(xlExcel7, Path);
      9: ComExecute(xlExcel9795, Path);
    end;
  end;
end;

//------------------------- Обработчик выполнения запроса ----------------------

procedure TTimetableF.SB_SelectClick(Sender: TObject);
begin
  with WorldSectionFrame1 do begin
    RowsName := SetRowsColsArrays(GetRowsQuery);
    ColsName := SetRowsColsArrays(GetColsQuery);
  end;

  CleanTheArray;
  FillTheArray;

  Menu_SaveAs.Enabled := True;

  with DG_Timetable do begin
    RowCount := RowsName.Count + 1;
    ColCount := ColsName.Count + 1;
    Visible := True;
  end;
end;

//------------------------- Заполнение ячеек -----------------------------------

function TTimetableF.GetFieldsFromName(ARow, ACol: Integer): TStringList;

  procedure SetList(OStrList: TStringList; AQuery: TSQLQuery; ATabName: string;
    ATitle: string);
  var
    Title: string;
  begin
    if CB_Title.Checked then // Заголовок
      Title := ATitle + ': ';
    OStrList.Add(Title + AQuery.FieldByName(ATabName).AsString);
  end;

  function GetCheck(AStr: string): boolean;
  var
    I: integer;
  begin
    with CLB_Field do begin
      for I := 0 to Items.Count - 1 do
        if Items[I] = AStr then begin
          Result := Checked[I];
          exit;
        end;
    end;
    Result := False;
  end;

  procedure AutoWidth(AStrList: TStringList);
  var
    I: integer;
  begin
    with DG_Timetable do begin
      for I := 0 to AStrList.Count - 1 do
        DefaultColWidth := Max(DefaultColWidth,
          Canvas.TextWidth(AStrList[I]));
    end;
  end;

  procedure AutoHeight;
  var
    I: integer;
    C: integer = 0;
  begin
    for I := 0 to CLB_Field.Items.Count - 1 do
      if CLB_Field.Checked[I] then
        inc(C);
    DG_Timetable.DefaultRowHeight := C * DG_Timetable.Canvas.TextHeight('I');
  end;

var
  I, J: integer;
begin
  Result := TStringList.Create;

  if not QuertArr[ARow][ACol].Active then QuertArr[ARow][ACol].Open;

  QuertArr[ARow][ACol].First; // Нужно писать
  with TablesData.Tables[Tag], DG_Timetable do begin
    for J := 0 to QuertArr[ARow][ACol].RecordCount - 1 do begin
      for I := 0 to High(TabNameArr) do
        with TabNameArr[I] do begin
          if GetCheck(ColSecondName) then
            SetList(Result, QuertArr[ARow][ACol], ColFirstName,
              ColSecondName);
          if GetCheck(ColFToPColSName) then
            SetList(Result, QuertArr[ARow][ACol], ColFToPColFName,
              ColFToPColSName);
        end;
      QuertArr[ARow][ACol].Next;
      Result.Add('');
    end;
    if Result.Count > 0 then Result.Delete(Result.Count - 1);

    if CB_AutoCell2.Checked then
      AutoWidth(Result)
    else
      DefaultColWidth := TabCellWidth;

    if CB_AutoCell.Checked then
      AutoHeight
    else
      DefaultRowHeight := TabCellHeight;
  end;
end;

//------------------------- Заполнение заголовков ------------------------------

function TTimetableF.SetRowsColsArrays(AQuery: string): TStringList;
var
  I: integer;
begin
  RefreshQuery(AQuery, SQLQuery_Timetable);
  Result := TStringList.Create;

  with SQLQuery_Timetable do
    for I := 0 to RecordCount - 1 do begin
        Result.Add(Fields[0].AsString);
        Next;
    end;
end;

//------------------------- Прорисовка ячеек -----------------------------------

procedure TTimetableF.TextShow(ACanv: TCanvas; AItemStr: TStringList;
  X, Y: integer);
var
  I: integer;
begin
  with ACanv, AItemStr do
    for I := 0 to Count - 1 do
      TextOut(X, Y + I * TextHeight('I'), Strings[I]);
end;

procedure TTimetableF.DG_TimetableDrawCell(Sender: TObject; aCol, aRow: Integer;
  aRect: TRect; aState: TGridDrawState);
var
  XL, YT, XR, YB: Integer;
  CStrList: TStringList;
begin
  with aRect do begin
    XL := Left;
    YT := Top;
    XR := Right;
    YB := Bottom;
  end;

  DG_Timetable.FocusRectVisible := False;

  with DG_Timetable.Canvas do begin
    if
    (ACol = 0) and
    (ARow = 0) or
    (RowsName = nil) or
    (ColsName = nil) then exit;

    if ACol = 0 then begin
      TextOut(XL + 1, YT, RowsName[ARow - 1]);
      exit;
    end;

    if ARow = 0 then begin
      TextOut(XL + 1, YT, ColsName[ACol - 1]);
      exit;
    end;

    CStrList := GetFieldsFromName(ARow - 1, ACol - 1);

    if CStrList.Count > 0 then
      Brush.Color := clSkyBlue
    else
      Brush.Color := clWhite;

    FillRect(aRect);

    TextShow(DG_Timetable.Canvas, CStrList, XL, YT);

    if (aCol = DG_Timetable.Col) and
       (aRow = DG_Timetable.Row) then
      CanvaButt.ShowOnCanva(DG_Timetable.Canvas, XR, YT);

    CanvaButtStatic.ShowOnCanva(DG_Timetable.Canvas, XR, YB,
      QuertArr[aRow - 1][aCol - 1]);
  end;
end;

//------------------------- События --------------------------------------------

procedure TTimetableF.CellClick(Sender: TObject);
begin
  with DG_Timetable do begin
    DefaultColWidth := 1;
    DefaultRowHeight := 1;
    Repaint;
  end;
end;

procedure TTimetableF.ItemClick(Sender: TObject; Index: integer);
begin
  CellClick(Sender);
end;

//------------------------- Отображение Подсказки ------------------------------

function TTimetableF.TextCreate(AItemStr: TStringList;
  Strip: string = #10): string;
var
  I: integer;
begin
  Result := '';
  with AItemStr do
    for I := 0 to Count - 1 do
      Result += Strings[I] + Strip;

  Delete(Result, Length(Result) - Length(Strip) + 1, Length(Strip));
end;

procedure TTimetableF.DG_TimetableMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  ACol, ARow: Integer;
begin
  with DG_Timetable do begin
    MouseToCell(X, Y, ACol, ARow);
    if (RowsName = nil) or
       (ColsName = nil) or
       (ARow = 0) or
       (ACol = 0) then begin
      Hint := '';
      exit;
    end;

    Hint := TextCreate(GetFieldsFromName(ARow - 1, ACol - 1));
  end;
end;

//------------------------- Проверка на нажатость кнопки -----------------------

procedure TTimetableF.DG_TimetableMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  zRow, zCol: integer;
  StrListTab, StrListValue: TStringList;
begin
  DG_Timetable.MouseToCell(X, Y, zCol, zRow);
  if (RowsName = nil) or
     (ColsName = nil) or
     (zRow = 0) or
     (zCol = 0) then
    exit;

  StrListTab := TStringList.Create;
  StrListTab.Add(WorldSectionFrame1.GetRowsFirstN);
  StrListTab.Add(WorldSectionFrame1.GetColsFirstN);

  StrListValue := TStringList.Create;
  StrListValue.Add(RowsName[zRow - 1]);
  StrListValue.Add(ColsName[zCol - 1]);

  CanvaButt.EventsCheck(PopupMenu_Timetable, Point(X, Y),
    QuertArr[zRow - 1][zCol - 1], StrListTab, StrListValue);

  StrListTab.Free;
  StrListValue.Free;
  DG_Timetable.Repaint;
end;

//------------------------- Формирование списка полей --------------------------

procedure TTimetableF.SetCLBFields;

  procedure SetAddTrueChecked(AStr: string);
  begin
    with CLB_Field do begin
      Items.Add(AStr);
      Checked[Items.Count - 1] := True;
    end;
  end;

var
  I: integer;
begin
  with TablesData.Tables[Tag] do
    for I := 0 to High(TabNameArr) do
      with TabNameArr[I] do begin
        if ColVisible then
          SetAddTrueChecked(ColSecondName);
        if ColFToPColVisible then
          SetAddTrueChecked(ColFToPColSName);
      end;
end;

end.

