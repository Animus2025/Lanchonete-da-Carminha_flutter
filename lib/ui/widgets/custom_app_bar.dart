import 'package:flutter/material.dart';
import '../../screens/login_overlay.dart';
import '../themes/app_theme.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback toggleTheme;

  const CustomAppBar({super.key, required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkTheme = theme.brightness == Brightness.dark;

    return PreferredSize(
      preferredSize: const Size.fromHeight(56.0),
      child: AppBar(
        backgroundColor: AppColors.preto,
        iconTheme: IconThemeData(color: AppColors.laranja),
        leading: IconButton(
          icon: const Icon(Icons.menu, size: 28),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        title: Center(
          child: GestureDetector(
            onTap: () {
              final currentRoute = ModalRoute.of(context)?.settings.name;
              if (currentRoute == null || currentRoute == '/') {
                // Já está na home, não faz nada
                return;
              }
              Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
            },
            child: Image.asset(
              'lib/assets/icons/logo.png',
              height: 50, // Ajuste proporcional
              fit: BoxFit.contain,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isDarkTheme ? Icons.light_mode : Icons.dark_mode,
              size: 28,
              color: AppColors.laranja,
            ),
            onPressed: toggleTheme,
          ),
          IconButton(
            icon: const Icon(
              Icons.person,
              size: 28,
              color: AppColors.laranja,
            ),
            onPressed: () {
              final auth = Provider.of<AuthProvider>(context, listen: false);

              if (auth.isLoggedIn) {
                print('Usuário logado: ${auth.userData}');
                Navigator.of(context).pop(); // Fecha o pop-up de login (se estiver aberto)
                Navigator.of(context).pushNamed('/minha_conta'); // Vai para Minha Conta
              } else {
                LoginDialog.show(
                  context,
                  onLoginSuccess: () {
                    Navigator.of(context).pop(); // Fecha o diálogo de login
                    Navigator.of(context).pushNamed('/minha_conta'); // Vai para Minha Conta
                  },
                );
              }
            },
          ),
        ],
        centerTitle: true, // 🔥 Mantém centralizado independentemente da tela
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}
