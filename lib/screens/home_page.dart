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

  // Mapeamento das seções para navegação e scroll automático
  final Map<String, GlobalKey> sectionKeys = {};

  String _currentSection = 'festa'; // Seção atualmente destacada

  /// Garante que cada categoria tenha uma chave única e estável
  GlobalKey _getSectionKey(String categoria) {
    return sectionKeys.putIfAbsent(categoria, () => GlobalKey());
  }

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
    final sections = sectionKeys.keys.toList();
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

    return Scaffold(
      appBar: CustomAppBar(toggleTheme: widget.toggleTheme),
      drawer: const CustomDrawer(),
      body: FutureBuilder<List<Salgado>>(
        future: fetchSalgados(),
        builder: (context, salgadosSnapshot) {
          if (salgadosSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (salgadosSnapshot.hasError) {
            return Center(child: Text('Erro: ${salgadosSnapshot.error}'));
          } else if (!salgadosSnapshot.hasData ||
              salgadosSnapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum salgado encontrado.'));
          }
          final salgados = salgadosSnapshot.data!;
          final festa = salgados.where((s) => s.categoria == 'festa').toList();
          final assado =
              salgados.where((s) => s.categoria == 'assado').toList();
          final mini = salgados.where((s) => s.categoria == 'mini').toList();

          return FutureBuilder<List<Bebida>>(
            future: fetchBebidas(),
            builder: (context, bebidasSnapshot) {
              if (bebidasSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (bebidasSnapshot.hasError) {
                return Center(child: Text('Erro: ${bebidasSnapshot.error}'));
              }
              final bebidas = bebidasSnapshot.data ?? [];

              // Apenas as seções, sem menu horizontal
              return SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    if (festa.isNotEmpty)
                      _buildSection(
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
                        title: 'MINI',
                        items: mini,
                        isSalgado: true,
                        titleColor:
                            isDarkMode
                                ? AppColors.laranja
                                : AppColors.pretoClaro,
                      ),
                    _buildSection(
                      title: 'BEBIDAS',
                      items: bebidas,
                      isSalgado: false,
                      titleColor:
                          isDarkMode ? AppColors.laranja : AppColors.pretoClaro,
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: const CustomFooter(),
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
    required String title,
    required List<dynamic> items,
    required bool isSalgado,
    Color? titleColor,
  }) {
    return SectionAnchor(
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
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
      ),
    );
  }
}
