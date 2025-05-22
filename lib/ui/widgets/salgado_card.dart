import 'package:flutter/material.dart';
import '../../models/salgado.dart';
import 'produto_card_base.dart';
import '../../controllers/salgado_card_controller.dart';
import '../../providers/cart_provider.dart';
import '../../models/cart_item.dart';
import 'package:provider/provider.dart';

// Widget de card para exibir um salgado com controles de quantidade e tipo de preparo
class SalgadoCard extends StatefulWidget {
  final Salgado salgado; // O salgado que será exibido neste card

  const SalgadoCard({super.key, required this.salgado});

  @override
  State<SalgadoCard> createState() => _SalgadoCardState();
}

class _SalgadoCardState extends State<SalgadoCard> {
  late SalgadoCardController controller; // Controller para lógica do card

  @override
  void initState() {
    super.initState();
    // Inicializa o controller com o salgado recebido
    controller = SalgadoCardController(salgado: widget.salgado);
  }

  // Função auxiliar para atualizar o estado do widget
  void atualizarEstado(VoidCallback fn) {
    setState(fn);
  }

  // Mostra um modal para escolher rapidamente a quantidade em dezenas (5, 10, 20, ..., 500)
  void _showQuantidadePicker() async {
    final result = await showModalBottomSheet<int>(
      context: context,
      builder: (context) {
        return ListView.builder(
          itemCount: 51, // 5, 10, 20, ..., 500 (total 51 opções)
          itemBuilder: (context, index) {
            int value = index == 0 ? 5 : index * 10; // Primeiro valor é 5, depois de 10 em 10
            return ListTile(
              title: Text('$value'),
              onTap: () {
                Navigator.pop(context, value); // Retorna o valor escolhido
              },
            );
          },
        );
      },
    );
    if (result != null) {
      atualizarEstado(() {
        controller.quantidade = result; // Atualiza a quantidade escolhida
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double largura = constraints.maxWidth; // Largura disponível do card
        double iconSize = largura * 0.045;     // Tamanho dos ícones
        double buttonMin = largura * 0.11;     // Tamanho mínimo dos botões
        double fontSize = largura * 0.045;     // Tamanho da fonte base

        // Widget para escolher o tipo de preparo (frito ou congelado)
        Widget chipsPreparo() => Row(
          children: [
            // Chip para "FRITO" ou "ASSADO"
            ChoiceChip(
              label: Text(
                controller.salgado.categoria == 'assado' ? "ASSADO" : "FRITO", // Troca o texto dinamicamente
                style: TextStyle(
                  color: controller.tipoSelecionado == TipoPreparo.frito
                      ? Colors.black // Cor preta se selecionado
                      : Colors.white, // Cor branca se não selecionado
                  fontSize: fontSize * 0.85, // Tamanho da fonte
                ),
              ),
              selected: controller.tipoSelecionado == TipoPreparo.frito,
              selectedColor: Colors.orange, // Cor de fundo quando selecionado
              backgroundColor: Colors.grey[900], // Cor de fundo padrão
              onSelected: (selected) {
                atualizarEstado(() {
                  controller.trocarTipo(TipoPreparo.frito); // Troca o tipo no controller
                });
              },
              labelPadding: EdgeInsets.symmetric(
                horizontal: fontSize * 0.3,
                vertical: fontSize * 0.12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            SizedBox(width: largura * 0.015), // Espaço entre os chips
            // Chip para "CONGELADO"
            ChoiceChip(
              label: Text(
                "CONGELADO",
                style: TextStyle(
                  color: controller.tipoSelecionado == TipoPreparo.congelado
                      ? Colors.black
                      : Colors.white,
                  fontSize: fontSize * 0.85,
                ),
              ),
              selected: controller.tipoSelecionado == TipoPreparo.congelado,
              selectedColor: Colors.orange,
              backgroundColor: Colors.grey[900],
              onSelected: (selected) {
                atualizarEstado(() {
                  controller.trocarTipo(TipoPreparo.congelado);
                });
              },
              labelPadding: EdgeInsets.symmetric(
                horizontal: fontSize * 0.3,
                vertical: fontSize * 0.12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        );

        // Widget para controle de quantidade (+, -, picker)
        Widget quantidadeWidget() => Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 48, 47, 47),
            borderRadius: BorderRadius.circular(4),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: largura * 0.005,
            vertical: 1,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Botão de diminuir quantidade
              IconButton(
                icon: Icon(Icons.remove, size: iconSize, color: Colors.white),
                constraints: BoxConstraints(
                  minWidth: buttonMin * 0.8,
                  minHeight: buttonMin * 0.8,
                ),
                padding: EdgeInsets.zero,
                // Só permite diminuir se quantidade > 5 e não for múltiplo de 10
                onPressed: (controller.quantidade >
                                ((controller.quantidade ~/ 10) * 10) &&
                            controller.quantidade > 5)
                        ? () => atualizarEstado(() => controller.decrementar())
                        : null,
                splashRadius: buttonMin / 2,
              ),
              // Exibe a quantidade atual
              Padding(
                padding: EdgeInsets.symmetric(horizontal: largura * 0.005),
                child: Text(
                  '${controller.quantidade}',
                  style: TextStyle(color: Colors.white, fontSize: fontSize),
                ),
              ),
              // Botão de aumentar quantidade
              IconButton(
                icon: Icon(Icons.add, size: iconSize, color: Colors.white),
                constraints: BoxConstraints(
                  minWidth: buttonMin * 0.8,
                  minHeight: buttonMin * 0.8,
                ),
                padding: EdgeInsets.zero,
                // Só permite aumentar se não passar do próximo múltiplo de 10 e menor que 2000
                onPressed: (controller.quantidade <
                                ((controller.quantidade ~/ 10) * 10 + 9) &&
                            controller.quantidade < 2000)
                        ? () => atualizarEstado(() => controller.incrementar())
                        : null,
                splashRadius: buttonMin / 2,
              ),
              // Botão para abrir o picker de dezenas
              IconButton(
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.white,
                  size: iconSize + 2,
                ),
                constraints: BoxConstraints(
                  minWidth: buttonMin * 0.8,
                  minHeight: buttonMin * 0.8,
                ),
                padding: EdgeInsets.zero,
                onPressed: _showQuantidadePicker,
                splashRadius: buttonMin / 2,
              ),
            ],
          ),
        );

        // Monta o card base do produto, passando os widgets de quantidade e preparo
        return ProdutoCardBase(
          nome: controller.salgado.nome,
          imagem: controller.salgado.imagem,
          precoTotal: controller.precoTotal,
          quantidadeWidget: quantidadeWidget(),
          extraWidget: chipsPreparo(), // Chips de preparo aparecem abaixo do nome
          onAdicionar: () {
            Provider.of<CartProvider>(context, listen: false).addItem(
              CartItem(
                nome: controller.salgado.nome,
                preco: controller.precoUnitario,
                imagem: controller.salgado.imagem,
                tags: [controller.tipoSelecionado == TipoPreparo.frito ? 'Frito' : 'Congelado'],
                quantidade: controller.quantidade,
                isBebida: false,
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
