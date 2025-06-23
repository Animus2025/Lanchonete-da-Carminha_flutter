import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lanchonetedacarminha/screens/login_overlay.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Página para o usuário verificar o telefone após cadastro
class VerificarTelefonePage extends StatefulWidget {
  const VerificarTelefonePage({Key? key}) : super(key: key);

  @override
  State<VerificarTelefonePage> createState() => _VerificarTelefonePageState();
}

class _VerificarTelefonePageState extends State<VerificarTelefonePage> {
  // Controller para o campo de código
  final TextEditingController _codigoController = TextEditingController();
  // Indica se o código digitado tem 6 dígitos (para habilitar o botão)
  bool _codigoValido = false;

  @override
  void initState() {
    super.initState();
    // Adiciona listener para atualizar o estado do botão ao digitar o código
    _codigoController.addListener(_onCodigoChanged);
  }

  // Atualiza o estado do botão de validação conforme o código digitado
  void _onCodigoChanged() {
    setState(() {
      _codigoValido = _codigoController.text.length == 6;
    });
  }

  @override
  void dispose() {
    // Remove o listener e libera o controller ao destruir o widget
    _codigoController.removeListener(_onCodigoChanged);
    _codigoController.dispose();
    super.dispose();
  }

  // Função para validar o código recebido pelo usuário
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

    // Primeiro, verifica o código com o backend
    final response = await http.post(
      Uri.parse('http://localhost:3000/whatsapp/confirmar-codigo'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'numero': telefone, 'codigo': codigo}),
    );

    if (response.statusCode == 200) {
      // Se o código está correto, finaliza o cadastro do usuário
      final finalizarResponse = await http.post(
        Uri.parse('http://localhost:3000/usuario/finalizar-cadastro'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'numero': telefone, 'codigo': codigo}),
      );

      if (finalizarResponse.statusCode == 201) {
        // Cadastro finalizado com sucesso, mostra feedback e volta para login
        await LoginDialog.showFeedbackDialog(
          context,
          'Telefone verificado e cadastro finalizado com sucesso!\nVocê já pode fazer login.',
          positivo: true,
        );
        Navigator.pushReplacementNamed(context, '/');
      } else {
        // Erro ao finalizar cadastro
        final msg =
            jsonDecode(finalizarResponse.body)['error'] ??
            'Erro ao finalizar cadastro!';
        await LoginDialog.showFeedbackDialog(context, msg, positivo: false);
      }
    } else {
      // Código inválido ou erro na verificação
      final msg =
          jsonDecode(response.body)['error'] ?? 'Erro ao verificar código!';
      await LoginDialog.showFeedbackDialog(context, msg, positivo: false);
    }
  }

  // Função para reenviar o código de verificação
  void _reenviarCodigo() async {
    await LoginDialog.showFeedbackDialog(
      context,
      'Código reenviado!',
      positivo: true,
    );
    // Aqui você pode chamar novamente o envio de SMS/WhatsApp no backend
  }

  @override
  Widget build(BuildContext context) {
    // Recupera o telefone passado como argumento pela rota
    final String telefone =
        ModalRoute.of(context)?.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(title: const Text('Verificar Telefone')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Instrução para o usuário
            const Text(
              'Digite o código que você recebeu no WhatsApp:',
              style: TextStyle(fontSize: 18, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            // Campo para digitar o código de 6 dígitos
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
            // Botão para validar o código (habilitado só se o código tem 6 dígitos)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    _codigoValido ? () => _validarCodigo(telefone) : null,
                child: const Text('Validar código'),
              ),
            ),
            const SizedBox(height: 16),
            // Botão para reenviar o código
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
