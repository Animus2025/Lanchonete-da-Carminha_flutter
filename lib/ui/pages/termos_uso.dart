import 'package:flutter/material.dart';
import 'package:lanchonetedacarminha/ui/themes/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lanchonetedacarminha/ui/widgets/app_body_container.dart';

class TermosDeUsoPage extends StatelessWidget {
  final VoidCallback toggleTheme;

  const TermosDeUsoPage({super.key, required this.toggleTheme});

  Future<void> _abrirLink(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Não foi possível abrir o link: $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        isDarkMode ? AppColors.darkTextPrimary : AppColors.textPrimary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Termos de Uso'),
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: toggleTheme,
          ),
        ],
      ),
      body: AppBodyContainer(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Termos de Uso - Lanchonete da Carminha',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.laranja,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Última atualização: [DATA]',
                style: TextStyle(fontSize: 16, color: textColor),
              ),
              const SizedBox(height: 16),
              Text(
                'Ao utilizar o aplicativo da Lanchonete da Carminha, você concorda com os seguintes Termos de Uso e Política de Privacidade, elaborados em conformidade com a Lei Geral de Proteção de Dados (LGPD - Lei nº 13.709/2018). Estes termos regulam o tratamento de dados pessoais coletados durante o uso do sistema, garantindo transparência e segurança em todas as interações.',
                style: TextStyle(fontSize: 16, color: textColor),
              ),
              const SizedBox(height: 16),
              Text(
                'Coleta e Finalidade dos Dados\n\n'
                'Para proporcionar uma experiência completa aos usuários, coletamos informações pessoais como nome completo, CPF, telefone, e-mail e endereço, essenciais para a criação de cadastro, processamento de pedidos e emissão de documentos fiscais. Dados de pagamento, incluindo informações de cartão de crédito ou chave Pix, são armazenados de forma criptografada, assegurando máxima proteção. Esses dados são utilizados exclusivamente para finalidades operacionais, como confirmação de pedidos, envio de notificações via WhatsApp e cumprimento de obrigações legais.',
                style: TextStyle(fontSize: 16, color: textColor),
              ),
              const SizedBox(height: 16),
              Text(
                'Compartilhamento de Informações\n\n'
                'A Lanchonete da Carminha assegura que seus dados pessoais não serão comercializados. O compartilhamento ocorre apenas com parceiros operacionais, como empresas de entrega e processadores de pagamento, sempre limitado ao estritamente necessário para a execução dos serviços. Em situações específicas, as informações podem ser divulgadas a autoridades competentes, conforme exigido por lei.',
                style: TextStyle(fontSize: 16, color: textColor),
              ),
              const SizedBox(height: 16),
              Text(
                'Direitos dos Usuários\n\n'
                'De acordo com a LGPD, você possui direitos claros sobre seus dados pessoais. É possível acessar, corrigir ou atualizar suas informações diretamente na seção "Minha Conta" do aplicativo. Também é garantido o direito de solicitar a exclusão dos dados, exceto aqueles retidos por obrigações legais ou fiscais. Caso deseje revogar o consentimento para o tratamento de dados, basta entrar em contato através dos canais oficiais de atendimento.',
                style: TextStyle(fontSize: 16, color: textColor),
              ),
              const SizedBox(height: 16),
              Text(
                'Medidas de Segurança\n\n'
                'Implementamos rigorosas medidas técnicas e administrativas para proteger seus dados contra acessos não autorizados ou situações de perda. Todas as informações sensíveis, como senhas e dados financeiros, são criptografadas utilizando padrões avançados (AES-256). A equipe responsável pelo manuseio desses dados é devidamente treinada, e o acesso é restrito a pessoal autorizado. Adicionalmente, realizamos backups diários, armazenados em ambiente seguro e controlado.',
                style: TextStyle(fontSize: 16, color: textColor),
              ),
              const SizedBox(height: 16),
              Text(
                'Links de Referência',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.laranja,
                ),
              ),
              const SizedBox(height: 8),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => _abrirLink(
                    'https://www.planalto.gov.br/ccivil_03/_ato2015-2018/2018/lei/l13709.htm',
                  ),
                  child: Text(
                    'Lei nº 13.709/2018',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.laranja,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => _abrirLink('https://www.gov.br/anpd/pt-br'),
                  child: Text(
                    'Orientações da ANPD',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.laranja,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
