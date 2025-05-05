import 'package:flutter/material.dart';
import '../../screens/login_overlay.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback toggleTheme;

  const CustomAppBar({super.key, required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return PreferredSize(
      preferredSize: const Size.fromHeight(50.0),
      child: AppBar(
        backgroundColor: const Color.fromARGB(255, 17, 17, 17),
        iconTheme: const IconThemeData(color: Color(0xFFF6C484)),
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
            icon: Icon(isDarkTheme ? Icons.light_mode : Icons.dark_mode, size: 28),
            onPressed: toggleTheme,
          ),
          IconButton(
            icon: const Icon(Icons.person, size: 28),
            onPressed: () {
              LoginDialog.show(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50.0);
}
