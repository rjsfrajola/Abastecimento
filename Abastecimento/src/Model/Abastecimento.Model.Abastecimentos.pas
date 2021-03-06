unit Abastecimento.Model.Abastecimentos;

interface

uses
  Abastecimento.Dao.Atributo,
  Abastecimento.Dao.PersistentObject,
  Abastecimento.Dao.Connection,
  FireDAC.Comp.Client,
  System.SysUtils;

type
  [TableName('ABASTECIMENTOS')]
  TAbastecimento = class(TPersistentObject)
  private
    FA5_A2_ID: integer;
    FA5_VALOR: double;
    FA5_ID: integer;
    FA5_LIQUIDO: double;
    FA5_QTDE: double;
    FA5_IMPOSTO: double;
    FA5_DATA: TDate;
    FCon: TFDConnection;
    FQuery: TFDQuery;
  public
    [FieldName('A5_ID')]
    [PrimaryKey('A5_ID')]
    property Codigo:integer read FA5_ID write FA5_ID;

    [FieldName('A5_DATA')]
    property Data:TDate read FA5_DATA write FA5_DATA;

    [FieldName('A5_A2_ID')]
    property Bomba:integer read FA5_A2_ID write FA5_A2_ID;

    [FieldName('A5_QTDE')]
    property Qtde:double read FA5_QTDE write FA5_QTDE;

    [FieldName('A5_VALOR')]
    property Valor:double read FA5_VALOR write FA5_VALOR;

    [FieldName('A5_IMPOSTO')]
    property Imposto:double read FA5_IMPOSTO write FA5_IMPOSTO;

    [FieldName('A5_LIQUIDO')]
    property Liquido:double read FA5_LIQUIDO write FA5_LIQUIDO;

    function BuscarPreco(aCombustivel: integer): double;

    constructor Create;
    destructor Destroy;override;

  end;

implementation

{ TAbastecimento }

function TAbastecimento.BuscarPreco(aCombustivel: integer): double;
var
  LSelect: TStringBuilder;

begin
  Result := 0;

  LSelect := TStringBuilder.Create;
  try
    LSelect.Append(' SELECT');
    LSelect.Append('   A1_PRECO ');
    LSelect.Append(' FROM');
    LSelect.Append('   COMBUSTIVEL');
    LSelect.Append('  WHERE A1_ID = ' + aCombustivel.ToString);

    FQuery.Open(LSelect.ToString);
    Result := FQuery.FieldByName('A1_PRECO').AsFloat;

  finally
    LSelect.Clear;
    FreeAndNil(LSelect);
  end;

end;

constructor TAbastecimento.Create;
begin
  inherited Create;

  if not (Assigned(FCon)) then
    FCon := _Connection.GetConnection;

  FQuery := TFDQuery.Create(nil);
  FQuery.Connection := FCon;

end;

destructor TAbastecimento.Destroy;
begin
  FQuery.Close;
  FQuery.Free;
  inherited;
end;

end.

