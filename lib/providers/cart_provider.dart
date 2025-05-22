import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
  // Exemplo de estrutura básica
  final List<String> _items = [];
  List<String> get items => _items;

  void addItem(String item) {
    _items.add(item);
    notifyListeners();
  }
}
