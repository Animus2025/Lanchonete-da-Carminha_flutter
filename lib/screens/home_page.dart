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
  // Recebe uma função (callback) pra alternar entre tema claro e escuro
  final VoidCallback toggleTheme;

  const HomePage({super.key, required this.toggleTheme});

  @override
  State<HomePage> createState() => _HomePageState();
}

// Estado da HomePage, onde fica a lógica e a interface
class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // Verifica se o modo escuro está ativado
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Agrupa os salgados por categoria
    final Map<String, List<Salgado>> salgadosPorCategoria = {};
    for (var salgado in salgados) {
      salgadosPorCategoria.putIfAbsent(salgado.categoria, () => []).add(salgado);
    }

    return Scaffold(
      // Usa a AppBar personalizada, que recebe o botão de alternar tema
      appBar: CustomAppBar(toggleTheme: widget.toggleTheme),

      // Usa um Drawer (menu lateral) customizado
      drawer: const CustomDrawer(),

      // Corpo da página
      body: Container(
        // Define a cor de fundo com base no tema atual
        color: isDarkMode ? AppColors.pretoClaro : AppColors.branco,

        // Lista de categorias e salgados
        child: ListView(
          padding: const EdgeInsets.only(bottom: 80), // Espaço para o rodapé
          children: [
            // Exibe todas as categorias de salgados, MENOS a "mini"
            ...salgadosPorCategoria.entries.where((entry) => entry.key != 'mini').map((entry) {
              final categoria = entry.key;
              final lista = entry.value;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Text(
                      categoria.toUpperCase(),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                    ),
                  ),
                  ...lista.map((salgado) => SalgadoCard(salgado: salgado)).toList(),
                ],
              );
            }),

            // Agora exibe a categoria "mini"
            if (salgadosPorCategoria.containsKey('mini')) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Text(
                  'MINI',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                ),
              ),
              ...salgadosPorCategoria['mini']!.map((salgado) => SalgadoCard(salgado: salgado)).toList(),
            ],

            // Agora exibe as bebidas
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                'BEBIDAS',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
              ),
            ),
            ...bebidas.map((bebida) => BebidaCard(bebida: bebida)).toList(),
          ],
        ),
      ),

      // Rodapé customizado fixado na parte inferior da tela
      bottomNavigationBar: const CustomFooter(),
    );
  }
}
