// Modelo que representa um item no carrinho
class CartItem {
  final int id_produto;   // ID único do produto
  final String nome;         // Nome do produto
  final double preco;        // Preço do produto (pronto, congelado ou bebida)
  final String imagem;       // Caminho da imagem do produto
  final List<String> tags;   // Lista de tags (ex: ['frito', 'assado', etc.])
  final bool isBebida;       // Indica se o item é uma bebida
  int quantidade;            // Quantidade do item no carrinho

  // Construtor do CartItem
  CartItem({
    required this.id_produto,
    required this.nome,
    required this.preco,
    required this.imagem,
    required this.tags,
    required this.isBebida,
    this.quantidade = 1, // Valor padrão: 1 unidade
  });
}

/* Exemplo de uso da classe CartItem para um item do tipo 'salgado'
CartItem(
  id_produto: salgado.id_produto,
  nome: salgado.nome,
  preco: (salgado.estado == 'pronto' || salgado.estado == null)
      ? (salgado.precoPronto ?? 0.0)
      : (salgado.precoCongelado ?? 0.0),
  imagem: salgado.imagem,
  tags: [if (salgado.estado != null) salgado.estado!],
  isBebida: false,
  quantidade: 1,
);

// Exemplo de uso da classe CartItem para um item do tipo 'bebida'
CartItem(
  id_produto: bebida.id_produto,
  nome: bebida.nome,
  preco: bebida.preco,
  imagem: bebida.imagem,
  tags: [],
  isBebida: true,
  quantidade: 1,
);
*/
