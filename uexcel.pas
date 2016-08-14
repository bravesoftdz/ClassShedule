unit UExcel;

{$mode objfpc}{$H+}

interface

uses
  ComObj, ActiveX, Windows, Messages, SysUtils, Classes, Dialogs;

var
  MyExcel: OleVariant;

const
  ExcelApp = 'Excel.Application';

function CheckExcelInstall: boolean;
function CheckExcelRun: boolean;
function RunExcel(Alerts: boolean = False; Visible: boolean = False): boolean;
function AddWorkBook(AutoRun: boolean = True): boolean;
function OpenWorkBook(FileName: TFileName): boolean;
function GetAllWorkBooks: TStringList;
function SaveWorkBook(FileName: TFileName; WBIndex, Exp: integer): boolean;
function StopExcel: boolean;

implementation

function CheckExcelInstall: boolean;
var
  ClassID: TCLSID;
begin
  Result := CLSIDFromProgID(ExcelApp, ClassID) = S_OK;
end;

function CheckExcelRun: boolean;
begin
  try
    MyExcel := GetActiveOleObject(ExcelApp);
    Result := True;
  except
    Result := False;
  end;
end;

function RunExcel(Alerts: boolean = False; Visible: boolean = False): boolean;
begin
  try
    if CheckExcelInstall then begin
      MyExcel := CreateOleObject(ExcelApp);
      MyExcel.Application.DisplayAlerts := Alerts;
      MyExcel.Application.EnableEvents := Alerts;
      MyExcel.Visible := Visible;
      Result := True;
    end
    else begin
      MessageDlg('Приложение MS Excel не установлено на этом компьютере',
        mtError, [mbOK], 0);
      Result := False;
    end;
  except
    Result := False;
  end;
end;

function AddWorkBook(AutoRun: boolean = True): boolean;
begin
  if CheckExcelRun then begin
    MyExcel.WorkBooks.Add;
    Result := True;
  end
  else
  if AutoRun then begin
    RunExcel;
    MyExcel.WorkBooks.Add;
    Result := True;
  end
  else
    Result := False;
end;

function OpenWorkBook(FileName: TFileName): boolean;
begin
  try
    MyExcel.WorkBooks.Open(WideString(FileName));
    Result := True;
  except
    Result := False;
  end;
end;

function GetAllWorkBooks: TStringList;
var
  I: integer;
begin
  try
    Result := TStringList.Create;
    for I := 1 to MyExcel.WorkBooks.Count do
      Result.Add(MyExcel.WorkBooks.Item[i].FullName)
  except
    MessageDlg('Ошибка перечисления открытых книг', mtError, [mbOK], 0);
  end;
end;

function SaveWorkBook(FileName: TFileName; WBIndex, Exp: integer): boolean;
begin
  try
    MyExcel.WorkBooks.Item[WBIndex].SaveAs(WideString(FileName), Exp);
    Result := MyExcel.WorkBooks.Item[WBIndex].Save;
  except
    Result := False;
  end;
end;

function StopExcel: boolean;
begin
  try
    if MyExcel.Visible then
      MyExcel.Visible := False;
    MyExcel.Quit;
    MyExcel := Unassigned;
    Result := True;
  except
    Result := False;
  end;
end;

end.
