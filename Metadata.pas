unit Metadata;

{$mode objfpc}{$H+}

interface

type
  TColumns = record
    DataField: string;
    CaptionField: string;
    ListField: string;
    KeyTable: string;
    KeyField: string;
    Primary: boolean;
  end;

  TTable = record
    NameTable: string;
    CaptionTable: string;
    Columns: array of TColumns;
  end;

  DBMetadata = class
  public
    Tables: array of TTable;
  private
    procedure AddTable(aNameTable, aCaptionTable: string);
    procedure AddColumn(aDataField, aCaptionField: string);
    procedure AddKey(aDataField, aCaptionField, aListField, aKeyTable,
      aKeyField: string);
  end;

var
  Mdata: DBMetadata;

implementation

procedure DBMetadata.AddTable(aNameTable, aCaptionTable: string);
begin
  SetLength(Tables, Length(Tables) + 1);
  with Tables[High(Tables)] do begin
    NameTable := aNameTable;
    CaptionTable := aCaptionTable;
  end;
end;

procedure DBMetadata.AddColumn(aDataField, aCaptionField: string);
begin
  with Tables[High(Tables)] do begin
    SetLength(Columns, Length(Columns) + 1);
    with Columns[High(Columns)] do begin
      DataField := aDataField;
      CaptionField := aCaptionField;
      Primary := false;
    end;
  end;
end;

procedure DBMetadata.AddKey(aDataField, aCaptionField, aListField, aKeyTable,
  aKeyField: string);
begin
  with Tables[High(Tables)] do begin
    SetLength(Columns, Length(Columns) + 1);
    with Columns[High(Columns)] do begin
      DataField := aDataField;
      CaptionField := aCaptionField;
      ListField := aListField;
      KeyTable := aKeyTable;
      KeyField := aKeyField;
      Primary := true;
    end;
  end;
end;

initialization

Mdata := DBMetadata.Create;
  with Mdata do begin
    AddTable('ACTIVITIES', 'Учебная деятельность');
    AddColumn('EDUCNAME', 'Название');

    AddTable('ADMINS', 'Администраторы');
    AddColumn('ADMININITIALS', 'Администратор');

    AddTable('TEACHERS', 'Преподаватели');
    AddColumn('TEACHERINITIALS', 'Преподаватель');

    AddTable('GROUPS', 'Группы');
    AddColumn('GROUPNUMBER', 'Группа');
    AddColumn('GROUPNAME', 'Направление подготовки');

    AddTable('STUDENTS', 'Студенты');
    AddKey('GROUPID', 'Группа', 'GROUPNUMBER', 'GROUPS', 'GROUPID');
    AddColumn('STYDENTINITIALS', 'Студент');

    AddTable('ITEMS', 'Предметы');
    AddColumn('ITEMNAME', 'Предмет');

    AddTable('AUDIENCES', 'Аудитории');
    AddColumn('AUDIENCENUMBER', 'Наименование');

    AddTable('ADMINSGP', 'Администраторы групп');
    AddKey('ADMINID', 'Администратор', 'ADMININITIALS', 'ADMINS', 'ADMINID');
    AddKey('GROUPID', 'Группа', 'GROUPNUMBER', 'GROUPS', 'GROUPID');

    AddTable('PAIRS', 'Время пар');
    AddColumn('PAIRBEGIN', 'Начало п.');
    AddColumn('PAIREND', 'Конец п.');
    AddColumn('PAIRNUMBER', '№');

    AddTable('WEEKDAYS', 'Дни недели');
    AddColumn('WEEKDAYNAME', 'День недели');
    AddColumn('WEEKDAYNUMBER', '№');

    AddTable('SCHEDULES', 'Расписание');
    AddKey('GROUPID', 'Группа', 'GROUPNUMBER', 'GROUPS', 'GROUPID');
    AddKey('WEEKDAYID', 'День недели', 'WEEKDAYNAME', 'WEEKDAYS', 'WEEKDAYID');
    AddKey('PAIRID', '№ пары', 'PAIRNUMBER', 'PAIRS', 'PAIRID');
    AddKey('ITEMID', 'Предмет', 'ITEMNAME', 'ITEMS', 'ITEMID');
    AddKey('EDUCID', 'Учебная деятельность', 'EDUCNAME', 'ACTIVITIES', 'EDUCID');
    AddKey('TEACHERID', 'Преподаватель', 'TEACHERINITIALS', 'TEACHERS', 'TEACHERID');
    AddKey('AUDIENCEID', 'Аудитория', 'AUDIENCENUMBER', 'AUDIENCES', 'AUDIENCEID');
  end;

 end.
