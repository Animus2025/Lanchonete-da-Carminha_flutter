import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lanchonetedacarminha/screens/login_overlay.dart';
import 'dart:convert';
import '../themes/app_theme.dart';
import 'package:http/http.dart' as http;
import 'package:lanchonetedacarminha/ui/widgets/password_rules_widget.dart';

class RedefinirSenhaPage extends StatefulWidget {
  const RedefinirSenhaPage({Key? key}) : super(key: key);

  @override
  State<RedefinirSenhaPage> createState() => _RedefinirSenhaPageState();
}

class _RedefinirSenhaPageState extends State<RedefinirSenhaPage> {
  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _codigoController = TextEditingController();
  final TextEditingController _novaSenhaController = TextEditingController();

  bool codigoValidado = false;
  bool codigoEnviado = false;
  String? loginTentado;
  String? metodo; // 'email' ou 'telefone'
  String _senhaAtual = '';

  @override
  void dispose() {
    _inputController.dispose();
    _codigoController.dispose();
    _novaSenhaController.dispose();
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

      final response = await http.post(
        Uri.parse('http://localhost:3000/whatsapp/alterar-senha'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'numero': digitsOnly}),
      );

      if (response.statusCode == 200) {
        await LoginDialog.showFeedbackDialog(
          context,
          'Confirmação enviada para o WhatsApp!',
          positivo: true,
        );
        setState(() {
          codigoEnviado = true;
        });
      } else {
        final msg = jsonDecode(response.body)['error'] ?? 'Erro ao enviar código!';
        await LoginDialog.showFeedbackDialog(context, msg, positivo: false);
      }
      return;
    }

    if (metodo == 'email') {
      final emailRegex = RegExp(r"^[\w\.\-]+@([\w\-]+\.)+[a-zA-Z]{2,4}\$");
      if (!emailRegex.hasMatch(input)) {
        await LoginDialog.showFeedbackDialog(
          context,
          'Email inválido!',
          positivo: false,
        );
        return;
      }
      await LoginDialog.showFeedbackDialog(
        context,
        'Confirmação enviada para o email!',
        positivo: true,
      );
    }
  }

  void _reenviarCodigo() async {
    await LoginDialog.showFeedbackDialog(
      context,
      'Código reenviado!',
      positivo: true,
    );
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
    final numero = _inputController.text.trim();

    if (codigo.isEmpty) {
      await LoginDialog.showFeedbackDialog(
        context,
        'Digite o código recebido!',
        positivo: null,
      );
      return;
    }

    final response = await http.post(
      Uri.parse('http://localhost:3000/whatsapp/confirmar-codigo'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'numero': numero, 'codigo': codigo}),
    );

    if (response.statusCode == 200) {
      await LoginDialog.showFeedbackDialog(
        context,
        'Código validado com sucesso! Agora digite sua nova senha.',
        positivo: true,
      );
      setState(() {
        codigoValidado = true;
      });
    } else {
      final msg = jsonDecode(response.body)['error'] ?? 'Erro ao validar código!';
      await LoginDialog.showFeedbackDialog(context, msg, positivo: false);
    }
  }

  void _redefinirSenha() async {
    final numero = _inputController.text.trim();
    final novaSenha = _novaSenhaController.text.trim();

    if (novaSenha.isEmpty) {
      await LoginDialog.showFeedbackDialog(
        context,
        'Digite a nova senha!',
        positivo: null,
      );
      return;
    }

    final response = await http.post(
      Uri.parse('http://localhost:3000/usuario/redefinir-senha-wpp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'numero': numero, 'novaSenha': novaSenha}),
    );

    if (response.statusCode == 200) {
      await LoginDialog.showFeedbackDialog(
        context,
        'Senha redefinida com sucesso!',
        positivo: true,
      );
      Navigator.pop(context);
    } else {
      final msg = jsonDecode(response.body)['error'] ?? 'Erro ao redefinir senha!';
      await LoginDialog.showFeedbackDialog(context, msg, positivo: false);
    }
  }

  String? validarSenha(String? senha) {
    if (senha == null || senha.isEmpty) return 'A senha é obrigatória';
    if (senha.length < 6) return 'A senha deve ter pelo menos 6 caracteres';
    if (RegExp(r'012|123|234|345|456|567|678|789').hasMatch(senha)) {
      return 'A senha não pode conter sequências numéricas (ex: 123)';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    loginTentado ??= ModalRoute.of(context)?.settings.arguments as String?;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? const Color(0xffF6C484) : Colors.black;

    return Scaffold(
      appBar: AppBar(title: Text('Redefinir Senha', style: TextStyle(color:AppColors.laranja ))),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (loginTentado != null)
                Text(
                  'Você tentou fazer login com: $loginTentado',
                  style: TextStyle(fontSize: 16, color: textColor),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 24),
              Text(
                'Como deseja redefinir sua senha?',
                style: TextStyle(fontSize: 18, color: textColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              RadioListTile<String>(
                title: Text('Por telefone (WhatsApp)', style: TextStyle(color: textColor)),
                value: 'telefone',
                groupValue: metodo,
                onChanged: codigoEnviado ? null : (value) {
                  setState(() {
                    metodo = value;
                    _inputController.clear();
                    codigoEnviado = false;
                  });
                },
              ),
              RadioListTile<String>(
                title: Text('Por email (apenas se estiver verificado)', style: TextStyle(color: textColor)),
                value: 'email',
                groupValue: metodo,
                onChanged: codigoEnviado ? null : (value) {
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
                  keyboardType: metodo == 'telefone' ? TextInputType.phone : TextInputType.emailAddress,
                  inputFormatters: metodo == 'telefone'
                      ? [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(11)]
                      : null,
                  decoration: InputDecoration(
                    labelText: metodo == 'telefone' ? 'Digite seu telefone' : 'Digite seu email',
                    border: const OutlineInputBorder(),
                  ),
                  style: TextStyle(color: textColor),
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
                Text('Digite o código recebido por WhatsApp:', style: TextStyle(fontSize: 16, color: textColor)),
                const SizedBox(height: 12),
                TextField(
                  controller: _codigoController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(6)],
                  decoration: const InputDecoration(
                    labelText: 'Código',
                    border: OutlineInputBorder(),
                  ),
                  style: TextStyle(color: textColor),
                  enabled: !codigoValidado,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: codigoValidado ? null : _validarCodigo,
                    child: const Text('Validar código'),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: codigoValidado ? null : _reenviarCodigo,
                      child: Text('Reenviar código', style: TextStyle(color: textColor, decoration: TextDecoration.underline)),
                    ),
                    const SizedBox(width: 16),
                    TextButton(
                      onPressed: codigoValidado ? null : _mudarTelefone,
                      child: Text('Mudar telefone', style: TextStyle(color: textColor, decoration: TextDecoration.underline)),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: codigoValidado ? null : () {
                    setState(() {
                      metodo = null;
                      codigoEnviado = false;
                      _inputController.clear();
                      _codigoController.clear();
                    });
                  },
                  child: Text('Alterar meio de confirmação', style: TextStyle(color: textColor, decoration: TextDecoration.underline)),
                ),
              ],
              if (codigoValidado) ...[
                const SizedBox(height: 24),
                Text('Digite sua nova senha:', style: TextStyle(fontSize: 16, color: textColor)),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _novaSenhaController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Nova senha',
                    border: OutlineInputBorder(),
                  ),
                  style: TextStyle(color: textColor),
                  onChanged: (value) {
                    setState(() {
                      _senhaAtual = value;
                    });
                  },
                ),
                if (_senhaAtual.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  PasswordRulesWidget(senhaAtual: _senhaAtual),
                ],
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final erro = validarSenha(_novaSenhaController.text);
                      if (erro != null) {
                        LoginDialog.showFeedbackDialog(context, erro, positivo: false);
                      } else {
                        _redefinirSenha();
                      }
                    },
                    child: const Text('Redefinir senha'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
