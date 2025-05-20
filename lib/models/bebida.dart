import 'produto.dart';

class Bebida extends Produto {
  final double volume;
  final double preco;

  Bebida({
    required String nome,
    required String imagem,
    required this.volume,
    required this.preco,
  }) : super(nome: nome, imagem: imagem);
}
