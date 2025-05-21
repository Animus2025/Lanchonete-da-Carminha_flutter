import 'package:flutter/material.dart';
import '../themes/app_theme.dart';

class PoliticaPrivacidadePage extends StatelessWidget {
  const PoliticaPrivacidadePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyMedium;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Políticas de Privacidade',
          style: TextStyle(
            color: AppColors.laranja, // Altere para a cor desejada
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.preto, // Altere para a cor desejada
        iconTheme: const IconThemeData(
          color: AppColors.laranja,
        ), // Ícone do menu também
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Última atualização: 21/05/2025\n',
              style: TextStyle(color: AppColors.preto),
            ),
            _titulo('1. Coleta de Informações'),
            _paragrafo(
              'Coletamos informações fornecidas por você ao utilizar o app, como:\n'
              '- Nome\n'
              '- CPF\n'
              '- Endereço de e-mail\n'
              '- Número de telefone\n'
              '- Endereço residencial\n'
              '- Informações de navegação (cookies ou logs de uso)\n',
              textStyle,
            ),
            _titulo('2. Uso das Informações'),
            _paragrafo(
              'As informações coletadas são utilizadas para:\n'
              '- Processar pedidos\n'
              '- Melhorar sua experiência no app\n'
              '- Enviar notificações relacionadas ao pedido (ex: confirmação, promoções)\n',
              textStyle,
            ),
            _titulo('3. Compartilhamento de Dados'),
            _paragrafo(
              'Não compartilhamos seus dados com terceiros, exceto quando necessário para:\n'
              '- Cumprir exigências legais\n'
              '- Processar pagamentos (se aplicável)\n',
              textStyle,
            ),
            _titulo('4. Segurança'),
            _paragrafo(
              'Adotamos medidas de segurança para proteger suas informações contra acesso não autorizado, '
              'alteração, divulgação ou destruição.\n',
              textStyle,
            ),
            _titulo('5. Seus Direitos'),
            _paragrafo(
              'Você pode solicitar:\n'
              '- Acesso aos seus dados\n'
              '- Correção ou exclusão de dados\n'
              '- Cancelamento do uso das informações\n',
              textStyle,
            ),
            _titulo('6. Contato'),
            _paragrafo(
              'Se tiver dúvidas, entre em contato conosco:\n'
              '📧 lanchonetecarminha@gmail.com\n'
              '📞 (31) 97152-0049\n',
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
          fontSize: 22, // Fonte maior para o título
          fontWeight: FontWeight.bold,
          color: AppColors.preto, // Exemplo de cor
          fontFamily: 'Arial', // Escolha sua fonte aqui
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
              fontSize: 18, // Fonte maior para o texto
              fontFamily: 'Arial', // Escolha sua fonte aqui
            ) ??
            const TextStyle(
              color: AppColors.preto,
              fontSize: 18,
              fontFamily: 'Arial', // Escolha sua fonte aqui
            ),
      ),
    );
  }
}
