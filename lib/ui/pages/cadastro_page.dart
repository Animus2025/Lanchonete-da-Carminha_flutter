import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lanchonetedacarminha/ui/widgets/password_rules_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Tela de cadastro de usuário
class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _formKey = GlobalKey<FormState>();

  // Controladores dos campos do formulário
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  bool _obscureSenha = true; // Controla visibilidade da senha
  String _senhaAtual = ''; // Guarda a senha digitada para mostrar regras

  final Color _laranjaPadrao = const Color(0xFFF6C484); // Cor padrão do app

  @override
  void dispose() {
    // Libera os controladores ao destruir a tela
    _emailController.dispose();
    _nomeController.dispose();
    _telefoneController.dispose();
    _cpfController.dispose();
    _enderecoController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  // Validação do campo e-mail (opcional)
  String? validarEmail(String? email) {
    if (email == null || email.isEmpty) return null; // opcional
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      return 'E-mail inválido';
    }
    return null;
  }

  // Validação do campo telefone (apenas números, 10 ou 11 dígitos)
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

  // Validação do campo CPF (apenas números, 11 dígitos)
  String? validarCPF(String? cpf) {
    if (cpf == null || cpf.isEmpty) {
      return 'CPF é obrigatório';
    }
    final cpfDigits = cpf.replaceAll(RegExp(r'\D'), '');
    if (cpfDigits.length != 11) {
      return 'CPF deve ter 11 dígitos';
    }
    // Pode colocar uma validação mais completa de CPF aqui, se quiser
    return null;
  }

  // Validação do campo senha (mínimo 8, maiúscula, especial, sem sequência)
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

  // Função para cadastrar o usuário via API
  Future<void> cadastrarUsuario() async {
    const url =
        'http://localhost:3000/usuario/cadastrar'; // Use seu IP local se for testar no celular
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nome_usuario': _nomeController.text,
        'email': _emailController.text,
        'senha': _senhaController.text,
        'telefone': _telefoneController.text,
        'endereco': _enderecoController.text,
        'cpf': _cpfController.text,
      }),
    );

    print('Status: ${response.statusCode}');
    print('Body: ${response.body}');

    if (response.statusCode == 201) {
      // Ao cadastrar com sucesso, abre o popup de confirmação do WhatsApp
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (context) => AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              title: const Text(
                "Confirme seu número",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Enviamos um código de confirmação para o WhatsApp:",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _telefoneController.text,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.pushReplacementNamed(
                        context,
                        '/verificar_telefone',
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _laranjaPadrao,
                    ),
                    child: const Text(
                      "OK",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
      );
    } else {
      // Mostra erro caso o cadastro falhe
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao cadastrar: ${response.body}')),
      );
    }
  }

  // Função chamada ao clicar em "Continuar"
  void _enviarFormulario() {
    if (_formKey.currentState!.validate()) {
      cadastrarUsuario();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black, // Fundo preto
        title: Text(
          'Cadastro',
          style:
              Theme.of(
                context,
              ).appBarTheme.titleTextStyle, // Fonte padrão do tema
        ),
        iconTheme: IconThemeData(
          color: _laranjaPadrao,
        ), // Ícones na cor laranja padrão
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Campo nome
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome completo *'),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Nome é obrigatório'
                            : null,
              ),
              // Campo email
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'E-mail (opcional)',
                ),
                keyboardType: TextInputType.emailAddress,
                validator: validarEmail,
              ),
              // Campo telefone
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
              // Campo CPF
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
              // Campo endereço
              TextFormField(
                controller: _enderecoController,
                decoration: const InputDecoration(labelText: 'Endereço *'),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Endereço é obrigatório'
                            : null,
              ),
              // Campo senha
              TextFormField(
                controller: _senhaController,
                decoration: InputDecoration(
                  labelText: 'Senha *',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureSenha ? Icons.visibility : Icons.visibility_off,
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
                  fontFamily: 'Oswald', // Fonte Oswald
                  fontSize: 16,
                ),
                validator: validarSenha,
              ),
              // Regras de senha (widget customizado)
              if (_senhaAtual.isNotEmpty) ...[
                const SizedBox(height: 10),
                PasswordRulesWidget(senhaAtual: _senhaAtual),
              ],
              const SizedBox(height: 20),
              // Botão de continuar/cadastrar
              ElevatedButton(
                onPressed: _enviarFormulario,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _laranjaPadrao, // Fundo laranja padrão
                ),
                child: Text(
                  'Continuar',
                  style: Theme.of(context).elevatedButtonTheme.style?.textStyle
                      ?.resolve({}), // Fonte padrão do tema
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
