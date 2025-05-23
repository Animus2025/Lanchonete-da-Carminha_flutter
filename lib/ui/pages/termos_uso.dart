import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import '../themes/app_theme.dart';

class TermosDeUsoPage extends StatelessWidget {
  final VoidCallback toggleTheme;

  const TermosDeUsoPage({super.key, required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(toggleTheme: toggleTheme),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Termos de Uso - Lanchonete da Carminha',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.laranja,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Bem-vindo ao aplicativo da Lanchonete da Carminha! Ao utilizar este aplicativo, '
              'você concorda com os seguintes termos:',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            SizedBox(height: 12),
            Text(
              '1. Uso do Aplicativo:\n'
              'Este app tem como objetivo facilitar pedidos, visualizar o cardápio e acompanhar promoções.\n',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            Text(
              '2. Privacidade:\n'
              'Seus dados serão usados apenas para fins de pedidos e atendimento. '
              'Não compartilhamos suas informações com terceiros.\n',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            Text(
              '3. Responsabilidades:\n'
              'A Lanchonete da Carminha se compromete a oferecer informações atualizadas, '
              'mas não se responsabiliza por erros de digitação ou instabilidades temporárias.\n',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            Text(
              '4. Alterações nos Termos:\n'
              'Estes termos podem ser atualizados a qualquer momento. Recomendamos revisar periodicamente.\n',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            SizedBox(height: 24),
            Text(
              'Se tiver dúvidas, entre em contato conosco pelo WhatsApp ou redes sociais no rodapé do app.',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
