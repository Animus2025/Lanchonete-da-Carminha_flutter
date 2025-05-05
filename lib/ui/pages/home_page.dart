import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/footer.dart';

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
        color: isDarkMode ? const Color(0xFF1B1B1B) : const Color(0xFFF6F6F6),
        child: Center(
          child: Text(
            "Produtos",
            style: TextStyle(
              color: isDarkMode ? const Color(0xffF6C484) : Colors.black,
            ),
          ),
        ),
      ),
      bottomNavigationBar: const CustomFooter(),
    );
  }
}
