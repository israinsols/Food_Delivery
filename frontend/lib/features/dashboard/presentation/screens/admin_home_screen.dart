import 'package:flutter/material.dart';
import 'package:foodos/core/theme/app_colors.dart';
import 'package:foodos/core/widgets/admin_bottom_nav.dart';
import 'package:go_router/go_router.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: const AdminBottomNav(currentIndex: 0),
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
                    Text('Admin Panel', style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.textHint)),
                    const SizedBox(height: 2),
                    Text('FoodOS Dashboard', style: TextStyle(fontFamily: 'Inter', fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                  ],
                ),
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFFCB202D), Color(0xFFFF6B35)]),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(child: Text('A', style: TextStyle(fontFamily: 'Inter', fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white))),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Platform stats
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFFCB202D), Color(0xFFFF6B35)]),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Platform Revenue', style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: Colors.white70)),
                  const SizedBox(height: 4),
                  const Text('Rs 2,45,000', style: TextStyle(fontFamily: 'Inter', fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(6)),
                        child: const Text('+12.5%', style: TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white)),
                      ),
                      const SizedBox(width: 8),
                      const Text('Commission: Rs 36,750', style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: Colors.white70)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Quick stats
            Row(
              children: [
                _buildStatCard(Icons.people, 'Users', '156'),
                const SizedBox(width: 12),
                _buildStatCard(Icons.restaurant, 'Restaurants', '6'),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildStatCard(Icons.receipt_long, 'Total Orders', '1,234'),
                const SizedBox(width: 12),
                _buildStatCard(Icons.pending_actions, 'Pending', '8'),
              ],
            ),
            const SizedBox(height: 24),

            // Quick actions
            Text('Management', style: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            const SizedBox(height: 12),
            _buildActionTile(context, Icons.restaurant, 'All Restaurants', 'Manage restaurant listings', () => context.go('/admin/restaurants')),
            _buildActionTile(context, Icons.receipt_long, 'All Orders', 'View platform orders', () => context.go('/admin/orders')),
            _buildActionTile(context, Icons.people, 'All Users', 'Manage customers & vendors', () => context.go('/admin/users')),
            _buildActionTile(context, Icons.local_offer, 'Promo Codes', 'Create & manage promotions', () => context.push('/customer/promo-codes')),
            _buildActionTile(context, Icons.delivery_dining, 'Riders', 'Manage delivery riders', () => context.push('/delivery/riders')),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(IconData icon, String label, String value) {
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
            Icon(icon, color: AppColors.primary, size: 22),
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
