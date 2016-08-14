unit UMetadata;

{$mode objfpc}{$H+}

interface

type

  TErrorsInf = record
    ErrFirstName: string;
    ErrSecondName: string;
    ErrColumns: array of string;
  end;

  TColumnInf = record
    ColFirstName: string;
    ColSecondName: string;
    ColWidth: integer;
    ColVisible: boolean;
    ColFToPTab: string;
    ColFToPCol: string;
    ColFToPColFName: string;
    ColFToPColSName: string;
    ColFToPColWidth: integer;
    ColFToPColVisible: boolean;
  end;

  TTableInf = record
    TabFirstName: string;
    TabSecondName: string;
    TabCellHeight: integer;
    TabCellWidth: integer;
    TabReadOnly: boolean;
    TabNameArr: array of TColumnInf;
    ErrNameArr: array of TErrorsInf;
  end;

  { TTableMC }

  TTableMC = class
    Tables: array of TTableInf;
    procedure AddCurTab(ATabFName, ATabSName: string; ATabCellHeigh,
      ATabCellWidth: integer; ATabReadOnly: boolean);
    procedure AddCurTabInf(AColFName, AColSName: string; AColWidth: integer;
      AColVisible: boolean; AColFToPTab: string = ''; AColFToPCol: string = '';
      AColFToPColFName: string = ''; AColFToPColSName: string = '';
      AColFToPColWidth: integer = 0;
      AColFToPVisible: boolean = False);

    procedure AddCurError(AErrFirstName, AErrSecondName: string);
    procedure AddCurErrorCol(AColFName: string);

    procedure AddCurQuery(ATabFName, ATabSName: string);
    procedure AddCurQueryInf(AColFName, AColSName: string; AColWidth: integer;
      AColVisible: boolean);
  end;

var
  TablesData: TTableMC;

implementation

//------------------------- Добавление метаданных ------------------------------

procedure TTableMC.AddCurTab(ATabFName, ATabSName: string; ATabCellHeigh,
  ATabCellWidth: integer; ATabReadOnly: boolean);
begin
  SetLength(Tables, Length(Tables) + 1);
  with Tables[High(Tables)] do begin
     TabFirstName := ATabFName;
     TabSecondName := ATabSName;
     TabCellHeight := ATabCellHeigh;
     TabCellWidth := ATabCellWidth;
     TabReadOnly := ATabReadOnly;
   end;
end;

procedure TTableMC.AddCurTabInf(AColFName, AColSName: string;
  AColWidth: integer; AColVisible: boolean; AColFToPTab: string = '';
  AColFToPCol: string = ''; AColFToPColFName: string = '';
  AColFToPColSName: string = ''; AColFToPColWidth: integer = 0;
  AColFToPVisible: boolean = False);
begin
  with Tables[High(Tables)] do begin
    SetLength(TabNameArr, Length(TabNameArr) + 1);
    with TabNameArr[High(TabNameArr)] do begin
      ColFirstName := AColFName;
      ColSecondName := AColSName;
      ColWidth := AColWidth;
      ColVisible := AColVisible;
      ColFToPTab := AColFToPTab;
      ColFToPCol := AColFToPCol;
      ColFToPColFName := AColFToPColFName;
      ColFToPColSName := AColFToPColSName;
      ColFToPColWidth := AColFToPColWidth;
      ColFToPColVisible := AColFToPVisible;
    end;
  end;
end;

procedure TTableMC.AddCurError(AErrFirstName, AErrSecondName: string);
begin
  with Tables[High(Tables)] do begin
    SetLength(ErrNameArr, Length(ErrNameArr) + 1);
    with ErrNameArr[High(ErrNameArr)] do begin
      ErrFirstName := AErrFirstName;
      ErrSecondName := AErrSecondName;
    end;
  end;
end;

procedure TTableMC.AddCurErrorCol(AColFName: string);
begin
  with Tables[High(Tables)] do
    with ErrNameArr[High(ErrNameArr)] do begin
      SetLength(ErrColumns, Length(ErrColumns) + 1);
      ErrColumns[High(ErrColumns)] := AColFName;
   end;
end;

procedure TTableMC.AddCurQuery(ATabFName, ATabSName: string);
begin
  AddCurTab(ATabFName, ATabSName, 0, 0, True);
end;

procedure TTableMC.AddCurQueryInf(AColFName, AColSName: string;
  AColWidth: integer; AColVisible: boolean);
begin
  AddCurTabInf(AColFName, AColSName, AColWidth, AColVisible);
end;

initialization

TablesData := TTableMC.Create;
  with TablesData do begin
    AddCurTab('EducActivities', 'Учебная деятельность', 150, 150, False);
    //AddCurTabInf('EducID', 'ID', 50, False);
    AddCurTabInf('EducName', 'Название', 100, True);

    AddCurTab('Administrators', 'Администраторы', 150, 150, False);
    //AddCurTabInf('AdminID', 'ID', 50, False);
    AddCurTabInf('AdminInitials', 'Администратор', 200, True);

    AddCurTab('Teachers', 'Преподаватели', 150, 150, False);
    //AddCurTabInf('TeacherID', 'ID', 50, False);
    AddCurTabInf('TeacherInitials', 'Преподаватель', 200, True);

    AddCurTab('Groups', 'Группы', 150, 150, False);
    //AddCurTabInf('GroupID', 'ID', 50, False);
    AddCurTabInf('GroupNumber', 'Группа', 50, True);
    AddCurTabInf('GroupName', 'Направление подготовки', 400, True);

    AddCurTab('Students', 'Студенты', 150, 150, False);
    //AddCurTabInf('StudentID', 'ID', 50, False);
    AddCurTabInf('StydentInitials', 'Студент', 200, True);
    AddCurTabInf('GroupID', 'ID', 50, False,
                 'Groups', 'GroupID', 'GroupNumber', 'Группа', 50, True);

    AddCurTab('Items', 'Предметы', 150, 150, False);
    //AddCurTabInf('ItemID', 'ID', 50, False);
    AddCurTabInf('ItemName', 'Предмет', 200, True);

    AddCurTab('Audiences', 'Аудитории', 150, 150, False);
    //AddCurTabInf('AudienceID', 'ID', 50, False);
    AddCurTabInf('AudienceNumber', 'Наименование', 200, True);

    AddCurTab('Pairs', 'Время пар', 150, 150, False);
    //AddCurTabInf('PairID', 'ID', 50, False);
    AddCurTabInf('PairBegin', 'Начало п.', 100, True);
    AddCurTabInf('PairEnd', 'Конец п.', 100, True);
    AddCurTabInf('PairNumber', '№', 50, True);

    AddCurTab('Administrators_Groups', 'Администраторы групп', 150, 150, False);
    AddCurTabInf('AdminID', 'ID', 50, False,
                 'Administrators', 'AdminID', 'AdminInitials', 'Администратор', 200, True);
    AddCurTabInf('GroupID', 'ID', 50, False,
                 'Groups', 'GroupID', 'GroupNumber', 'Группа', 50, True);

    AddCurTab('WeekDays', 'Дни недели', 150, 150, False);
    //AddCurTabInf('WeekDayID', 'ID', 50, False);
    AddCurTabInf('WeekDayName', 'День недели', 100, True);
    AddCurTabInf('WeekDayNumber', '№', 50, True);

    AddCurTab('Schedules', 'Расписание', 150, 150, False);
    AddCurTabInf('GroupID', 'ID', 50, False,
                 'Groups', 'GroupID', 'GroupNumber', 'Группа', 50, True);
    AddCurTabInf('WeekDayID', 'ID', 50, False,
                 'WeekDays', 'WeekDayID', 'WeekDayName', 'День недели', 100, True);
    AddCurTabInf('PairID', 'ID', 50, False,
                 'Pairs', 'PairID', 'PairNumber', '№ пары', 50, True);
    AddCurTabInf('ItemID', 'ID', 50, False,
                 'Items', 'ItemID', 'ItemName', 'Предмет', 200, True);
    AddCurTabInf('EducID', 'ID', 50, False,
                 'EducActivities', 'EducID', 'EducName', 'Учебная деятельность', 100, True);
    AddCurTabInf('TeacherID', 'ID', 50, False,
                 'Teachers', 'TeacherID', 'TeacherInitials', 'Преподаватель', 200, True);
    AddCurTabInf('AudienceID', 'ID', 50, False,
                 'Audiences', 'AudienceID', 'AudienceNumber', 'Аудитория', 200, True);
    AddCurError('Error_GWP', 'Студенты одной группы не могут присутствовать одновременно на нескольких парах');
    AddCurErrorCol('GroupNumber');
    AddCurErrorCol('WeekDayName');
    AddCurErrorCol('PairNumber');

    AddCurError('Error_TWP', 'Преподаватели не могут присутствовать одновременно на нескольких парах');
    AddCurErrorCol('TeacherInitials');
    AddCurErrorCol('WeekDayName');
    AddCurErrorCol('PairNumber');

    AddCurQuery('GroupCount', 'Информация о группе');
    AddCurQueryInf('GroupNumber', 'Группа', 50, True);
    AddCurQueryInf('GroupName', 'Направление подготовки', 300, True);
    AddCurQueryInf('CountSTD', 'Количество студентов', 150, True);
    AddCurQueryInf('CountADM', 'Количество администраторов', 200, True);
    AddCurQueryInf('CountPAIR', 'Количество пар', 150, True);

    AddCurQuery('TeacherCount', 'Загруженность преподавателя');
    AddCurQueryInf('TeacherInitials', 'Преподаватель', 200, True);
    AddCurQueryInf('CountPair', 'Количество пар в неделю', 200, True);
  end;

end.

