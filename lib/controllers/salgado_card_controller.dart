import '../models/salgado.dart';

/// Enumeração para os tipos de preparo possíveis de um salgado.
enum TipoPreparo { frito, congelado }

/// Controlador responsável por gerenciar o estado de um card de salgado na interface.
/// Permite controlar a quantidade, tipo de preparo e calcular preços.
class SalgadoCardController {
  /// Instância do salgado associada a este controlador.
  final Salgado salgado;

  /// Quantidade selecionada do salgado (padrão: 5).
  int quantidade = 5;

  /// Tipo de preparo selecionado (padrão: frito).
  TipoPreparo tipoSelecionado = TipoPreparo.frito;

  /// Construtor que exige um salgado.
  SalgadoCardController({required this.salgado});

  /// Retorna o preço unitário do salgado de acordo com o tipo de preparo e dados vindos do backend.
  double get precoUnitario {
    if (tipoSelecionado == TipoPreparo.frito) {
      return salgado.precoPronto ?? 0.0;
    } else {
      return salgado.precoCongelado ?? 0.0;
    }
  }

  /// Calcula o preço total multiplicando a quantidade pelo preço unitário.
  double get precoTotal => quantidade * precoUnitario;

  /// Troca o tipo de preparo selecionado.
  void trocarTipo(TipoPreparo tipo) {
    tipoSelecionado = tipo;
  }

  /// Incrementa a quantidade até o máximo de 500.
  void incrementar() {
    if (quantidade < 500) quantidade++;
  }

  /// Decrementa a quantidade até o mínimo de 0.
  void decrementar() {
    if (quantidade > 0) quantidade--;
  }
}
