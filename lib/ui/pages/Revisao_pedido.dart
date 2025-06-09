import 'package:flutter/material.dart';
import 'package:lanchonetedacarminha/ui/widgets/custom_app_bar.dart';
import 'package:lanchonetedacarminha/ui/themes/app_theme.dart';
import 'package:lanchonetedacarminha/ui/widgets/custom_drawer.dart';
import 'package:provider/provider.dart';
import 'package:lanchonetedacarminha/providers/cart_provider.dart';

class RevisaoPedido extends StatelessWidget {
  final VoidCallback toggleTheme;

  const RevisaoPedido({super.key, required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final stepTextColor = isDark ? AppColors.laranja : Colors.black;

    // Pegue os itens do carrinho do Provider
    final cartItems = context.watch<CartProvider>().items;

    return Scaffold(
      appBar: CustomAppBar(toggleTheme: toggleTheme),
      drawer: CustomDrawer(),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Barra de progresso customizada
          Padding(
            padding: const EdgeInsets.only(top: 16, left: 24, right: 24, bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Passo 1
                Column(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: AppColors.laranja,
                      child: Text(
                        '1',
                        style: const TextStyle(
                          color: AppColors.preto,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'REVER PEDIDO',
                      style: TextStyle(
                        fontSize: 13,
                        color: stepTextColor,
                      ),
                    ),
                  ],
                ),
                // Passo 2
                Column(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.grey[200],
                      child: Text(
                        '2',
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'FINALIZAR PEDIDO',
                      style: TextStyle(
                        fontSize: 13,
                        color: stepTextColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Linha de progresso
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: LinearProgressIndicator(
              value: 0.5, // 50% (primeiro passo)
              backgroundColor: Colors.grey[200],
              color: AppColors.laranja,
              minHeight: 3,
            ),
          ),
          // Altere o Divider para também usar Padding:
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Divider(
              thickness: 1,
              height: 24,
              color: isDark ? AppColors.laranja : Colors.black,
            ),
          ),
          const SizedBox(height: 24),
          // Conteúdo da página
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  // Adicionando o cabeçalho da tabela
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
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
                          flex: 2,
                          child: Center(
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
                  const SizedBox(height: 12), // Adicione este espaçamento logo após o cabeçalho
                  Expanded(
                    child: ListView.builder(
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final item = cartItems[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: AppColors.preto,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: IntrinsicHeight( // Adicione este widget para garantir altura mínima
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // PRODUTO
                                Expanded(
                                  flex: 3,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SizedBox(
                                          width: 80,
                                          height: 80,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: Image.network(
                                              item.imagem,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      // O resto do conteúdo do produto
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item.nome,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  overflow: TextOverflow.ellipsis, // Evita overflow
                                                ),
                                                maxLines: 2, // Limita linhas do nome
                                              ),
                                              const SizedBox(height: 4),
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
                                    ],
                                  ),
                                ),
                                // QUANTIDADE
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
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
                                          ),
                                          SizedBox(
                                            width: 20, // Garante espaço para até 3 dígitos
                                            child: Center(
                                              child: Text(
                                                '${item.quantidade}',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.add, color: AppColors.laranja),
                                            onPressed: () {
                                              context.read<CartProvider>().increaseQuantity(index);
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                // PREÇO
                                Expanded(
                                  flex: 2,
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
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
