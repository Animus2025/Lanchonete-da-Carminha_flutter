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
    final auth = Provider.of<AuthProvider>(context);

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
                return;
              }
              Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
            },
            child: Image.asset(
              'lib/assets/icons/logo.png',
              height: 50,
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

          /// 🔥 Se está logado, mostra submenu; senão, botão que abre login
          auth.isLoggedIn
              ? PopupMenuButton<String>(
                  icon: const Icon(
                    Icons.person,
                    size: 28,
                    color: AppColors.laranja,
                  ),
                  color: Colors.white,
                  offset: const Offset(0, 48), // <-- faz o menu abrir para baixo
                  onSelected: (value) {
                    if (value == 'minha_conta') {
                      Navigator.of(context).pushNamed('/minha_conta');
                    } else if (value == 'sair') {
                      auth.logout();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Você saiu da conta!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  itemBuilder: (context) {
                    return [
                      const PopupMenuItem(
                        value: 'minha_conta',
                        child: Text(
                          'Minha Conta',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'sair',
                        child: Text(
                          'Sair',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ];
                  },
                )
              : IconButton(
                  icon: const Icon(
                    Icons.person,
                    size: 28,
                    color: AppColors.laranja,
                  ),
                  onPressed: () {
                    LoginDialog.show(
                      context,
                      onLoginSuccess: () {
                      },
                    );
                  },
                ),
        ],
        centerTitle: true,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}
