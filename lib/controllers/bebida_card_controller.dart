import '../../models/bebida.dart';

class BebidaCardController {
  final Bebida bebida;
  int quantidade = 1;

  BebidaCardController({required this.bebida});

  double get precoTotal => quantidade * bebida.preco;

  void incrementar() {
    if (quantidade < 20) quantidade++;
  }

  void decrementar() {
    if (quantidade > 1) quantidade--;
  }
}
