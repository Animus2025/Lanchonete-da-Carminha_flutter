import '../models/salgado.dart';

enum TipoPreparo { frito, congelado }

class SalgadoCardController {
  final Salgado salgado;
  int quantidade = 5;
  TipoPreparo tipoSelecionado = TipoPreparo.frito;

  SalgadoCardController({required this.salgado});

  double get precoUnitario {
    switch (salgado.categoria) {
      case 'festa':
        return tipoSelecionado == TipoPreparo.frito ? 0.90 : 0.78;
      case 'assado':
        return 1.00;
      case 'mini':
        return tipoSelecionado == TipoPreparo.frito ? 0.48 : 0.38;
      default:
        return tipoSelecionado == TipoPreparo.frito ? 1.00 : 0.90;
    }
  }

  double get precoTotal => quantidade * precoUnitario;

  void trocarTipo(TipoPreparo tipo) {
    tipoSelecionado = tipo;
  }

  void incrementar() {
    if (quantidade < 500) quantidade++;
  }

  void decrementar() {
    if (quantidade > 0) quantidade--;
  }
}
