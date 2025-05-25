import 'package:flutter/material.dart';
import '../models/cart_item.dart';

// Provider responsável por gerenciar o estado do carrinho
class CartProvider with ChangeNotifier {
  // Lista de itens no carrinho
  List<CartItem> _items = [];

  // Getter para acessar os itens do carrinho
  List<CartItem> get items => _items;

  // Retorna o total de itens (quantidade somada de todos os produtos)
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantidade);

  // Adiciona um item ao carrinho
  void addItem(CartItem item) {
    // Verifica se já existe um item igual (pode usar nome, id, ou outro identificador único)
    final index = _items.indexWhere((e) =>
      e.nome == item.nome &&
      e.isBebida == item.isBebida &&
      e.tags.join(',') == item.tags.join(',') // se tags diferenciam o produto
    );
    if (index != -1) {
      // Se já existe, apenas aumenta a quantidade
      _items[index].quantidade += item.quantidade;
    } else {
      // Se não existe, adiciona novo item
      _items.add(item);
    }
    notifyListeners(); // Notifica os ouvintes para atualizar a UI
  }

  // Remove um item do carrinho pelo índice
  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  // Limpa todos os itens do carrinho
  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  // Aumenta a quantidade de um item
  void increaseQuantity(int index) {
    final item = _items[index];
    if (item.isBebida) {
      // Limita bebidas a no máximo 20 unidades
      if (item.quantidade < 20) {
        item.quantidade++;
        notifyListeners();
      }
    } else {
      // Outros produtos podem ser aumentados sem limite
      item.quantidade++;
      notifyListeners();
    }
  }

  // Diminui a quantidade de um item
  void decreaseQuantity(int index) {
    final item = _items[index];
    if (item.isBebida) {
      // Bebidas não podem ter menos que 1 unidade
      if (item.quantidade > 1) {
        item.quantidade--;
        notifyListeners();
      }
    } else {
      // Outros produtos não podem ter menos que 5 unidades
      if (item.quantidade > 5) {
        item.quantidade--;
        notifyListeners();
      }
    }
  }

  // Calcula o valor total do carrinho
  double get total =>
      _items.fold(0.0, (sum, item) => sum + item.quantidade * item.preco);
}