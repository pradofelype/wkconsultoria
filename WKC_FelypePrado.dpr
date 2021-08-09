program WKC_FelypePrado;

uses
  Forms,
  PedidoVenda in 'PedidoVenda.pas' {PedidoVendaF},
  Entity in 'Entity.pas',
  Clientes in 'Clientes.pas',
  Controle in 'Controle.pas',
  ConexaoBanco in 'ConexaoBanco.pas',
  Pedidos in 'Pedidos.pas',
  PedidosProdutos in 'PedidosProdutos.pas',
  Produtos in 'Produtos.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TPedidoVendaF, PedidoVendaF);
  Application.Run;
end.
