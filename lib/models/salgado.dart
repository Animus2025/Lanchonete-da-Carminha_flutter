import 'produto.dart';

/// Classe que representa um salgado no aplicativo.
/// Herda de Produto e adiciona a propriedade de categoria.
class Salgado extends Produto {
  /// Categoria do salgado (ex: festa, assado, mini).
  final String categoria;

  /// Construtor da classe Salgado.
  /// Recebe nome, imagem e categoria, e repassa nome e imagem para a superclasse Produto.
  Salgado({
    required super.nome,
    required super.imagem,
    required this.categoria,
  });
}
