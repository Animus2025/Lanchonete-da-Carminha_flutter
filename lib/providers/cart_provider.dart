import 'package:flutter/material.dart';
import '../models/cart_item.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void addItem(CartItem item) {
  // Verifica se já existe um item igual (pode usar nome, id, ou outro identificador único)
  final index = _items.indexWhere((e) =>
    e.nome == item.nome &&
    e.isBebida == item.isBebida &&
    e.tags.join(',') == item.tags.join(',') // se tags diferenciam o produto
  );
  if (index != -1) {
    _items[index].quantidade += item.quantidade;
  } else {
    _items.add(item);
  }
  notifyListeners();
}

  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  void increaseQuantity(int index) {
  final item = _items[index];
  if (item.isBebida) {
    if (item.quantidade < 20) {
      item.quantidade++;
      notifyListeners();
    }
  } else {
    item.quantidade++;
    notifyListeners();
  }
}

void decreaseQuantity(int index) {
  final item = _items[index];
  if (item.isBebida) {
    if (item.quantidade > 1) {
      item.quantidade--;
      notifyListeners();
    }
  } else {
    if (item.quantidade > 5) {
      item.quantidade--;
      notifyListeners();
    }
  }
}





  double get total =>
      _items.fold(0.0, (sum, item) => sum + item.quantidade * item.preco);
}
