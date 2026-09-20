import 'package:flutter/material.dart';
import 'package:foodos/core/theme/app_colors.dart';

class InventoryReportScreen extends StatelessWidget {
  const InventoryReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Inventory Report')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSummaryCards(),
          const SizedBox(height: 20),
          _buildSection('Stock by Category', [
            _buildCategoryBar('Fresh Produce', 0.75, '45 items', AppColors.success),
            _buildCategoryBar('Meat & Seafood', 0.60, '28 items', AppColors.warning),
            _buildCategoryBar('Dairy', 0.45, '18 items', AppColors.primary),
            _buildCategoryBar('Beverages', 0.80, '32 items', AppColors.info),
            _buildCategoryBar('Frozen', 0.30, '12 items', AppColors.error),
          ]),
          const SizedBox(height: 20),
          _buildSection('Low Stock Alerts', [
            _buildAlertItem('Chicken Breast', '3 left', 'Min: 10', AppColors.error),
            _buildAlertItem('Fresh Milk', '5 left', 'Min: 15', AppColors.warning),
            _buildAlertItem('Tomatoes', '8 left', 'Min: 20', AppColors.warning),
            _buildAlertItem('Cooking Oil', '2 left', 'Min: 5', AppColors.error),
          ]),
          const SizedBox(height: 20),
          _buildSection('Top Consumed Items', [
            _buildConsumedItem('Chicken Breast', '245 kg', 'Rs 73,500'),
            _buildConsumedItem('Rice (Basmati)', '180 kg', 'Rs 27,000'),
            _buildConsumedItem('Cooking Oil', '45 L', 'Rs 11,250'),
            _buildConsumedItem('Onions', '90 kg', 'Rs 13,500'),
          ]),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Row(
      children: [
        Expanded(child: _buildCard('Total Items', '135', AppColors.primary)),
        const SizedBox(width: 12),
        Expanded(child: _buildCard('Low Stock', '8', AppColors.warning)),
        const SizedBox(width: 12),
        Expanded(child: _buildCard('Value', 'Rs 4.2L', AppColors.success)),
      ],
    );
  }

  Widget _buildCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderLight, width: 1),
      ),
      child: Column(
        children: [
          Text(value, style: TextStyle(fontFamily: 'Inter', fontSize: 20, fontWeight: FontWeight.w800, color: color)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textHint)),
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

  Widget _buildCategoryBar(String name, double value, String count, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
              Text(count, style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textHint)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: value,
              backgroundColor: AppColors.borderLight,
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertItem(String name, String stock, String min, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(width: 4, height: 36, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
                Text(min, style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textHint)),
              ],
            ),
          ),
          Text(stock, style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600, color: color)),
        ],
      ),
    );
  }

  Widget _buildConsumedItem(String name, String qty, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(child: Text(name, style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.textPrimary))),
          Text(qty, style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textSecondary)),
          const SizedBox(width: 16),
          Text(value, style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary)),
        ],
      ),
    );
  }
}
