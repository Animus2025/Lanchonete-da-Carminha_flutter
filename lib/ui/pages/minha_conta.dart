import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/app_body_container.dart';
import '../themes/app_theme.dart';

class MinhaContaPage extends StatelessWidget {
  final VoidCallback toggleTheme;

  const MinhaContaPage({super.key, required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
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
                  const Text(
                    'INFORMAÇÕES PESSOAIS:',
                    style: TextStyle(
                      fontFamily: 'BebasNeue',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.laranja,
                    ),
                  ),
                  const SizedBox(height: 16),
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
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        buildInfoRow(Icons.person, 'FULANO DA SILVA'),
                        const SizedBox(height: 12),
                        buildInfoRow(Icons.email, 'EMAIL@EMAIL.COM'),
                        const SizedBox(height: 12),
                        buildInfoRow(Icons.phone, 'Nº DE TELEFONE'),
                        const SizedBox(height: 12),
                        buildInfoRow(Icons.badge, 'CPF'),
                        const SizedBox(height: 12),
                        buildInfoRow(Icons.location_on, 'RUA/N°'),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, '/redefinir_senha');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.laranja,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                              ),
                              child: const Text(
                                'ALTERAR SENHA',
                                style: TextStyle(
                                  fontFamily: 'BebasNeue',
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // Ação para editar dados
                              },
                              child: const Text(
                                'EDITAR',
                                style: TextStyle(
                                  fontFamily: 'BebasNeue',
                                  fontSize: 16,
                                  color: AppColors.laranja,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            )
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

  Widget buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 28, color: Colors.grey[800]),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'Oswald',
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
