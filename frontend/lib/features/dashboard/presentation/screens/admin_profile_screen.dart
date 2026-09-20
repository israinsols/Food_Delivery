import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodos/core/theme/app_colors.dart';
import 'package:foodos/core/widgets/admin_bottom_nav.dart';
import 'package:foodos/features/auth/presentation/providers/auth_provider.dart';
import 'package:go_router/go_router.dart';

class AdminProfileScreen extends ConsumerWidget {
  const AdminProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: const AdminBottomNav(currentIndex: 4),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  Container(
                    width: 80, height: 80,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFFCB202D), Color(0xFFFF6B35)]),
                      shape: BoxShape.circle,
                    ),
                    child: Center(child: Text((user?.fullName ?? 'A')[0].toUpperCase(), style: const TextStyle(fontFamily: 'Inter', fontSize: 32, fontWeight: FontWeight.w800, color: Colors.white))),
                  ),
                  const SizedBox(height: 12),
                  Text(user?.fullName ?? 'Admin', style: TextStyle(fontFamily: 'Inter', fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                  const SizedBox(height: 4),
                  Text(user?.email ?? '', style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.textHint)),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                    child: Text('Super Admin', style: TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.error)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildMenuItem(Icons.dashboard, 'Dashboard', '', () => context.go('/admin/dashboard')),
            _buildMenuItem(Icons.restaurant, 'Restaurants', '', () => context.go('/admin/restaurants')),
            _buildMenuItem(Icons.receipt_long, 'Orders', '', () => context.go('/admin/orders')),
            _buildMenuItem(Icons.people, 'Users', '', () => context.go('/admin/users')),
            _buildMenuItem(Icons.local_offer, 'Promo Codes', '', () => context.push('/customer/promo-codes')),
            _buildMenuItem(Icons.delivery_dining, 'Riders', '', () => context.push('/delivery/riders')),
            _buildMenuItem(Icons.help_outline, 'Help & Support', '', () => context.push('/settings/help')),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () async {
                await ref.read(authProvider.notifier).logout();
                if (context.mounted) context.go('/customer/home');
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.error.withValues(alpha: 0.2), width: 1),
                ),
                child: Center(child: Text('Sign Out', style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.error))),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderLight, width: 1),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.textSecondary, size: 20),
            const SizedBox(width: 14),
            Expanded(child: Text(title, style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary))),
            if (subtitle.isNotEmpty) Text(subtitle, style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textHint)),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right_rounded, color: AppColors.textHint, size: 18),
          ],
        ),
      ),
    );
  }
}
