import 'produto.dart';

/// Classe que representa uma bebida no aplicativo.
/// Herda de Produto e adiciona propriedades específicas de bebida.
class Bebida extends Produto {
  /// Preço da bebida em reais.
  final double preco;

  /// Construtor da classe Bebida.
  /// Recebe nome, imagem, volume e preço, e repassa nome e imagem para a superclasse Produto.
  Bebida({required super.id_produto, required super.nome, required super.imagem, required this.preco});

  factory Bebida.fromJson(Map<String, dynamic> json) {
    double parsePreco(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      if (value is String)
        return double.tryParse(value.replaceAll(',', '.')) ?? 0.0;
      return 0.0;
    }

    return Bebida(
      id_produto: json['id_produto'] ?? json['id'] ?? '',
      nome: json['nome_produto'] ?? json['nome'] ?? '',
      preco: parsePreco(json['preco_pronto']),
      imagem: json['imagem'] ?? '',
    );
  }
}
