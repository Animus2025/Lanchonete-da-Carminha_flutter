import 'package:flutter/material.dart';

class LoginDialog {
  static void show(BuildContext context) {
    final TextEditingController emailController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: true, // Permite fechar o pop-up ao clicar fora
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ), 
          title: const Text(
            "Cadastre-se/Entrar",
            textAlign: TextAlign.center,
            style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
            Center(
              child: TextButton(
                onPressed: () {
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