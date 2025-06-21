// Importação dos pacotes e widgets necessários para a tela principal (Home)
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../ui/widgets/custom_app_bar.dart'; // AppBar customizada com botão de tema
import '../ui/widgets/custom_drawer.dart'; // Menu lateral personalizado
import '../ui/widgets/footer.dart'; // Rodapé personalizado
import '../ui/themes/app_theme.dart'; // Tema de cores do app
import '../data/salgado_data.dart'; // Dados dos salgados
import '../ui/widgets/salgado_card.dart'; // Card de salgado
import '../models/salgado.dart'; // Modelo de salgado
import '../models/bebida.dart'; // Modelo de bebida
import '../data/bebida_data.dart'; // Dados das bebidas
import '../ui/widgets/bebida_card.dart'; // Card de bebida
import '../providers/cart_provider.dart'; // Provider do carrinho
import '../screens/Cart_Overlay.dart'; // Overlay do carrinho

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

  // Mapeamento das seções para navegação e scroll automático
  final Map<String, GlobalKey> sectionKeys = {
    'festa': GlobalKey(),
    'assado': GlobalKey(),
    'mini': GlobalKey(),
    'bebidas': GlobalKey(),
  };

  String _currentSection = 'festa'; // Seção atualmente destacada

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(
      _onScroll,
    ); // Adiciona listener para detectar rolagem
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  /// Faz o scroll animado até a seção desejada ao clicar no menu horizontal
  void _scrollTo(String section) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = sectionKeys[section]?.currentContext;
      if (context != null) {
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeInOut,
          alignment: 0,
        );
        if (mounted) {
          setState(() {
            _currentSection = section; // Atualiza o destaque do menu
          });
        }
      }
    });
  }

  /// Detecta qual seção está visível no momento para destacar no menu
  void _onScroll() {
    final sections = ['festa', 'assado', 'mini', 'bebidas'];
    String? newSection;

    for (final section in sections) {
      final key = sectionKeys[section];
      if (key == null) continue;
      final context = key.currentContext;
      if (context == null) continue;
      final box = context.findRenderObject() as RenderBox?;
      if (box == null) continue;
      final position = box.localToGlobal(Offset.zero, ancestor: null).dy;

      // Marca a seção ativa se o topo está acima ou alinhado ao topo da tela
      if (position <= 300) {
        newSection = section;
      }
    }

    // Atualiza o menu apenas se mudou de seção
    if (newSection != null && _currentSection != newSection) {
      setState(() {
        _currentSection = newSection!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Agrupa os salgados por categoria para exibição nas seções
    final Map<String, List<Salgado>> salgadosPorCategoria = {};
    for (var salgado in salgados) {
      salgadosPorCategoria
          .putIfAbsent(salgado.categoria, () => [])
          .add(salgado);
    }

    return Scaffold(
      appBar: CustomAppBar(
        toggleTheme: widget.toggleTheme,
      ), // AppBar customizada com botão de tema
      drawer: const CustomDrawer(), // Drawer lateral
      body: Column(
        children: [
          // Menu de navegação horizontal entre as seções
          Container(
            height: 50,
            color: AppColors.pretoClaro,
            child: Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildSectionButton("Festa", 'festa'),
                    _buildSectionButton("Assado", 'assado'),
                    _buildSectionButton("Mini", 'mini'),
                    _buildSectionButton("Bebidas", 'bebidas'),
                    // Botão do carrinho de compras
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 2,
                        vertical: 2,
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        child: Stack(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.shopping_cart,
                                size: 30,
                                color: AppColors.laranja,
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
                            // Badge com a quantidade de itens no carrinho
                            Positioned(
                              right: 6,
                              top: 6,
                              child: Consumer<CartProvider>(
                                builder: (context, cart, child) {
                                  return cart.itemCount > 0
                                      ? Container(
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
                                      )
                                      : const SizedBox.shrink();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Conteúdo principal com as seções de produtos
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  // Seção Festa
                  _buildSection(
                    key: sectionKeys['festa']!,
                    title: 'FESTA',
                    items: salgadosPorCategoria['festa'] ?? [],
                    isSalgado: true,
                    titleColor:
                        isDarkMode ? AppColors.laranja : AppColors.pretoClaro,
                  ),
                  // Seção Assado
                  _buildSection(
                    key: sectionKeys['assado']!,
                    title: 'ASSADO',
                    items: salgadosPorCategoria['assado'] ?? [],
                    isSalgado: true,
                    titleColor:
                        isDarkMode ? AppColors.laranja : AppColors.pretoClaro,
                  ),
                  // Seção Mini
                  _buildSection(
                    key: sectionKeys['mini']!,
                    title: 'MINI',
                    items: salgadosPorCategoria['mini'] ?? [],
                    isSalgado: true,
                    titleColor:
                        isDarkMode ? AppColors.laranja : AppColors.pretoClaro,
                  ),
                  // Seção Bebidas
                  _buildSection(
                    key: sectionKeys['bebidas']!,
                    title: 'BEBIDAS',
                    items: bebidas,
                    isSalgado: false,
                    titleColor:
                        isDarkMode ? AppColors.laranja : AppColors.pretoClaro,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomFooter(), // Rodapé fixo
    );
  }

  /// Cria o botão do menu horizontal para cada seção.
  /// Destaca o botão se a seção estiver ativa.
  Widget _buildSectionButton(String label, String section) {
    final bool isSelected = _currentSection == section;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Container(
        alignment: Alignment.center,
        decoration:
            isSelected
                ? BoxDecoration(
                  border: Border.all(color: AppColors.laranja, width: 2),
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.laranja,
                )
                : null,
        child: SizedBox(
          height: 36,
          child: TextButton(
            onPressed: () => _scrollTo(section),
            style: TextButton.styleFrom(
              foregroundColor:
                  isSelected ? Colors.black : AppColors.textSecondary,
              backgroundColor: Colors.transparent,
              padding: EdgeInsets.zero,
              minimumSize: const Size(60, 36),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.black : AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Monta cada seção de produtos (salgados ou bebidas) com título e cards.
  Widget _buildSection({
    required GlobalKey key,
    required String title,
    required List<dynamic> items,
    required bool isSalgado,
    Color? titleColor,
  }) {
    return Container(
      key: key,
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
                // Um card por linha, altura ajustável
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
                // Sempre 2 cards por linha em telas grandes
                return GridView.builder(
                  itemCount: items.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Sempre 2 cards por linha
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio:
                        4 / 2, // Ajuste conforme o visual desejado
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
    );
  }
}
