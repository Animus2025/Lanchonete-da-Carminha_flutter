import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lanchonetedacarminha/screens/login_overlay.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VerificarTelefonePage extends StatefulWidget {
  const VerificarTelefonePage({Key? key}) : super(key: key);

  @override
  State<VerificarTelefonePage> createState() => _VerificarTelefonePageState();
}

class _VerificarTelefonePageState extends State<VerificarTelefonePage> {
  final TextEditingController _codigoController = TextEditingController();
  bool _codigoValido = false;

  @override
  void initState() {
    super.initState();
    _codigoController.addListener(_onCodigoChanged);
  }

  void _onCodigoChanged() {
    setState(() {
      _codigoValido = _codigoController.text.length == 6;
    });
  }

  @override
  void dispose() {
    _codigoController.removeListener(_onCodigoChanged);
    _codigoController.dispose();
    super.dispose();
  }

  Future<void> _validarCodigo(String telefone) async {
    final codigo = _codigoController.text.trim();
    if (codigo.isEmpty) {
      await LoginDialog.showFeedbackDialog(
        context,
        'Digite o código recebido!',
        positivo: null,
      );
      return;
    }

    // Primeiro, verifica o código
    final response = await http.post(
      Uri.parse('http://localhost:3000/whatsapp/confirmar-codigo'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'numero': telefone, 'codigo': codigo}),
    );

    if (response.statusCode == 200) {
      // Agora finaliza o cadastro
      final finalizarResponse = await http.post(
        Uri.parse('http://localhost:3000/usuario/finalizar-cadastro'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'numero': telefone, 'codigo': codigo}),
      );

      if (finalizarResponse.statusCode == 201) {
        await LoginDialog.showFeedbackDialog(
          context,
          'Telefone verificado e cadastro finalizado com sucesso!\nVocê já pode fazer login.',
          positivo: true,
        );
        Navigator.pushReplacementNamed(context, '/');
      } else {
        final msg =
            jsonDecode(finalizarResponse.body)['error'] ??
            'Erro ao finalizar cadastro!';
        await LoginDialog.showFeedbackDialog(context, msg, positivo: false);
      }
    } else {
      final msg =
          jsonDecode(response.body)['error'] ?? 'Erro ao verificar código!';
      await LoginDialog.showFeedbackDialog(context, msg, positivo: false);
    }
  }

  void _reenviarCodigo() async {
    await LoginDialog.showFeedbackDialog(
      context,
      'Código reenviado!',
      positivo: true,
    );
    // Aqui você pode chamar novamente o envio de SMS/WhatsApp
  }

  @override
  Widget build(BuildContext context) {
    final String telefone =
        ModalRoute.of(context)?.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(title: const Text('Verificar Telefone')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Digite o código que você recebeu no WhatsApp:',
              style: TextStyle(fontSize: 18, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _codigoController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(6),
              ],
              decoration: const InputDecoration(
                labelText: 'Código',
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(fontFamily: 'Arial'),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    _codigoValido ? () => _validarCodigo(telefone) : null,
                child: const Text('Validar código'),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: _reenviarCodigo,
              child: const Text(
                'Reenviar código',
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
  }
}
