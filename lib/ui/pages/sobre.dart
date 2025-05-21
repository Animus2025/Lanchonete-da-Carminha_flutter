import 'package:flutter/material.dart';
import '../themes/app_theme.dart';

class Sobre extends StatelessWidget {
  const Sobre({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Usa o mesmo estilo de texto das políticas
    final textStyle = Theme.of(context).textTheme.bodyMedium;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sobre',
          style: TextStyle(
            color: AppColors.laranja,
            fontWeight: FontWeight.bold,
            fontFamily: 'Arial', // Mesma fonte do título das políticas
          ),
        ),
        backgroundColor: AppColors.preto,
        iconTheme: const IconThemeData(
          color: AppColors.laranja,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _titulo('Lanchonete da Carminha'),
            const SizedBox(height: 16),
            _paragrafo('Versão: 1.0.0', textStyle),
            const SizedBox(height: 16),
            _paragrafo('Desenvolvido por: Seu Nome ou Empresa', textStyle),
            const SizedBox(height: 24),
            _paragrafo(
              'Aplicativo para pedidos e cardápio da Lanchonete da Carminha.',
              textStyle,
            ),
          ],
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
          fontFamily: 'Arial', // Mesma fonte do título das políticas
        ),
      ),
    );
  }

  Widget _paragrafo(String texto, TextStyle? estilo) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        texto,
        style: estilo?.copyWith(
              color: AppColors.preto,
              fontSize: 18,
              fontFamily: 'Arial', // Mesma fonte dos parágrafos das políticas
            ) ??
            const TextStyle(
              color: AppColors.preto,
              fontSize: 18,
              fontFamily: 'Arial',
            ),
      ),
    );
  }
}