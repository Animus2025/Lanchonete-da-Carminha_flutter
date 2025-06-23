import 'package:flutter/material.dart';
import 'package:lanchonetedacarminha/ui/widgets/custom_app_bar.dart';
import 'package:lanchonetedacarminha/ui/themes/app_theme.dart';
import 'package:lanchonetedacarminha/ui/widgets/custom_drawer.dart';
import 'package:lanchonetedacarminha/providers/cart_provider.dart';
import 'package:lanchonetedacarminha/ui/widgets/app_body_container.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lanchonetedacarminha/providers/auth_provider.dart';

// Página de revisão e finalização do pedido (checkout)
class RevisaoPedidoPage extends StatefulWidget {
  final VoidCallback toggleTheme;

  const RevisaoPedidoPage({super.key, required this.toggleTheme});

  @override
  State<RevisaoPedidoPage> createState() => _RevisaoPedidoPageState();
}

class _RevisaoPedidoPageState extends State<RevisaoPedidoPage> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  // Variáveis para o passo 2 (finalização)
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? pagamentoTipo;
  String? formaPagamento;

  // Controllers para os campos do cartão
  final TextEditingController _cartaoNumeroController = TextEditingController();
  final TextEditingController _cartaoNomeController = TextEditingController();
  final TextEditingController _cartaoCvvController = TextEditingController();

  // Adicione este campo ao seu State:
  bool pedidoFinalizado = false;

  @override
  void dispose() {
    _pageController.dispose();
    _cartaoNumeroController.dispose();
    _cartaoNomeController.dispose();
    _cartaoCvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final stepTextColor = isDark ? AppColors.laranja : Colors.black;
    final cartItems = context.watch<CartProvider>().items;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    double progressValue = (_currentStep + 1) / 2; // 2 passos

    return Scaffold(
      appBar: CustomAppBar(toggleTheme: widget.toggleTheme),
      drawer: const CustomDrawer(),
      body: AppBodyContainer(
        child: Column(
          children: [
            // Barra de progresso dos passos
            Padding(
              padding: const EdgeInsets.only(
                top: 16,
                left: 8,
                right: 8,
                bottom: 8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStep(
                    '1',
                    'REVER PEDIDO',
                    _currentStep == 0,
                    stepTextColor,
                  ),
                  _buildStep(
                    '2',
                    'FINALIZAR PEDIDO',
                    _currentStep == 1,
                    stepTextColor,
                  ),
                ],
              ),
            ),
            // Barra linear de progresso
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: LinearProgressIndicator(
                value: progressValue,
                backgroundColor: Colors.grey[200],
                color: AppColors.laranja,
                minHeight: 3,
              ),
            ),
            // Linha divisória
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Divider(
                thickness: 1,
                height: 24,
                color: isDark ? AppColors.laranja : Colors.black,
              ),
            ),

            // Conteúdo dos passos (PageView)
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildRevisaoPedido(
                    cartItems,
                    isDark,
                    isMobile,
                    screenWidth,
                    stepTextColor,
                  ),
                  _buildFinalizarPedidoStep2(isDark, cartItems),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Passo 1: Revisão do pedido
  Widget _buildRevisaoPedido(
    List cartItems,
    bool isDark,
    bool isMobile,
    double screenWidth,
    Color stepTextColor,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 16),

        // Cabeçalho da tabela de produtos
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'PRODUTO',
                      style: TextStyle(
                        fontSize: 15,
                        color: stepTextColor,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'QUANTIDADE',
                    style: TextStyle(
                      fontSize: 15,
                      color: stepTextColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'PREÇO',
                      style: TextStyle(
                        fontSize: 15,
                        color: stepTextColor,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Lista de itens do carrinho
        Expanded(
          child: ListView.builder(
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              final item = cartItems[index];
              return _buildCartItem(
                context,
                item,
                index,
                isMobile,
                screenWidth,
              );
            },
          ),
        ),

        const SizedBox(height: 16),

        // Total do pedido
        _buildTotalBox(cartItems, isDark, isMobile),

        const SizedBox(height: 16),

        // Botões de navegação
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                style: _buttonStyle(isDark, isMobile),
                icon: Icon(
                  Icons.arrow_back,
                  color: AppColors.laranja,
                  size: isMobile ? 18 : 24,
                ),
                label: Text(
                  'CONTINUAR COMPRANDO',
                  style: _buttonTextStyle(isMobile),
                ),
                onPressed: () {
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil('/', (route) => false);
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                style: _buttonStyle(isDark, isMobile),
                child: Text(
                  'FINALIZAR PEDIDO',
                  style: _buttonTextStyle(isMobile),
                ),
                onPressed: () {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.ease,
                  );
                  setState(() => _currentStep = 1);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  // Passo 2: Finalizar pedido (data, horário, pagamento)
  Widget _buildFinalizarPedidoStep2(bool isDark, List cartItems) {
    final bool habilitaFormasPagamento =
        selectedDate != null && selectedTime != null;
    final bool habilitaFormaPagamento =
        habilitaFormasPagamento &&
        pagamentoTipo != null &&
        formaPagamento != null;

    // Se for cartão, todos os campos devem estar preenchidos
    final bool cartaoPreenchido =
        formaPagamento != 'cartao' ||
        (_cartaoNumeroController.text.trim().isNotEmpty &&
            _cartaoNomeController.text.trim().isNotEmpty &&
            _cartaoCvvController.text.trim().isNotEmpty);

    final bool habilitarFinalizar = habilitaFormaPagamento && cartaoPreenchido;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _mapaLocalizacao(),
          const SizedBox(height: 10),
          // Seleção de data e horário
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
              color: isDark ? AppColors.preto : AppColors.branco,
            ),
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(child: _itemData(context, isDark)),
                const SizedBox(width: 8),
                Expanded(child: _itemHorario(context, isDark)),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // Modo de pagamento (integral ou 50%)
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
              color: isDark ? AppColors.preto : AppColors.branco,
            ),
            padding: const EdgeInsets.all(8),
            child: _modoPagamento(isDark),
          ),

          const SizedBox(height: 10),
          // Forma de pagamento (Pix, Cartão)
          Opacity(
            opacity: habilitaFormasPagamento ? 1.0 : 0.4,
            child: IgnorePointer(
              ignoring: !habilitaFormasPagamento,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                  color: isDark ? AppColors.preto : AppColors.branco,
                ),
                padding: const EdgeInsets.all(8),
                child: _formaPagamentoWidget(
                  metodoLimitado: pagamentoTipo == '50%',
                  isDark: isDark,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Total do pedido
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
              color: isDark ? AppColors.preto : AppColors.branco,
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                AutoSizeText(
                  "TOTAL DO PEDIDO",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.laranja : Colors.black,
                  ),
                  maxLines: 1,
                  minFontSize: 12,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                AutoSizeText(
                  "R\$ ${_calcularTotal().toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 20,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  maxLines: 1,
                  minFontSize: 16,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Botões de navegação
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.ease,
                    );
                    setState(() => _currentStep = 0);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.preto,
                    foregroundColor: AppColors.laranja,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const AutoSizeText(
                    "VOLTAR",
                    maxLines: 1,
                    minFontSize: 14,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: habilitarFinalizar
                      ? () {
                          if (formaPagamento == 'cartao' && !cartaoPreenchido) {
                            showDialog(
                              context: context,
                              builder: (_) => const AlertDialog(
                                title: Text("Preencha todos os dados do cartão!"),
                              ),
                            );
                            return;
                          }
                          _finalizarPedido();
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.verde,
                    foregroundColor: AppColors.branco,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: AutoSizeText(
                    pedidoFinalizado ? "Meus Pedidos" : "FINALIZAR PEDIDO",
                    maxLines: 1,
                    minFontSize: 14,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget auxiliar para mostrar o passo atual
  Widget _buildStep(String number, String label, bool active, Color color) {
    return Column(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor:
              active ? AppColors.laranja : AppColors.laranja.withOpacity(0.5),
          child: Text(
            number,
            style: const TextStyle(
              color: AppColors.preto,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 13, color: color)),
      ],
    );
  }

  // Estilo dos botões principais
  ButtonStyle _buttonStyle(bool isDark, bool isMobile) {
    return ElevatedButton.styleFrom(
      backgroundColor: AppColors.preto,
      padding: EdgeInsets.symmetric(vertical: isMobile ? 8 : 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isMobile ? 6 : 8),
      ),
    );
  }

  // Estilo do texto dos botões
  TextStyle _buttonTextStyle(bool isMobile) {
    return TextStyle(
      color: AppColors.laranja,
      fontWeight: FontWeight.bold,
      fontSize: isMobile ? 13 : 15,
    );
  }

  // Widget para mostrar o total do pedido
  Widget _buildTotalBox(List cartItems, bool isDark, bool isMobile) {
    final total = cartItems.fold<double>(
      0,
      (sum, item) => sum + item.preco * item.quantidade,
    );

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 8 : 12,
        horizontal: isMobile ? 8 : 12,
      ),
      decoration: BoxDecoration(
        color: isDark ? Colors.transparent : Colors.white,
        border: Border.all(
          color: isDark ? AppColors.laranja : Colors.black,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(isMobile ? 6 : 8),
      ),
      child: Column(
        children: [
          Text(
            'TOTAL DO PEDIDO',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: isDark ? AppColors.laranja : Colors.black,
            ),
          ),
          const SizedBox(height: 6),
          Divider(
            color: isDark ? AppColors.laranja : Colors.black,
            thickness: 1,
            height: 8,
          ),
          const SizedBox(height: 6),
          Text(
            'R\$ ${total.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isMobile ? 20 : 24,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  // Widget para cada item do carrinho
  Widget _buildCartItem(
    BuildContext context,
    dynamic item,
    int index,
    bool isMobile,
    double screenWidth,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: AppColors.preto,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.symmetric(vertical: isMobile ? 2 : 4),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Imagem do produto
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: SizedBox(
                width: isMobile ? screenWidth * 0.22 : 120,
                height: isMobile ? screenWidth * 0.22 : 120,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    item.imagem,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) => Container(
                          color: AppColors.cinza,
                          child: const Icon(Icons.image_not_supported),
                        ),
                  ),
                ),
              ),
            ),
            // Nome e tags do produto
            Expanded(
              flex: 16,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.nome,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 20),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children:
                            item.tags.map<Widget>((tag) {
                              Color tagColor;
                              if (tag.toUpperCase() == 'FRITO') {
                                tagColor = AppColors.laranja;
                              } else if (tag.toUpperCase() == 'CONGELADO') {
                                tagColor = Colors.blue[200]!;
                              } else {
                                tagColor = Colors.grey[300]!;
                              }
                              return Container(
                                margin: const EdgeInsets.only(right: 6),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: tagColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  tag,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Controle de quantidade
            SizedBox(
              width: isMobile ? 20 : 110,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.add, color: AppColors.laranja),
                    onPressed:
                        () => context.read<CartProvider>().increaseQuantity(
                          index,
                        ),
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                  ),
                  Text(
                    '${item.quantidade}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.remove,
                      color:
                          item.isBebida
                              ? (item.quantidade > 1
                                  ? AppColors.laranja
                                  : AppColors.laranja.withOpacity(0.4))
                              : (item.quantidade > 5
                                  ? AppColors.laranja
                                  : AppColors.laranja.withOpacity(0.4)),
                    ),
                    onPressed:
                        item.isBebida
                            ? (item.quantidade > 1
                                ? () => context
                                    .read<CartProvider>()
                                    .decreaseQuantity(index)
                                : null)
                            : (item.quantidade > 5
                                ? () => context
                                    .read<CartProvider>()
                                    .decreaseQuantity(index)
                                : null),
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 2),
                ],
              ),
            ),
            // Preço total do item
            Flexible(
              flex: 15,
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'R\$ ${(item.preco * item.quantidade).toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      overflow: TextOverflow.ellipsis,
                    ),
                    softWrap: false,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget do mapa de localização da lanchonete
  Widget _mapaLocalizacao() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: GestureDetector(
              onTap: () async {
                const url = 'https://maps.app.goo.gl/MyjnJSZAK1nHgTHK7';
                if (await canLaunchUrl(Uri.parse(url))) {
                  await launchUrl(
                    Uri.parse(url),
                    mode: LaunchMode.externalApplication,
                  );
                }
              },
              child: Image.asset(
                'lib/assets/icons/mapa_lanchonete.png',
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: const [
                Icon(Icons.location_pin, color: Colors.white),
                SizedBox(width: 8),
                AutoSizeText(
                  "R. José Alexandre, Centro - Teixeiras/MG",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                  maxLines: 1,
                  minFontSize: 10,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget para selecionar a data do pedido
  Widget _itemData(BuildContext context, bool isDark) {
    return ListTile(
      title: Text(
        "Data",
        style: TextStyle(color: isDark ? AppColors.laranja : Colors.black),
      ),
      subtitle: Text(
        selectedDate == null
            ? 'Selecione'
            : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
        style: TextStyle(color: isDark ? AppColors.laranja : Colors.black),
      ),
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          locale: const Locale('pt', 'BR'),
          initialDate: DateTime.now().add(const Duration(days: 1)),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 30)),
        );
        if (picked != null) setState(() => selectedDate = picked);
      },
      trailing: Icon(
        Icons.calendar_today,
        color: isDark ? AppColors.laranja : Colors.black,
      ),
    );
  }

  // Widget para selecionar o horário do pedido
  Widget _itemHorario(BuildContext context, bool isDark) {
    return ListTile(
      title: Text(
        "Horário",
        style: TextStyle(color: isDark ? AppColors.laranja : Colors.black),
      ),
      subtitle: Text(
        selectedTime == null ? 'Selecione' : selectedTime!.format(context),
        style: TextStyle(color: isDark ? AppColors.laranja : Colors.black),
      ),
      onTap: () async {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final TimeOfDay? picked = await showTimePicker(
          context: context,
          initialTime: const TimeOfDay(hour: 9, minute: 0),
          builder: (context, child) {
            final textColor = isDark ? Colors.white : Colors.black;
            return Theme(
              data: Theme.of(context).copyWith(
                timePickerTheme: TimePickerThemeData(
                  hourMinuteTextColor: textColor,
                  dayPeriodTextColor: textColor,
                  dialTextColor: textColor,
                  entryModeIconColor: textColor,
                  helpTextStyle: TextStyle(color: textColor),
                ),
                textTheme: TextTheme(
                  bodyLarge: TextStyle(color: textColor),
                  bodyMedium: TextStyle(color: textColor),
                  titleMedium: TextStyle(color: textColor),
                ),
                colorScheme: Theme.of(context).colorScheme.copyWith(
                  onSurface: textColor,
                  primary: textColor,
                ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null) setState(() => selectedTime = picked);
      },
      trailing: Icon(
        Icons.access_time,
        color: isDark ? AppColors.laranja : Colors.black,
      ),
    );
  }

  // Widget para escolher o modo de pagamento (integral ou 50%)
  Widget _modoPagamento(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Modo de pagamento",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.laranja : Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  "Pagar integralmente",
                  style: TextStyle(
                    color: isDark ? AppColors.laranja : Colors.black,
                  ),
                ),
                leading: Radio<String>(
                  value: 'integral',
                  groupValue: pagamentoTipo,
                  onChanged: (value) => setState(() => pagamentoTipo = value),
                  activeColor: isDark ? AppColors.laranja : Colors.black,
                  fillColor: MaterialStatePropertyAll(
                    isDark ? AppColors.laranja : Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  "Pagar 50% agora\nE 50% depois",
                  style: TextStyle(
                    color: isDark ? AppColors.laranja : Colors.black,
                  ),
                ),
                leading: Radio<String>(
                  value: '50%',
                  groupValue: pagamentoTipo,
                  onChanged: (value) => setState(() => pagamentoTipo = value),
                  activeColor: isDark ? AppColors.laranja : Colors.black,
                  fillColor: MaterialStatePropertyAll(
                    isDark ? AppColors.laranja : Colors.black,
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(
                    Icons.info_outline,
                    size: 20,
                    color: isDark ? AppColors.laranja : Colors.black,
                  ),
                  onPressed: _showInfoDialog,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Widget para escolher a forma de pagamento (Pix, Cartão)
  Widget _formaPagamentoWidget({
    required bool metodoLimitado,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Forma de pagamento",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.laranja : Colors.black,
          ),
        ),
        ListTile(
          leading: Radio<String>(
            value: 'pix',
            groupValue: formaPagamento,
            onChanged: (value) => setState(() => formaPagamento = value),
            activeColor: isDark ? AppColors.laranja : Colors.black,
            fillColor: MaterialStatePropertyAll(
              isDark ? AppColors.laranja : Colors.black,
            ),
          ),
          title: Text(
            "Pix",
            style: TextStyle(color: isDark ? AppColors.laranja : Colors.black),
          ),
        ),
        if (!metodoLimitado)
          ListTile(
            leading: Radio<String>(
              value: 'cartao',
              groupValue: formaPagamento,
              onChanged: (value) => setState(() => formaPagamento = value),
              activeColor: isDark ? AppColors.laranja : Colors.black,
              fillColor: MaterialStatePropertyAll(
                isDark ? AppColors.laranja : Colors.black,
              ),
            ),
            title: Text(
              "Cartão",
              style: TextStyle(
                color: isDark ? AppColors.laranja : Colors.black,
              ),
            ),
          ),
        if (formaPagamento == 'cartao')
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                TextField(
                  controller: _cartaoNumeroController,
                  decoration: const InputDecoration(
                    labelText: "Número do cartão",
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                  style: const TextStyle(color: Colors.black),
                  cursorColor: Colors.black,
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _cartaoNomeController,
                  decoration: const InputDecoration(
                    labelText: "Nome no cartão",
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                  style: const TextStyle(color: Colors.black),
                  cursorColor: Colors.black,
                ),
                TextField(
                  controller: _cartaoCvvController,
                  decoration: const InputDecoration(
                    labelText: "CVV",
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                  style: const TextStyle(color: Colors.black),
                  cursorColor: Colors.black,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  maxLength: 4,
                ),
              ],
            ),
          ),
      ],
    );
  }

  // Função chamada ao finalizar o pedido
  void _finalizarPedido() async {
    // 1. Envia o pedido para o backend e aguarda resposta
    final pedidoId = await _enviarPedidoParaBackend();

    // 2. Se o pedido foi salvo com sucesso, envia o resumo para o WhatsApp
    if (pedidoId != null) {
      final user = Provider.of<AuthProvider>(context, listen: false).userData;
      final cartItems = context.read<CartProvider>().items;

      // Monta os itens no formato esperado pelo backend do WhatsApp
      final itens = cartItems.map((item) => {
        "nome": item.nome,
        "quantidade": item.quantidade,
        "preco_unitario": item.preco,
        "total": item.preco * item.quantidade,
        "estado": item.tags.isNotEmpty ? item.tags.first : "",
        "unidade": item.isBebida ? "Bebida" : "Salgado",
      }).toList();

      final resumo = {
        "id_usuario": user?['id_usuario'],
        "nome_usuario": user?['nome_usuario'] ?? "",
        "email": user?['email'] ?? "",
        "pedidoId": pedidoId,
        "dataRetirada": selectedDate?.toIso8601String().split('T').first ?? "",
        "horarioRetirada": selectedTime?.format(context) ?? "",
        "formaPagamento": formaPagamento ?? "",
        "statusPagamento": "Pendente",
        "itens": itens,
        "subtotal": cartItems.fold<double>(0, (sum, item) => sum + item.preco * item.quantidade),
        "descontos": 0.0,
        "total": cartItems.fold<double>(0, (sum, item) => sum + item.preco * item.quantidade),
      };
      print('Resumo enviado para WhatsApp: $resumo');
      try {
        final response = await http.post(
          Uri.parse('http://localhost:3000/whatsapp/confirmar-pedido'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(resumo),
        );
        if (response.statusCode == 200) {
          print('✅ Resumo do pedido enviado para o WhatsApp!');
        } else {
          print('❌ Erro ao enviar resumo para o WhatsApp: ${response.body}');
        }
      } catch (e) {
        print('❌ Erro de conexão ao enviar resumo para o WhatsApp: $e');
      }
    }

    setState(() {
      pedidoFinalizado = true;
    });
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Row(
          children: const [
            Icon(Icons.check_circle, color: Colors.green, size: 32),
            SizedBox(width: 10),
            Text("Pedido realizado com sucesso!"),
          ],
        ),
        content: const Text(
          "Os detalhes do seu pedido foram enviados por WhatsApp.",
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushNamed(context, '/Meus_pedidos');
            },
            child: const Text("Meus Pedidos"),
          ),
        ],
      ),
    );
  }

  Future<int?> _enviarPedidoParaBackend() async {
    final user = Provider.of<AuthProvider>(context, listen: false).userData;
    final cartItems = context.read<CartProvider>().items;

    // Calcula o valor total do pedido
    final valorTotal = cartItems.fold<double>(
      0,
      (sum, item) => sum + item.preco * item.quantidade,
    );

    // Monta o objeto do pedido conforme esperado pelo backend
    final pedido = {
      "id_usuario": user?['id_usuario'],
      "data_retirada": selectedDate?.toIso8601String().split('T').first,
      "horario_retirada": selectedTime?.format(context),
      "tipo_pagamento": pagamentoTipo,
      "forma_pagamento": formaPagamento,
      "status": "Pendente",
      "valor_total": valorTotal,
      "produtos": cartItems.map((item) => {
        "id_produto": item.id_produto,
        "quantidade": item.quantidade,
        "preco_unitario": item.preco,
      }).toList(),
    };

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/pedidos/pedido'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(pedido),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print('✅ Pedido enviado com sucesso! ID: ${data['id_pedido']}');
        return data['id_pedido']; // <-- Retorna o id_pedido do backend
      } else {
        print('❌ Erro ao enviar pedido: ${response.body}');
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Erro ao enviar pedido"),
            content: Text("Tente novamente. Detalhes: ${response.body}"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("OK"),
              ),
            ],
          ),
        );
        return null;
      }
    } catch (e) {
      print('❌ Erro de conexão ao enviar pedido: $e');
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Erro de conexão"),
          content: Text("Não foi possível conectar ao servidor. Tente novamente.\nErro: $e"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return null;
    }
  }

  // Mostra informações sobre o pagamento parcelado
  void _showInfoDialog() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              "Pagamento Parcelado",
              style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
            ),
            content: Text(
              "Com esta opção, você paga metade do valor agora e a outra metade no momento da retirada do pedido.\n"
              "O primeiro pagamento é necessário para confirmar seu pedido.",
              style: TextStyle(color: textColor),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Entendi",
                  style: TextStyle(color: isDark ? Colors.white : Colors.black),
                ),
              ),
            ],
            backgroundColor: isDark ? Colors.black : Colors.white,
          ),
    );
  }

  // Calcula o valor total do pedido
  double _calcularTotal() {
    final cartItems = context.read<CartProvider>().items;
    return cartItems.fold<double>(
      0,
      (sum, item) => sum + item.preco * item.quantidade,
    );
  }
}
