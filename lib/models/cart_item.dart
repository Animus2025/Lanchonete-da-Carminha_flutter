class CartItem {
  final String nome;
  final int quantidade;
  final double preco;
  final String imagem;
  final List<String> tags;

  CartItem({
    required this.nome,
    required this.quantidade,
    required this.preco,
    required this.imagem,
    required this.tags,
  });
}
