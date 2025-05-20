class CartItem {
  final String nome;
  final double preco;
  final String imagem;
  final List<String> tags;
  final bool isBebida;
  int quantidade;

  CartItem({
    required this.nome,
    required this.preco,
    required this.imagem,
    required this.tags,
    required this.isBebida,
    this.quantidade = 1,
  });
}
