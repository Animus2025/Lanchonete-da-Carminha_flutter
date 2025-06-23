import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

// Variável global para armazenar o último login tentado
String? ultimoLoginTentado;

// Classe utilitária para exibir o diálogo de login
class LoginDialog {
  /// Exibe o diálogo de login. Recebe uma callback para ser chamada após login bem-sucedido.
  static void show(
    BuildContext context, {
    required VoidCallback onLoginSuccess,
  }) {
    // Controllers para os campos de email/telefone e senha
    final TextEditingController emailController = TextEditingController();
    final TextEditingController senhaController = TextEditingController();

    // Função interna para realizar o login
    Future<void> fazerLogin() async {
      final emailOuTelefone = emailController.text.trim();
      final senha = senhaController.text.trim();

      print('🔍 Tentando logar com: $emailOuTelefone / $senha');

      // Validação dos campos
      if (emailOuTelefone.isEmpty || senha.isEmpty) {
        await showFeedbackDialog(
          context,
          'Preencha todos os campos!',
          positivo: null,
        );
        print('🚫 Campos vazios!');
        return;
      }

      ultimoLoginTentado = emailOuTelefone;

      // Decide se é email ou telefone
      final bool isEmail = emailOuTelefone.contains('@');
      final url = Uri.parse('http://localhost:3000/usuario/login');
      try {
        // Faz a requisição POST para login
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': isEmail ? emailOuTelefone : null,
            'numero': isEmail ? null : emailOuTelefone,
            'senha': senha,
          }),
        );

        print('📬 Resposta recebida: ${response.statusCode}');
        print('📦 Body: ${response.body}');

        if (response.statusCode == 200) {
          // Login bem-sucedido
          final data = jsonDecode(response.body);
          print('📦 Dados recebidos: $data');

          final usuario = data['usuario'];

          // Salva os dados do usuário no AuthProvider
          Provider.of<AuthProvider>(context, listen: false).login({
            'id_usuario': usuario['id_usuario'],
            'nome_usuario': usuario['nome_usuario'],
            'email': usuario['email'],
            'telefone': usuario['numero'],
            'cpf': usuario['cpf'],
            'endereco': usuario['endereco'],
          });

          // ADICIONE ESTA LINHA PARA PRINTAR O CONTEÚDO DO PROVIDER APÓS O LOGIN
          final savedUser =
              Provider.of<AuthProvider>(context, listen: false).userData;
          print('🔒 Conteúdo salvo no provider após login: $savedUser');

          Navigator.pop(context); // Fecha o diálogo de login

          // Mostra feedback de sucesso
          await showFeedbackDialog(
            context,
            'Login realizado com sucesso!',
            positivo: true,
          );

          // Chama o callback de sucesso
          onLoginSuccess();
        } else {
          // Erro de autenticação
          final msg =
              jsonDecode(response.body)['error'] ?? 'Erro ao fazer login!';
          await showFeedbackDialog(context, msg, positivo: false);
        }
      } catch (e) {
        // Erro de conexão
        print('💥 Erro de conexão: $e');
        await showFeedbackDialog(
          context,
          'Erro de conexão com o servidor',
          positivo: false,
        );
      }
    }

    // Exibe o AlertDialog de login
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: const Text(
            "Entrar",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Campo de email ou telefone
                TextField(
                  controller: emailController,
                  style: const TextStyle(
                    color: Colors.black,
                    fontFamily: 'Arial',
                  ),
                  decoration: const InputDecoration(
                    labelText: "Email ou número de telefone",
                    labelStyle: TextStyle(color: Colors.black54),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Campo de senha
                TextField(
                  controller: senhaController,
                  obscureText: true,
                  style: const TextStyle(
                    color: Colors.black,
                    fontFamily: 'Arial',
                  ),
                  decoration: const InputDecoration(
                    labelText: "Senha",
                    labelStyle: TextStyle(color: Colors.black54),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                // Link para redefinir senha
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(
                        context,
                        '/redefinir_senha',
                        arguments: ultimoLoginTentado,
                      );
                    },
                    child: const Text(
                      "Esqueci minha senha",
                      style: TextStyle(
                        color: Colors.black,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Botão de login
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: fazerLogin,
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xffF6C484),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text(
                      "Continuar",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Botão para cadastro
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Future.delayed(Duration.zero, () {
                      Navigator.pushNamed(context, '/cadastro_page');
                    });
                  },
                  child: const Text(
                    "Cadastrar-se",
                    style: TextStyle(
                      color: Colors.black,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Exibe um diálogo de feedback (sucesso, erro ou dúvida)
  static Future<void> showFeedbackDialog(
    BuildContext context,
    String message, {
    bool? positivo,
  }) async {
    String emoji;
    if (positivo == true) {
      emoji = "✅";
    } else if (positivo == false) {
      emoji = "❌";
    } else {
      emoji = "❓";
    }

    showDialog(
      context: context,
      barrierDismissible: true,
      builder:
          (context) => AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(emoji, style: const TextStyle(fontSize: 48)),
                const SizedBox(height: 16),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18, color: Colors.black),
                ),
              ],
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
    );

    await Future.delayed(const Duration(seconds: 2));
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }
}
