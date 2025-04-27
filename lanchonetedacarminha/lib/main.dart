import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'screens/login_overlay.dart';

Widget _buildMenuItem(IconData icon, String text, VoidCallback onTap) {
  return ListTile(
    leading: Icon(icon, color: const Color(0xffF6C484)),
    title: Text(text, style: const TextStyle(color: Color(0xffF6C484))),
    onTap: onTap,
  );
}

void main() {
  runApp(const MyApp());
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
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: 'BebasNeue',
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'BebasNeue',
      ),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: HomePage(toggleTheme: toggleTheme),
    );
  }
}

class HomePage extends StatelessWidget {
  final VoidCallback toggleTheme;

  const HomePage({super.key, required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBar(toggleTheme: toggleTheme),
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width * 0.7, // Define 70% da largura da tela
        child: Drawer(
          backgroundColor: const Color(0xff111111),
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 32.0),
            children: [
              _buildMenuItem(Icons.person, "Minha Conta", () {
                LoginDialog.show(context); // Chama o pop-up de login
              }),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: const Divider(
                  color:  Color(0xff333333), // Cor do Divider
                  height: 1, // Altura do Divider
                  thickness: 1, // Espessura do Divider
                ),
              ),

              _buildMenuItem(Icons.list_alt, "Meus Pedidos", () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/Meus-Pedidos');
              }),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: const Divider(
                  color: Color(0xff333333), // Cor do Divider
                  height: 1, // Altura do Divider
                  thickness: 1, // Espessura do Divider
                ),
              ),

              ListTile(
                leading: Image.asset(
                  'lib/assets/icons/cardapio.png', color: const Color(0xffF6C484),
                  width: 24,
                  height: 24,
                ),
                title: Text(
                  "Cardápio", style: TextStyle(color: Color(0xffF6C484))
                  ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/cardapio');
                },
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 200.0),
              ),
              
              ListTile(
                leading: Image.asset(
                  'lib/assets/icons/termos.png', color: const Color(0xffF6C484),
                  width: 24,
                  height: 24,
                ),
                title: Text(
                  "Termos de Uso", style: TextStyle(color: Color(0xffF6C484))
                  ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/termos-de-uso');
                },
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: const Divider(
                  color:  Color(0xff333333), // Cor do Divider
                  height: 1, // Altura do Divider
                  thickness: 1, // Espessura do Divider
                ),
              ),

              ListTile(
                leading: Image.asset(
                  'lib/assets/icons/privacidade.png', color: const Color(0xffF6C484),
                  width: 24,
                  height: 24,
                ),
                title: Text(
                  "Políticas de Privacidade", style: TextStyle(color: Color(0xffF6C484))
                  ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/politicas-de-privacidade');
                },
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: const Divider(
                  color:  Color(0xff333333), // Cor do Divider
                  height: 1, // Altura do Divider
                  thickness: 1, // Espessura do Divider
                ),
              ),

              ListTile(
                leading: Image.asset(
                  'lib/assets/icons/info.png', color: const Color(0xffF6C484),
                  width: 24,
                  height: 24,
                ),
                title: Text(
                  "Sobre", style: TextStyle(color: Color(0xffF6C484))
                  ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/sobre');
                },
              ),
            ],
          ),
        ),
      ),
      body: Container(
        color: isDarkTheme ? const Color.fromARGB(255, 27, 27, 27) : const Color.fromARGB(255, 246, 246, 246),
      ),
      bottomNavigationBar: Container(
        color: Colors.black, // Define a cor preta fixa para o rodapé
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 4.0), // Espaçamento geral
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Ícones de redes sociais
            Row(
              children : [
                const Icon(
                  Icons.location_on, 
                  color: const Color(0xffF6C484),
                  size: 28,
                  ),
                
                Text('Rua Antônio Moreira Barros N°10 Centro, Teixeiras, MG', style: TextStyle(color: Color(0xffF6C484), fontSize: 12)),

                const SizedBox(width: 25), // Espaçamento entre os ícones

                GestureDetector(
                  onTap: () async {
                    final Uri whatsappUrl = Uri.parse("https://wa.me/5531971520049");
                    if (await canLaunchUrl(whatsappUrl)) {
                      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
                    } else {
                      print("Não foi possível abrir o WhatsApp");
                    }
                  },
                  child: Image.asset(
                    'lib/assets/icons/whatsapp.png',
                    color: const Color(0xffF6C484),
                    width: 28,
                    height: 28,
                  ),
                ),
                const SizedBox(width: 20), // Espaçamento entre os ícones

                GestureDetector(
                  onTap: () async {
                    final Uri instagramUrl =
                        Uri.parse("https://www.instagram.com/lanchonete_carminha");
                    if (await canLaunchUrl(instagramUrl)) {
                      await launchUrl(instagramUrl, mode: LaunchMode.externalApplication);
                    } else {
                      print("Não foi possível abrir o Instagram");
                    }
                  },
                  child: Image.asset(
                    'lib/assets/icons/instagram.png',
                    color: const Color(0xffF6C484),
                    width: 28,
                    height: 28,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback toggleTheme;

  const CustomAppBar({super.key, required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return PreferredSize(
      preferredSize: const Size.fromHeight(50.0), // Define a altura do AppBar
      child: AppBar(
        backgroundColor: const Color.fromARGB(255, 17, 17, 17),
        iconTheme: const IconThemeData(color: Color(0xFFF6C484)),
        leading: IconButton(
          icon: const Icon(Icons.menu, size: 28,),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        title: SizedBox(
          width: 418,
          height: 50,
          child: Center(
            child: Image.asset(
              'lib/assets/icons/logo.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(isDarkTheme ? Icons.light_mode : Icons.dark_mode, size: 28),
            onPressed: toggleTheme,
          ),
          
          IconButton(
            icon: const Icon(Icons.person, size: 28),
            onPressed: () {
              LoginDialog.show(context); // Chama o pop-up de login ao pressionar o botão
            },
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50.0); // Altura personalizada
}