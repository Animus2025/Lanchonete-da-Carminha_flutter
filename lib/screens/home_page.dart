// Importação dos pacotes e widgets necessários para a tela principal (Home)
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../ui/widgets/custom_app_bar.dart';
import '../ui/widgets/custom_drawer.dart';
import '../ui/widgets/footer.dart';
import '../ui/themes/app_theme.dart';
import '../data/salgado_data.dart';
import '../ui/widgets/salgado_card.dart';
import '../models/salgado.dart';
import '../models/bebida.dart';
import '../data/bebida_data.dart';
import '../ui/widgets/bebida_card.dart';
import '../providers/cart_provider.dart';
import '../screens/cart_overlay.dart';

/// Widget âncora para permitir navegação por scroll entre seções
class SectionAnchor extends StatelessWidget {
  final Widget child;
  const SectionAnchor({super.key, required this.child});
  @override
  Widget build(BuildContext context) => child;
}

/// Tela principal do aplicativo, exibindo as categorias de produtos e bebidas.
/// Possui navegação horizontal entre seções, AppBar customizada, Drawer e rodapé.
class HomePage extends StatefulWidget {
  final VoidCallback toggleTheme; // Função para alternar o tema do app

  const HomePage({super.key, required this.toggleTheme});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  // Chaves para cada seção
  final Map<String, GlobalKey> sectionKeys = {
    'festa': GlobalKey(),
    'assado': GlobalKey(),
    'mini': GlobalKey(),
    'bebidas': GlobalKey(),
  };

  // Função para rolar até a seção desejada
  void _scrollToSection(String section) {
    final context = sectionKeys[section]?.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
        alignment: 0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBar(toggleTheme: widget.toggleTheme),
      drawer: const CustomDrawer(),

      // BARRA HORIZONTAL DE LINKS
      body: Column(
        children: [
          Container(
            color: AppColors.pretoClaro,
            height: 54,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _SectionLink(
                  label: 'Festa',
                  onTap: () => _scrollToSection('festa'),
                ),
                _SectionLink(
                  label: 'Assado',
                  onTap: () => _scrollToSection('assado'),
                ),
                _SectionLink(
                  label: 'Mini',
                  onTap: () => _scrollToSection('mini'),
                ),
                _SectionLink(
                  label: 'Bebidas',
                  onTap: () => _scrollToSection('bebidas'),
                ),
                const SizedBox(width: 8),
                // Ícone do carrinho
                Consumer<CartProvider>(
                  builder:
                      (context, cart, child) => Stack(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.shopping_cart,
                              color: AppColors.laranja,
                              size: 28,
                            ),
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                isDismissible: true,
                                enableDrag: true,
                                builder: (_) => CartOverlay(),
                              );
                            },
                            tooltip: 'Ver carrinho',
                          ),
                          if (cart.itemCount > 0)
                            Positioned(
                              right: 4,
                              top: 4,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  '${cart.itemCount}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                ),
              ],
            ),
          ),
          // CONTEÚDO PRINCIPAL
          Expanded(
            child: FutureBuilder<List<Salgado>>(
              future: fetchSalgados(),
              builder: (context, salgadosSnapshot) {
                if (salgadosSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (salgadosSnapshot.hasError) {
                  return Center(child: Text('Erro: ${salgadosSnapshot.error}'));
                } else if (!salgadosSnapshot.hasData ||
                    salgadosSnapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('Nenhum salgado encontrado.'),
                  );
                }
                final salgados = salgadosSnapshot.data!;
                final festa =
                    salgados.where((s) => s.categoria == 'festa').toList();
                final assado =
                    salgados.where((s) => s.categoria == 'assado').toList();
                final mini =
                    salgados.where((s) => s.categoria == 'mini').toList();

                return FutureBuilder<List<Bebida>>(
                  future: fetchBebidas(),
                  builder: (context, bebidasSnapshot) {
                    if (bebidasSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (bebidasSnapshot.hasError) {
                      return Center(
                        child: Text('Erro: ${bebidasSnapshot.error}'),
                      );
                    }
                    final bebidas = bebidasSnapshot.data ?? [];

                    return SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        children: [
                          if (festa.isNotEmpty)
                            _buildSection(
                              key: sectionKeys['festa'],
                              title: 'FESTA',
                              items: festa,
                              isSalgado: true,
                              titleColor:
                                  isDarkMode
                                      ? AppColors.laranja
                                      : AppColors.pretoClaro,
                            ),
                          if (assado.isNotEmpty)
                            _buildSection(
                              key: sectionKeys['assado'],
                              title: 'ASSADO',
                              items: assado,
                              isSalgado: true,
                              titleColor:
                                  isDarkMode
                                      ? AppColors.laranja
                                      : AppColors.pretoClaro,
                            ),
                          if (mini.isNotEmpty)
                            _buildSection(
                              key: sectionKeys['mini'],
                              title: 'MINI',
                              items: mini,
                              isSalgado: true,
                              titleColor:
                                  isDarkMode
                                      ? AppColors.laranja
                                      : AppColors.pretoClaro,
                            ),
                          _buildSection(
                            key: sectionKeys['bebidas'],
                            title: 'BEBIDAS',
                            items: bebidas,
                            isSalgado: false,
                            titleColor:
                                isDarkMode
                                    ? AppColors.laranja
                                    : AppColors.pretoClaro,
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomFooter(),
    );
  }

  // Widget para cada link da barra horizontal
  Widget _SectionLink({required String label, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.laranja,
          ),
        ),
      ),
    );
  }

  // Ajuste para aceitar key opcional
  Widget _buildSection({
    Key? key,
    required String title,
    required List<dynamic> items,
    required bool isSalgado,
    Color? titleColor,
  }) {
    return SectionAnchor(
      key: key,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: titleColor ?? Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 600) {
                  return ListView.builder(
                    itemCount: items.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child:
                            isSalgado
                                ? SalgadoCard(salgado: item as Salgado)
                                : BebidaCard(bebida: item as Bebida),
                      );
                    },
                  );
                } else {
                  return GridView.builder(
                    itemCount: items.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          childAspectRatio: 4 / 2,
                        ),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return isSalgado
                          ? SalgadoCard(salgado: item as Salgado)
                          : BebidaCard(bebida: item as Bebida);
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
