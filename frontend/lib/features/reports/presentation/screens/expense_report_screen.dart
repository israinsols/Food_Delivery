import 'package:flutter/material.dart';
import 'package:foodos/core/theme/app_colors.dart';

class ExpenseReportScreen extends StatelessWidget {
  const ExpenseReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Expense Report')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSummaryCards(),
          const SizedBox(height: 20),
          _buildSection('Expenses by Category', [
            _buildCategoryBar('Ingredients', 'Rs 1.8L', 0.55, AppColors.primary),
            _buildCategoryBar('Staff Salary', 'Rs 85K', 0.26, AppColors.info),
            _buildCategoryBar('Utilities', 'Rs 32K', 0.10, AppColors.warning),
            _buildCategoryBar('Rent', 'Rs 25K', 0.08, AppColors.error),
            _buildCategoryBar('Other', 'Rs 5K', 0.02, AppColors.textHint),
          ]),
          const SizedBox(height: 20),
          _buildSection('Recent Expenses', [
            _buildExpenseItem('Chicken Purchase', 'Ingredients', 'Rs 12,500', 'Today'),
            _buildExpenseItem('Electric Bill', 'Utilities', 'Rs 8,200', 'Yesterday'),
            _buildExpenseItem('Staff Payroll', 'Staff Salary', 'Rs 85,000', 'Sep 1'),
            _buildExpenseItem('Vegetables', 'Ingredients', 'Rs 6,800', 'Aug 30'),
          ]),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Row(
      children: [
        Expanded(child: _buildCard('This Month', 'Rs 3.2L', AppColors.error)),
        const SizedBox(width: 12),
        Expanded(child: _buildCard('Last Month', 'Rs 2.9L', AppColors.textSecondary)),
        const SizedBox(width: 12),
        Expanded(child: _buildCard('Avg/Day', 'Rs 10.8K', AppColors.warning)),
      ],
    );
  }

  Widget _buildCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.borderLight, width: 1)),
      child: Column(children: [
        Text(value, style: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w800, color: color)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textHint)),
      ]),
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

  Widget _buildCategoryBar(String name, String amount, double value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
              Text(amount, style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600, color: color)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(value: value, backgroundColor: AppColors.borderLight, valueColor: AlwaysStoppedAnimation(color), minHeight: 6),
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseItem(String name, String category, String amount, String date) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
                Text('$category â€¢ $date', style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textHint)),
              ],
            ),
          ),
          Text(amount, style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.error)),
        ],
      ),
    );
  }
}
