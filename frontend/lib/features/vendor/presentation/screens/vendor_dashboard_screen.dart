import 'package:flutter/material.dart';
import 'package:foodos/core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';

class VendorDashboardScreen extends StatelessWidget {
  const VendorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Vendor Dashboard'),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.circle, size: 8, color: AppColors.success),
                const SizedBox(width: 6),
                Text('Online', style: TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.success)),
              ],
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Restaurant info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.borderLight, width: 1),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset('assets/images/biryani.jpg', width: 60, height: 60, fit: BoxFit.cover),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('FoodOS Kitchen', style: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                      const SizedBox(height: 2),
                      Text('Biryani, Kebabs, BBQ', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textHint)),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => context.push('/vendor/edit-restaurant'),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                    child: Icon(Icons.edit_outlined, color: AppColors.primary, size: 18),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Stats
          Row(
            children: [
              _buildStatCard('Today\'s Orders', '24', Icons.receipt_long, AppColors.primary),
              const SizedBox(width: 12),
              _buildStatCard('Revenue', 'Rs 12.5K', Icons.account_balance_wallet, AppColors.success),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildStatCard('Avg Rating', '4.8', Icons.star, const Color(0xFFFFB27A)),
              const SizedBox(width: 12),
              _buildStatCard('Pending', '3', Icons.pending_actions, AppColors.warning),
            ],
          ),
          const SizedBox(height: 24),

          // Quick actions
          Text('Quick Actions', style: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          const SizedBox(height: 12),
          _buildActionTile(context, Icons.restaurant_menu, 'Manage Menu', 'Add, edit, remove items', '/vendor/menu'),
          _buildActionTile(context, Icons.receipt_long, 'Orders', 'View & manage orders', '/vendor/orders'),
          _buildActionTile(context, Icons.analytics, 'Analytics', 'Sales & performance', '/vendor/analytics'),
          _buildActionTile(context, Icons.store_outlined, 'Restaurant Profile', 'Update details', '/vendor/edit-restaurant'),
          _buildActionTile(context, Icons.settings, 'Settings', 'Payment, delivery, hours', '/settings'),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderLight, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 10),
            Text(value, style: TextStyle(fontFamily: 'Inter', fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
            const SizedBox(height: 2),
            Text(title, style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textHint)),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile(BuildContext context, IconData icon, String title, String subtitle, String route) {
    return GestureDetector(
      onTap: () => context.push(route),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderLight, width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                  Text(subtitle, style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textHint)),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: AppColors.textHint, size: 20),
          ],
        ),
      ),
    );
  }
}
