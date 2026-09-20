import 'package:flutter/material.dart';
import 'package:foodos/core/theme/app_colors.dart';
import 'package:foodos/core/theme/app_text_styles.dart';
import 'package:go_router/go_router.dart';

class ReportsHubScreen extends StatelessWidget {
  const ReportsHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _ReportCard(
            title: 'Sales Report',
            subtitle: 'View daily, weekly, and monthly sales',
            icon: Icons.trending_up,
            color: AppColors.success,
            onTap: () => context.push('/reports/sales'),
          ),
          _ReportCard(
            title: 'Inventory Report',
            subtitle: 'Stock levels and consumption tracking',
            icon: Icons.inventory_2_outlined,
            color: AppColors.warning,
            onTap: () => context.push('/reports/inventory'),
          ),
          _ReportCard(
            title: 'Staff Performance',
            subtitle: 'Employee productivity and sales',
            icon: Icons.people_outline,
            color: AppColors.info,
            onTap: () => context.push('/reports/staff-performance'),
          ),
          _ReportCard(
            title: 'Customer Analytics',
            subtitle: 'Customer behavior and retention',
            icon: Icons.analytics_outlined,
            color: AppColors.primary,
            onTap: () => context.push('/reports/customer-analytics'),
          ),
          _ReportCard(
            title: 'Expense Report',
            subtitle: 'Track and categorize expenses',
            icon: Icons.receipt_long_outlined,
            color: AppColors.error,
            onTap: () => context.push('/reports/expense'),
          ),
          _ReportCard(
            title: 'Profit & Loss',
            subtitle: 'Revenue vs expenses overview',
            icon: Icons.account_balance_outlined,
            color: AppColors.secondary,
            onTap: () => context.push('/reports/profit-loss'),
          ),
        ],
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ReportCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: AppTextStyles.caption),
        trailing: const Icon(Icons.chevron_right),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: AppColors.borderLight),
        ),
      ),
    );
  }
}
