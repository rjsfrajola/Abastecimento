program Abastecimento;

uses
  System.StartUpCopy,
  FMX.Forms,
  Abastecimento.View.Menu in 'Abastecimento.View.Menu.pas' {FrmAbastecimentoPrincipal},
  Abastecimento.View.Abastecimentos in 'View\Abastecimento.View.Abastecimentos.pas' {AbastecimentosView},
  Abastecimento.Dao.Connection in 'Dao\Abastecimento.Dao.Connection.pas',
  Abastecimento.Dao.Atributo in 'Dao\Abastecimento.Dao.Atributo.pas',
  Abastecimento.Dao.PersistentObject in 'Dao\Abastecimento.Dao.PersistentObject.pas',
  Abastecimento.Model.Abastecimentos in 'Model\Abastecimento.Model.Abastecimentos.pas',
  Abastecimento.Controller.Interfaces in 'Controller\Interfaces\Abastecimento.Controller.Interfaces.pas',
  Abastecimento.Model.Entity.Interfaces in 'Model\Entity\Interfaces\Abastecimento.Model.Entity.Interfaces.pas',
  Abastecimento.Model.Entity.Entities in 'Model\Entity\Entities\Abastecimento.Model.Entity.Entities.pas',
  Abastecimento.Controller.Classes in 'Controller\Classes\Abastecimento.Controller.Classes.pas',
  Abastecimento.EnumUtils in 'Abastecimento.EnumUtils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmAbastecimentoPrincipal, FrmAbastecimentoPrincipal);
  Application.Run;
end.
