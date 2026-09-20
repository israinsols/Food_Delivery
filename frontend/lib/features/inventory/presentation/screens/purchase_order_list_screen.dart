import 'package:flutter/material.dart';
import 'package:foodos/core/theme/app_colors.dart';
import 'package:foodos/core/theme/app_text_styles.dart';
import 'package:go_router/go_router.dart';

class PurchaseOrderListScreen extends StatelessWidget {
  const PurchaseOrderListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = [
      {'id': 'PO-001', 'supplier': 'Khan Fresh Chicken', 'status': 'received', 'total': 12000, 'date': 'Aug 28'},
      {'id': 'PO-002', 'supplier': 'Basmati Rice Traders', 'status': 'ordered', 'total': 8500, 'date': 'Aug 29'},
      {'id': 'PO-003', 'supplier': 'Spice World', 'status': 'draft', 'total': 3200, 'date': 'Aug 30'},
    ];

    Color getStatusColor(String s) {
      switch (s) {
        case 'received': return AppColors.success;
        case 'ordered': return AppColors.info;
        case 'draft': return AppColors.warning;
        default: return AppColors.textSecondary;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Purchase Orders'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/inventory/create-po'),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final o = orders[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: getStatusColor(o['status'] as String).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.receipt_long, color: getStatusColor(o['status'] as String), size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(o['id'] as String, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: getStatusColor(o['status'] as String).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(o['status'] as String, style: TextStyle(color: getStatusColor(o['status'] as String), fontSize: 10, fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                      Text(o['supplier'] as String, style: AppTextStyles.caption),
                      Text(o['date'] as String, style: AppTextStyles.caption),
                    ],
                  ),
                ),
                Text('Rs ${o['total']}', style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w700)),
              ],
            ),
          );
        },
      ),
    );
  }
}
