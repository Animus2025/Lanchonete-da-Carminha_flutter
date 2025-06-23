import 'package:flutter/material.dart';
import 'package:lanchonetedacarminha/ui/pages/Meus_pedidos.dart';
import 'package:provider/provider.dart';
import 'package:lanchonetedacarminha/ui/pages/cadastro_page.dart';
import 'ui/pages/termos_uso.dart';
import 'ui/pages/politicas_privacidade.dart';
import 'ui/pages/sobre.dart';
import 'ui/themes/app_theme.dart';
import 'providers/cart_provider.dart';
import 'providers/auth_provider.dart';
import 'screens/home_page.dart';
import 'ui/pages/redefinir_senha.dart';
import 'ui/pages/verificar_telefone.dart ';
import 'ui/pages/minha_conta.dart';
import 'package:lanchonetedacarminha/ui/widgets/pedido_regras.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'ui/pages/checkout_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const MyApp(),
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

      // 🌎 Configurações de idioma para português
      locale: const Locale('pt', 'BR'),
      supportedLocales: const [
        Locale('pt', 'BR'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // 🔧 ROTAS REGISTRADAS AQUI
      routes: {
        '/': (context) => HomePage(toggleTheme: toggleTheme),
        '/termos_uso': (context) => TermosDeUsoPage(toggleTheme: toggleTheme),
        '/cadastro_page': (context) => const CadastroPage(),
        '/politicas-de-privacidade': (context) => PoliticaPrivacidadePage(toggleTheme: toggleTheme),
        '/sobre': (context) => Sobre(toggleTheme: toggleTheme),
        '/redefinir_senha': (context) => const RedefinirSenhaPage(),
        '/verificar_telefone': (context) => const VerificarTelefonePage(),
        '/Meus_pedidos': (context) => MeusPedidosPage(toggleTheme: toggleTheme),
        '/minha_conta': (context) => MinhaContaPage(toggleTheme: toggleTheme),
        '/checkout': (context) => RevisaoPedidoPage(toggleTheme: toggleTheme),
        // você pode adicionar outras rotas aqui também:
        // '/politicas-de-prisvacidade': (context) => const PoliticasPage(),
        // '/sobre': (context) => const SobrePage(),
      },
    );
  }
}