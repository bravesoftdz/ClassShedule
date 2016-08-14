unit UDataModule;

{$mode objfpc}{$H+}

interface

uses
  Classes, IBConnection, sqldb, odbcconn;

type

  { TScheduleDM }

  TScheduleDM = class(TDataModule)
    IBConnection_Main: TIBConnection;
    SQLTransaction_Main: TSQLTransaction;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  ScheduleDM: TScheduleDM;

implementation

{$R *.lfm}

{ TScheduleDM }

procedure TScheduleDM.DataModuleCreate(Sender: TObject);
begin
  IBConnection_Main.Connected := True;
  SQLTransaction_Main.Active := True;
end;

procedure TScheduleDM.DataModuleDestroy(Sender: TObject);
begin
  SQLTransaction_Main.Active := False;
  IBConnection_Main.Connected := False;
end;

end.

