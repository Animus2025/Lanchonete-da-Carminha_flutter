import 'package:flutter/material.dart';
import 'package:lanchonetedacarminha/ui/themes/app_theme.dart';

class StepHeader extends StatelessWidget {
  final int currentStep; // 1 ou 2

  const StepHeader({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final stepTextColor = isDark ? AppColors.laranja : Colors.black;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, left: 8, right: 8, bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStep('1', 'REVER PEDIDO', currentStep == 1, stepTextColor),
              _buildStep('2', 'FINALIZAR PEDIDO', currentStep == 2, stepTextColor),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: LinearProgressIndicator(
            value: currentStep == 1 ? 0.5 : 1.0,
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
      ],
    );
  }

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
}
