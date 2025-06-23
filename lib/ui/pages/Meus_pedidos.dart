import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../themes/app_theme.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/app_body_container.dart';
import '/../providers/auth_provider.dart';

class MeusPedidosPage extends StatefulWidget {
  final VoidCallback toggleTheme;
  const MeusPedidosPage({super.key, required this.toggleTheme});

  @override
  State<MeusPedidosPage> createState() => _MeusPedidosPageState();
}

class _MeusPedidosPageState extends State<MeusPedidosPage> {
  List<dynamic> pedidosPendentes = [];
  List<dynamic> pedidosCancelados = [];
  List<dynamic> pedidosHistorico = [];
  List<dynamic> pedidosFavoritos = [];

  @override
  void initState() {
    super.initState();
    _carregarPedidos();
  }

  Future<void> _carregarPedidos() async {
    final user = Provider.of<AuthProvider>(context, listen: false).userData;
    final int idUsuario = user?['id_usuario'] ?? 0;
    final pendentes = await fetchPedidosPendentes(idUsuario);
    final cancelados = await fetchPedidosCancelados(idUsuario);
    setState(() {
      pedidosPendentes = pendentes;
      pedidosCancelados = cancelados;
      // pedidosHistorico = ... // Busque do backend se quiser
      // pedidosFavoritos = ... // Busque do backend se quiser
    });
  }

  // Função para buscar pedidos cancelados
  Future<List<dynamic>> fetchPedidosCancelados(int idUsuario) async {
    final response = await http.get(
      Uri.parse('http://localhost:3000/pedidos/cancelados/$idUsuario'),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erro ao buscar pedidos cancelados');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(toggleTheme: widget.toggleTheme),
      drawer: const CustomDrawer(),
      body: AppBodyContainer(
        child: ListView(
          children: [
            buildPedidoSection(
              context: context,
              title: 'Pedidos Pendentes',
              pedidos: pedidosPendentes.map((pedido) => buildPedidoCard(
                context,
                pedido,
                isPendente: true,
                onCancelado: () {
                  setState(() {
                    pedidosPendentes.removeWhere((p) => p['id_pedido'] == pedido['id_pedido']);
                    pedidosCancelados.insert(0, pedido);
                  });
                },
              )).toList(),
            ),
            buildPedidoSection(
              context: context,
              title: 'Pedidos Cancelados',
              pedidos: pedidosCancelados.map((pedido) => buildPedidoCard(context, pedido)).toList(),
            ),
            buildPedidoSection(
              context: context,
              title: 'Histórico de Pedidos',
              pedidos: pedidosHistorico.map((pedido) => buildPedidoCard(context, pedido)).toList(),
            ),
            buildPedidoSection(
              context: context,
              title: 'Pedidos Favoritos',
              pedidos: pedidosFavoritos.map((pedido) => buildPedidoCard(context, pedido)).toList(),
            ),
          ],
        ),
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

    // Adiciona estrela apenas para "Pedidos Favoritos"
    final bool isFavoritos = title == 'Pedidos Favoritos';

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Row(
          children: [
            if (isFavoritos)
              const Icon(Icons.star, color: Colors.amber, size: 26),
            if (isFavoritos)
              const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: isDarkMode ? AppColors.laranja : AppColors.preto,
                fontFamily: 'BebasNeue',
              ),
            ),
          ],
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

  // Card visual de cada pedido
  Widget buildPedidoCard(BuildContext context, dynamic pedido, {bool isPendente = false, VoidCallback? onCancelado}) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      color: Colors.grey[850],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pedido #${pedido['id_pedido']}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                fontFamily: 'BebasNeue',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Data/Hora retirada: ${pedido['data_retirada']} às ${pedido['horario_retirada']}',
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
            Text(
              'Status do pagamento: ${pedido['status_pagamento'] ?? "Pendente"}',
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 12),
            ...((pedido['produtos'] as List).map((produto) {
              final double precoUnit = double.tryParse(produto['preco_unitario'].toString()) ?? 0.0;
              final int qtd = int.tryParse(produto['quantidade'].toString()) ?? 0;
              final double precoTotal = precoUnit * qtd;
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        produto['imagem'],
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            produto['nome'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                'Qtd: $qtd',
                                style: const TextStyle(color: Colors.white70, fontSize: 14),
                              ),
                              if (produto['estado'] != null && produto['estado'] != '')
                                Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.orange[700],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      produto['estado'],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Total do produto: R\$ ${precoTotal.toStringAsFixed(2)}',
                            style: const TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            })).toList(),
            const Divider(height: 24, color: Colors.white24),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Total: R\$ ${double.tryParse(pedido['valor_total'].toString())?.toStringAsFixed(2) ?? pedido['valor_total']}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
            if (isPendente) ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[700],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    icon: const Icon(Icons.cancel, color: Colors.white),
                    label: const Text("Cancelar Pedido", style: TextStyle(color: Colors.white)),
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text("Cancelar pedido"),
                          content: const Text("Deseja cancelar este pedido?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text("Não"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text("Sim"),
                            ),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        // Chame o backend para cancelar o pedido
                        final response = await http.post(
                          Uri.parse('http://localhost:3000/pedidos/cancelar'),
                          headers: {'Content-Type': 'application/json'},
                          body: jsonEncode({"id_pedido": pedido['id_pedido']}),
                        );
                        if (response.statusCode == 200) {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text("Pedido cancelado"),
                              content: const Text("Seu pedido foi cancelado com sucesso!"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    if (onCancelado != null) onCancelado();
                                  },
                                  child: const Text("OK"),
                                ),
                              ],
                            ),
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text("Erro"),
                              content: const Text("Não foi possível cancelar o pedido. Tente novamente."),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text("OK"),
                                ),
                              ],
                            ),
                          );
                        }
                      }
                    },
                  ),
                  // Aqui você pode adicionar o botão de modificar data/hora se desejar
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<List<dynamic>> fetchPedidosPendentes(int idUsuario) async {
    final response = await http.get(
      Uri.parse('http://localhost:3000/pedidos/pendentes/$idUsuario'),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erro ao buscar pedidos pendentes');
    }
  }
}
