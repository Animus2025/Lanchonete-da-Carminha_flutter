import 'produto.dart';

class Bebida extends Produto {
  final double volume;
  final double preco;

  Bebida({
    required String nome,
    required String imagem,
    required this.volume,
    required this.preco,
  }) : super(nome: nome, imagem: imagem);
}

final List<Bebida> bebidas = [
  Bebida(
    nome: 'Coca-Cola 2 litros',
    imagem: 'assets/imagens/coca2litros.jpg',
    preco: 14.00,
    volume: 2000,
  ),
  Bebida(
    nome: 'Guaraná 2 litros',
    imagem: 'assets/imagens/coca2litros.jpg',
    preco: 12.00,
    volume: 2000,
  ),
  Bebida(
    nome: 'Cola-cola 600ml',
    imagem: 'assets/imagens/coca2litros.jpg',
    preco: 7.50,
    volume: 600,
  ),
  Bebida(
    nome: 'Guaraná 1 litro',
    imagem: 'assets/imagens/coca2litros.jpg',
    preco: 7.00,
    volume: 1000,
  ),
];
