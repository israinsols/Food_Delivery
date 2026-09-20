import 'package:flutter/material.dart';
import 'package:foodos/core/theme/app_colors.dart';
import 'package:foodos/core/theme/app_text_styles.dart';

class DailyClosingScreen extends StatelessWidget {
  const DailyClosingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daily Closing')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Date
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Date', style: AppTextStyles.bodyMedium),
                Text('Aug 30, 2026', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Sales
          Text('Sales Summary', style: AppTextStyles.h4),
          const SizedBox(height: 8),
          _ClosingRow(label: 'Cash Sales', value: 'Rs 28,000'),
          _ClosingRow(label: 'Card Sales', value: 'Rs 12,000'),
          _ClosingRow(label: 'Online Sales', value: 'Rs 5,200'),
          _ClosingRow(label: 'Total Sales', value: 'Rs 45,200', isBold: true),
          const SizedBox(height: 16),

          // Expenses
          Text('Expenses', style: AppTextStyles.h4),
          const SizedBox(height: 8),
          _ClosingRow(label: 'Total Expenses', value: 'Rs 8,500', isNegative: true),
          const SizedBox(height: 16),

          // Cash Drawer
          Text('Cash Drawer', style: AppTextStyles.h4),
          const SizedBox(height: 8),
          _ClosingRow(label: 'Expected Cash', value: 'Rs 28,000'),
          _ClosingRow(label: 'Cash Counted', value: 'Rs 27,800'),
          _ClosingRow(label: 'Variance', value: '-Rs 200', isNegative: true),
          const SizedBox(height: 24),

          // Profit
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Net Profit', style: AppTextStyles.h4),
                Text('Rs 36,700', style: AppTextStyles.h3.copyWith(color: AppColors.success)),
              ],
            ),
          ),
          const SizedBox(height: 24),

          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                // TODO: Close day
              },
              child: const Text('Close Day'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ClosingRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final bool isNegative;
  const _ClosingRow({required this.label, required this.value, this.isBold = false, this.isNegative = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodyMedium),
          Text(
            value,
            style: TextStyle(
              fontSize: isBold ? 16 : 14,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
              color: isNegative ? AppColors.error : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
