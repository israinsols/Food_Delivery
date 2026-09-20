import 'package:flutter/material.dart';
import 'package:foodos/core/theme/app_colors.dart';
import 'package:foodos/core/widgets/gradient_text.dart';

class ProfitLossReportScreen extends StatelessWidget {
  const ProfitLossReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Profit & Loss')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildNetProfitCard(),
          const SizedBox(height: 20),
          _buildSection('Revenue', [
            _buildPLRow('Food Sales', 'Rs 8.5L', true),
            _buildPLRow('Beverages', 'Rs 1.2L', true),
            _buildPLRow('Other Income', 'Rs 15K', true),
            _buildDivider(),
            _buildPLRow('Total Revenue', 'Rs 9.85L', true, isBold: true),
          ]),
          const SizedBox(height: 16),
          _buildSection('Cost of Goods Sold', [
            _buildPLRow('Ingredients', 'Rs 3.2L', false),
            _buildPLRow('Packaging', 'Rs 45K', false),
            _buildDivider(),
            _buildPLRow('Total COGS', 'Rs 3.65L', false, isBold: true),
          ]),
          const SizedBox(height: 16),
          _buildSection('Gross Profit', [
            _buildPLRow('Gross Profit', 'Rs 6.2L', true, isBold: true),
            _buildPLRow('Gross Margin', '62.9%', true, isBold: true),
          ]),
          const SizedBox(height: 16),
          _buildSection('Operating Expenses', [
            _buildPLRow('Staff Salaries', 'Rs 2.4L', false),
            _buildPLRow('Rent', 'Rs 75K', false),
            _buildPLRow('Utilities', 'Rs 96K', false),
            _buildPLRow('Marketing', 'Rs 25K', false),
            _buildPLRow('Other Expenses', 'Rs 32K', false),
            _buildDivider(),
            _buildPLRow('Total Expenses', 'Rs 4.68L', false, isBold: true),
          ]),
          const SizedBox(height: 16),
          _buildSection('Net Profit', [
            _buildPLRow('Net Profit', 'Rs 1.52L', true, isBold: true),
            _buildPLRow('Net Margin', '15.4%', true, isBold: true),
          ]),
        ],
      ),
    );
  }

  Widget _buildNetProfitCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.success.withValues(alpha: 0.12), AppColors.success.withValues(alpha: 0.06)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.25), width: 1),
      ),
      child: Column(
        children: [
          Text('NET PROFIT THIS MONTH', style: TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textHint, letterSpacing: 1.2)),
          const SizedBox(height: 8),
          GradientText(
            text: 'Rs 1,52,000',
            style: const TextStyle(fontFamily: 'Inter', fontSize: 32, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(6)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.trending_up, color: AppColors.success, size: 14),
                SizedBox(width: 4),
                Text('+12.5% vs last month', style: TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.success)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title.toUpperCase(), style: TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textHint, letterSpacing: 1.2)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.borderLight, width: 1)),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildPLRow(String label, String amount, bool isPositive, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontFamily: 'Inter', fontSize: isBold ? 14 : 13, fontWeight: isBold ? FontWeight.w700 : FontWeight.w500, color: AppColors.textPrimary)),
          Text(
            amount,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: isBold ? 14 : 13,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
              color: isPositive ? AppColors.success : AppColors.error,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(height: 1, color: AppColors.borderLight),
    );
  }
}
