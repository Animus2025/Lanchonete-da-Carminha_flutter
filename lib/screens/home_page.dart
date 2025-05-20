// Importa os pacotes necessários do Flutter e widgets personalizados criados no projeto
import 'package:flutter/material.dart';
import '../ui/widgets/custom_app_bar.dart'; // AppBar customizado (provavelmente com o botão de tema e logo)
import '../ui/widgets/custom_drawer.dart'; // Menu lateral personalizado
import '../ui/widgets/footer.dart'; // Rodapé personalizado
import '../ui/themes/app_theme.dart'; // Tema com as cores da aplicação
import '../data/salgado_data.dart'; // Dados dos salgados
import '../ui/widgets/salgado_card.dart'; // Importa o card de salgado
import '../models/salgado.dart'; // Importa o modelo de salgado
import '../data/bebida_data.dart'; // Importe a lista de bebidas
import '../ui/widgets/bebida_card.dart'; // Importe o card de bebida

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
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildSectionButton("Festa", 'festa'),
                _buildSectionButton("Assado", 'assado'),
                _buildSectionButton("Mini", 'mini'),
                _buildSectionButton("Bebidas", 'bebidas'),
              ],
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
                    titleColor: AppColors.pretoClaro,
                  ),
                  // Seção Assado
                  _buildSection(
                    key: sectionKeys['assado']!,
                    title: 'ASSADO',
                    items: salgadosPorCategoria['assado'] ?? [],
                    isSalgado: true,
                    titleColor: AppColors.pretoClaro,
                  ),
                  // Seção Mini
                  _buildSection(
                    key: sectionKeys['mini']!,
                    title: 'MINI',
                    items: salgadosPorCategoria['mini'] ?? [],
                    isSalgado: true,
                    titleColor: AppColors.pretoClaro,
                  ),
                  // Seção Bebidas
                  _buildSection(
                    key: sectionKeys['bebidas']!,
                    title: 'BEBIDAS',
                    items: bebidas,
                    isSalgado: false,
                    titleColor: AppColors.pretoClaro,
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Container(
        alignment: Alignment.center, // Centraliza o conteúdo
        decoration:
            isSelected
                ? BoxDecoration(
                  border: Border.all(color: AppColors.laranja, width: 2),
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.laranja, // Fundo laranja quando ativo
                )
                : null,
        child: SizedBox(
          height: 40, // Altura fixa para garantir centralização vertical
          child: TextButton(
            onPressed: () => _scrollTo(section),
            style: TextButton.styleFrom(
              foregroundColor:
                  isSelected ? Colors.black : AppColors.textSecondary,
              backgroundColor: Colors.transparent,
              padding: EdgeInsets.zero, // Remove padding extra
              minimumSize: const Size(80, 40), // Largura e altura mínimas
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 19,
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
