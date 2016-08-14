unit UScheduleForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, sqldb, Forms, Controls, Dialogs, Menus, ExtCtrls, UMetadata,
  UDirectoryForm, UTimetableForm, UAboutForm;

type

  { TObjMenuItem }

  TObjMenuItem = class (TMenuItem)
    ModalWinControl: TWinControl;
    procedure Menu_Click(Sender: TObject);
    constructor CreateMenu(TheOwner: TComponent);
  end;

  { TScheduleF }

  TScheduleF = class(TForm)
    Main_Menu: TMainMenu;
    Menu_Timetable: TMenuItem;
    Menu_Directory: TMenuItem;
    Menu_Exit: TMenuItem;
    Menu_About: TMenuItem;
    Menu_File: TMenuItem;
    Menu_Help: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure Menu_AboutClick(Sender: TObject);
    procedure Menu_ExitClick(Sender: TObject);
    procedure Menu_TimetableClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  ScheduleF: TScheduleF;

implementation

{$R *.lfm}

{ TObjMenuItem }

procedure TObjMenuItem.Menu_Click(Sender: TObject);
begin
  if Checked = False then begin
    ModalWinControl := TDirectoryF.CreateAndShow(Self);
    Checked := True;
  end
  else
    ModalWinControl.SetFocus;
end;

constructor TObjMenuItem.CreateMenu(TheOwner: TComponent);
begin
  Tag := TheOwner.Tag; //Соглашение Tag меняем пред inherited
  inherited Create(TheOwner);
  Caption := TablesData.Tables[Tag].TabSecondName;
  OnClick := @Menu_Click;
end;

{ TScheduleF }

procedure TScheduleF.Menu_ExitClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TScheduleF.Menu_TimetableClick(Sender: TObject);
begin
  TTimetableF.CreateOnly(Self).ShowModal;
end;

procedure TScheduleF.Menu_AboutClick(Sender: TObject);
begin
  About.ShowModal;
end;

procedure TScheduleF.FormCreate(Sender: TObject);
var
  I: integer;
begin
  for I := 0 to High(TablesData.Tables) do begin
    Tag := I;
    Menu_Directory.Add(TObjMenuItem.CreateMenu(Self));
  end;
end;

end.

