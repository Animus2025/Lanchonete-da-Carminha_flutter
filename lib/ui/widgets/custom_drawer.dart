import 'package:flutter/material.dart';
import '../../screens/login_overlay.dart';
import '../themes/app_theme.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

// Drawer personalizado para navegação lateral
class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width > 400
          ? 400
          : MediaQuery.of(context).size.width * 0.7, // Limita a largura máxima
      backgroundColor: AppColors.pretoClaro, // Cor de fundo do Drawer
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Parte de cima do menu
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32.0),
            child: Column(
              children: [
                _buildMenuItemWithImage(
                  imagePath: 'lib/assets/icons/cardapio.png',
                  text: "Cardápio",
                  onTap: () {
                    Navigator.pop(context); // Fecha o Drawer primeiro
                    final currentRoute = ModalRoute.of(context)?.settings.name;
                    if (currentRoute == null || currentRoute == '/') {
                      // Já está na home, não faz nada além de fechar o Drawer
                      return;
                    }
                    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
                  },
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Divider(color: Color(0xff333333)),
                ),
                _buildMenuItem(
                    icon: Icons.person,
                    text: "Minha Conta",
                    onTap: () {
                      final auth = Provider.of<AuthProvider>(context, listen: false);

                      if (auth.isLoggedIn) {
                        Navigator.of(context).pop();
                        Navigator.of(context).pushNamed('/minha_conta');
                      } else {
                        LoginDialog.show(
                          context,
                          onLoginSuccess: () {
                            Navigator.of(context).pop(); // fecha o diálogo
                            Navigator.of(context).pushNamed('/minha_conta');
                          },
                        );
                      }
                    },
                  ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Divider(color: Color(0xff333333)),
                ),
                Consumer<AuthProvider>(
                  builder: (context, auth, _) {
                    return _buildMenuItem(
                      icon: Icons.list_alt,
                      text: "Meus Pedidos",
                      onTap: () {
                        final auth = Provider.of<AuthProvider>(context, listen: false);

                        if (auth.isLoggedIn) {
                          print('Usuário logado: ${auth.userData}');
                          Navigator.of(context).pop(); // Fecha o pop-up de login (se estiver aberto)
                          Navigator.of(context).pushNamed('/Meus_pedidos'); // Vai para Minha Conta
                        } else {
                          LoginDialog.show(
                            context,
                            onLoginSuccess: () {
                              Navigator.of(context).pop(); // fecha o diálogo
                              Navigator.of(context).pushNamed('/Meus_pedidos');
                            },
                          );
                        }
                      },
                    );
                  },
                ),
              ],
            ),
          ),

          // Parte de baixo (rodapé fixo)
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              children: [
                _buildMenuItemWithImage(
                  imagePath: 'lib/assets/icons/termos.png',
                  text: "Termos de Uso",
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/termos_uso');
                  },
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Divider(color: Color(0xff333333)),
                ),
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
      title: Text(
        text,
        style: const TextStyle(color: Color(0xffF6C484)),
      ),
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
      title: Text(
        text,
        style: const TextStyle(color: Color(0xffF6C484)),
      ),
      onTap: onTap,
    );
  }
}
