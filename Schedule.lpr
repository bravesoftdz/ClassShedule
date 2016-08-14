program Schedule;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, UScheduleForm, UDirectoryForm, UDataModule, UPropertyForm, UMetadata,
  UEdits, UMiniFilterFrame, UBigFilterFrame, 
UTimetableForm, USQLCompatible, UMiniSortingFrame, UBasicFrame, 
  UExtendedFilterFrame, UGlobalFiltersFrame,
  UGlobalRowColFrame, UWorldSectionFrame, UButtons, UConflictForm, 
UPropConflictsForm, UExcel, UExcelConst, UAboutForm, UButtonsStatic;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TScheduleF, ScheduleF);
  Application.CreateForm(TScheduleDM, ScheduleDM);
  Application.CreateForm(TAbout, About);
  Application.Run;
end.

