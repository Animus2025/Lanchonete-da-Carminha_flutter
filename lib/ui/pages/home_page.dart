// Importa os pacotes necessários do Flutter e widgets personalizados criados no projeto
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/ui/widgets/custom_app_bar.dart'; // AppBar customizado (provavelmente com o botão de tema e logo)
import '/ui/widgets/custom_drawer.dart'; // Menu lateral personalizado
import '/ui/widgets/footer.dart'; // Rodapé personalizado
import '/ui/themes/app_theme.dart'; // Tema com as cores da aplicação
import '/data/salgado_data.dart'; // Dados dos salgados
import '/ui/widgets/salgado_card.dart'; // Importa o card de salgado
import '/models/salgado.dart'; // Importa o modelo de salgado
import '/data/bebida_data.dart'; // Importe a lista de bebidas
import '/ui/widgets/bebida_card.dart'; // Importe o card de bebida
import '/providers/cart_provider.dart';
import '/screens/cart_overlay.dart';

// Componente principal da tela Home
class HomePage extends StatefulWidget {
  final VoidCallback toggleTheme;

  const HomePage({super.key, required this.toggleTheme});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  // Mapeamento robusto das seções
  final Map<String, GlobalKey> sectionKeys = {
    'festa': GlobalKey(),
    'assado': GlobalKey(),
    'mini': GlobalKey(),
    'bebidas': GlobalKey(),
  };

  String _currentSection = 'festa'; // Variável de estado para destacar a seção

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
        // Animação do scroll
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeInOut,
          alignment: 0, // Leva o título para o topo
        );

        // Efeito visual (opcional)
        if (mounted) {
          setState(() {
            _currentSection = section; // Destaca a seção atual
          });
        }
      }
    });
  }

  void _onScroll() {
    // Lista das seções na ordem em que aparecem
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

      // Se o topo do título está acima ou alinhado ao topo da tela, marca como possível seção ativa
      if (position <= 300) {
        // 56 é o tamanho padrão da AppBar, ajuste se necessário
        newSection = section;
      }
    }

    // Só atualiza se mudou
    if (newSection != null && _currentSection != newSection) {
      setState(() {
        _currentSection = newSection!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Agrupa os salgados por categoria
    final Map<String, List<Salgado>> salgadosPorCategoria = {};
    for (var salgado in salgados) {
      salgadosPorCategoria
          .putIfAbsent(salgado.categoria, () => [])
          .add(salgado);
    }

    return Scaffold(
      appBar: CustomAppBar(toggleTheme: widget.toggleTheme),
      drawer: const CustomDrawer(),
      body: Column(
        children: [
          // Menu de navegação horizontal
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
                    // Botão separado com ícone de carrinho
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
                                  color: AppColors.laranja),
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
          // Conteúdo principal com SingleChildScrollView
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
      bottomNavigationBar: const CustomFooter(),
    );
  }

  Widget _buildSectionButton(String label, String section) {
    final bool isSelected = _currentSection == section;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ), // Menos espaço horizontal e vertical
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
          height: 36, // Altura um pouco menor
          child: TextButton(
            onPressed: () => _scrollTo(section),
            style: TextButton.styleFrom(
              foregroundColor:
              isSelected ? Colors.black : AppColors.textSecondary,
              backgroundColor: Colors.transparent,
              padding: EdgeInsets.zero,
              minimumSize: const Size(60, 36), // Menor largura e altura mínimas
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 20, // Fonte um pouco menor
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

  Widget _buildSection({
    required GlobalKey key,
    required String title,
    required List<dynamic> items,
    required bool isSalgado,
    Color? titleColor,
  }) {
    return Container(
      key: key,
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: titleColor ?? Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 8), // Espaço logo abaixo do título
          ...items.map(
                (item) =>
                isSalgado
                    ? SalgadoCard(salgado: item)
                    : BebidaCard(bebida: item),
          ),
        ],
      ),
    );
  }
}
