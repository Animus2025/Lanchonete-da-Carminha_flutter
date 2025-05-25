import 'package:flutter/material.dart';

class PasswordRulesWidget extends StatelessWidget {
  final String senhaAtual;

  const PasswordRulesWidget({Key? key, required this.senhaAtual}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Regras da senha:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 5),
          _buildRegraItem(
            'Mínimo de 8 caracteres',
            senhaAtual.length >= 8,
          ),
          _buildRegraItem(
            'Pelo menos uma letra maiúscula',
            senhaAtual.contains(RegExp(r'[A-Z]')),
          ),
          _buildRegraItem(
            'Pelo menos um caractere especial',
            senhaAtual.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]')),
          ),
          _buildRegraItem(
            'Sem sequências numéricas (ex: 123)',
            !RegExp(r'012|123|234|345|456|567|678|789').hasMatch(senhaAtual),
          ),
        ],
      ),
    );
  }

  Widget _buildRegraItem(String regra, bool atendida) {
    return Row(
      children: [
        Icon(
          atendida ? Icons.check_circle : Icons.cancel,
          color: atendida ? Colors.green : Colors.red,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          regra,
          style: TextStyle(
            color: atendida ? Colors.green : Colors.red,
          ),
        ),
      ],
    );
  }
}