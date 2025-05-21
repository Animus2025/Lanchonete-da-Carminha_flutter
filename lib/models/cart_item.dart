// Modelo que representa um item no carrinho
class CartItem {
  final String nome;         // Nome do produto
  final double preco;        // Preço do produto (pode ser o preço base ou do preparo selecionado)
  final String imagem;       // Caminho da imagem do produto
  final List<String> tags;   // Lista de tags (ex: ['frito', 'assado', etc.])
  final bool isBebida;       // Indica se o item é uma bebida
  int quantidade;            // Quantidade do item no carrinho

  // Construtor do CartItem
  CartItem({
    required this.nome,
    required this.preco,
    required this.imagem,
    required this.tags,
    required this.isBebida,
    this.quantidade = 1, // Valor padrão: 1 unidade
  });
}
