unit UButtonsStatic;

{$mode objfpc}{$H+}

interface

uses
  Graphics, Windows, Classes, sqldb, UDirectoryForm, Menus, Forms, Controls, sysutils, UMetadata;

type

  { TButtPropStatic }

  TButtPropStat = class
    Left: integer;
    Top: integer;
    Ico: TIcon;
    Query: TSQLQuery;
    constructor Create; virtual; abstract;
    procedure OnClick(SqlQuery: TSQLQuery); virtual; abstract;
    function Checker(SqlQuery: TSQLQuery): boolean; virtual; abstract;
    procedure AfterCreate(AGlyph: string);
  end;

  CTButtPropStat = class of TButtPropStat;

  { TButtError }

  TButtError = class(TButtPropStat)
    constructor Create; override;
    function Checker(SqlQuery: TSQLQuery): boolean; override;
  end;

  TButtNum1 = class(TButtPropStat)
    constructor Create; override;
    function Checker(SqlQuery: TSQLQuery): boolean; override;
  end;

  TButtNum2 = class(TButtPropStat)
    constructor Create; override;
    function Checker(SqlQuery: TSQLQuery): boolean; override;
  end;

  TButtNum3 = class(TButtPropStat)
    constructor Create; override;
    function Checker(SqlQuery: TSQLQuery): boolean; override;
  end;

  TButtNum4 = class(TButtPropStat)
    constructor Create; override;
    function Checker(SqlQuery: TSQLQuery): boolean; override;
  end;

  TButtNum5 = class(TButtPropStat)
    constructor Create; override;
    function Checker(SqlQuery: TSQLQuery): boolean; override;
  end;

  TButtNum6 = class(TButtPropStat)
    constructor Create; override;
    function Checker(SqlQuery: TSQLQuery): boolean; override;
  end;

  TButtNum7 = class(TButtPropStat)
    constructor Create; override;
    function Checker(SqlQuery: TSQLQuery): boolean; override;
  end;

  TButtNum8 = class(TButtPropStat)
    constructor Create; override;
    function Checker(SqlQuery: TSQLQuery): boolean; override;
  end;

  TButtNum9 = class(TButtPropStat)
    constructor Create; override;
    function Checker(SqlQuery: TSQLQuery): boolean; override;
  end;

  TButtNumMax = class(TButtPropStat)
    constructor Create; override;
    function Checker(SqlQuery: TSQLQuery): boolean; override;
  end;

  { TButtonsStatic }

  TButtonsStat = class
    Arr: array of TButtPropStat;
    procedure Add(But: CTButtPropStat);
    procedure ShowOnCanva(aCanva: TCanvas; aRight, aBottom: integer; aSqlQuery: TSQLQuery);
    procedure EventsCheck(aPoint: TPoint; aQuery: TSQLQuery);
  end;

var
  CanvaButtStatic: TButtonsStat;

implementation

{ TButtPropStatic }

procedure TButtPropStat.AfterCreate(AGlyph: string);
begin
  Ico := TIcon.Create;
  Ico.LoadFromFile(AGlyph);
end;

constructor TButtError.Create;
begin
  AfterCreate('Icons\Error.ico');
end;

function TButtError.Checker(SqlQuery: TSQLQuery): boolean;
var
  I, J, L: integer;
begin
  with TablesData.Tables[SqlQuery.Tag] do
    for I := 0 to High(ErrNameArr) do
      with ErrNameArr[I] do begin
        SqlQuery.First;
        for J := 1 to SqlQuery.RecordCount do begin
          if SqlQuery.FieldByName(ErrFirstName).AsInteger > 0 then begin
            Result := True;
            Exit;
          end;
          SqlQuery.Next;
        end;
      end;
  Result := False;
end;

constructor TButtNum1.Create;
begin
  AfterCreate('Icons\Number1.ico');
end;

function TButtNum1.Checker(SqlQuery: TSQLQuery): boolean;
begin
  Result := SqlQuery.RecordCount = 1;
end;


constructor TButtNum2.Create;
begin
  AfterCreate('Icons\Number2.ico');
end;

function TButtNum2.Checker(SqlQuery: TSQLQuery): boolean;
begin
  Result := SqlQuery.RecordCount = 2;
end;


constructor TButtNum3.Create;
begin
  AfterCreate('Icons\Number3.ico');
end;

function TButtNum3.Checker(SqlQuery: TSQLQuery): boolean;
begin
  Result := SqlQuery.RecordCount = 3;
end;


constructor TButtNum4.Create;
begin
  AfterCreate('Icons\Number4.ico');
end;

function TButtNum4.Checker(SqlQuery: TSQLQuery): boolean;
begin
  Result := SqlQuery.RecordCount = 4;
end;


constructor TButtNum5.Create;
begin
  AfterCreate('Icons\Number5.ico');
end;

function TButtNum5.Checker(SqlQuery: TSQLQuery): boolean;
begin
  Result := SqlQuery.RecordCount = 5;
end;


constructor TButtNum6.Create;
begin
  AfterCreate('Icons\Number6.ico');
end;

function TButtNum6.Checker(SqlQuery: TSQLQuery): boolean;
begin
  Result := SqlQuery.RecordCount = 6;
end;


constructor TButtNum7.Create;
begin
  AfterCreate('Icons\Number7.ico');
end;

function TButtNum7.Checker(SqlQuery: TSQLQuery): boolean;
begin
  Result := SqlQuery.RecordCount = 7;
end;


constructor TButtNum8.Create;
begin
  AfterCreate('Icons\Number8.ico');
end;

function TButtNum8.Checker(SqlQuery: TSQLQuery): boolean;
begin
  Result := SqlQuery.RecordCount = 8;
end;


constructor TButtNum9.Create;
begin
  AfterCreate('Icons\Number9.ico');
end;

function TButtNum9.Checker(SqlQuery: TSQLQuery): boolean;
begin
  Result := SqlQuery.RecordCount = 9;
end;


constructor TButtNumMax.Create;
begin
  AfterCreate('Icons\NumberMax.ico');
end;

function TButtNumMax.Checker(SqlQuery: TSQLQuery): boolean;
begin
  Result := SqlQuery.RecordCount > 9;
end;


procedure TButtonsStat.Add(But: CTButtPropStat);
begin
  SetLength(Arr, Length(Arr) + 1);
  Arr[High(Arr)] := But.Create;
end;

procedure TButtonsStat.ShowOnCanva(aCanva: TCanvas; aRight, aBottom: integer;
  aSqlQuery: TSQLQuery);
var
  RightCL: Integer;

var
  I: integer;
  A: array of integer;
begin
  RightCL := aRight;
  for I := 0 to High(Arr) do
    with Arr[I] do
      if Checker(aSqlQuery) then begin
        SetLength(A, Length(A) + 1);
        A[High(A)] := I;
        RightCL -= Ico.Width;
      end;

  for I := 0 to High(A) do begin
    with Arr[A[I]] do begin
    Left := RightCL - 1;
    Top := aBottom - Ico.Height - 1;
    aCanva.Draw(Left, Top, Ico);
    RightCL += Ico.Width;
    end;
  end;
end;

procedure TButtonsStat.EventsCheck(aPoint: TPoint; aQuery: TSQLQuery);
var
  I: integer;
begin
  for I := 0 to High(Arr) do
    with Arr[I] do
      if PtInRect(
           Rect(Left, Top, Left + Ico.Width, Top + Ico.Height), aPoint) then
      begin
        Arr[I].OnClick(aQuery);
        exit;
      end;
end;

initialization

  CanvaButtStatic := TButtonsStat.Create;
  with CanvaButtStatic do begin
    Add(TButtError);
    //Add(TButtNum1);
    Add(TButtNum2);
    Add(TButtNum3);
    Add(TButtNum4);
    Add(TButtNum5);
    Add(TButtNum6);
    Add(TButtNum7);
    Add(TButtNum8);
    Add(TButtNum9);
    Add(TButtNumMax);
  end;

end.

