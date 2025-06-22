import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '/../providers/auth_provider.dart';
import '../widgets/app_body_container.dart';
import '../themes/app_theme.dart';

class EditarContaPage extends StatefulWidget {
  const EditarContaPage({super.key});

  @override
  State<EditarContaPage> createState() => _EditarContaPageState();
}

class _EditarContaPageState extends State<EditarContaPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nomeController;
  late TextEditingController emailController;
  late TextEditingController telefoneController;
  late TextEditingController cpfController;
  late TextEditingController enderecoController;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<AuthProvider>(context, listen: false).userData!;
    nomeController = TextEditingController(text: user['nome_usuario']);
    emailController = TextEditingController(text: user['email']);
    telefoneController = TextEditingController(text: user['telefone']);
    cpfController = TextEditingController(text: user['cpf']);
    enderecoController = TextEditingController(text: user['endereco']);
  }

  Future<void> salvarAlteracoes() async {
    if (!_formKey.currentState!.validate()) return;

    final userId =
        Provider.of<AuthProvider>(context, listen: false).userData!['id'];
    final url = Uri.parse('http://localhost:3000/usuario/$userId');

    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nome_usuario': nomeController.text,
          'email': emailController.text,
          'telefone': telefoneController.text,
          'cpf': cpfController.text,
          'endereco': enderecoController.text,
        }),
      );

      if (response.statusCode == 200) {
        final updatedUser = jsonDecode(response.body);
        Provider.of<AuthProvider>(context, listen: false).login(updatedUser);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Informações atualizadas com sucesso!')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao atualizar dados')),
        );
      }
    } catch (e) {
      print('Erro ao salvar alterações: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro de conexão com o servidor')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Informações'),
        backgroundColor: AppColors.preto,
      ),
      body: AppBodyContainer(
        child: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    Text(
                      'EDITAR DADOS:',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'BebasNeue',
                        color:
                            Theme.of(context).brightness == Brightness.dark
                                ? AppColors.laranja
                                : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 24),
                    buildTextField(label: 'Nome', controller: nomeController),
                    buildTextField(label: 'Email', controller: emailController),
                    buildTextField(
                      label: 'Telefone',
                      controller: telefoneController,
                    ),
                    buildTextField(label: 'CPF', controller: cpfController),
                    buildTextField(
                      label: 'Endereço',
                      controller: enderecoController,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: salvarAlteracoes,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.laranja,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'SALVAR ALTERAÇÕES',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'BebasNeue',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField({
    required String label,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(fontFamily: 'Arial'),
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
