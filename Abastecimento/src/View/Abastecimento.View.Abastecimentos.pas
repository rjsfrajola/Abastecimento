unit Abastecimento.View.Abastecimentos;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.Controls.Presentation,
  FMX.StdCtrls,
  FMX.Edit,
  System.Rtti,
  FMX.Grid.Style,
  Data.DB,
  FMX.ScrollBox,
  FMX.Grid,
  Data.Bind.EngExt,
  Fmx.Bind.DBEngExt,
  Fmx.Bind.Grid,
  System.Bindings.Outputs,
  Fmx.Bind.Editors,
  Data.Bind.Components,
  Data.Bind.Grid,
  Data.Bind.DBScope,
  FMX.ListBox,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param,
  FireDAC.Stan.Error,
  FireDAC.DatS,
  FireDAC.Phys.Intf,
  FireDAC.DApt.Intf,
  FireDAC.Stan.StorageBin,
  FireDAC.Stan.Async,
  FireDAC.DApt,
  FireDAC.Comp.Client,
  FireDAC.Comp.DataSet,
  FireDAC.UI.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Phys,
  FireDAC.VCLUI.Wait,
  FireDAC.Phys.FBDef,
  FireDAC.Comp.UI,
  FireDAC.Phys.IBBase,
  FireDAC.Phys.FB,
  FireDAC.FMXUI.Wait,
  Abastecimento.Controller.Interfaces,
  FMX.DateTimeCtrls;

type
  TAbastecimentosView = class(TForm)
    edtCodigo: TEdit;
    pnlPrincipal: TPanel;
    btnInserir: TButton;
    btnFechar: TButton;
    btnDelete: TButton;
    stgLista: TStringGrid;
    btnBuscar: TButton;
    lbl2: TLabel;
    lbl3: TLabel;
    dts1: TDataSource;
    lblBomba: TLabel;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDPhysFBDriverLink1: TFDPhysFBDriverLink;
    cbbBomba: TComboBox;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkGridToDataSourceBindSourceDB1: TLinkGridToDataSource;
    edtData: TDateEdit;
    edtQtde: TEdit;
    lblQtde: TLabel;
    Label1: TLabel;
    edtValor: TEdit;
    procedure btnFecharClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure dts1DataChange(Sender: TObject; Field: TField);
    procedure btnInserirClick(Sender: TObject);
    procedure btnBuscarClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure edtQtdeExit(Sender: TObject);
  private
    FController: iController;
    FPreco: Currency;
  public
  end;

var
  AbastecimentosView: TAbastecimentosView;

implementation

uses
  Abastecimento.Controller.Classes,
  Abastecimento.EnumUtils;

{$R *.fmx}

procedure TAbastecimentosView.btnDeleteClick(Sender: TObject);
var
  LCodigo: integer;
begin
  if not TryStrToInt(edtCodigo.Text, LCodigo) then
    raise Exception.Create('Erro ao informar o C?digo');

  FController
    .Entity
      .Abastecimento
        .Codigo := LCodigo;

  FController.Entity.Abastecimento.Delete;

  btnBuscar.OnClick(Self);

end;

procedure TAbastecimentosView.btnInserirClick(Sender: TObject);
var
  LValor, LQtde, LImposto, Liquido, LPreco: Currency;
  LBomba: integer;
begin
  if not TryStrToCurr(edtQtde.Text, LQtde) then
    raise Exception.Create('Erro ao informar a Qtde');

  if cbbBomba.ItemIndex < 0 then
    raise Exception.Create('Bomba precisa ser escolhida');

  LValor :=  FPreco * LQtde;
  LImposto := LValor * 0.13;
  Liquido := LValor - LImposto;

  LBomba := TBomba(cbbBomba.ItemIndex).GetNumber;

  FController.Entity.Abastecimento.Data  := edtData.Date;
  FController.Entity.Abastecimento.Bomba := LBomba;
  FController.Entity.Abastecimento.Qtde  := LQtde;
  FController.Entity.Abastecimento.Valor := LValor;
  FController.Entity.Abastecimento.Imposto := LImposto;
  FController.Entity.Abastecimento.Liquido := Liquido;

  FController.Entity.Abastecimento.Insert;

  btnBuscar.OnClick(Self);

end;

procedure TAbastecimentosView.btnBuscarClick(Sender: TObject);
begin
  FController
    .Entity
      .Abastecimento
      .Open(dts1);
end;

procedure TAbastecimentosView.dts1DataChange(Sender: TObject; Field: TField);
begin
  edtCodigo.Text := dts1.DataSet.FieldByName('CODIGO').AsString;
  edtData.Text := dts1.DataSet.FieldByName('DATA').AsString;
  edtQtde.Text := dts1.DataSet.FieldByName('QTDE').AsFloat.ToString;

  cbbBomba.ItemIndex :=
    GetBombaComboIndex(dts1.DataSet.FieldByName('BOMBA').AsInteger);

  edtValor.Text :=
    FController
      .Entity
        .Abastecimento
        .BuscarPreco(TBomba(cbbBomba.ItemIndex).GetNumber).ToString;

end;

procedure TAbastecimentosView.edtQtdeExit(Sender: TObject);
begin
  FPreco :=
    FController
      .Entity
        .Abastecimento
        .BuscarPreco(TBomba(cbbBomba.ItemIndex).GetNumber);

  edtValor.Text := CurrToStr(FPreco);
end;

procedure TAbastecimentosView.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TAbastecimentosView.FormCreate(Sender: TObject);
begin
  FController := TController.New;

  EnumToComboBox(cbbBomba);

  // Only a Test to Memory Leak
  ReportMemoryLeaksOnShutdown := true;
end;

end.

