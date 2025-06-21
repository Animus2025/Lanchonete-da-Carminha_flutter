import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lanchonetedacarminha/ui/widgets/password_rules_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../widgets/AppBodyConteiner.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _codigoController = TextEditingController();

  bool _obscureSenha = true;
  String _senhaAtual = '';

  final Color _laranjaPadrao = const Color(0xFFF6C484);

  @override
  void dispose() {
    _emailController.dispose();
    _nomeController.dispose();
    _telefoneController.dispose();
    _cpfController.dispose();
    _enderecoController.dispose();
    _senhaController.dispose();
    _codigoController.dispose();
    super.dispose();
  }

  String? validarEmail(String? email) {
    if (email == null || email.isEmpty) return null;
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      return 'E-mail inválido';
    }
    return null;
  }

  String? validarTelefone(String? telefone) {
    if (telefone == null || telefone.isEmpty) {
      return 'Telefone é obrigatório';
    }
    final telefoneRegex = RegExp(r'^\d{10,11}$');
    final digitsOnly = telefone.replaceAll(RegExp(r'\D'), '');
    if (!telefoneRegex.hasMatch(digitsOnly)) {
      return 'Telefone inválido';
    }
    return null;
  }

  String? validarCPF(String? cpf) {
    if (cpf == null || cpf.isEmpty) {
      return 'CPF é obrigatório';
    }
    final cpfDigits = cpf.replaceAll(RegExp(r'\D'), '');
    if (cpfDigits.length != 11) {
      return 'CPF deve ter 11 dígitos';
    }
    return null;
  }

  String? validarSenha(String? senha) {
    if (senha == null || senha.isEmpty) {
      return 'Senha obrigatória';
    }
    if (senha.length < 8) {
      return 'A senha deve ter no mínimo 8 caracteres';
    }
    if (!senha.contains(RegExp(r'[A-Z]'))) {
      return 'A senha deve conter pelo menos uma letra maiúscula';
    }
    if (!senha.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'))) {
      return 'A senha deve conter pelo menos um caractere especial';
    }
    if (RegExp(r'012|123|234|345|456|567|678|789').hasMatch(senha)) {
      return 'A senha não pode conter sequências numéricas (ex: 123)';
    }
    return null;
  }

  Future<void> cadastrarUsuario() async {
    const url = 'http://localhost:3000/usuario/pre-cadastro';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nome_usuario': _nomeController.text,
        'email': _emailController.text,
        'senha': _senhaController.text,
        'numero': _telefoneController.text,
        'endereco': _enderecoController.text,
        'cpf': _cpfController.text,
      }),
    );

    if (response.statusCode == 201) {
      await http.post(
        Uri.parse('http://localhost:3000/whatsapp/verificar-numero'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'numero': _telefoneController.text}),
      );

      Navigator.pushReplacementNamed(
        context,
        '/verificar_telefone',
        arguments: _telefoneController.text,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao cadastrar: ${response.body}')),
      );
    }
  }

  void _enviarFormulario() {
    if (_formKey.currentState!.validate()) {
      cadastrarUsuario();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Cadastro',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        iconTheme: IconThemeData(color: _laranjaPadrao),
      ),
      body: AppBodyContainer(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: _nomeController,
                  decoration:
                      const InputDecoration(labelText: 'Nome completo *'),
                  validator: (value) =>
                      (value == null || value.isEmpty) ? 'Nome é obrigatório' : null,
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'E-mail (opcional)',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: validarEmail,
                ),
                TextFormField(
                  controller: _telefoneController,
                  decoration: const InputDecoration(labelText: 'Telefone *'),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(11),
                  ],
                  validator: validarTelefone,
                ),
                TextFormField(
                  controller: _cpfController,
                  decoration: const InputDecoration(labelText: 'CPF *'),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(11),
                  ],
                  validator: validarCPF,
                ),
                TextFormField(
                  controller: _enderecoController,
                  decoration: const InputDecoration(labelText: 'Endereço *'),
                  validator: (value) => (value == null || value.isEmpty)
                      ? 'Endereço é obrigatório'
                      : null,
                ),
                TextFormField(
                  controller: _senhaController,
                  decoration: InputDecoration(
                    labelText: 'Senha *',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureSenha
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureSenha = !_obscureSenha;
                        });
                      },
                    ),
                  ),
                  obscureText: _obscureSenha,
                  onChanged: (value) {
                    setState(() {
                      _senhaAtual = value;
                    });
                  },
                  style: const TextStyle(
                    fontFamily: 'Oswald',
                    fontSize: 16,
                  ),
                  validator: validarSenha,
                ),
                if (_senhaAtual.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  PasswordRulesWidget(senhaAtual: _senhaAtual),
                ],
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _enviarFormulario,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _laranjaPadrao,
                  ),
                  child: Text(
                    'Continuar',
                    style: Theme.of(context)
                        .elevatedButtonTheme
                        .style
                        ?.textStyle
                        ?.resolve({}),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
