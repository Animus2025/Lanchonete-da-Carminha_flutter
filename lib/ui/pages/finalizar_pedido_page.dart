import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lanchonetedacarminha/ui/themes/app_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:auto_size_text/auto_size_text.dart';

class FinalizarPedidoPage extends StatefulWidget {
  const FinalizarPedidoPage({super.key});

  @override
  State<FinalizarPedidoPage> createState() => _FinalizarPedidoPageState();
}

class _FinalizarPedidoPageState extends State<FinalizarPedidoPage> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? pagamentoTipo;
  String? formaPagamento;

  // Estilo para as áreas sombreadas
  final BoxDecoration _boxDecoration = BoxDecoration(
    border: Border.all(color: Colors.grey.shade300),
    borderRadius: BorderRadius.circular(8),
    color: Colors.grey.shade100,
  );

  @override
  Widget build(BuildContext context) {
    final bool habilitaFormasPagamento = selectedDate != null && selectedTime != null;
    final bool habilitarFinalizar = habilitaFormasPagamento && pagamentoTipo != null;

    return Scaffold(
      appBar: AppBar(title: const Text('FINALIZAR PEDIDO'), centerTitle: true),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 🔎 Mapa com localização
                _mapaLocalizacao(),

                const SizedBox(height: 10),

                // 📆 Data e 🕐 Horário lado a lado
                Container(
                  decoration: _boxDecoration,
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

                // 💳 Modo de pagamento (com texto em duas linhas)
                Container(
                  decoration: _boxDecoration,
                  padding: const EdgeInsets.all(8),
                  child: _modoPagamento(),
                ),

                const SizedBox(height: 10),

                // 💰 Formas de pagamento (desativada até escolher data e hora)
                Opacity(
                  opacity: habilitaFormasPagamento ? 1.0 : 0.4,
                  child: IgnorePointer(
                    ignoring: !habilitaFormasPagamento,
                    child: Container(
                      decoration: _boxDecoration,
                      padding: const EdgeInsets.all(8),
                      child: _formaPagamentoWidget(metodoLimitado: pagamentoTipo == '50%'),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // 💵 Total e botões
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Total do pedido com box sombreado
                    Container(
                      decoration: _boxDecoration,
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: const [
                          AutoSizeText(
                            "TOTAL DO PEDIDO",
                            style: TextStyle(fontWeight: FontWeight.bold),
                            maxLines: 1,
                            minFontSize: 12,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 4),
                          AutoSizeText(
                            "R\$ 52,22",
                            style: TextStyle(fontSize: 20),
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
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.cinza,
                              foregroundColor: Colors.white,
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
                              foregroundColor: Colors.white,
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 📍 Mapa e redirecionamento
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

  // 📅 Campo de data
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

  // 🕐 Campo de horário
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

  // 💳 Modo de pagamento com texto em duas linhas para a opção de 50%
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

  // 💰 Formas de pagamento
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

  // ✅ Finaliza pedido
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

  // ℹ️ Diálogo de informações sobre pagamento parcelado
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
}