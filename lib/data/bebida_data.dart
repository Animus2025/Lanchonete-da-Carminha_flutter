import '../models/bebida.dart';

/// Lista de bebidas disponíveis no aplicativo.
/// Cada bebida é representada por uma instância da classe Bebida,
/// contendo nome, caminho da imagem, preço e volume em ml.
final List<Bebida> bebidas = [
  Bebida(
    nome: 'Coca-Cola 2 litros', // Nome da bebida
    imagem: 'lib/assets/produtos/coca2l.png', // Caminho da imagem da bebida
    preco: 14.00, // Preço em reais
    volume: 2000, // Volume em ml
  ),
  Bebida(
    nome: 'Guaraná 2 litros',
    imagem: 'lib/assets/produtos/guarana2l.png',
    preco: 12.00,
    volume: 2000,
  ),
  Bebida(
    nome: 'Cola-cola 600ml',
    imagem: 'lib/assets/produtos/coca600ml.png',
    preco: 7.50,
    volume: 600,
  ),
  Bebida(
    nome: 'Guaraná 1 litro',
    imagem: 'lib/assets/produtos/guarana1l.png',
    preco: 7.00,
    volume: 1000,
  ),
];
