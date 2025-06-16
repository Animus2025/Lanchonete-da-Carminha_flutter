import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lanchonetedacarminha/screens/login_overlay.dart';

class RedefinirSenhaPage extends StatefulWidget {
  const RedefinirSenhaPage({Key? key}) : super(key: key);

  @override
  State<RedefinirSenhaPage> createState() => _RedefinirSenhaPageState();
}

class _RedefinirSenhaPageState extends State<RedefinirSenhaPage> {
  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _codigoController = TextEditingController();
  String? loginTentado;
  String? metodo; // 'email' ou 'telefone'
  bool codigoEnviado = false;

  @override
  void dispose() {
    _inputController.dispose();
    _codigoController.dispose();
    super.dispose();
  }

  void _enviarConfirmacao() async {
    final input = _inputController.text.trim();

    if (input.isEmpty) {
      await LoginDialog.showFeedbackDialog(
        context,
        'Preencha o campo corretamente!',
        positivo: null,
      );
      return;
    }

    if (metodo == 'telefone') {
      final digitsOnly = input.replaceAll(RegExp(r'\D'), '');
      if (digitsOnly.length != 11) {
        await LoginDialog.showFeedbackDialog(
          context,
          'O telefone deve ter exatamente 11 dígitos numéricos!',
          positivo: false,
        );
        return;
      }
      if (!RegExp(r'^\d{11}$').hasMatch(digitsOnly)) {
        await LoginDialog.showFeedbackDialog(
          context,
          'Telefone inválido!',
          positivo: false,
        );
        return;
      }
    }

    if (metodo == 'email') {
      final emailRegex = RegExp(r"^[\w\.\-]+@([\w\-]+\.)+[a-zA-Z]{2,4}$");
      if (!emailRegex.hasMatch(input)) {
        await LoginDialog.showFeedbackDialog(
          context,
          'Email inválido!',
          positivo: false,
        );
        return;
      }
    }

    await LoginDialog.showFeedbackDialog(
      context,
      metodo == 'email'
          ? 'Confirmação enviada para o email!'
          : 'Confirmação enviada para o WhatsApp!',
      positivo: true,
    );

    if (metodo == 'telefone') {
      setState(() {
        codigoEnviado = true;
      });
    }
  }

  void _reenviarCodigo() async {
    await LoginDialog.showFeedbackDialog(
      context,
      'Código reenviado!',
      positivo: true,
    );
    // Aqui você pode chamar novamente o envio de SMS
  }

  void _mudarTelefone() {
    setState(() {
      codigoEnviado = false;
      _inputController.clear();
      _codigoController.clear();
    });
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
    // Aqui você pode validar o código digitado
    await LoginDialog.showFeedbackDialog(
      context,
      'Código validado com sucesso!',
      positivo: true,
    );
    // Continue o fluxo de redefinição de senha aqui
  }

  @override
  Widget build(BuildContext context) {
    loginTentado ??= ModalRoute.of(context)?.settings.arguments as String?;

    return Scaffold(
      appBar: AppBar(title: const Text('Redefinir Senha')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (loginTentado != null)
              Text(
                'Você tentou fazer login com: $loginTentado',
                style: const TextStyle(fontSize: 16, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 24),
            const Text(
              'Como deseja redefinir sua senha?',
              style: TextStyle(fontSize: 18, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            RadioListTile<String>(
              title: const Text('Por telefone (WpphatsApp)'),
              value: 'telefone',
              groupValue: metodo,
              onChanged:
                  (codigoEnviado)
                      ? null // Desabilita troca de método após envio do código
                      : (value) {
                        setState(() {
                          metodo = value;
                          _inputController.clear();
                          codigoEnviado = false;
                        });
                      },
            ),
            RadioListTile<String>(
              title: const Text('Por email (apenas se estiver verificado)'),
              value: 'email',
              groupValue: metodo,
              onChanged:
                  (codigoEnviado)
                      ? null // Desabilita troca de método após envio do código
                      : (value) {
                        setState(() {
                          metodo = value;
                          _inputController.clear();
                          codigoEnviado = false;
                        });
                      },
            ),
            if (metodo != null && !codigoEnviado) ...[
              const SizedBox(height: 16),
              TextField(
                controller: _inputController,
                keyboardType:
                    metodo == 'telefone'
                        ? TextInputType.phone
                        : TextInputType.emailAddress,
                inputFormatters:
                    metodo == 'telefone'
                        ? [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(11),
                        ]
                        : null,
                decoration: InputDecoration(
                  labelText:
                      metodo == 'telefone'
                          ? 'Digite seu telefone'
                          : 'Digite seu email',
                  border: const OutlineInputBorder(),
                ),
                style: const TextStyle(fontFamily: 'Arial'),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _enviarConfirmacao,
                  child: Text(
                    metodo == 'telefone'
                        ? 'Enviar confirmação para o telefone (via WhatsApp)'
                        : 'Enviar confirmação para o email',
                  ),
                ),
              ),
            ],
            if (metodo == 'telefone' && codigoEnviado) ...[
              const SizedBox(height: 24),
              const Text(
                'Digite o código recebido por WhatsApp:',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),
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
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _validarCodigo,
                  child: const Text('Validar código'),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                  const SizedBox(width: 16),
                  TextButton(
                    onPressed: _mudarTelefone,
                    child: const Text(
                      'Mudar telefone',
                      style: TextStyle(
                        color: Colors.black,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  setState(() {
                    metodo = null;
                    codigoEnviado = false;
                    _inputController.clear();
                    _codigoController.clear();
                  });
                },
                child: const Text(
                  'Alterar meio de confirmação',
                  style: TextStyle(
                    color: Colors.black,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
