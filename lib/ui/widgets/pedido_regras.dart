import 'package:flutter/material.dart';

class PedidoRegras {
  static Duration calcularPrazoMinimo(int quantidade, String sabor, double proporcaoDoSabor) {
    if (['Enroladinho de salsicha', 'Risole de carne'].contains(sabor)) {
      return const Duration(hours: 48);
    }

    if (quantidade <= 100) return const Duration(hours: 24);
    if (quantidade <= 500) return const Duration(hours: 72);
    if (quantidade <= 1000) return const Duration(hours: 168);
    return const Duration(hours: 336);
  }

  static bool verificarLimites(int total, Map<String, int> porSabor) {
    if (total > 2000) return false;
    for (var qnt in porSabor.values) {
      if (qnt > 500) return false;
    }
    return true;
  }

  static bool verificarHorarioDomingo(DateTime data, TimeOfDay horario) {
    if (data.weekday == DateTime.sunday) {
      return horario.hour >= 18 && horario.hour <= 21;
    }
    return true;
  }

  // Outras regras podem ser adicionadas conforme necessário...
}