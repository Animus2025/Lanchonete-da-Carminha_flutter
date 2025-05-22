import 'package:flutter/material.dart';
import 'package:providers/provider.dart';

class LoginDialog {
  static void show(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController senhaController =
        TextEditingController(); // novo campo

    showDialog(
      context: context,
      barrierDismissible: true, // Pode fechar tocando fora
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: const Text(
            "Cadastre-se/Entrar",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Campo de email
              TextField(
                controller: emailController,
                style: const TextStyle(color: Colors.black),
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
              const SizedBox(height: 16), // espaço entre campos
              // Campo de senha
              TextField(
                controller: senhaController,
                obscureText: true, // esconde a senha
                style: const TextStyle(color: Colors.black),
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
            ],
          ),
          actions: [
            Center(
              child: TextButton(
                onPressed: () {
                  // Aqui futuramente você pode verificar os dados
                  Navigator.pop(context); // Fecha o pop-up
                },
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
          ],
        );
      },
    );
  }
}
