import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Classe responsável por exibir o diálogo de login/cadastro
class LoginDialog {
  // Método estático para mostrar o pop-up de login
  static void show(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController senhaController = TextEditingController();

    Future<void> fazerLogin() async {
      final emailOuTelefone = emailController.text.trim();
      final senha = senhaController.text.trim();

      print('🔍 Tentando logar com: $emailOuTelefone / $senha');

      if (emailOuTelefone.isEmpty || senha.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Preencha todos os campos!')),
        );
        print('🚫 Campos vazios!');
        return;
      }

      // Decide se é email ou telefone
      final bool isEmail = emailOuTelefone.contains('@');
      final url = Uri.parse('http://localhost:3000/usuario/login');
      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': isEmail ? emailOuTelefone : null,
            'telefone': isEmail ? null : emailOuTelefone,
            'senha': senha,
          }),
        );

        print('📬 Resposta recebida: ${response.statusCode}');
        print('📦 Body: ${response.body}');

        if (response.statusCode == 200) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login realizado com sucesso!')),
          );
          // Aqui você pode navegar para a tela principal, por exemplo:
          // Navigator.pushReplacementNamed(context, '/home');
        } else {
          final msg =
              jsonDecode(response.body)['error'] ?? 'Erro ao fazer login!';
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(msg)));
        }
      } catch (e) {
        print('💥 Erro de conexão: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro de conexão com o servidor')),
        );
      }
    }

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
                TextField(
                  controller: emailController,
                  style: const TextStyle(
                    color: Colors.black,
                    fontFamily: 'Arial', // Fonte Arial para o campo de usuário
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
                TextField(
                  controller: senhaController,
                  obscureText: true,
                  style: const TextStyle(
                    color: Colors.black,
                    fontFamily: 'Arial', // Fonte Arial para o campo de senha
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
                const SizedBox(height: 24),
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
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // fecha o diálogo
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
}
