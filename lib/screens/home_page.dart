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
import '../ui/widgets/AppBodyConteiner.dart';

class HomePage extends StatefulWidget {
  final VoidCallback toggleTheme;

  const HomePage({super.key, required this.toggleTheme});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  final Map<String, GlobalKey> sectionKeys = {
    'festa': GlobalKey(),
    'assado': GlobalKey(),
    'mini': GlobalKey(),
    'bebidas': GlobalKey(),
  };

  String _currentSection = 'festa';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

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
            _currentSection = section;
          });
        }
      }
    });
  }

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
      final position = box.localToGlobal(Offset.zero).dy;

      if (position <= 300) {
        newSection = section;
      }
    }

    if (newSection != null && _currentSection != newSection) {
      setState(() {
        _currentSection = newSection!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final Map<String, List<Salgado>> salgadosPorCategoria = {};
    for (var salgado in salgados) {
      salgadosPorCategoria
          .putIfAbsent(salgado.categoria, () => [])
          .add(salgado);
    }

    return AppScaffold(
      appBar: CustomAppBar(toggleTheme: widget.toggleTheme),
      drawer: const CustomDrawer(),
      topBar: _buildTopMenu(),
      footer: Container(
        color: AppColors.pretoClaro,
        width: double.infinity,
        child: const CustomFooter(),
      ),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  _buildSection(
                    key: sectionKeys['festa']!,
                    title: 'FESTA',
                    items: salgadosPorCategoria['festa'] ?? [],
                    isSalgado: true,
                    titleColor: isDarkMode
                        ? AppColors.laranja
                        : AppColors.pretoClaro,
                  ),
                  _buildSection(
                    key: sectionKeys['assado']!,
                    title: 'ASSADO',
                    items: salgadosPorCategoria['assado'] ?? [],
                    isSalgado: true,
                    titleColor: isDarkMode
                        ? AppColors.laranja
                        : AppColors.pretoClaro,
                  ),
                  _buildSection(
                    key: sectionKeys['mini']!,
                    title: 'MINI',
                    items: salgadosPorCategoria['mini'] ?? [],
                    isSalgado: true,
                    titleColor: isDarkMode
                        ? AppColors.laranja
                        : AppColors.pretoClaro,
                  ),
                  _buildSection(
                    key: sectionKeys['bebidas']!,
                    title: 'BEBIDAS',
                    items: bebidas,
                    isSalgado: false,
                    titleColor: isDarkMode
                        ? AppColors.laranja
                        : AppColors.pretoClaro,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopMenu() {
  final isMobile = MediaQuery.of(context).size.width < 600;

  return Container(
    color: AppColors.pretoClaro,
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 12),
    child: SizedBox(
      height: 50,
      child: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTopButton("Festa", 'festa', isMobile),
                _buildTopButton("Assado", 'assado', isMobile),
                _buildTopButton("Mini", 'mini', isMobile),
                _buildTopButton("Bebidas", 'bebidas', isMobile),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Stack(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.shopping_cart,
                  size: 26,
                  color: AppColors.laranja,
                ),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => CartOverlay(),
                  );
                },
                tooltip: 'Ver carrinho',
              ),
              Positioned(
                right: 4,
                top: 4,
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
        ],
      ),
    ),
  );
}


  Widget _buildTopButton(String label, String section, bool isMobile) {
  final bool isSelected = _currentSection == section;

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 2),
    child: SizedBox(
      width: isMobile ? null : 80, // largura menor no PC
      child: TextButton(
        onPressed: () => _scrollTo(section),
        style: TextButton.styleFrom(
          backgroundColor:
              isSelected ? AppColors.laranja : Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
            side: BorderSide(
              color: isSelected ? AppColors.laranja : Colors.transparent,
              width: 1,
            ),
          ),
        ),
        child: FittedBox(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.black : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    ),
  );
}


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
                return ListView.builder(
                  itemCount: items.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: isSalgado
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
    );
  }
}
