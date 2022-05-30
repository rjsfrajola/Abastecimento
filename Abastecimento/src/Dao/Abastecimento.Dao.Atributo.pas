unit Abastecimento.Dao.Atributo;

interface

type
  TableName = class(TCustomAttribute)
  private
    FName: string;
  public
    constructor Create(aStrName: string);
    property Name: string read FName write FName;
  end;

  FieldName = class(TCustomAttribute)
  private
    FName: string;
  public
    constructor Create(aStrName: string);
    property Name: string read FName write FName;
  end;

  PrimaryKey = class(TCustomAttribute)
  private
    FName: string;
  public
    constructor Create(aStrName: string);
    property Name: string read FName write FName;
  end;

implementation

{ PrimaryKey }

constructor PrimaryKey.Create(aStrName: string);
begin
  FName := aStrName;
end;

{ FieldName }

constructor FieldName.Create(aStrName: string);
begin
  FName := aStrName;
end;

{ TableName }

constructor TableName.Create(aStrName: string);
begin
  FName := aStrName;
end;

end.

