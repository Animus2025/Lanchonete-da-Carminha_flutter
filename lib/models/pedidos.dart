class Pedido {
  final String data;
  final String numero;
  final List<ItemPedido> itens;
  final double total;

  Pedido({
    required this.data,
    required this.numero,
    required this.itens,
    required this.total,
  });
}

class ItemPedido {
  final String nome;
  final String tipo; // 'Frito' ou 'Assado'

  ItemPedido({required this.nome, required this.tipo});
}
