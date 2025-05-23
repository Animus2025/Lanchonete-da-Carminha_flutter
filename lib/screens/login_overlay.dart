import 'package:flutter/material.dart';

class LoginDialog {
  static void show(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController senhaController = TextEditingController();

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
                const SizedBox(height: 16),
                TextField(
                  controller: senhaController,
                  obscureText: true,
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
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
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
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // fecha o diálogo
                    // Navega após fechar o diálogo com um delay zero pra garantir
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
