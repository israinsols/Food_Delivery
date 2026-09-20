import 'package:flutter/material.dart';
import 'package:foodos/core/theme/app_colors.dart';
import 'package:foodos/core/theme/app_text_styles.dart';

class SalesReportScreen extends StatelessWidget {
  const SalesReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales Report'),
        actions: [
          IconButton(icon: const Icon(Icons.date_range), onPressed: () {}),
          IconButton(icon: const Icon(Icons.download), onPressed: () {}),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Summary Cards
          Row(
            children: [
              Expanded(child: _SummaryCard(title: 'Today', value: 'Rs 45,200', change: '+12%', isPositive: true)),
              const SizedBox(width: 8),
              Expanded(child: _SummaryCard(title: 'Orders', value: '28', change: '+5', isPositive: true)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _SummaryCard(title: 'Avg Order', value: 'Rs 1,614', change: '+8%', isPositive: true)),
              const SizedBox(width: 8),
              Expanded(child: _SummaryCard(title: 'Customers', value: '22', change: '3 new', isPositive: true)),
            ],
          ),
          const SizedBox(height: 20),

          // Sales Chart
          Text('Sales Trend', style: AppTextStyles.h4),
          const SizedBox(height: 12),
          Container(
            height: 200,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: const Center(child: Text('Sales Chart (fl_chart)')),
          ),
          const SizedBox(height: 20),

          // Top Products
          Text('Top Selling Items', style: AppTextStyles.h4),
          const SizedBox(height: 8),
          _ProductRow(rank: 1, name: 'Chicken Biryani', orders: 45, revenue: 'Rs 13,500'),
          _ProductRow(rank: 2, name: 'Seekh Kabab', orders: 32, revenue: 'Rs 6,400'),
          _ProductRow(rank: 3, name: 'Naan', orders: 28, revenue: 'Rs 1,400'),
          _ProductRow(rank: 4, name: 'Samosa', orders: 20, revenue: 'Rs 1,600'),
          _ProductRow(rank: 5, name: 'Lassi', orders: 18, revenue: 'Rs 1,800'),
          const SizedBox(height: 20),

          // Payment Methods
          Text('Payment Methods', style: AppTextStyles.h4),
          const SizedBox(height: 8),
          _PaymentRow(method: 'Cash', amount: 'Rs 28,000', percent: 62),
          _PaymentRow(method: 'Card', amount: 'Rs 12,000', percent: 27),
          _PaymentRow(method: 'Online', amount: 'Rs 5,200', percent: 11),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final String change;
  final bool isPositive;
  const _SummaryCard({required this.title, required this.value, required this.change, required this.isPositive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.caption),
          const SizedBox(height: 4),
          Text(value, style: AppTextStyles.h4),
          const SizedBox(height: 4),
          Text(change, style: TextStyle(color: isPositive ? AppColors.success : AppColors.error, fontSize: 12)),
        ],
      ),
    );
  }
}

class _ProductRow extends StatelessWidget {
  final int rank;
  final String name;
  final int orders;
  final String revenue;
  const _ProductRow({required this.rank, required this.name, required this.orders, required this.revenue});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: rank <= 3 ? AppColors.primary.withValues(alpha: 0.1) : AppColors.surfaceVariant,
            child: Text('$rank', style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(name, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600))),
          Text('$orders orders', style: AppTextStyles.caption),
          const SizedBox(width: 12),
          Text(revenue, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _PaymentRow extends StatelessWidget {
  final String method;
  final String amount;
  final int percent;
  const _PaymentRow({required this.method, required this.amount, required this.percent});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          Icon(
            method == 'Cash' ? Icons.money : method == 'Card' ? Icons.credit_card : Icons.phone_android,
            size: 18,
            color: AppColors.primary,
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(method, style: AppTextStyles.bodySmall)),
          Text(amount, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(width: 8),
          SizedBox(
            width: 60,
            child: LinearProgressIndicator(
              value: percent / 100,
              backgroundColor: AppColors.surfaceVariant,
              color: AppColors.primary,
              minHeight: 4,
            ),
          ),
          const SizedBox(width: 6),
          Text('$percent%', style: AppTextStyles.caption),
        ],
      ),
    );
  }
}
