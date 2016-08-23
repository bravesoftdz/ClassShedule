program ClassSchedule;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, lazcontrols, Main, Connection, Metadata, Catalog, Editor,
  MiniFilterFrm, NameFrm, EditFrm, BoxFrm, FilterFrm;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(TClassShedule, ClassShedule);
  Application.CreateForm(TFireBird, FireBird);
  Application.Run;
end.

