import 'package:flutter/material.dart';
import '../../screens/login_overlay.dart';
import '../themes/app_theme.dart';
import '/screens/Cart_Overlay.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback toggleTheme;

  const CustomAppBar({super.key, required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Obtém o tema atual
    final isDarkTheme = theme.brightness == Brightness.dark;

    return PreferredSize(
      preferredSize: const Size.fromHeight(50.0),
      child: AppBar(
        backgroundColor: AppColors.preto,
        iconTheme: IconThemeData(color: AppColors.laranja), // Ícones com a cor primária
        leading: IconButton(
          icon: const Icon(Icons.menu, size: 28),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        title: SizedBox(
          width: 418,
          height: 50,
          child: Center(
            child: Image.asset(
              'lib/assets/icons/logo.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isDarkTheme ? Icons.light_mode : Icons.dark_mode,
              size: 28,
              color: AppColors.laranja, // Ícone de alternância de tema com cor primária
            ),
            onPressed: toggleTheme,
          ),
          IconButton(
            icon: const Icon(
              Icons.person,
              size: 28,
              color: AppColors.laranja, // Ícone de perfil com cor primária
            ),
            onPressed: () {
              LoginDialog.show(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                isDismissible: true,
                builder: (_) => CartOverlay(),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50.0);
}
