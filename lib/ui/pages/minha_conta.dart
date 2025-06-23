import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/app_body_container.dart';
import '../themes/app_theme.dart';
import '../../../providers/auth_provider.dart';
import '../pages/editar_conta.dart';

// Página de "Minha Conta" que exibe informações pessoais do usuário logado
class MinhaContaPage extends StatelessWidget {
  final VoidCallback toggleTheme;

  const MinhaContaPage({super.key, required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    // Obtém o AuthProvider para acessar os dados do usuário
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.userData ?? {};
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBar(toggleTheme: toggleTheme),
      drawer: const CustomDrawer(),
      body: AppBodyContainer(
        child: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título da seção
                  Text(
                    'INFORMAÇÕES PESSOAIS:',
                    style: TextStyle(
                      fontFamily: 'BebasNeue',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? AppColors.laranja : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Card com informações do usuário
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1),
                      borderRadius: BorderRadius.circular(12),
                      color: Theme.of(context).cardColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 6,
                          offset: const Offset(2, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Linha com nome do usuário
                        buildInfoRow(
                          context,
                          Icons.person,
                          user['nome_usuario'] ?? 'Nome não informado',
                        ),
                        const SizedBox(height: 12),
                        // Linha com email
                        buildInfoRow(
                          context,
                          Icons.email,
                          user['email'] ?? 'Email não informado',
                        ),
                        const SizedBox(height: 12),
                        // Linha com telefone
                        buildInfoRow(
                          context,
                          Icons.phone,
                          user['telefone'] ?? 'Telefone não informado',
                        ),
                        const SizedBox(height: 12),
                        // Linha com CPF
                        buildInfoRow(
                          context,
                          Icons.badge,
                          user['cpf'] ?? 'CPF não informado',
                        ),
                        const SizedBox(height: 12),
                        // Linha com endereço
                        buildInfoRow(
                          context,
                          Icons.location_on,
                          user['endereco'] ?? 'Endereço não informado',
                        ),
                        const SizedBox(height: 20),
                        // Botões para alterar senha e editar conta
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Botão para alterar senha
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  '/redefinir_senha',
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.laranja,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                              ),
                              child: const Text(
                                'ALTERAR SENHA',
                                style: TextStyle(
                                  fontFamily: 'BebasNeue',
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            // Botão para editar informações da conta
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditarContaPage(),
                                  ),
                                );
                              },
                              child: const Text(
                                'EDITAR',
                                style: TextStyle(
                                  fontFamily: 'BebasNeue',
                                  fontSize: 24,
                                  color: AppColors.laranja,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget auxiliar para exibir uma linha de informação com ícone e texto
  Widget buildInfoRow(BuildContext context, IconData icon, String text) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final color = isDarkMode ? AppColors.laranja : Colors.black87;

    return Row(
      children: [
        Icon(icon, size: 28, color: color),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontFamily: 'Oswald', fontSize: 16, color: color),
          ),
        ),
      ],
    );
  }
}
