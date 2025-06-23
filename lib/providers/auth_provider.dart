import 'package:flutter/material.dart';

/// Provider responsável por gerenciar o estado de autenticação do usuário.
/// Ele armazena se o usuário está logado e os dados do usuário logado.
/// Notifica os listeners (widgets que usam Provider) sempre que o estado muda.
class AuthProvider extends ChangeNotifier {
  // Indica se o usuário está logado ou não
  bool _isLoggedIn = false;

  // Armazena os dados do usuário logado (pode ser null se não estiver logado)
  Map<String, dynamic>? _userData;

  // Getter para saber se o usuário está logado
  bool get isLoggedIn => _isLoggedIn;

  // Getter para acessar os dados do usuário logado
  Map<String, dynamic>? get userData => _userData;

  /// Método para realizar login.
  /// Recebe um Map com os dados do usuário (ex: id, nome, email, etc).
  /// Atualiza o estado para logado, armazena os dados e notifica os listeners.
  void login(Map<String, dynamic> userData) {
    _isLoggedIn = true;
    _userData = userData;
    notifyListeners(); // Notifica widgets que usam esse provider para atualizar a UI
  }

  /// Método para realizar logout.
  /// Limpa os dados do usuário, marca como deslogado e notifica os listeners.
  void logout() {
    _isLoggedIn = false;
    _userData = null;
    notifyListeners(); // Notifica widgets para atualizar a UI (ex: mostrar tela de login)
  }
}
