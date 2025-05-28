import 'produto.dart';

/// Classe que representa uma bebida no aplicativo.
/// Herda de Produto e adiciona propriedades específicas de bebida.
class Bebida extends Produto {
  /// Volume da bebida em mililitros (ml).
  final double volume;

  /// Preço da bebida em reais.
  final double preco;

  /// Construtor da classe Bebida.
  /// Recebe nome, imagem, volume e preço, e repassa nome e imagem para a superclasse Produto.
  Bebida({
    required String nome,
    required String imagem,
    required this.volume,
    required this.preco,
  }) : super(nome: nome, imagem: imagem);
}
