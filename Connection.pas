unit Connection;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, IBConnection, sqldb, FileUtil;

type
  TFireBird = class(TDataModule)
    IBConnect: TIBConnection;
    SQLTransact: TSQLTransaction;
  end;

var
  FireBird: TFireBird;

implementation

{$R *.lfm}

end.

