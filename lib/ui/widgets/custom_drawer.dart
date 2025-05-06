import 'package:flutter/material.dart';
import '../../screens/login_overlay.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.7,
      backgroundColor: const Color(0xff111111),
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 32.0),
        children: [
          // Cardápio
          _buildMenuItemWithImage(
            imagePath: 'lib/assets/icons/cardapio.png',
            text: "Cardápio",
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/cardapio');
            },
          ),          
          const Divider(color: Color(0xff333333)),

          // Minha Conta
          _buildMenuItem(
            icon: Icons.person,
            text: "Minha Conta",
            onTap: () {
              LoginDialog.show(context);
            },
          ),
          const Divider(color: Color(0xff333333)),
          
          // Meus Pedidos
          _buildMenuItem(
            icon: Icons.list_alt,
            text: "Meus Pedidos",
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/Meus-Pedidos');
            },
          ),

          const SizedBox(height: 330), // Espaçamento vertical

          // Termos de Uso
          _buildMenuItemWithImage(
            imagePath: 'lib/assets/icons/termos.png',
            text: "Termos de Uso",
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/termos-de-uso');
            },
          ),
          const Divider(color: Color(0xff333333)),

          // Políticas de Privacidade
          _buildMenuItemWithImage(
            imagePath: 'lib/assets/icons/privacidade.png',
            text: "Políticas de Privacidade",
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/politicas-de-privacidade');
            },
          ),
          const Divider(color: Color(0xff333333)),

          // Sobre
          _buildMenuItemWithImage(
            imagePath: 'lib/assets/icons/info.png',
            text: "Sobre",
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/sobre');
            },
          ),
        ],
      ),
    );
  }

  // Helper para criar itens do menu com ícones padrão
  Widget _buildMenuItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xffF6C484)),
      title: Text(text, style: const TextStyle(color: Color(0xffF6C484))),
      onTap: onTap,
    );
  }

  // Helper para criar itens do menu com imagens personalizadas
  Widget _buildMenuItemWithImage({
    required String imagePath,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Image.asset(
        imagePath,
        color: const Color(0xffF6C484),
        width: 24,
        height: 24,
      ),
      title: Text(text, style: const TextStyle(color: Color(0xffF6C484))),
      onTap: onTap,
    );
  }
}
