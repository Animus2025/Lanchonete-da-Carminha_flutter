import 'package:flutter/material.dart';
import 'package:lanchonetedacarminha/ui/widgets/custom_app_bar.dart';
import 'package:lanchonetedacarminha/ui/themes/app_theme.dart';
import 'package:lanchonetedacarminha/ui/widgets/custom_drawer.dart';
import 'package:lanchonetedacarminha/providers/cart_provider.dart';
import 'package:lanchonetedacarminha/ui/widgets/AppBodyConteiner.dart';
import 'package:provider/provider.dart';

// Tela de revisão do pedido
class RevisaoPedido extends StatelessWidget {
  final VoidCallback toggleTheme;

  const RevisaoPedido({super.key, required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final stepTextColor = isDark ? AppColors.laranja : Colors.black;

    // Obtém os itens do carrinho do provider
    final cartItems = context.watch<CartProvider>().items;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      appBar: CustomAppBar(toggleTheme: toggleTheme), // Barra superior customizada
      drawer: const CustomDrawer(), // Menu lateral
      body: AppBodyContainer(
        // Container centralizado e responsivo
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Barra de progresso customizada
            Padding(
              padding: const EdgeInsets.only(top: 16, left: 8, right: 8, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStep('1', 'REVER PEDIDO', true, stepTextColor),
                  _buildStep('2', 'FINALIZAR PEDIDO', false, stepTextColor),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: LinearProgressIndicator(
                value: 0.5,
                backgroundColor: Colors.grey[200],
                color: AppColors.laranja,
                minHeight: 3,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Divider(
                thickness: 1,
                height: 24,
                color: isDark ? AppColors.laranja : Colors.black,
              ),
            ),
            const SizedBox(height: 24),

            // Cabeçalho da Tabela
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'PRODUTO',
                          style: TextStyle(
                            fontSize: 15,
                            color: stepTextColor,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'QUANTIDADE',
                        style: TextStyle(
                          fontSize: 15,
                          color: stepTextColor,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'PREÇO',
                          style: TextStyle(
                            fontSize: 15,
                            color: stepTextColor,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Lista de Itens
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return _buildCartItem(context, item, index, isMobile, screenWidth);
                },
              ),
            ),

            const SizedBox(height: 16),

            // Total do Pedido
            _buildTotalBox(cartItems, isDark, isMobile),

            const SizedBox(height: 16),

            // Botões
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: _buttonStyle(isDark, isMobile),
                    icon: Icon(Icons.arrow_back, color: AppColors.laranja, size: isMobile ? 18 : 24),
                    label: Text(
                      'CONTINUAR COMPRANDO',
                      style: _buttonTextStyle(isMobile),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    style: _buttonStyle(isDark, isMobile),
                    child: Text(
                      'FINALIZAR PEDIDO',
                      style: _buttonTextStyle(isMobile),
                    ),
                    onPressed: () {
                      // Implementar ação de finalizar pedido
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // COMPONENTES AUXILIARES

  Widget _buildStep(String number, String label, bool active, Color color) {
    return Column(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: active ? AppColors.laranja : AppColors.laranja.withOpacity(0.5),
          child: Text(
            number,
            style: const TextStyle(
              color: AppColors.preto,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: color,
          ),
        ),
      ],
    );
  }

  ButtonStyle _buttonStyle(bool isDark, bool isMobile) {
    return ElevatedButton.styleFrom(
      backgroundColor: AppColors.preto,
      padding: EdgeInsets.symmetric(vertical: isMobile ? 8 : 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isMobile ? 6 : 8),
      ),
    );
  }

  TextStyle _buttonTextStyle(bool isMobile) {
    return TextStyle(
      color: AppColors.laranja,
      fontWeight: FontWeight.bold,
      fontSize: isMobile ? 13 : 15,
    );
  }

  Widget _buildTotalBox(List cartItems, bool isDark, bool isMobile) {
    final total = cartItems.fold<double>(
        0, (sum, item) => sum + item.preco * item.quantidade);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 8 : 12,
        horizontal: isMobile ? 8 : 12,
      ),
      decoration: BoxDecoration(
        color: isDark ? Colors.transparent : Colors.white,
        border: Border.all(color: isDark ? AppColors.laranja : Colors.black, width: 1),
        borderRadius: BorderRadius.circular(isMobile ? 6 : 8),
      ),
      child: Column(
        children: [
          Text(
            'TOTAL DO PEDIDO',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isMobile ? 15 : 18,
              color: isDark ? AppColors.laranja : Colors.black,
            ),
          ),
          const SizedBox(height: 6),
          Divider(
            color: isDark ? AppColors.laranja : Colors.black,
            thickness: 1,
            height: 8,
          ),
          const SizedBox(height: 6),
          Text(
            'R\$ ${total.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isMobile ? 20 : 24,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, dynamic item, int index, bool isMobile, double screenWidth) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: AppColors.preto,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.symmetric(vertical: isMobile ? 2 : 4),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Imagem
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: SizedBox(
                width: isMobile ? screenWidth * 0.22 : 120,
                height: isMobile ? screenWidth * 0.22 : 120,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    item.imagem,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: AppColors.cinza,
                      child: const Icon(Icons.image_not_supported),
                    ),
                  ),
                ),
              ),
            ),
            // Nome e tags
            Expanded(
              flex: 16,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.nome,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 20),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: item.tags.map<Widget>((tag) {
                          Color tagColor;
                          if (tag.toUpperCase() == 'FRITO') {
                            tagColor = AppColors.laranja;
                          } else if (tag.toUpperCase() == 'CONGELADO') {
                            tagColor = Colors.blue[200]!;
                          } else {
                            tagColor = Colors.grey[300]!;
                          }
                          return Container(
                            margin: const EdgeInsets.only(right: 6),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: tagColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              tag,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Botões de quantidade
            SizedBox(
              width: isMobile ? 20 : 110,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.add, color: AppColors.laranja),
                    onPressed: () => context.read<CartProvider>().increaseQuantity(index),
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                  ),
                  Text(
                    '${item.quantidade}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.remove,
                      color: item.isBebida
                          ? (item.quantidade > 1 ? AppColors.laranja : AppColors.laranja.withOpacity(0.4))
                          : (item.quantidade > 5 ? AppColors.laranja : AppColors.laranja.withOpacity(0.4)),
                    ),
                    onPressed: item.isBebida
                        ? (item.quantidade > 1
                            ? () => context.read<CartProvider>().decreaseQuantity(index)
                            : null)
                        : (item.quantidade > 5
                            ? () => context.read<CartProvider>().decreaseQuantity(index)
                            : null),
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 2),
                ],
              ),
            ),
            // Preço
            Flexible(
              flex: 15,
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'R\$ ${(item.preco * item.quantidade).toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      overflow: TextOverflow.ellipsis,
                    ),
                    softWrap: false,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}