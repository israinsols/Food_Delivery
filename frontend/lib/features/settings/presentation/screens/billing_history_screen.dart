import 'package:flutter/material.dart';
import 'package:foodos/core/theme/app_colors.dart';
import 'package:foodos/core/theme/app_text_styles.dart';
import 'package:foodos/core/widgets/status_badge.dart';

class BillingHistoryScreen extends StatelessWidget {
  const BillingHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final billingHistory = [
      {
        'date': 'Aug 1, 2026',
        'plan': 'Starter Plan',
        'amount': 'Rs 3,000',
        'status': 'paid',
        'invoice': 'INV-2026-008',
      },
      {
        'date': 'Jul 1, 2026',
        'plan': 'Starter Plan',
        'amount': 'Rs 3,000',
        'status': 'paid',
        'invoice': 'INV-2026-007',
      },
      {
        'date': 'Jun 1, 2026',
        'plan': 'Starter Plan',
        'amount': 'Rs 3,000',
        'status': 'paid',
        'invoice': 'INV-2026-006',
      },
      {
        'date': 'May 1, 2026',
        'plan': 'Starter Plan',
        'amount': 'Rs 3,000',
        'status': 'paid',
        'invoice': 'INV-2026-005',
      },
      {
        'date': 'Apr 1, 2026',
        'plan': 'Free Trial',
        'amount': 'Rs 0',
        'status': 'paid',
        'invoice': 'INV-2026-004',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Billing History'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: billingHistory.length,
        itemBuilder: (context, index) {
          final bill = billingHistory[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.receipt_long, color: AppColors.success),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(bill['plan'] as String, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text(
                        '${bill['date']} â€¢ ${bill['invoice']}',
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(bill['amount'] as String, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    StatusBadge(
                      label: bill['status'] as String,
                      color: AppColors.success,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
