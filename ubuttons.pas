unit UButtons;

{$mode objfpc}{$H+}

interface

uses
  Graphics, Windows, Classes, sqldb, UDirectoryForm, Menus, Forms, Controls, sysutils, UMetadata;

type

  { TButtProp }

  TButtProp = class
    Left: integer;
    Top: integer;
    Ico: TIcon;
    Query: TSQLQuery;
    constructor Create; virtual; abstract;
    procedure OnClick(Pop: TPopupMenu; SqlQuery: TSQLQuery; StrListT, StrListV: TStringList);
      virtual; abstract;
    procedure AfterCreate(AGlyph: string);
    procedure MenuClick(Sender: TObject);
  end;

  CTButtProp = class of TButtProp;

  { TButtAdd }

  TButtAdd = class(TButtProp)
    constructor Create; override;
    procedure OnClick(Pop: TPopupMenu; SqlQuery: TSQLQuery;
      StrListT, StrListV: TStringList);
      override;
  end;

  { TButtDel }

  TButtDel = class(TButtProp)
    constructor Create; override;
    procedure OnClick(Pop: TPopupMenu; SqlQuery: TSQLQuery;
      StrListT, StrListV: TStringList);
      override;
  end;

  { TButtEdit }

  TButtEdit = class(TButtProp)
    constructor Create; override;
    procedure OnClick(Pop: TPopupMenu; SqlQuery: TSQLQuery;
      StrListT, StrListV: TStringList);
      override;
  end;

  { TButtons }

  TButtons = class
    Arr: array of TButtProp;
    procedure Add(But: CTButtProp);
    procedure ShowOnCanva(aCanva: TCanvas; aRight, aBottom: integer);
    procedure EventsCheck(aPop: TPopupMenu; aPoint: TPoint; aQuery: TSQLQuery;
      StrListT, StrListV: TStringList);
  end;

var
  CanvaButt: TButtons;

implementation

{ TButtProp }

procedure TButtProp.AfterCreate(AGlyph: string);
begin
  Ico := TIcon.Create;
  Ico.LoadFromFile(AGlyph);
end;

procedure TButtProp.MenuClick(Sender: TObject);
var
  I: integer;
begin
  Query.First;
  for I := 1 to TMenuItem(Sender).Tag do
    Query.Next;
  TDirectoryF.CreateNoQuery(Query).SB_DelClick(Query);
end;

{ TButtEdit }

constructor TButtEdit.Create;
begin
  AfterCreate('Icons\Edit.ico');
end;

procedure TButtEdit.OnClick(Pop: TPopupMenu; SqlQuery: TSQLQuery;
  StrListT, StrListV: TStringList);
begin
  TDirectoryF.CreateNoQuery(SqlQuery).ShowModal;
end;

{ TButtDel }

constructor TButtDel.Create;
begin
  AfterCreate('Icons\Del.ico');
end;

procedure TButtDel.OnClick(Pop: TPopupMenu; SqlQuery: TSQLQuery;
  StrListT, StrListV: TStringList);

  function GetQueryText: string;
  var
    I: integer;
  begin
    Result := '';

    with TablesData.Tables[SqlQuery.Tag] do
      for I := 0 to High(TabNameArr) do
        with TabNameArr[I] do begin
          if ColVisible then
            Result += SqlQuery.FieldByName(ColFirstName).AsString + ' ';
          if ColFToPColVisible then
            Result += SqlQuery.FieldByName(ColFToPColFName).AsString + ' ';
        end;

    Delete(Result, Length(Result), 1);
  end;

var
  I: integer;
begin
  if SqlQuery.RecordCount > 1 then begin
    Query := SqlQuery;
    Pop.Items.Clear;
    SqlQuery.First;
    for I := 0 to SqlQuery.RecordCount - 1 do begin
      with Pop do begin
        Items.Add(TMenuItem.Create(Pop));
        with Items[I] do begin
          Tag := I;
          Caption := GetQueryText;
          OnClick := @MenuClick;
        end;
        SqlQuery.Next;
      end;
    end;
    Pop.PopUp;
  end
  else
    TDirectoryF.CreateNoQuery(SqlQuery).SB_DelClick(SqlQuery);
end;

{ TButtAdd }

constructor TButtAdd.Create;
begin
  AfterCreate('Icons\Add.ico');
end;

procedure TButtAdd.OnClick(Pop: TPopupMenu; SqlQuery: TSQLQuery;
  StrListT, StrListV: TStringList);
begin
  TDirectoryF.CreateTVAdd(SqlQuery, StrListT, StrListV);
end;

{ TButtons }

procedure TButtons.Add(But: CTButtProp);
begin
  SetLength(Arr, Length(Arr) + 1);
  Arr[High(Arr)] := But.Create;
end;

procedure TButtons.ShowOnCanva(aCanva: TCanvas; aRight, aBottom: integer);
var
  RightCL, I: integer;
begin
  RightCL := aRight;
  for I := 0 to High(Arr) do
    with Arr[I] do
      RightCL -= Ico.Width;

  for I := 0 to High(Arr) do begin
    with Arr[I] do begin
    Left := RightCL - 1;
    Top := aBottom - 1;
    aCanva.Draw(Left, Top, Ico);
    RightCL += Ico.Width;
    end;
  end;
end;

procedure TButtons.EventsCheck(aPop: TPopupMenu; aPoint: TPoint;
  aQuery: TSQLQuery; StrListT: TStringList; StrListV: TStringList);
var
  I: integer;
begin
  for I := 0 to High(Arr) do
    with Arr[I] do
      if PtInRect(
           Rect(Left, Top, Left + Ico.Width, Top + Ico.Height), aPoint) then
      begin
        Arr[I].OnClick(aPop, aQuery, StrListT, StrListV);
        exit;
      end;
end;

initialization

  CanvaButt := TButtons.Create;
  with CanvaButt do begin
    Add(TButtAdd);
    Add(TButtDel);
    Add(TButtEdit);
  end;

end.

