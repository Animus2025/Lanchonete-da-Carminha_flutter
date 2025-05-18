import 'package:flutter/material.dart';
import '../ui/widgets/custom_app_bar.dart';
import '../ui/widgets/custom_drawer.dart';
import '../ui/widgets/footer.dart';
import '../ui/themes/app_theme.dart';

//luana esteve aqui

class HomePage extends StatefulWidget {
  final VoidCallback toggleTheme;

  const HomePage({super.key, required this.toggleTheme});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBar(toggleTheme: widget.toggleTheme),
      drawer: const CustomDrawer(),
      body: Container(
        color: isDarkMode ? AppColors.pretoClaro : AppColors.branco,
        child: Center(
          child: Text(
            "Produtos",
            style:
                Theme.of(
                  context,
                ).textTheme.bodyLarge, // Usa o estilo definido no tema
          ),
        ),
      ),
      bottomNavigationBar: const CustomFooter(),
    );
  }
}
