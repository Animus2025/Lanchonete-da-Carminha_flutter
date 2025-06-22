import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/bebida.dart';

// Função para buscar bebidas do backend
Future<List<Bebida>> fetchBebidas() async {
  final response = await http.get(
    Uri.parse(
      'http://localhost:3000/produto/bebidas',
    ), // ajuste a rota conforme seu backend
  );

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => Bebida.fromJson(json)).toList();
  } else {
    throw Exception('Falha ao carregar bebidas');
  }
}
