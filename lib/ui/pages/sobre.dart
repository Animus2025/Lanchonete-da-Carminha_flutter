import 'package:flutter/material.dart';
import '../themes/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class Sobre extends StatelessWidget {
  const Sobre({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyMedium;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sobre',
          style: TextStyle(
            color: AppColors.laranja,
            fontWeight: FontWeight.bold,
            fontFamily: 'Arial',
          ),
        ),
        backgroundColor: AppColors.preto,
        iconTheme: const IconThemeData(color: AppColors.laranja),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(0), // ou 24.0 se preferir
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                color: AppColors.preto,
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // Agora a logo ocupa quase toda a largura disponível
                      double maxLogoWidth = constraints.maxWidth * 0.96;
                      return Image.asset(
                        'lib/assets/icons/logo.png', // Corrija o caminho se necessário
                        height: 50,
                        width: maxLogoWidth,
                        fit: BoxFit.contain,
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(
                  24.0,
                ), // Padding só para o conteúdo
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _titulo('Lanchonete da Carminha'),
                    const SizedBox(height: 16),
                    _paragrafo('Versão: 1.0.0', textStyle),
                    const SizedBox(height: 16),
                    _paragrafo(
                      'Aplicativo para encomendas da Lanchonete da Carminha.',
                      textStyle,
                    ),
                    const SizedBox(height: 16),
                    _titulo('Desenvolvido pela Empresa Ânimus'),
                    const SizedBox(height: 12),
                    Image.asset(
                      'lib/assets/icons/logo_animus.png',
                      height: 40,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 32),
                    _titulo('Formas de Pagamento'),
                    const SizedBox(height: 12),
                    // PIX
                    const Text(
                      'Pix',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.preto,
                        fontFamily: 'BebasNeue',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Image.asset(
                          'lib/assets/icons/band-pix.png',
                          height: 28,
                          width: 44,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Cartões de Crédito
                    const Text(
                      'Cartões de Crédito',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.preto,
                        fontFamily: 'BebasNeue',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Image.asset(
                          'lib/assets/icons/band-visa.png',
                          height: 28,
                          width: 44,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(width: 8),
                        Image.asset(
                          'lib/assets/icons/band-mastercard.png',
                          height: 28,
                          width: 44,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(width: 8),
                        Image.asset(
                          'lib/assets/icons/band-hipercard.png',
                          height: 28,
                          width: 44,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(width: 8),
                        Image.asset(
                          'lib/assets/icons/band-elo.png',
                          height: 28,
                          width: 44,
                          fit: BoxFit.contain,
                        ),
                        // Adicione mais imagens conforme necessário
                      ],
                    ),
                    const SizedBox(height: 32),
                    _titulo('Redes Sociais'),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        // WhatsApp
                        GestureDetector(
                          onTap: () async {
                            // Use o pacote url_launcher para abrir o link
                            final url = Uri.parse('https://api.whatsapp.com/send/?phone=5531971520049&text&type=phone_number&app_absent=0');
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url);
                            }
                          },
                          child: Row(
                            children: [
                              Image.asset(
                                'lib/assets/icons/logo_whats.png',
                                height: 32,
                                width: 32,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'WhatsApp',
                                style: TextStyle(
                                  color: Colors.green[800],
                                  fontSize: 18,
                                  fontFamily: 'BebasNeue',
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 24),
                        // Instagram
                        GestureDetector(
                          onTap: () async {
                            final url = Uri.parse('https://www.instagram.com/lanchonete_carminha/');
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url);
                            }
                          },
                          child: Row(
                            children: [
                              Image.asset(
                                'lib/assets/icons/logo_insta.png',
                                height: 32,
                                width: 32,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Instagram',
                                style: TextStyle(
                                  color: Colors.purple,
                                  fontSize: 18,
                                  fontFamily: 'BebasNeue',
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 24),
                        // Facebook
                        GestureDetector(
                          onTap: () async {
                            final url = Uri.parse('https://www.facebook.com/lanchonetedacarminha');
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url);
                            }
                          },
                          child: Row(
                            children: [
                              Image.asset(
                                'lib/assets/icons/logo_facebook.png',
                                height: 32,
                                width: 32,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Facebook',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 18,
                                  fontFamily: 'BebasNeue',
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    _titulo('Contatos'),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.phone, color: AppColors.laranja, size: 24),
                        const SizedBox(width: 8),
                        Text(
                          '(31) 97152-0049',
                          style: TextStyle(
                            color: AppColors.preto,
                            fontSize: 18,
                            fontFamily: 'BebasNeue',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.email, color: AppColors.laranja, size: 24),
                        const SizedBox(width: 8),
                        Text(
                          'lanchonetecarminha@gmail.com',
                          style: TextStyle(
                            color: AppColors.preto,
                            fontSize: 18,
                            fontFamily: 'BebasNeue',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _titulo(String texto) {
    return Padding(
      padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
      child: Text(
        texto,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: AppColors.preto,
          fontFamily: 'BebasNeue',
        ),
      ),
    );
  }

  Widget _paragrafo(String texto, TextStyle? estilo) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        texto,
        style:
            estilo?.copyWith(
              color: AppColors.preto,
              fontSize: 18,
              fontFamily: 'BebasNeue',
            ) ??
            const TextStyle(
              color: AppColors.preto,
              fontSize: 18,
              fontFamily: 'BebasNeue',
            ),
      ),
    );
  }
}
