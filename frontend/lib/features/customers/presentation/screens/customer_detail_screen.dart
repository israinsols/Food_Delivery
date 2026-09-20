import 'package:flutter/material.dart';
import 'package:foodos/core/theme/app_colors.dart';
import 'package:foodos/core/theme/app_text_styles.dart';
import 'package:go_router/go_router.dart';

class CustomerDetailScreen extends StatelessWidget {
  final String customerId;
  const CustomerDetailScreen({super.key, required this.customerId});

  @override
  Widget build(BuildContext context) {
    final customer = {
      'name': 'Ahmed Khan',
      'phone': '0300-1234567',
      'email': 'ahmed@email.com',
      'totalOrders': 24,
      'totalSpent': 18500,
      'avgOrder': 771,
      'loyaltyPoints': 185,
      'notes': 'Allergic to peanuts',
      'joined': 'Jan 2026',
    };

    final recentOrders = [
      {'id': 'ORD-001', 'date': 'Aug 30', 'total': 950, 'status': 'completed'},
      {'id': 'ORD-045', 'date': 'Aug 28', 'total': 660, 'status': 'completed'},
      {'id': 'ORD-032', 'date': 'Aug 25', 'total': 1200, 'status': 'completed'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(customer['name'] as String),
        actions: [
          IconButton(icon: const Icon(Icons.edit), onPressed: () => context.push('/customers/edit/$customerId')),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  child: Text(
                    (customer['name'] as String)[0],
                    style: TextStyle(fontSize: 28, color: AppColors.primary, fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(height: 12),
                Text(customer['name'] as String, style: AppTextStyles.h3),
                Text(customer['phone'] as String, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                if (customer['email'] != null)
                  Text(customer['email'] as String, style: AppTextStyles.caption),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _StatItem(label: 'Orders', value: '${customer['totalOrders']}'),
                    _StatItem(label: 'Total Spent', value: 'Rs ${customer['totalSpent']}'),
                    _StatItem(label: 'Points', value: '${customer['loyaltyPoints']}'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Notes
          if (customer['notes'] != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.note, color: AppColors.warning, size: 18),
                  const SizedBox(width: 8),
                  Text(customer['notes'] as String, style: AppTextStyles.bodySmall),
                ],
              ),
            ),
          const SizedBox(height: 16),

          // Recent Orders
          Text('Recent Orders', style: AppTextStyles.h4),
          const SizedBox(height: 8),
          ...recentOrders.map((o) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Row(
              children: [
                Expanded(child: Text(o['id'] as String, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600))),
                Text(o['date'] as String, style: AppTextStyles.caption),
                const SizedBox(width: 12),
                Text('Rs ${o['total']}', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: AppTextStyles.h4.copyWith(color: AppColors.primary)),
        const SizedBox(height: 4),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }
}
