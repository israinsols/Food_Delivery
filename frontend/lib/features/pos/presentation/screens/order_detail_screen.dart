import 'package:flutter/material.dart';
import 'package:foodos/core/theme/app_colors.dart';
import 'package:foodos/core/theme/app_text_styles.dart';
import 'package:foodos/core/widgets/status_badge.dart';

class OrderDetailScreen extends StatelessWidget {
  final String orderId;
  const OrderDetailScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    // Mock order data
    final order = {
      'id': orderId,
      'table': 'Table 5',
      'type': 'Dine-in',
      'status': 'completed',
      'subtotal': 850,
      'tax': 85,
      'discount': 0,
      'total': 935,
      'payment': 'Cash',
      'time': '12:30 PM',
      'date': 'Aug 30, 2026',
      'cashier': 'Sara Khan',
      'items': [
        {'name': 'Chicken Biryani', 'qty': 2, 'price': 300, 'total': 600},
        {'name': 'Naan', 'qty': 4, 'price': 50, 'total': 200},
        {'name': 'Lassi', 'qty': 1, 'price': 100, 'total': 100},
      ],
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(orderId),
        actions: [
          IconButton(icon: const Icon(Icons.print), onPressed: () {}),
          IconButton(icon: const Icon(Icons.share), onPressed: () {}),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Order Status
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: AppColors.success),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Order Completed', style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
                      Text('${order['date']} â€¢ ${order['time']}', style: AppTextStyles.caption),
                    ],
                  ),
                ),
                StatusBadge(label: order['status'] as String, color: AppColors.success),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Order Info
          _InfoCard(
            children: [
              _InfoRow(label: 'Order Type', value: order['type'] as String),
              _InfoRow(label: 'Table', value: order['table'] as String),
              _InfoRow(label: 'Cashier', value: order['cashier'] as String),
              _InfoRow(label: 'Payment', value: order['payment'] as String),
            ],
          ),
          const SizedBox(height: 16),

          // Items
          Text('Items', style: AppTextStyles.h4),
          const SizedBox(height: 8),
          ...(order['items'] as List).map((item) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Text('${item['qty']}', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(item['name'], style: AppTextStyles.bodyMedium)),
                Text('Rs ${item['total']}', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
              ],
            ),
          )),
          const SizedBox(height: 16),

          // Summary
          _InfoCard(
            children: [
              _InfoRow(label: 'Subtotal', value: 'Rs ${order['subtotal']}'),
              _InfoRow(label: 'Tax (10%)', value: 'Rs ${order['tax']}'),
              if ((order['discount'] as int) > 0) _InfoRow(label: 'Discount', value: '-Rs ${order['discount']}'),
              const Divider(),
              _InfoRow(label: 'Total', value: 'Rs ${order['total']}', isBold: true),
            ],
          ),
          const SizedBox(height: 24),

          // Actions
          if (order['status'] != 'cancelled')
            OutlinedButton.icon(
              onPressed: () {
                // TODO: Cancel/Refund
              },
              icon: Icon(Icons.cancel_outlined, color: AppColors.error),
              label: Text('Cancel Order', style: TextStyle(color: AppColors.error)),
              style: OutlinedButton.styleFrom(side: BorderSide(color: AppColors.error)),
            ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final List<Widget> children;
  const _InfoCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(children: children),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  const _InfoRow({required this.label, required this.value, this.isBold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodyMedium),
          Text(value, style: (isBold ? AppTextStyles.h4 : AppTextStyles.bodyMedium)),
        ],
      ),
    );
  }
}
