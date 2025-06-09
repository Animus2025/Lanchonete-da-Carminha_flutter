import 'package:flutter/material.dart';
import 'package:lanchonetedacarminha/ui/pages/Revisao_pedido.dart';
import 'package:provider/provider.dart';
import 'package:lanchonetedacarminha/ui/pages/cadastro_page.dart';
import 'ui/pages/termos_uso.dart';
import 'ui/pages/politicas_privacidade.dart';
import 'ui/pages/sobre.dart';
import 'ui/themes/app_theme.dart';
import 'providers/cart_provider.dart';
import 'providers/auth_provider.dart';
import 'screens/home_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lanchonete da Carminha',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,

      // 🔧 ROTAS REGISTRADAS AQUI
      routes: {
        '/': (context) => HomePage(toggleTheme: toggleTheme),
        '/termos_uso': (context) => TermosDeUsoPage(toggleTheme: toggleTheme),
        '/cadastro_page': (context) => const CadastroPage(),
        '/cardapio': (context) => HomePage(toggleTheme: toggleTheme),
        '/politicas-de-privacidade': (context) => PoliticaPrivacidadePage(toggleTheme: toggleTheme),
        '/sobre': (context) => Sobre(toggleTheme: toggleTheme),
        '/revisao_pedido': (context) => RevisaoPedido(toggleTheme: toggleTheme),
        // você pode adicionar outras rotas aqui também:
        // '/politicas-de-prisvacidade': (context) => const PoliticasPage(),
        // '/sobre': (context) => const SobrePage(),
      },
    );
  }
}
