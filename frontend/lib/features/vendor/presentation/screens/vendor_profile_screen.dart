import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodos/core/theme/app_colors.dart';
import 'package:foodos/core/widgets/vendor_bottom_nav.dart';
import 'package:foodos/features/auth/presentation/providers/auth_provider.dart';
import 'package:go_router/go_router.dart';

class VendorProfileScreen extends ConsumerWidget {
  const VendorProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: const VendorBottomNav(currentIndex: 4),
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
                      gradient: LinearGradient(colors: [AppColors.gradientButtonStart, AppColors.gradientButtonEnd]),
                      shape: BoxShape.circle,
                    ),
                    child: Center(child: Text((user?.fullName ?? 'V')[0].toUpperCase(), style: const TextStyle(fontFamily: 'Inter', fontSize: 32, fontWeight: FontWeight.w800, color: Colors.white))),
                  ),
                  const SizedBox(height: 12),
                  Text(user?.fullName ?? 'Vendor', style: TextStyle(fontFamily: 'Inter', fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                  const SizedBox(height: 4),
                  Text(user?.email ?? '', style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.textHint)),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                    child: Text('Restaurant Owner', style: TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primary)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Role switcher for dual-role users
            if (user != null && user.hasVendorAccess) ...[
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [const Color(0xFF2196F3).withValues(alpha: 0.08), AppColors.primary.withValues(alpha: 0.08)],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFF2196F3).withValues(alpha: 0.2), width: 1),
                ),
                child: Row(
                  children: [
                    Icon(Icons.swap_horiz, color: const Color(0xFF2196F3), size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Currently viewing: Restaurant', style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                          Text('Switch to browse & order food', style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textHint)),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await ref.read(authProvider.notifier).switchToCustomer();
                        if (context.mounted) context.go('/customer/home');
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [Color(0xFF2196F3), Color(0xFF1565C0)]),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text('Switch to Customer', style: TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            _buildMenuItem(Icons.store, 'My Restaurant', 'Manage your listing', () => context.push('/vendor/register')),
            _buildMenuItem(Icons.receipt_long, 'Order History', 'View past orders', () => context.go('/vendor/orders')),
            _buildMenuItem(Icons.analytics, 'Analytics', 'Revenue & insights', () => context.go('/vendor/analytics')),
            _buildMenuItem(Icons.notifications_outlined, 'Notifications', 'Order alerts', () => context.push('/customer/notifications')),
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
