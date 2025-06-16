import 'package:flutter/material.dart';
import '../themes/app_theme.dart';
import '../widgets/custom_app_bar.dart';
import '/models/pedidos.dart';
import '../widgets/custom_drawer.dart';

class MeusPedidosPage extends StatelessWidget {
  final VoidCallback toggleTheme;

  const MeusPedidosPage({super.key, required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    // Simulação dos pedidos
    List<Pedido> pedidosPendentes = [
      Pedido(
        data: 'SEG 10 JUNHO 2025',
        numero: '5555',
        itens: [
          ItemPedido(nome: '10x Coxinha', tipo: 'Frito'),
          ItemPedido(nome: '5x Empada de Frango', tipo: 'Assado'),
        ],
        total: 32.00,
      ),
    ];

    List<Pedido> historicoPedidos = [
      Pedido(
        data: 'TER 04 MARÇO 2025',
        numero: '4444',
        itens: [
          ItemPedido(nome: '20x Risole de Carne/Festa', tipo: 'Frito'),
          ItemPedido(nome: '10x Pastel de Frango com Catupiry', tipo: 'Assado'),
        ],
        total: 48.00,
      ),
      Pedido(
        data: 'SEX 28 FEVEREIRO 2025',
        numero: '3333',
        itens: [
          ItemPedido(nome: '20x Risole de Carne/Festa', tipo: 'Frito'),
        ],
        total: 20.00,
      ),
    ];

    return Scaffold(
      appBar: CustomAppBar(toggleTheme: toggleTheme),
      drawer: CustomDrawer(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          buildPedidoSection(
            title: 'Pedidos Pendentes (${pedidosPendentes.length})',
            pedidos: pedidosPendentes.map(buildCardPedido).toList(),
          ),
          buildPedidoSection(
            title: 'Histórico de Pedidos',
            pedidos: historicoPedidos.map(buildCardPedido).toList(),
          ),
          buildPedidoSection(
            title: '⭐ Pedidos Favoritos',
            pedidos: [], // Você pode preencher futuramente
          ),
          buildPedidoSection(
            title: 'Pedidos Cancelados',
            pedidos: [], // Você pode preencher futuramente
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

  // Card de cada pedido
  Widget buildCardPedido(Pedido pedido) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabeçalho
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                pedido.data,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'N° ${pedido.numero}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Itens
          ...pedido.itens.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(item.nome),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        item.tipo.toUpperCase(),
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 8),

          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'TOTAL:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'R\$ ${pedido.total.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Botão
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: const Center(
              child: Text(
                'PEDIR NOVAMENTE',
                style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
