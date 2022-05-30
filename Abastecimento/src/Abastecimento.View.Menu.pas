unit Abastecimento.View.Menu;

interface
uses
  System.SysUtils,
  System.UITypes,
  System.Classes,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Effects,
  FMX.Objects,
  FMX.MultiView,
  FMX.StdCtrls,
  FMX.Ani,
  FMX.Layouts,
  FMX.Controls.Presentation,
  FMX.Dialogs,
  Abastecimento.View.Abastecimentos;

type
  TFrmAbastecimentoPrincipal = class(TForm)
    cir1: TCircle;
    cir2: TCircle;
    se1: TShadowEffect;
    se2: TShadowEffect;
    MultiViewMenu: TMultiView;
    StyleBook1: TStyleBook;
    rctMultiViewMenu: TRectangle;
    btnAbastecimentos: TSpeedButton;
    img1: TImage;
    txtAbastecimentos: TText;
    btnMaster: TSpeedButton;
    txtMaster: TText;
    cirMaster: TCircle;
    CAStartShowing: TColorAnimation;
    CAStartHiding: TColorAnimation;
    btnRelatorios: TSpeedButton;
    imgRelatorios: TImage;
    txtRelatorios: TText;
    layTop: TLayout;
    layMenu: TLayout;
    layForms: TLayout;
    btnClose: TSpeedButton;
    imgClose: TImage;
    txtClose: TText;
    lbl1: TLabel;
    pnlFormPrincipal: TPanel;
    imgFormPrincipal: TImage;
    rctForms: TRectangle;
    seRctForms: TShadowEffect;
    rctTop: TRectangle;
    btnMax: TRectangle;
    imgbtnMax: TImage;
    sebtnMax: TShadowEffect;
    btnNormal: TRectangle;
    imgbtnNormal: TImage;
    sebtnNormal: TShadowEffect;
    procedure MultiViewMenuStartHiding(Sender: TObject);
    procedure MultiViewMenuStartShowing(Sender: TObject);
    procedure CAStartHidingFinish(Sender: TObject);
    procedure CAStartShowingFinish(Sender: TObject);
    procedure btnAbastecimentosClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MultiViewMenuPresenterChanging(Sender: TObject;
      var PresenterClass: TMultiViewPresentationClass);
    procedure btnCloseClick(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure rctTopMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure btnMaxClick(Sender: TObject);
    procedure btnNormalClick(Sender: TObject);
    procedure btnRelatoriosClick(Sender: TObject);
  private
    FMultiViewOpen: Single;
    FMultiViewClose: Single;
    { Private declarations }
    procedure WidthLayMenu(aWidth: Single);
  public
    { Public declarations }
  end;

var
  FrmAbastecimentoPrincipal: TFrmAbastecimentoPrincipal;

implementation

{$R *.fmx}

procedure TFrmAbastecimentoPrincipal.btnAbastecimentosClick(Sender: TObject);
begin
  AbastecimentosView := TAbastecimentosView.Create(nil);
  try
    AbastecimentosView.ShowModal;
  finally
    FreeAndNil(AbastecimentosView);
  end;
end;

procedure TFrmAbastecimentoPrincipal.btnCloseClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TFrmAbastecimentoPrincipal.CAStartHidingFinish(Sender: TObject);
begin
  CAStartShowing.Enabled := false;
end;

procedure TFrmAbastecimentoPrincipal.CAStartShowingFinish(Sender: TObject);
begin
  CAStartHiding.Enabled := false;
end;

procedure TFrmAbastecimentoPrincipal.FormCreate(Sender: TObject);
begin
  WidthLayMenu(MultiViewMenu.Width);

  // Only a Test
  ReportMemoryLeaksOnShutdown := true;

end;

procedure TFrmAbastecimentoPrincipal.FormMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  Self.StartWindowDrag;
end;

procedure TFrmAbastecimentoPrincipal.MultiViewMenuPresenterChanging(Sender: TObject;
  var PresenterClass: TMultiViewPresentationClass);
begin
  if MultiViewMenu.Width <> MultiViewMenu.NavigationPaneOptions.CollapsedWidth then
  begin
    FMultiViewOpen := MultiViewMenu.Width;
    FMultiViewClose := MultiViewMenu.NavigationPaneOptions.CollapsedWidth;
  end;
end;

procedure TFrmAbastecimentoPrincipal.MultiViewMenuStartHiding(Sender: TObject);
begin
  CAStartHiding.Enabled := true;
  WidthLayMenu(FMultiViewClose);
end;

procedure TFrmAbastecimentoPrincipal.MultiViewMenuStartShowing(Sender: TObject);
begin
  CAStartShowing.Enabled := true;
  WidthLayMenu(FMultiViewOpen);
end;

procedure TFrmAbastecimentoPrincipal.btnMaxClick(Sender: TObject);
begin
  Self.WindowState := TWindowState.wsMaximized;
end;

procedure TFrmAbastecimentoPrincipal.btnNormalClick(Sender: TObject);
begin
  Self.WindowState := TWindowState.wsNormal;
end;

procedure TFrmAbastecimentoPrincipal.btnRelatoriosClick(Sender: TObject);
begin
  ShowMessage('Em desenvolvimento...');
end;

procedure TFrmAbastecimentoPrincipal.rctTopMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  Self.StartWindowDrag;
end;

procedure TFrmAbastecimentoPrincipal.WidthLayMenu(aWidth: Single);
begin
  layMenu.Width := aWidth;
end;

end.
