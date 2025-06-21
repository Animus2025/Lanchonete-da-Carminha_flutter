import 'package:flutter/material.dart';

class AppBodyContainer extends StatelessWidget {
  final Widget child;

  const AppBodyContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 1000;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1400),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 4 : 24),
          child: child,
        ),
      ),
    );
  }
}

class AppScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget? footer;
  final Widget child;
  final Widget? drawer;
  final Color? backgroundColor;
  final FloatingActionButton? floatingActionButton;
  final Widget? topBar; // Adiciona uma barra superior (menu horizontal se quiser)

  const AppScaffold({
    super.key,
    this.appBar,
    this.footer,
    required this.child,
    this.drawer,
    this.backgroundColor,
    this.floatingActionButton,
    this.topBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBar,
      drawer: drawer,
      floatingActionButton: floatingActionButton,
      body: Column(
        children: [
          if (topBar != null) topBar!, // Menu horizontal no topo (full width)
          Expanded(
            child: AppBodyContainer(
              child: child, // Conteúdo centralizado
            ),
          ),
          if (footer != null) footer!, // Footer fora da centralização
        ],
      ),
    );
  }
}