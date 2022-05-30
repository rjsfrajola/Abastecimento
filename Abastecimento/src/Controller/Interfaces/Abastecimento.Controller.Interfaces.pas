unit Abastecimento.Controller.Interfaces;

interface

uses
  Abastecimento.Model.Entity.Interfaces;

type
  TOperacao = (Inserir, Atualizar, Deletar, Consultar);

  iController = interface
    ['{DD8372BF-7AC3-483A-B0B1-94560E7FE27C}']
    function Entity: iEntity;
  end;

implementation

end.
