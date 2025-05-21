import 'package:flutter/material.dart';
import '../../screens/login_overlay.dart';
import '../themes/app_theme.dart';

// Drawer personalizado para navegação lateral
class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.7, // Define a largura do Drawer
      backgroundColor: AppColors.pretoClaro, // Cor de fundo do Drawer
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 32.0),
        children: [
          // Item do menu: Cardápio (com imagem personalizada)
          _buildMenuItemWithImage(
            imagePath: 'lib/assets/icons/cardapio.png',
            text: "Cardápio",
            onTap: () {
              Navigator.pop(context); // Fecha o Drawer
              Navigator.pushNamed(context, '/cardapio'); // Navega para a tela de cardápio
            },
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(color: Color(0xff333333)), // Linha divisória
          ),

          // Item do menu: Minha Conta (com ícone padrão)
          _buildMenuItem(
            icon: Icons.person,
            text: "Minha Conta",
            onTap: () {
              LoginDialog.show(context); // Abre o diálogo de login
            },
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(color: Color(0xff333333)),
          ),

          // Item do menu: Meus Pedidos (com ícone padrão)
          _buildMenuItem(
            icon: Icons.list_alt,
            text: "Meus Pedidos",
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/Meus-Pedidos'); // Navega para a tela de pedidos
            },
          ),
          const SizedBox(height: 330), // Espaçamento vertical para separar os itens inferiores

          // Item do menu: Termos de Uso (com imagem personalizada)
          _buildMenuItemWithImage(
            imagePath: 'lib/assets/icons/termos.png',
            text: "Termos de Uso",
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/termos-de-uso');
            },
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(color: Color(0xff333333)),
          ),

          // Item do menu: Políticas de Privacidade (com imagem personalizada)
          _buildMenuItemWithImage(
            imagePath: 'lib/assets/icons/privacidade.png',
            text: "Políticas de Privacidade",
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/politicas-de-privacidade');
            },
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(color: Color(0xff333333)),
          ),

          // Item do menu: Sobre (com imagem personalizada)
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
      leading: Icon(icon, color: const Color(0xffF6C484)), // Ícone do item
      title: Text(text, style: const TextStyle(color: Color(0xffF6C484))), // Texto do item
      onTap: onTap, // Ação ao clicar
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
        color: const Color(0xffF6C484), // Cor da imagem
        width: 24,
        height: 24,
      ),
      title: Text(text, style: const TextStyle(color: Color(0xffF6C484))),
      onTap: onTap,
    );
  }
}
