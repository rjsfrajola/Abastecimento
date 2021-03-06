unit Abastecimento.Dao.PersistentObject;

interface

uses
  Abastecimento.Dao.Atributo,
  Abastecimento.Dao.Connection,
  RTTI,
  System.SysUtils,
  Data.DBXCommon,
  Vcl.Dialogs,
  System.Variants,
  FireDAC.Stan.Error,
  Vcl.Forms,
  Winapi.Windows,
  FireDAC.Comp.Client,
  Data.DB;

type
  TPersistentObject = class
  private
    FCon: TFDConnection;
    FQuery: TFDQuery;
    function ValidarDados(LRtp: TRttiProperty): Boolean;
    function FormatarValores(LRtp: TRttiProperty): string;
  public
    constructor Create;
    destructor Destroy; override;
    function Insert: boolean;
    function Update: boolean;
    function Delete: boolean;
    procedure Open(aDataSource: TDataSource);
  end;

implementation

{ TPersistentObject }

destructor TPersistentObject.Destroy;
begin
  if Assigned(FQuery) then
  begin
    FQuery.Close;
    FQuery.Free;
  end;
  inherited;
end;

constructor TPersistentObject.Create;
begin
  if not (Assigned(FCon)) then
    FCon := _Connection.GetConnection;

  if not (Assigned(FQuery)) then
  begin
    FQuery := TFDQuery.Create(nil);
    FQuery.Connection := FCon;
  end;
end;

function TPersistentObject.Delete: boolean;
var
  LCtx: TRttiContext;  { Necessário para extrair contexto de um tipo }
  LRtt: TRttiType;     { }
  LRtp: TRttiProperty; { Para mapear Propriedade por Propriedade }
  LAtt: TCustomAttribute; { Para extrair o valor de cada Atributo encontrado }
  LStrSql, LStrWhere: string; { Para montar as instruções SQL }
begin
  FCon := _Connection.GetConnection;

  FCon.StartTransaction;
  try
    LCtx := TRttiContext.Create;
    try
      LRtt := LCtx.GetType(ClassType);

      // Pegando o nome da Tabela
      for LAtt in LRtt.GetAttributes do
      begin
        if LAtt is TableName then
          LStrSql := 'DELETE FROM ' + TableName(LAtt).Name;
      end;

      // Pegando os nomes do campos da Tabela
      for LRtp in LRtt.GetProperties do
      begin
        for LAtt in LRtp.GetAttributes do
        begin
          if LAtt is PrimaryKey then
          begin
            LStrWhere := ' WHERE ' + PrimaryKey(LAtt).Name + ' = ' +
              QuotedStr(LRtp.GetValue(Self).ToString);
          end;
        end;
      end;

      LStrSql := LStrSql + LStrWhere;
      // Executar no banco de dados
      Result := _Connection.GetConnection.ExecSQL(LStrSql) > 0;
    finally
      LCtx.Free; // Por ser um Record liberamos desta forma
    end;

    FCon.Commit;

    Application.MessageBox('Registro excluído com sucesso..', '..: Excluir :..', MB_OK +
      MB_ICONINFORMATION);

  except
    on ex: Exception do
    begin
      FCon.Rollback;
      raise Exception.Create('Não foi possível excluir o registro');
    end;

  end;

end;

function TPersistentObject.FormatarValores(LRtp: TRttiProperty): string;
var
  FormatBr: TFormatSettings;
begin
  FormatBr := TFormatSettings.Create;
  FormatBr.DecimalSeparator  := '.';
  FormatBr.CurrencyString    := '';

  if Trim(LRtp.PropertyType.ToString) = 'TDateTime' then
    Result := FormatDateTime('dd.mm.yyyy:hh:mm:ss', LRtp.GetValue(Self).AsVariant)
  else if Trim(LRtp.PropertyType.ToString) = 'TDate' then
    Result := FormatDateTime('dd.mm.yyyy', LRtp.GetValue(Self).AsVariant)
  else if Trim(LRtp.PropertyType.ToString) = 'Currency' then
    Result := FormatCurr('0.00', LRtp.GetValue(Self).AsVariant, FormatBr)
  else if Trim(LRtp.PropertyType.ToString) = 'Double' then
    Result := FormatCurr('0.00', LRtp.GetValue(Self).AsVariant, FormatBr)
  else
    Result := LRtp.GetValue(Self).ToString;

end;

function TPersistentObject.ValidarDados(LRtp: TRttiProperty): Boolean;
var
  LValor: Variant;
begin
  LValor := LRtp.GetValue(Self).AsVariant;
  Result := (VarToStr(LValor) <> EmptyStr) and (VarToStr(LValor) <> '0');
end;

function TPersistentObject.Insert: boolean;
var
  LCtx: TRttiContext;  { Necessário para extrair contexto de um tipo }
  LRtt: TRttiType;     { }
  LRtp: TRttiProperty; { Para mapear Propriedade por Propriedade }
  LAtt: TCustomAttribute; { Para cada extrair o valo de cada Atributo encontrado }
  LStrSql, LStrField, LStrValue: string;
  LValue: string;
begin
  FCon := _Connection.GetConnection;

  FCon.StartTransaction;
  try
    LCtx := TRttiContext.Create;
    try
      LRtt := LCtx.GetType(ClassType);
      // Pegando o nome da Tabela
      for LAtt in LRtt.GetAttributes do
      begin
        if LAtt is TableName then
          LStrSql := 'INSERT INTO ' + TableName(LAtt).Name;
      end;

      // Pegando os nomes do campos da Tabela
      for LRtp in LRtt.GetProperties do
      begin
        for LAtt in LRtp.GetAttributes do
        begin
          if LAtt is FieldName then
          begin
            if ValidarDados(LRtp) then
            begin
              LValue := FormatarValores(LRtp);
              LStrField := LStrField + FieldName(LAtt).Name + ',';
              LStrValue := LStrValue + QuotedStr(LValue) + ',';
            end;
          end;
        end;
      end;

      LStrField := Copy(LStrField, 1, length(LStrField)-1);
      LStrValue := Copy(LStrValue, 1, length(LStrValue)-1);

      LStrSql := LStrSql + '('+LStrField+') VALUES ('+LStrValue+')';
      // Executar no banco de dados
      Result := FCon.ExecSQL(LStrSql) > 0;

    finally
      LCtx.Free; // Por ser um Record liberamos desta forma
    end;

    FCon.Commit;

    Application.MessageBox('Registro salvo com sucesso..', '..: Inserir :..', MB_OK +
      MB_ICONINFORMATION);

  except
    on ex: EFDDBEngineException do
    begin
      if ex.Kind = ekUKViolated then
      begin
        FCon.Rollback;
        raise Exception.Create('Não foi possivel salvar esse Registro, ele já existe no banco');
      end;
    end;

  end;

end;

procedure TPersistentObject.Open(aDataSource: TDataSource);
var
  LSelect: TStringBuilder;
begin
  LSelect := TStringBuilder.Create;
  try
    LSelect.Append(' SELECT');
    LSelect.Append('   A5_ID      AS CODIGO, ');
    LSelect.Append('   A5_DATA    AS DATA,   ');
    LSelect.Append('   A5_A2_ID   AS BOMBA,  ');
    LSelect.Append('   A5_QTDE    AS QTDE,   ');
    LSelect.Append('   A5_VALOR   AS TOTAL,  ');
    LSelect.Append('   A5_IMPOSTO AS IMPOSTO,');
    LSelect.Append('   A5_LIQUIDO AS LIQUIDO ');
    LSelect.Append(' FROM');
    LSelect.Append('   ABASTECIMENTOS');

    FQuery.Open(LSelect.ToString);

  finally
    LSelect.Clear;
    FreeAndNil(LSelect);
  end;

  aDataSource.DataSet := FQuery;
end;

function TPersistentObject.Update: boolean;
var
  LCtx: TRttiContext;  { Necessário para extrair contexto de um tipo }
  LRtt: TRttiType;     { }
  LRtp: TRttiProperty; { Para mapear Propriedade por Propriedade }
  LAtt: TCustomAttribute; { Para cada extrair o valo de cada Atributo encontrado }
  LStrSql, LStrField, LStrWhere: string; { Para montar as instruções SQL }
begin
  FCon := _Connection.GetConnection;

  FCon.StartTransaction;
  try
    LCtx := TRttiContext.Create;
    try
      LRtt := LCtx.GetType(ClassType);

      // Pegando o nome da Tabela
      for LAtt in LRtt.GetAttributes do
      begin
        if LAtt is TableName then
          LStrSql := 'UPDATE ' + TableName(LAtt).Name + ' SET ';
      end;

      // Pegando os nomes do campos da Tabela
      for LRtp in LRtt.GetProperties do
      begin
        for LAtt in LRtp.GetAttributes do
        begin
          if LAtt is FieldName then
          begin
            LStrField := LStrField + FieldName(LAtt).Name + ' = ' +
              QuotedStr(LRtp.GetValue(Self).ToString) + ',';
          end
          else
          if LAtt is PrimaryKey then
          begin
            LStrWhere := ' WHERE ' + PrimaryKey(LAtt).Name + ' = ' +
              QuotedStr(LRtp.GetValue(Self).ToString);
          end;
        end;
      end;

      LStrField := Copy(LStrField, 1, length(LStrField)-1);

      LStrSql := LStrSql + LStrField + LStrWhere;

      // Executar no banco de dados
      Result := _Connection.GetConnection.ExecSQL(LStrSql) > 0;

    finally
      LCtx.Free; // Por ser um Record liberamos desta forma
    end;

    FCon.Commit;

    Application.MessageBox('Registro alterado com sucesso..', '..: Alterar :..', MB_OK +
      MB_ICONINFORMATION);

  except
    on ex: Exception do
    begin
      FCon.Rollback;
      raise Exception.Create('Não foi possível alterar o registro');
    end;

  end;

end;

end.

