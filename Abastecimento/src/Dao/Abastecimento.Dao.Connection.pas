unit Abastecimento.Dao.Connection;

interface

uses
//  Data.DBXFirebird,
  Data.FMTBcd,
  Data.DB,
  Data.SqlExpr,
  System.SysUtils,
  FireDAC.Comp.Client,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param,
  FireDAC.Stan.Error,
  FireDAC.DatS,
  FireDAC.Stan.Async,
  FireDAC.DApt,
  FireDAC.Comp.DataSet,
  FireDAC.Stan.Def,
  FireDAC.UI.Intf,
  FireDAC.Phys.Intf,
  FireDAC.Stan.Pool,
  FireDAC.Phys,
  FireDAC.Phys.FB,
  FireDAC.Phys.FBDef,
  FireDAC.VCLUI.Wait;

type
  iConnection = interface
    function GetConnection: TFDConnection;
  end;

  TConnection = class(TInterfacedObject, iConnection)
  strict private

  private
    class var FCon: TFDConnection;
    function GetConnection: TFDConnection;
	  class function GetDBConfig: string;
  public
    destructor Destroy;override;
    class function New: iConnection;
  end;

var
  _Connection : iConnection;

implementation

uses
  IniFiles,
  Vcl.Forms;

{ TConexao }

class function TConnection.GetDBConfig: string;
begin
  Result :=
	  IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName))+'Config.Txt';
end;

destructor TConnection.Destroy;
begin
  FCon.Free;
  inherited;
end;

function TConnection.GetConnection: TFDConnection;
begin
  if Assigned(FCon) then
    Result := FCon;
end;

class function TConnection.New: iConnection;
var
  LIniFile: TIniFile;
  LDBName, LCaminho: string;
begin
  FCon := TFDConnection.Create(nil);
  try
    FCon.Params.DriverID := 'FB';
    FCon.Params.UserName := 'SYSDBA';
    FCon.Params.Password := 'masterkey';

    if FileExists(GetDBConfig) then
	  begin
      LIniFile := TIniFile.Create(
        IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)) + 'Config.Txt');
      try
        LDBName  := LIniFile.ReadString('BANCO', 'NOME', '');
        LCaminho := LIniFile.ReadString('BANCO', 'CAMINHO', '');
      finally
        LIniFile.Free;
      end;
  	end;

    // Only to Test
    if LCaminho = '' then
      LCaminho := 'C:\Labs\Data\ABASTECIMENTO.FDB';

    FCon.Params.Database := LCaminho;
    FCon.Connected := true;

  except
    on e: Exception do
    begin
      raise Exception.Create('Não foi possível criar uma conexão com o Firebird.');
    end;
  end;

  Result := self.Create;

end;

initialization
  _Connection := TConnection.New;

end.
