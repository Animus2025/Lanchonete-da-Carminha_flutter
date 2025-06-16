import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lanchonetedacarminha/screens/login_overlay.dart';

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

  void _validarCodigo() async {
    final codigo = _codigoController.text.trim();
    if (codigo.isEmpty) {
      await LoginDialog.showFeedbackDialog(
        context,
        'Digite o código recebido!',
        positivo: null,
      );
      return;
    }
    await LoginDialog.showFeedbackDialog(
      context,
      'Telefone verificado com sucesso!\nVocê já pode fazer login.',
      positivo: true,
    );
    Navigator.pushReplacementNamed(context, '/');
  }

  void _reenviarCodigo() async {
    await LoginDialog.showFeedbackDialog(
      context,
      'Código reenviado!',
      positivo: true,
    );
  }

  @override
  Widget build(BuildContext context) {
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
                onPressed: _codigoValido ? _validarCodigo : null,
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
