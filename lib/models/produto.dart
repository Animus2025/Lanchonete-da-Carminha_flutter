/// Classe base que representa um produto genérico no aplicativo.
/// Pode ser estendida para representar diferentes tipos de produtos, como bebidas ou salgados.
class Produto {
  /// Nome do produto.
  final String nome;
  final int id_produto;

  /// Caminho da imagem do produto.
  final String imagem;

  /// Construtor da classe Produto.
  /// Exige o nome e o caminho da imagem como parâmetros obrigatórios.
  Produto({required this.nome, required this.imagem, required this.id_produto});
}
