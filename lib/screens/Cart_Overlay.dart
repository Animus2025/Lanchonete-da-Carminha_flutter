import 'package:flutter/material.dart';
import 'package:lanchonetedacarminha/ui/themes/app_theme.dart';
import 'package:provider/provider.dart';
import '/providers/cart_provider.dart';


// Widget que exibe o overlay do carrinho
class CartOverlay extends StatelessWidget {
  const CartOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtém o provider do carrinho e informações de tema
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.items;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleAndTotalColor = isDark ? AppColors.laranja : AppColors.preto;
    final iconColor = AppColors.laranja;
    final quantityAndPriceColor = AppColors.branco;

    // GestureDetector externo fecha o overlay ao clicar fora
    return GestureDetector(
      behavior: HitTestBehavior.opaque, // Captura toques fora do overlay
      onTap: () => Navigator.of(context).pop(),
      child: DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        builder: (context, scrollController) {
          // GestureDetector interno impede que o tap dentro feche o overlay
          return GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.pretoClaro : AppColors.branco,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  // Indicador de arraste
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Center(
                      child: Container(
                        width: 40,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  // Cabeçalho com título e botão de limpar carrinho
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "SEU CARRINHO",
                          style: TextStyle(
                            fontSize: 25,
                            color: titleAndTotalColor, // Preto no claro, laranja no escuro
                          ),
                        ),
                        // Botão LIMPAR só habilitado se houver itens no carrinho
                        TextButton(
                          onPressed: cartItems.isNotEmpty
                              ? () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => Dialog(
                                      backgroundColor: Colors.transparent,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                                        decoration: BoxDecoration(
                                          color: isDark ? AppColors.pretoClaro : AppColors.branco,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const SizedBox(height: 16),
                                            Text(
                                              "DESEJA LIMPAR O CARRINHO ?",
                                              style: TextStyle(
                                                color: isDark ? AppColors.laranja : AppColors.preto,
                                                fontSize: 20,
                                                letterSpacing: 1,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(height: 32),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                // Botão cancelar
                                                Expanded(
                                                  child: ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: AppColors.preto,
                                                      foregroundColor: AppColors.laranja,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(8),
                                                      ),
                                                    ),
                                                    onPressed: () => Navigator.of(context).pop(),
                                                    child: const Text(
                                                      "CANCELAR",
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 18,
                                                        letterSpacing: 1,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 16),
                                                // Botão SIM limpa o carrinho
                                                Expanded(
                                                  child: ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: AppColors.preto,
                                                      foregroundColor: AppColors.laranja,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(8),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      cartProvider.clearCart();
                                                      Navigator.of(context).pop();
                                                    },
                                                    child: const Text(
                                                      "SIM",
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 18,
                                                        letterSpacing: 1,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              : null, // Desabilita se carrinho vazio
                          child: Text(
                            "LIMPAR",
                            style: TextStyle(
                              fontSize: 25,
                              color: cartItems.isNotEmpty
                                  ? titleAndTotalColor
                                  : titleAndTotalColor.withOpacity(0.4), // Apaga se vazio
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(color: isDark ? Colors.white24 : Colors.black12),

                  // Lista de Itens ou mensagem de carrinho vazio
                  Expanded(
                    child: cartItems.isEmpty
                        ? Center(
                            child: Text(
                              "Seu carrinho está vazio",
                              style: TextStyle(
                                fontSize: 18,
                                color: isDark ? AppColors.laranja : AppColors.pretoClaro,
                              ),
                            ),
                          )
                        : ListView.builder(
                            controller: scrollController,
                            itemCount: cartItems.length,
                            itemBuilder: (context, index) {
                              final item = cartItems[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: AppColors.preto),
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      // Imagem do produto
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: item.nome.toLowerCase().contains('coca') && item.nome.contains('2')
                                            ? Container(
                                                width: 140,
                                                height: 140,
                                                color: Colors.black,
                                                alignment: Alignment.center,
                                                child: Image.asset(
                                                  item.imagem,
                                                  width: 70,
                                                  height: 140,
                                                  fit: BoxFit.contain,
                                                  errorBuilder: (context, error, stackTrace) => Container(
                                                    width: 70,
                                                    height: 140,
                                                    color: AppColors.preto,
                                                    child: const Icon(Icons.image_not_supported),
                                                  ),
                                                ),
                                              )
                                            : Image.asset(
                                                item.imagem,
                                                width: 140,
                                                height: 140,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error, stackTrace) => Container(
                                                  width: 90,
                                                  height: 90,
                                                  color: AppColors.cinza,
                                                  child: const Icon(Icons.image_not_supported),
                                                ),
                                              ),
                                      ),
                                      const SizedBox(width: 10),
                                      // Informações do produto
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // Nome do produto
                                            Text(
                                              item.nome,
                                              style: TextStyle(
                                                color: AppColors.laranja,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            ),
                                            // Preço total do item (preço x quantidade)
                                            Text(
                                              "R\$ ${(item.preco * item.quantidade).toStringAsFixed(2)}",
                                              style: TextStyle(
                                                color: quantityAndPriceColor,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            // Tags do produto (ex: frito, assado)
                                            Row(
                                              children: item.tags.map<Widget>((tag) {
                                                final color = tag.toLowerCase() == 'frito'
                                                    ? AppColors.laranja
                                                    : AppColors.azulClaro;
                                                return Container(
                                                  margin: const EdgeInsets.only(right: 8),
                                                  padding: const EdgeInsets.symmetric(
                                                      horizontal: 8, vertical: 4),
                                                  decoration: BoxDecoration(
                                                    color: color,
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  child: Text(
                                                    tag.toUpperCase(),
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.bold,
                                                      color: AppColors.preto,
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                            // Botão para remover o item do carrinho
                                            TextButton(
                                              onPressed: () => cartProvider.removeItem(index),
                                              style: TextButton.styleFrom(
                                                foregroundColor: AppColors.laranja,
                                              ),
                                              child: const Text(
                                                "REMOVER",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Coluna de quantidade e botões de ajuste
                                      SizedBox(
                                        width: 40,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              icon: Icon(Icons.add, size: 18, color: iconColor),
                                              onPressed: () => cartProvider.increaseQuantity(index),
                                            ),
                                            Text(
                                              '${item.quantidade}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 25,
                                                color: quantityAndPriceColor,
                                              ),
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                Icons.remove,
                                                size: 18,
                                                color: (item.isBebida ? item.quantidade > 1 : item.quantidade > 5)
                                                    ? iconColor
                                                    : iconColor.withOpacity(0.4), // Esmaece se mínimo
                                              ),
                                              onPressed: (item.isBebida ? item.quantidade > 1 : item.quantidade > 5)
                                                  ? () => cartProvider.decreaseQuantity(index)
                                                  : null, // Desabilita se mínimo
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),

                  // Rodapé com total e botão de finalizar pedido
                  Container(
                    color: isDark ? AppColors.pretoClaro : AppColors.branco,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Total do carrinho
                        Text(
                          "TOTAL: R\$ ${cartProvider.total.toStringAsFixed(2)}",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: titleAndTotalColor,
                          ),
                        ),
                        // Botão de finalizar pedido
                        ElevatedButton(
                          onPressed: cartItems.isNotEmpty
                              ? () {
                                  Navigator.pushNamed(context, '/revisao_pedido');
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.preto,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            "FINALIZAR PEDIDO",
                            style: TextStyle(
                              fontSize: 20,
                              color: cartItems.isNotEmpty
                                  ? AppColors.laranja
                                  : AppColors.laranja.withOpacity(0.4), // Esmaece o texto se desabilitado
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
