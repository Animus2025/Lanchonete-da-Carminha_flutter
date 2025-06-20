import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/salgado.dart';
import 'package:flutter/material.dart';

// Função para buscar salgados do backend
Future<List<Salgado>> fetchSalgados() async {
  final response = await http.get(
    Uri.parse(
      'http://localhost:3000/produto/salgados',
    ), // ajuste a rota conforme seu backend
  );

  print('Status: ${response.statusCode}');
  print('Body: ${response.body}');

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => Salgado.fromJson(json)).toList();
  } else {
    throw Exception('Falha ao carregar salgados');
  }
}

class SalgadoList extends StatelessWidget {
  const SalgadoList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Salgado>>(
      future: fetchSalgados(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erro: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Nenhum salgado encontrado.'));
        }
        final salgados = snapshot.data!;
        final categorias = salgados.map((s) => s.categoria).toSet().toList();

        return ListView(
          children:
              categorias.map((categoria) {
                final itens =
                    salgados.where((s) => s.categoria == categoria).toList();
                return ExpansionTile(
                  title: Text(categoria.toUpperCase()),
                  children:
                      itens
                          .map(
                            (salgado) => ListTile(
                              title: Text(salgado.nome),
                              subtitle: Text(
                                '${salgado.categoria} - ${salgado.tipoProduto}',
                              ),
                              trailing: Text(
                                salgado.estado == 'pronto'
                                    ? 'R\$ ${salgado.precoPronto?.toStringAsFixed(2) ?? '-'}'
                                    : 'R\$ ${salgado.precoCongelado?.toStringAsFixed(2) ?? '-'}',
                              ),
                            ),
                          )
                          .toList(),
                );
              }).toList(),
        );
      },
    );
  }
}
