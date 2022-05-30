unit Abastecimento.Controller.Classes;

interface

uses
  Abastecimento.Controller.Interfaces,
  Abastecimento.Model.Entity.Interfaces;

type
  TController = class(TInterfacedObject, iController)
  private
    FEntity: iEntity;
  public
    constructor Create;
    class function New: iController;
    function Entity: iEntity;
  end;

implementation

uses
  Abastecimento.Model.Entity.Entities;

{ TController }

constructor TController.Create;
begin
  FEntity :=  TEntity.New;
end;

function TController.Entity: iEntity;
begin
  Result := FEntity;
end;

class function TController.New: iController;
begin
  Result := Self.Create;
end;

end.

