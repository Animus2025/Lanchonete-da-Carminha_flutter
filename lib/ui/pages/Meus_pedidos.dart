import 'package:flutter/material.dart';
import '../themes/app_theme.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_drawer.dart';

class MeusPedidosPage extends StatelessWidget {
  final VoidCallback toggleTheme;

  const MeusPedidosPage({super.key, required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(toggleTheme: toggleTheme),
      drawer: CustomDrawer(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          buildPedidoSection(
            context: context,
            title: 'Pedidos Pendentes',
            pedidos: [],
          ),
          buildPedidoSection(
            context: context,
            title: 'Histórico de Pedidos',
            pedidos: [],
          ),
          buildPedidoSection(
            context: context,
            title: '⭐ Pedidos Favoritos',
            pedidos: [],
          ),
          buildPedidoSection(
            context: context,
            title: 'Pedidos Cancelados',
            pedidos: [],
          ),
        ],
      ),
    );
  }

  // Seção com ExpansionTile
  Widget buildPedidoSection({
    required BuildContext context,
    required String title,
    required List<Widget> pedidos,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: isDarkMode ? AppColors.laranja : AppColors.preto,
            fontFamily: 'BebasNeue',
          ),
        ),
        children: pedidos.isNotEmpty
            ? pedidos
            : [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Nenhum pedido.',
                    style: TextStyle(
                      fontFamily: 'BebasNeue',
                      fontSize: 16,
                      color: isDarkMode
                          ? AppColors.laranja
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
      ),
    );
  }
}
