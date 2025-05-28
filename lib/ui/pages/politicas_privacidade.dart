import 'package:flutter/material.dart';
import '../themes/app_theme.dart';

/// Página que exibe as Políticas de Privacidade do aplicativo.
/// Permite alternar entre modo claro e escuro usando o botão na AppBar.
class PoliticaPrivacidadePage extends StatelessWidget {
  /// Função para alternar o tema do app (claro/escuro).
  final VoidCallback? toggleTheme;

  /// Construtor da página, recebe a função de alternância de tema.
  const PoliticaPrivacidadePage({Key? key, this.toggleTheme}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Detecta se o app está no modo escuro.
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    // Define a cor do texto conforme o tema.
    final textColor = isDarkMode ? AppColors.laranja : AppColors.preto;

    return Scaffold(
      // AppBar personalizada com título, cor e botão de alternância de tema.
      appBar: AppBar(
        title: const Text(
          'Políticas de Privacidade',
          style: TextStyle(
            color: AppColors.laranja,
            fontWeight: FontWeight.bold,
            fontFamily: 'BebasNeue',
          ),
        ),
        backgroundColor: AppColors.preto,
        iconTheme: const IconThemeData(color: AppColors.laranja),
        actions: [
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: AppColors.laranja,
            ),
            onPressed: () {
              // Chama a função de alternância de tema, se fornecida.
              if (toggleTheme != null) {
                toggleTheme!();
              } else {
                // Alternativa para navegação por rota sem parâmetro.
                final parent = ModalRoute.of(context)?.settings.arguments;
                if (parent is VoidCallback) parent();
              }
            },
            tooltip: 'Alternar tema',
          ),
        ],
      ),
      // Corpo da página com rolagem e padding.
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título centralizado e destacado.
            Center(
              child: Text(
                'Políticas de Privacidade - Lanchonete da Carminha',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.laranja,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'BebasNeue',
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Data da última atualização.
            Text(
              'Última atualização: 28/05/2025\n',
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontFamily: 'BebasNeue',
              ),
            ),
            // Seções da política de privacidade, cada uma com título e parágrafo.
            _titulo('1. Coleta de Informações', textColor),
            _paragrafo(
              'Coletamos informações fornecidas por você ao utilizar o app, como:\n'
              '- Nome\n'
              '- CPF\n'
              '- Endereço de e-mail\n'
              '- Número de telefone\n'
              '- Endereço residencial\n'
              '- Informações de navegação (cookies ou logs de uso)\n',
              textColor,
            ),
            _titulo('2. Uso das Informações', textColor),
            _paragrafo(
              'As informações coletadas são utilizadas para:\n'
              '- Processar pedidos\n'
              '- Melhorar sua experiência no app\n'
              '- Enviar notificações relacionadas ao pedido (ex: confirmação, promoções)\n',
              textColor,
            ),
            _titulo('3. Compartilhamento de Dados', textColor),
            _paragrafo(
              'Não compartilhamos seus dados com terceiros, exceto quando necessário para:\n'
              '- Cumprir exigências legais\n'
              '- Processar pagamentos (se aplicável)\n',
              textColor,
            ),
            _titulo('4. Segurança', textColor),
            _paragrafo(
              'Adotamos medidas de segurança para proteger suas informações contra acesso não autorizado, '
              'alteração, divulgação ou destruição.\n',
              textColor,
            ),
            _titulo('5. Seus Direitos', textColor),
            _paragrafo(
              'Você pode solicitar:\n'
              '- Acesso aos seus dados\n'
              '- Correção ou exclusão de dados\n'
              '- Cancelamento do uso das informações\n',
              textColor,
            ),
            _titulo('6. Retenção de Dados', textColor),
            _paragrafo(
              'Seus dados serão mantidos enquanto sua conta estiver ativa ou conforme necessário para cumprir obrigações legais.\n',
              textColor,
            ),
            _titulo('7. Alterações nesta Política', textColor),
            _paragrafo(
              'Podemos atualizar esta política periodicamente. Notificaremos sobre mudanças relevantes pelo app ou e-mail.\n',
              textColor,
            ),
            _titulo('8. Consentimento', textColor),
            _paragrafo(
              'Ao utilizar nosso aplicativo, você concorda com esta Política de Privacidade.\n',
              textColor,
            ),
            _titulo('9. Contato', textColor),
            _paragrafo(
              'Se tiver dúvidas, entre em contato conosco:\n'
              '📧 lanchonetecarminha@gmail.com\n'
              '📞 (31) 97152-0049\n',
              textColor,
            ),
          ],
        ),
      ),
    );
  }

  /// Widget auxiliar para exibir títulos das seções, com cor e fonte padronizadas.
  Widget _titulo(String texto, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
      child: Text(
        texto,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: textColor,
          fontFamily: 'BebasNeue',
        ),
      ),
    );
  }

  /// Widget auxiliar para exibir parágrafos das seções, com cor e fonte padronizadas.
  Widget _paragrafo(String texto, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        texto,
        style: TextStyle(
          color: textColor,
          fontSize: 16,
          fontFamily: 'BebasNeue',
        ),
      ),
    );
  }
}
