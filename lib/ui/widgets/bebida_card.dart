import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/bebida.dart';
import 'produto_card_base.dart';
import '../../controllers/bebida_card_controller.dart';
import '../../providers/cart_provider.dart';
import '../../models/cart_item.dart';

// Widget de card para exibir uma bebida com controles de quantidade
class BebidaCard extends StatefulWidget {
  final Bebida bebida; // A bebida que será exibida neste card

  const BebidaCard({super.key, required this.bebida});

  @override
  State<BebidaCard> createState() => _BebidaCardState();
}

class _BebidaCardState extends State<BebidaCard> {
  late BebidaCardController controller; // Controller para lógica do card

  @override
  void initState() {
    super.initState();
    // Inicializa o controller com a bebida recebida
    controller = BebidaCardController(bebida: widget.bebida);
  }

  @override
  Widget build(BuildContext context) {
    final bebida = widget.bebida; // Referência à bebida atual

    // Widget do seletor de quantidade (apenas botões + e -)
    Widget quantidadeWidget(double fontSize, double largura) => Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(
          255,
          48,
          47,
          47,
        ), // Cor de fundo do controle
        borderRadius: BorderRadius.circular(4), // Cantos arredondados
      ),
      padding: EdgeInsets.symmetric(
        horizontal: largura * 0.01,
        vertical: 2,
      ), // Espaçamento interno
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Botão de diminuir quantidade
          IconButton(
            icon: const Icon(Icons.remove, color: Colors.white, size: 18),
            onPressed:
                controller.quantidade > 1
                    ? () => setState(
                      () => controller.decrementar(),
                    ) // Só permite se quantidade > 1
                    : null,
            splashRadius: 16,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            padding: EdgeInsets.zero,
          ),
          // Exibe a quantidade atual
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '${controller.quantidade}',
              style: TextStyle(color: Colors.white, fontSize: fontSize),
            ),
          ),
          // Botão de aumentar quantidade
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white, size: 18),
            onPressed:
                controller.quantidade < 20
                    ? () => setState(
                      () => controller.incrementar(),
                    ) // Só permite se quantidade < 20
                    : null,
            splashRadius: 16,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );

    // Usa LayoutBuilder para adaptar o tamanho dos elementos ao espaço disponível
    return LayoutBuilder(
      builder: (context, constraints) {
        double largura = constraints.maxWidth; // Largura disponível do card
        double fontSize = largura * 0.045; // Tamanho da fonte proporcional

        // Monta o card base do produto, passando os widgets de quantidade e outros dados
        return ProdutoCardBase(
          nome: bebida.nome, // Nome da bebida
          imagem: bebida.imagem, // Caminho da imagem da bebida
          precoTotal:
              controller.precoTotal, // Preço total calculado pelo controller
          quantidadeWidget: quantidadeWidget(
            fontSize,
            largura,
          ), // Widget de quantidade
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
            // Mostra um pop-up rápido no centro
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => Dialog(
                backgroundColor: Colors.black87,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 24.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.check_circle, color: Colors.green, size: 32),
                      SizedBox(width: 12),
                      Flexible(
                        child: Text(
                          'Produto adicionado ao carrinho!',
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
            // Fecha o pop-up automaticamente após 1 segundo
            Future.delayed(const Duration(seconds: 1), () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
            });
          },
        );
      },
    );
  }
}
