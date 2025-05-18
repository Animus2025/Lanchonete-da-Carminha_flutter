import 'produto.dart';

class Salgado extends Produto {
  final String categoria;

  Salgado({
    required String nome,
    required String imagem,
    required this.categoria,
  }) : super(nome: nome, imagem: imagem);
}
