import 'package:flutter/material.dart';
import '../../screens/login_overlay.dart';
import '../themes/app_theme.dart';

// AppBar personalizada para o aplicativo
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback toggleTheme; // Função para alternar o tema (claro/escuro)

  const CustomAppBar({super.key, required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Obtém o tema atual
    final isDarkTheme = theme.brightness == Brightness.dark; // Verifica se está no modo escuro

    return PreferredSize(
      preferredSize: const Size.fromHeight(50.0), // Altura fixa da AppBar
      child: AppBar(
        backgroundColor: AppColors.preto, // Cor de fundo da AppBar
        iconTheme: IconThemeData(color: AppColors.laranja), // Cor dos ícones padrão
        leading: IconButton(
          icon: const Icon(Icons.menu, size: 28), // Ícone do menu lateral (Drawer)
          onPressed: () {
            Scaffold.of(context).openDrawer(); // Abre o Drawer ao clicar
          },
        ),
        title: SizedBox(
          width: 418,
          height: 50,
          child: Center(
            child: Image.asset(
              'lib/assets/icons/logo.png', // Logo centralizada
              fit: BoxFit.contain,
            ),
          ),
        ),
        actions: [
          // Botão para alternar o tema (claro/escuro)
          IconButton(
            icon: Icon(
              isDarkTheme ? Icons.light_mode : Icons.dark_mode, // Ícone muda conforme o tema
              size: 28,
              color: AppColors.laranja, // Cor do ícone
            ),
            onPressed: toggleTheme, // Chama a função para alternar o tema
          ),
          // Botão de perfil/login
          IconButton(
            icon: const Icon(
              Icons.person,
              size: 28,
              color: AppColors.laranja, // Cor do ícone de perfil
            ),
            onPressed: () {
              LoginDialog.show(context); // Abre o diálogo de login ao clicar
            },
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50.0); // Define a altura da AppBar
}
