import 'package:flutter/material.dart';
import 'package:lanchonetedacarminha/ui/themes/app_theme.dart';
import 'package:provider/provider.dart';
import '/providers/cart_provider.dart';

class CartOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.items;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleAndTotalColor = isDark ? AppColors.laranja : Colors.black;
    final iconColor = AppColors.laranja;
    final quantityAndPriceColor = Colors.white;


    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      minChildSize: 0.4,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.only(top: 12),
          decoration: BoxDecoration(
            color: isDark ? AppColors.pretoClaro : Colors.white,
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
              // Cabeçalho
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
                    TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => Dialog(
                            backgroundColor: Colors.transparent,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.pretoClaro : Colors.grey[200], // Ajuste aqui
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(height: 16),
                                  Text(
                                    "DESEJA LIMPAR O CARRINHO ?",
                                    style: TextStyle(
                                      color: isDark ? AppColors.laranja : Colors.grey, // Texto claro no dark
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      letterSpacing: 1,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 32),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.black,
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
                                      Expanded(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.black,
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
                      },
                      child: Text(
                        "LIMPAR",
                        style: TextStyle(
                          fontSize: 25,
                          color: titleAndTotalColor, // Preto no claro, laranja no escuro
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(color: isDark ? Colors.white24 : Colors.black12),

              // Lista de Itens ou Carrinho vazio
              Expanded(
                child: cartItems.isEmpty
                    ? Center(
                        child: Text(
                          "Seu carrinho está vazio",
                          style: TextStyle(
                            fontSize: 18,
                            color: isDark ? AppColors.laranja : AppColors.pretoClaro, // pretoClaro no claro, padrão no escuro
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
                                crossAxisAlignment: CrossAxisAlignment.center, // Centraliza verticalmente
                                children: [
                                  // Imagem
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
                                                color: Colors.black,
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
                                              color: Colors.grey[300],
                                              child: const Icon(Icons.image_not_supported),
                                            ),
                                          ),
                                  ),
                                  const SizedBox(width: 10),
                                  // Infos do produto
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center, // Centraliza verticalmente os textos
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.nome,
                                          style: TextStyle(
                                            color: AppColors.laranja,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                        Text(
                                          "R\$ ${(item.preco * item.quantidade).toStringAsFixed(2)}",
                                          style: TextStyle(
                                            color: quantityAndPriceColor,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
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
                                                  color: AppColors.preto, // Sempre preto
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                        TextButton(
                                          onPressed: () => cartProvider.removeItem(index),
                                          style: TextButton.styleFrom(
                                            foregroundColor: AppColors.laranja, // Sempre laranja
                                          ),
                                          child: const Text(
                                            "REMOVER",
                                            style: TextStyle(
                                              fontSize: 18, // Aumente o valor conforme desejar
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Quantidade e editar
                                  SizedBox(
                                    width: 40, // largura fixa para evitar overflow
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center, // Centraliza verticalmente os botões
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
                                            color: quantityAndPriceColor, // sempre branco
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.remove, size: 18, color: iconColor),
                                          onPressed: () => cartProvider.decreaseQuantity(index),
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

              // Rodapé com total e botão
              Container(
                color: isDark ? AppColors.pretoClaro : Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // TOTAL primeiro
                    Text(
                      "TOTAL: R\$ ${cartProvider.total.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: titleAndTotalColor, // Preto no claro, laranja no escuro
                      ),
                    ),
                    // Botão depois
                    ElevatedButton(
                      onPressed: () {
                        // ação finalizar
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "FINALIZAR PEDIDO",
                        style: TextStyle(fontSize: 20, color: AppColors.laranja),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
