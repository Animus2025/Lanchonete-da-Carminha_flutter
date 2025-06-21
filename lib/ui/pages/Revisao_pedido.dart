import 'package:flutter/material.dart';
import 'package:lanchonetedacarminha/ui/widgets/custom_app_bar.dart';
import 'package:lanchonetedacarminha/ui/themes/app_theme.dart';
import 'package:lanchonetedacarminha/ui/widgets/custom_drawer.dart';
import 'package:provider/provider.dart';
import 'package:lanchonetedacarminha/providers/cart_provider.dart';
import 'package:lanchonetedacarminha/ui/pages/finalizar_pedido_page.dart';

class RevisaoPedido extends StatelessWidget {
  final VoidCallback toggleTheme;

  const RevisaoPedido({super.key, required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final stepTextColor = isDark ? AppColors.laranja : Colors.black;

    // Pegue os itens do carrinho do Provider
    final cartItems = context.watch<CartProvider>().items;

    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      appBar: CustomAppBar(toggleTheme: toggleTheme),
      drawer: CustomDrawer(),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Barra de progresso customizada
          Padding(
            padding: const EdgeInsets.only(
              top: 16,
              left: 24,
              right: 24,
              bottom: 8,
            ),
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
                      style: TextStyle(fontSize: 13, color: stepTextColor),
                    ),
                  ],
                ),
                // Passo 2
                Column(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: AppColors.laranja.withOpacity(
                        0.5,
                      ), // Laranja esmaecido
                      child: Text(
                        '2',
                        style: TextStyle(
                          color: AppColors.preto,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'FINALIZAR PEDIDO',
                      style: TextStyle(fontSize: 13, color: stepTextColor),
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
            padding: const EdgeInsets.symmetric(horizontal: 20),
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
                          flex: 3,
                          child: Align(
                            alignment:
                                Alignment
                                    .centerRight, // Alinha o texto mais à direita
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
                  const SizedBox(
                    height: 12,
                  ), // Adicione este espaçamento logo após o cabeçalho
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
                          // Aumente o padding vertical aqui:
                          padding: EdgeInsets.symmetric(
                            vertical: isMobile ? 8 : 24,
                            horizontal: 0,
                          ),
                          child: IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Imagem
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    width: isMobile ? screenWidth * 0.22 : 120,
                                    height: isMobile ? screenWidth * 0.22 : 120,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child:
                                          item.nome.toLowerCase().contains(
                                                    'coca',
                                                  ) &&
                                                  item.nome.contains('2')
                                              ? Container(
                                                width:
                                                    isMobile
                                                        ? screenWidth * 0.22
                                                        : 140,
                                                height:
                                                    isMobile
                                                        ? screenWidth * 0.22
                                                        : 140,
                                                color: Colors.black,
                                                alignment: Alignment.center,
                                                child: Image.asset(
                                                  item.imagem,
                                                  width:
                                                      isMobile
                                                          ? screenWidth * 0.11
                                                          : 70,
                                                  height:
                                                      isMobile
                                                          ? screenWidth * 0.22
                                                          : 140,
                                                  fit: BoxFit.contain,
                                                  errorBuilder:
                                                      (
                                                        context,
                                                        error,
                                                        stackTrace,
                                                      ) => Container(
                                                        width:
                                                            isMobile
                                                                ? screenWidth *
                                                                    0.11
                                                                : 70,
                                                        height:
                                                            isMobile
                                                                ? screenWidth *
                                                                    0.22
                                                                : 140,
                                                        color: AppColors.preto,
                                                        child: const Icon(
                                                          Icons
                                                              .image_not_supported,
                                                        ),
                                                      ),
                                                ),
                                              )
                                              : Image.asset(
                                                item.imagem,
                                                width:
                                                    isMobile
                                                        ? screenWidth * 0.22
                                                        : 140,
                                                height:
                                                    isMobile
                                                        ? screenWidth * 0.22
                                                        : 140,
                                                fit: BoxFit.cover,
                                                errorBuilder:
                                                    (
                                                      context,
                                                      error,
                                                      stackTrace,
                                                    ) => Container(
                                                      width:
                                                          isMobile
                                                              ? screenWidth *
                                                                  0.22
                                                              : 90,
                                                      height:
                                                          isMobile
                                                              ? screenWidth *
                                                                  0.22
                                                              : 90,
                                                      color: AppColors.cinza,
                                                      child: const Icon(
                                                        Icons
                                                            .image_not_supported,
                                                      ),
                                                    ),
                                              ),
                                    ),
                                  ),
                                ),
                                // Nome e tags (flexível)
                                Expanded(
                                  flex: 5,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 8,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.nome,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                          maxLines: 5,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children:
                                                item.tags.map<Widget>((tag) {
                                                  Color tagColor;
                                                  if (tag.toUpperCase() ==
                                                      'FRITO') {
                                                    tagColor =
                                                        AppColors.laranja;
                                                  } else if (tag
                                                          .toUpperCase() ==
                                                      'CONGELADO') {
                                                    tagColor =
                                                        Colors.blue[200]!;
                                                  } else {
                                                    tagColor =
                                                        Colors.grey[300]!;
                                                  }
                                                  return Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                          right: 6,
                                                        ),
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 8,
                                                          vertical: 2,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: tagColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                    ),
                                                    child: Text(
                                                      tag,
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        overflow:
                                                            TextOverflow
                                                                .ellipsis,
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
                                // Botões de quantidade (logo após o nome, mais à esquerda)
                                SizedBox(
                                  width: isMobile ? 90 : 110,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.remove,
                                          color:
                                              item.isBebida
                                                  ? (item.quantidade > 1
                                                      ? AppColors.laranja
                                                      : AppColors.laranja
                                                          .withOpacity(0.4))
                                                  : (item.quantidade > 5
                                                      ? AppColors.laranja
                                                      : AppColors.laranja
                                                          .withOpacity(0.4)),
                                        ),
                                        onPressed:
                                            item.isBebida
                                                ? (item.quantidade > 1
                                                    ? () => context
                                                        .read<CartProvider>()
                                                        .decreaseQuantity(index)
                                                    : null)
                                                : (item.quantidade > 5
                                                    ? () => context
                                                        .read<CartProvider>()
                                                        .decreaseQuantity(index)
                                                    : null),
                                        constraints: const BoxConstraints(),
                                        padding: EdgeInsets.zero,
                                      ),
                                      SizedBox(
                                        width:
                                            isMobile
                                                ? 20
                                                : 20, // Diminua a largura
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
                                        icon: const Icon(
                                          Icons.add,
                                          color: AppColors.laranja,
                                        ),
                                        onPressed:
                                            () => context
                                                .read<CartProvider>()
                                                .increaseQuantity(index),
                                        constraints: const BoxConstraints(),
                                        padding: EdgeInsets.zero,
                                      ),
                                    ],
                                  ),
                                ),
                                // Preço (sempre à direita, flexível)
                                Flexible(
                                  flex: 6,
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
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: isMobile ? 4 : 8),
                    padding: EdgeInsets.symmetric(
                      vertical: isMobile ? 12 : 16,
                      horizontal: isMobile ? 8 : 12,
                    ),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.transparent : Colors.white,
                      border: Border.all(
                        color: isDark ? AppColors.laranja : Colors.black,
                        width: 1,
                      ),
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
                        SizedBox(height: isMobile ? 6 : 8),
                        Divider(
                          color: isDark ? AppColors.laranja : Colors.black,
                          thickness: 1,
                          height: isMobile ? 6 : 8,
                        ),
                        SizedBox(height: isMobile ? 6 : 8),
                        Text(
                          'R\$ ${cartItems.fold<double>(0, (total, item) => total + item.preco * item.quantidade).toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: isMobile ? 20 : 24,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: isMobile ? 8 : 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.preto,
                            padding: EdgeInsets.symmetric(
                              vertical: isMobile ? 8 : 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                isMobile ? 6 : 8,
                              ),
                            ),
                          ),
                          icon: Icon(
                            Icons.arrow_back,
                            color: AppColors.laranja,
                            size: isMobile ? 18 : 24,
                          ),
                          label: Text(
                            'CONTINUAR COMPRANDO',
                            style: TextStyle(
                              color: AppColors.laranja,
                              fontWeight: FontWeight.bold,
                              fontSize: isMobile ? 13 : 15,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(
                              context,
                            ).pushNamedAndRemoveUntil('/', (route) => false);
                          },
                        ),
                      ),
                      SizedBox(width: isMobile ? 8 : 16),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.preto,
                            padding: EdgeInsets.symmetric(
                              vertical: isMobile ? 8 : 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                isMobile ? 6 : 8,
                              ),
                            ),
                          ),
                          child: Text(
                            'FINALIZAR PEDIDO',
                            style: TextStyle(
                              color: AppColors.laranja,
                              fontWeight: FontWeight.bold,
                              fontSize: isMobile ? 13 : 15,
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FinalizarPedidoPage(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
