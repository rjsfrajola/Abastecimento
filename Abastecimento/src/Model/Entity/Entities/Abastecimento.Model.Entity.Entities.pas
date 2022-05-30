unit Abastecimento.Model.Entity.Entities;

interface

uses
  Abastecimento.Model.Entity.Interfaces,
  Abastecimento.Model.Abastecimentos;

type
  TEntity = class(TinterfacedObject, iEntity)
  private
    FModelAbastecimento: TAbastecimento;
    constructor Create;
    destructor Destroy;override;
  public
    class function New: iEntity;
    function Abastecimento: TAbastecimento;
  end;

implementation

{ TEntity }

function TEntity.Abastecimento: TAbastecimento;
begin
  Result := FModelAbastecimento;
end;

constructor TEntity.Create;
begin
  FModelAbastecimento := TAbastecimento.Create;
end;

destructor TEntity.Destroy;
begin
  if Assigned(FModelAbastecimento) then
    FModelAbastecimento.Free;

  inherited;
end;

class function TEntity.New: iEntity;
begin
  Result := Self.Create;
end;

end.

