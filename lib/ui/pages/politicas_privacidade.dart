import 'package:flutter/material.dart';

class PoliticaPrivacidadePage extends StatelessWidget {
  const PoliticaPrivacidadePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyMedium;

    return Scaffold(
      appBar: AppBar(title: const Text('Política de Privacidade')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Última atualização: 21/05/2025\n', style: textStyle),
            _titulo('1. Coleta de Informações'),
            _paragrafo(
              'Coletamos informações fornecidas por você ao utilizar o app, como:\n'
              '- Nome\n'
              '- Endereço de e-mail\n'
              '- Endereço de entrega (se houver pedidos no app)\n'
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
              '- Processar pagamentos (se aplicável)\n'
              '- Serviços de entrega (se houver)\n',
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
              '📧 carminha@salgadosdeluxo.com\n'
              '📞 (99) 99999-9999\n',
              textStyle,
            ),
          ],
        ),
      ),
    );
  }

  Widget _titulo(String texto) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        texto,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _paragrafo(String texto, TextStyle? estilo) {
    return Text(texto, style: estilo);
  }
}
