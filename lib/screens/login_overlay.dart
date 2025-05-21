import 'package:flutter/material.dart';

// Classe responsável por exibir o diálogo de login/cadastro
class LoginDialog {
  // Método estático para mostrar o pop-up de login
  static void show(BuildContext context) {
    // Controlador para o campo de texto do email/telefone
    final TextEditingController emailController = TextEditingController();

    // Exibe o diálogo
    showDialog(
      context: context,
      barrierDismissible: true, // Permite fechar o pop-up ao clicar fora
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255), // Cor de fundo do pop-up
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), // Borda arredondada
          ), 
          title: const Text(
            "Cadastre-se/Entrar",
            textAlign: TextAlign.center,
            style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Campo de texto para email ou telefone
              TextField(
                controller: emailController,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  labelText: "Email ou número de telefone",
                  labelStyle: TextStyle(color: Color.fromARGB(170, 0, 0, 0)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                ),
              ), 
            ],
          ),
          actions: [
            // Botão "Continuar" centralizado
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context); // Fecha o pop-up ao clicar
                },
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xffF6C484), // Cor de fundo do botão
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0), // Borda arredondada do botão
                  ),
                ),
                child: const Text(
                  "Continuar",
                  style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}