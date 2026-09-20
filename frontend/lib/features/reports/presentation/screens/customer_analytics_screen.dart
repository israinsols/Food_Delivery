import 'package:flutter/material.dart';
import 'package:foodos/core/theme/app_colors.dart';

class CustomerAnalyticsScreen extends StatelessWidget {
  const CustomerAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Customer Analytics')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSummaryCards(),
          const SizedBox(height: 20),
          _buildSection('Customer Segments', [
            _buildSegmentBar('VIP', 0.15, '42 customers', const Color(0xFFFFD700)),
            _buildSegmentBar('Regular', 0.65, '186 customers', AppColors.primary),
            _buildSegmentBar('New', 0.20, '57 customers', AppColors.info),
          ]),
          const SizedBox(height: 20),
          _buildSection('Top Customers', [
            _buildCustomerItem('Ahmed Khan', 'VIP', 'Rs 1.2L', 28),
            _buildCustomerItem('Fatima Ali', 'VIP', 'Rs 98K', 22),
            _buildCustomerItem('Hassan Raza', 'Regular', 'Rs 75K', 18),
          ]),
          const SizedBox(height: 20),
          _buildSection('Visit Frequency', [
            _buildFreqBar('Daily', 0.25),
            _buildFreqBar('Weekly', 0.45),
            _buildFreqBar('Monthly', 0.20),
            _buildFreqBar('Occasional', 0.10),
          ]),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Row(
      children: [
        Expanded(child: _buildCard('Total', '285', AppColors.info)),
        const SizedBox(width: 12),
        Expanded(child: _buildCard('Active', '210', AppColors.success)),
        const SizedBox(width: 12),
        Expanded(child: _buildCard('Avg Spend', 'Rs 4.2K', AppColors.primary)),
      ],
    );
  }

  Widget _buildCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.borderLight, width: 1)),
      child: Column(children: [
        Text(value, style: TextStyle(fontFamily: 'Inter', fontSize: 20, fontWeight: FontWeight.w800, color: color)),
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

  Widget _buildSegmentBar(String name, double value, String count, Color color) {
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
            child: LinearProgressIndicator(value: value, backgroundColor: AppColors.borderLight, valueColor: AlwaysStoppedAnimation(color), minHeight: 6),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerItem(String name, String type, String spend, int orders) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: type == 'VIP' ? AppColors.warning.withValues(alpha: 0.15) : AppColors.primary.withValues(alpha: 0.1),
            child: Text(name[0], style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w700, color: type == 'VIP' ? AppColors.warning : AppColors.primary)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
                Text('$orders orders', style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textHint)),
              ],
            ),
          ),
          Text(spend, style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary)),
        ],
      ),
    );
  }

  Widget _buildFreqBar(String label, double value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.textPrimary)),
              Text('${(value * 100).toInt()}%', style: TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(value: value, backgroundColor: AppColors.borderLight, valueColor: AlwaysStoppedAnimation(AppColors.primary), minHeight: 6),
          ),
        ],
      ),
    );
  }
}
