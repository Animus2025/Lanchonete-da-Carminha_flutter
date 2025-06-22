import 'package:flutter/material.dart';
import 'package:lanchonetedacarminha/ui/widgets/custom_app_bar.dart';
import 'package:lanchonetedacarminha/ui/themes/app_theme.dart';
import 'package:lanchonetedacarminha/ui/widgets/custom_drawer.dart';
import 'package:lanchonetedacarminha/providers/cart_provider.dart';
import 'package:lanchonetedacarminha/ui/widgets/app_body_container.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../themes/app_theme.dart';

class RevisaoPedidoPage extends StatefulWidget {
  final VoidCallback toggleTheme;

  const RevisaoPedidoPage({super.key, required this.toggleTheme});

  @override
  State<RevisaoPedidoPage> createState() => _RevisaoPedidoPageState();
}

class _RevisaoPedidoPageState extends State<RevisaoPedidoPage> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  // Variáveis para o passo 2
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? pagamentoTipo;
  String? formaPagamento;

  @override
  void dispose() {
    _pageController.dispose();
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
            // Barra de progresso
            Padding(
              padding: const EdgeInsets.only(top: 16, left: 8, right: 8, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStep('1', 'REVER PEDIDO', _currentStep == 0, stepTextColor),
                  _buildStep('2', 'FINALIZAR PEDIDO', _currentStep == 1, stepTextColor),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: LinearProgressIndicator(
                value: progressValue,
                backgroundColor: Colors.grey[200],
                color: AppColors.laranja,
                minHeight: 3,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Divider(
                thickness: 1,
                height: 24,
                color: isDark ? AppColors.laranja : Colors.black,
              ),
            ),

            // Conteúdo dos passos
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildRevisaoPedido(cartItems, isDark, isMobile, screenWidth, stepTextColor),
                  _buildFinalizarPedidoStep2(isDark, cartItems),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget para o step 1 — Revisão do pedido
  Widget _buildRevisaoPedido(List cartItems, bool isDark, bool isMobile, double screenWidth, Color stepTextColor) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 16),

        // Cabeçalho da tabela
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

        // Lista de itens
        Expanded(
          child: ListView.builder(
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              final item = cartItems[index];
              return _buildCartItem(context, item, index, isMobile, screenWidth);
            },
          ),
        ),

        const SizedBox(height: 16),

        // Total do pedido
        _buildTotalBox(cartItems, isDark, isMobile),

        const SizedBox(height: 16),

        // Botões
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                style: _buttonStyle(isDark, isMobile),
                icon: Icon(Icons.arrow_back, color: AppColors.laranja, size: isMobile ? 18 : 24),
                label: Text(
                  'CONTINUAR COMPRANDO',
                  style: _buttonTextStyle(isMobile),
                ),
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
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
                  _pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.ease);
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

  // Widget para o step 2 — Finalizar pedido (adaptado do seu código, sem Scaffold)
  Widget _buildFinalizarPedidoStep2(bool isDark, List cartItems) {
    final bool habilitaFormasPagamento = selectedDate != null && selectedTime != null;
    final bool habilitarFinalizar = habilitaFormasPagamento && pagamentoTipo != null;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _mapaLocalizacao(),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
              color: AppColors.branco,
            ),
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(child: _itemData(context)),
                const SizedBox(width: 8),
                Expanded(child: _itemHorario(context)),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
              color: AppColors.branco,
            ),
            padding: const EdgeInsets.all(8),
            child: _modoPagamento(),
          ),
          const SizedBox(height: 10),
          Opacity(
            opacity: habilitaFormasPagamento ? 1.0 : 0.4,
            child: IgnorePointer(
              ignoring: !habilitaFormasPagamento,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.branco,
                ),
                padding: const EdgeInsets.all(8),
                child: _formaPagamentoWidget(metodoLimitado: pagamentoTipo == '50%'),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
              color: AppColors.branco,
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                const AutoSizeText(
                  "TOTAL DO PEDIDO",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  minFontSize: 12,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                AutoSizeText(
                  "R\$ ${_calcularTotal().toStringAsFixed(2)}",
                  style: const TextStyle(fontSize: 20),
                  maxLines: 1,
                  minFontSize: 16,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _pageController.previousPage(duration: const Duration(milliseconds: 400), curve: Curves.ease);
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
                  onPressed: habilitarFinalizar ? _finalizarPedido : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.verde,
                    foregroundColor: AppColors.branco,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const AutoSizeText(
                    "FINALIZAR PEDIDO",
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

  // COMPONENTES AUXILIARES DO STEP 1

  Widget _buildStep(String number, String label, bool active, Color color) {
    return Column(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: active ? AppColors.laranja : AppColors.laranja.withOpacity(0.5),
          child: Text(
            number,
            style: const TextStyle(
              color: AppColors.preto,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: color,
          ),
        ),
      ],
    );
  }

  ButtonStyle _buttonStyle(bool isDark, bool isMobile) {
    return ElevatedButton.styleFrom(
      backgroundColor: AppColors.preto,
      padding: EdgeInsets.symmetric(vertical: isMobile ? 8 : 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isMobile ? 6 : 8),
      ),
    );
  }

  TextStyle _buttonTextStyle(bool isMobile) {
    return TextStyle(
      color: AppColors.laranja,
      fontWeight: FontWeight.bold,
      fontSize: isMobile ? 13 : 15,
    );
  }

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
        border: Border.all(color: isDark ? AppColors.laranja : Colors.black, width: 1),
        borderRadius: BorderRadius.circular(isMobile ? 6 : 8),
      ),
      child: Column(
        children: [
          Text(
            'TOTAL DO PEDIDO',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isMobile ? 15 : 18,
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

  Widget _buildCartItem(BuildContext context, dynamic item, int index, bool isMobile, double screenWidth) {
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
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: AppColors.cinza,
                      child: const Icon(Icons.image_not_supported),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 16,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.nome,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 20),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: item.tags.map<Widget>((tag) {
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
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
            SizedBox(
              width: isMobile ? 20 : 110,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.add, color: AppColors.laranja),
                    onPressed: () => context.read<CartProvider>().increaseQuantity(index),
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
                      color: item.isBebida
                          ? (item.quantidade > 1 ? AppColors.laranja : AppColors.laranja.withOpacity(0.4))
                          : (item.quantidade > 5 ? AppColors.laranja : AppColors.laranja.withOpacity(0.4)),
                    ),
                    onPressed: item.isBebida
                        ? (item.quantidade > 1
                            ? () => context.read<CartProvider>().decreaseQuantity(index)
                            : null)
                        : (item.quantidade > 5
                            ? () => context.read<CartProvider>().decreaseQuantity(index)
                            : null),
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 2),
                ],
              ),
            ),
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

  // COMPONENTES AUXILIARES DO STEP 2

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
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
            child: GestureDetector(
              onTap: () async {
                const url = 'https://maps.app.goo.gl/MyjnJSZAK1nHgTHK7';
                if (await canLaunchUrl(Uri.parse(url))) {
                  await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
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
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
            ),
            child: Row(
              children: const [
                Icon(Icons.location_pin, color: Colors.white),
                SizedBox(width: 8),
                Expanded(
                  child: AutoSizeText(
                    "R. José Alexandre, Centro - Teixeiras/MG",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                    maxLines: 1,
                    minFontSize: 10,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemData(BuildContext context) {
    return ListTile(
      title: const Text("Data"),
      subtitle: Text(selectedDate == null
          ? 'Selecione'
          : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'),
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
      trailing: const Icon(Icons.calendar_today),
    );
  }

  Widget _itemHorario(BuildContext context) {
    return ListTile(
      title: const Text("Horário"),
      subtitle: Text(selectedTime == null
          ? 'Selecione'
          : selectedTime!.format(context)),
      onTap: () async {
        final TimeOfDay? picked = await showTimePicker(
          context: context,
          initialTime: const TimeOfDay(hour: 9, minute: 0),
          builder: (context, child) {
            return Localizations.override(
              context: context,
              locale: const Locale('pt', 'BR'),
              child: child,
            );
          },
        );
        if (picked != null) setState(() => selectedTime = picked);
      },
      trailing: const Icon(Icons.access_time),
    );
  }

  Widget _modoPagamento() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Modo de pagamento", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text("Pagar integralmente"),
                leading: Radio<String>(
                  value: 'integral',
                  groupValue: pagamentoTipo,
                  onChanged: (value) => setState(() => pagamentoTipo = value),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Pagar 50% agora"),
                    Text("e 50% depois"),
                  ],
                ),
                leading: Radio<String>(
                  value: '50%',
                  groupValue: pagamentoTipo,
                  onChanged: (value) => setState(() => pagamentoTipo = value),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.info_outline, size: 20, color: Colors.orange),
                  onPressed: _showInfoDialog,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _formaPagamentoWidget({required bool metodoLimitado}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Forma de pagamento", style: TextStyle(fontWeight: FontWeight.bold)),
        ListTile(
          leading: Radio<String>(
            value: 'pix',
            groupValue: formaPagamento,
            onChanged: (value) => setState(() => formaPagamento = value),
          ),
          title: const Text("Pix"),
        ),
        if (!metodoLimitado)
          ListTile(
            leading: Radio<String>(
              value: 'cartao',
              groupValue: formaPagamento,
              onChanged: (value) => setState(() => formaPagamento = value),
            ),
            title: const Text("Cartão"),
          ),
        if (formaPagamento == 'cartao')
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: const [
                TextField(decoration: InputDecoration(labelText: "Número do cartão")),
                TextField(decoration: InputDecoration(labelText: "Nome no cartão")),
                TextField(decoration: InputDecoration(labelText: "CVV")),
              ],
            ),
          ),
      ],
    );
  }

  void _finalizarPedido() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Pedido realizado com sucesso!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushNamed(context, '/meus-pedidos');
            },
            child: const Text("Meus Pedidos"),
          ),
        ],
      ),
    );
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Pagamento Parcelado"),
        content: const Text(
          "Com esta opção, você paga metade do valor agora e a outra metade "
          "no momento da retirada do pedido.\n O primeiro pagamento é necessário "
          "para confirmar seu pedido.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Entendi"),
          ),
        ],
      ),
    );
  }

  double _calcularTotal() {
    final cartItems = context.read<CartProvider>().items;
    return cartItems.fold<double>(
      0,
      (sum, item) => sum + item.preco * item.quantidade,
    );
  }
}
