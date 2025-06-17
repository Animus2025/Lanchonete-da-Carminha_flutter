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
            title: 'Pedidos Pendentes',
            pedidos: [],
          ),
          buildPedidoSection(
            title: 'Histórico de Pedidos',
            pedidos: [],
          ),
          buildPedidoSection(
            title: '⭐ Pedidos Favoritos',
            pedidos: [],
          ),
          buildPedidoSection(
            title: 'Pedidos Cancelados',
            pedidos: [],
          ),
        ],
      ),
    );
  }

  // Secção com ExpansionTile
  Widget buildPedidoSection({
    required String title,
    required List<Widget> pedidos,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        children: pedidos.isNotEmpty
            ? pedidos
            : [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Nenhum pedido.'),
                )
              ],
      ),
    );
  }
}
