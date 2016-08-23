unit Connection;

{$mode objfpc}{$H+}

interface

uses
  Classes, IBConnection, sqldb;

type
  TFireBird = class(TDataModule)
  published
    IBConnect: TIBConnection;
    SQLTransact: TSQLTransaction;
  end;

var
  FireBird: TFireBird;

implementation

{$R *.lfm}

end.

