import '../../models/bebida.dart';

/// Controlador responsável por gerenciar a quantidade e o preço total de uma bebida selecionada no card.
/// Usado para manipular o estado do card de bebida na interface.
class BebidaCardController {
  /// Instância da bebida associada a este controlador.
  final Bebida bebida;

  /// Quantidade selecionada da bebida (mínimo 1, máximo 20).
  int quantidade = 1;

  /// Construtor que exige uma bebida.
  BebidaCardController({required this.bebida});

  /// Calcula o preço total com base na quantidade selecionada.
  double get precoTotal => quantidade * bebida.preco;

  /// Incrementa a quantidade da bebida até o máximo de 20.
  void incrementar() {
    if (quantidade < 20) quantidade++;
  }

  /// Decrementa a quantidade da bebida até o mínimo de 1.
  void decrementar() {
    if (quantidade > 1) quantidade--;
  }
}
