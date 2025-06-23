import 'produto.dart';

/// Classe que representa um salgado no aplicativo.
/// Herda de Produto e adiciona a propriedade de categoria.
class Salgado extends Produto {
  /// Categoria do salgado (ex: festa, assado, mini).
  final String categoria;
  final String? estado;
  final String tipoProduto;
  final double? precoPronto;
  final double? precoCongelado;

  /// Construtor da classe Salgado.
  /// Recebe nome, imagem e categoria, e repassa nome e imagem para a superclasse Produto.
  Salgado({
    required super.id_produto,
    required super.nome,
    required this.categoria,
    this.estado,
    required this.tipoProduto,
    this.precoPronto,
    this.precoCongelado,
    required super.imagem,
  });

  factory Salgado.fromJson(Map<String, dynamic> json) {
    double? parsePreco(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value.replaceAll(',', '.'));
      return null;
    }

    return Salgado(
      id_produto: json['id_produto'] ?? json['id'] ?? '',
      nome: json['nome_produto'] ?? json['nome'] ?? '',
      imagem: json['imagem'] ?? '',
      categoria: json['categoria'] ?? '',
      tipoProduto: json['tipo_produto'] ?? '',
      estado: json['estado'],
      precoPronto: parsePreco(json['preco_pronto']),
      precoCongelado: parsePreco(json['preco_congelado']),
    );
  }
}
