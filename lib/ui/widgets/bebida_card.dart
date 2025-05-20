import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/bebida.dart';
import 'produto_card_base.dart';
import '../../controllers/bebida_card_controller.dart';
import '../../providers/cart_provider.dart';
import '../../models/cart_item.dart';

class BebidaCard extends StatefulWidget {
  final Bebida bebida;

  const BebidaCard({super.key, required this.bebida});

  @override
  State<BebidaCard> createState() => _BebidaCardState();
}

class _BebidaCardState extends State<BebidaCard> {
  late BebidaCardController controller;

  @override
  void initState() {
    super.initState();
    controller = BebidaCardController(bebida: widget.bebida);
  }

  @override
  Widget build(BuildContext context) {
    final bebida = widget.bebida;

    // Widget do seletor de quantidade (apenas + e -)
    Widget quantidadeWidget(double fontSize, double largura) => Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 48, 47, 47),
        borderRadius: BorderRadius.circular(4),
      ),
      padding: EdgeInsets.symmetric(horizontal: largura * 0.01, vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove, color: Colors.white, size: 18),
            onPressed: controller.quantidade > 1
                ? () => setState(() => controller.decrementar())
                : null,
            splashRadius: 16,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            padding: EdgeInsets.zero,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '${controller.quantidade}',
              style: TextStyle(color: Colors.white, fontSize: fontSize),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white, size: 18),
            onPressed: controller.quantidade < 20
                ? () => setState(() => controller.incrementar())
                : null,
            splashRadius: 16,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        double largura = constraints.maxWidth;
        double fontSize = largura * 0.045;

        return ProdutoCardBase(
          nome: bebida.nome,
          imagem: bebida.imagem,
          precoTotal: controller.precoTotal,
          quantidadeWidget: quantidadeWidget(fontSize, largura),
          extraWidget: null, // Bebida não tem chips de preparo
          onAdicionar: () {
            Provider.of<CartProvider>(context, listen: false).addItem(
              CartItem(
                nome: controller.bebida.nome,
                preco: controller.bebida.preco,
                imagem: controller.bebida.imagem,
                quantidade: controller.quantidade,
                tags: [], // Bebida não possui tags, então passa uma lista vazia
                isBebida: true, // Indica que este item é uma bebida
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Produto adicionado ao carrinho!')),
            );
          },
        );
      },
    );
  }
}
