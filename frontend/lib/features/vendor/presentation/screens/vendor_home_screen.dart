import 'package:flutter/material.dart';
import 'package:foodos/core/theme/app_colors.dart';
import 'package:foodos/core/widgets/vendor_bottom_nav.dart';
import 'package:go_router/go_router.dart';

class VendorHomeScreen extends StatelessWidget {
  const VendorHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: const VendorBottomNav(currentIndex: 0),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Welcome back,', style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.textHint)),
                    const SizedBox(height: 2),
                    Text('Ahmed Khan', style: TextStyle(fontFamily: 'Inter', fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                  ],
                ),
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [AppColors.gradientButtonStart, AppColors.gradientButtonEnd]),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(child: Text('A', style: TextStyle(fontFamily: 'Inter', fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white))),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Stats cards
            Row(
              children: [
                _buildStatCard(Icons.receipt_long, 'Today\'s Orders', '12', AppColors.primary),
                const SizedBox(width: 12),
                _buildStatCard(Icons.attach_money, 'Revenue', 'Rs 8,500', AppColors.success),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildStatCard(Icons.pending_actions, 'Pending', '3', AppColors.warning),
                const SizedBox(width: 12),
                _buildStatCard(Icons.star, 'Rating', '4.8', const Color(0xFFFFB27A)),
              ],
            ),
            const SizedBox(height: 24),

            // Quick actions
            Text('Quick Actions', style: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            const SizedBox(height: 12),
            _buildActionTile(context, Icons.restaurant_menu, 'Manage Menu', 'Add, edit or remove items', () => context.go('/vendor/menu')),
            _buildActionTile(context, Icons.receipt_long, 'View Orders', 'See all incoming orders', () => context.go('/vendor/orders')),
            _buildActionTile(context, Icons.analytics, 'Analytics', 'Revenue, peak hours, top items', () => context.go('/vendor/analytics')),
            _buildActionTile(context, Icons.toggle_on, 'Toggle Open/Close', 'Restaurant is currently OPEN', () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Restaurant status toggled!'),
                  backgroundColor: AppColors.success,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(IconData icon, String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.borderLight, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 10),
            Text(value, style: TextStyle(fontFamily: 'Inter', fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textHint)),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile(BuildContext context, IconData icon, String title, String subtitle, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
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
            Icon(icon, color: AppColors.primary, size: 22),
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
