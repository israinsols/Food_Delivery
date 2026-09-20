import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodos/core/theme/app_colors.dart';
import 'package:foodos/core/widgets/customer_bottom_nav.dart';
import 'package:foodos/features/auth/presentation/providers/auth_provider.dart';
import 'package:go_router/go_router.dart';

class CustomerProfileScreen extends ConsumerWidget {
  const CustomerProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final isAuthenticated = authState.status == AuthStatus.authenticated;
    final user = authState.user;

    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: const CustomerBottomNav(currentIndex: 4),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: 20),

            if (isAuthenticated) ...[
              _buildLoggedInHeader(user),
              const SizedBox(height: 24),
              if (user != null && user.hasVendorAccess) ...[
                _buildRoleSwitcher(context, ref, user),
                const SizedBox(height: 16),
              ],
              _buildStatsRow(),
              const SizedBox(height: 24),
              _buildMenuSection(context, ref, isAuthenticated: true),
            ] else ...[
              _buildLoggedOutHeader(context),
              const SizedBox(height: 24),
              _buildMenuSection(context, ref, isAuthenticated: false),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLoggedInHeader(dynamic user) {
    return Center(
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [AppColors.gradientButtonStart, AppColors.gradientButtonEnd]),
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 20, spreadRadius: 2)],
            ),
            child: Center(child: Text((user?.fullName ?? 'U')[0].toUpperCase(), style: const TextStyle(fontFamily: 'Inter', fontSize: 32, fontWeight: FontWeight.w800, color: Colors.white))),
          ),
          const SizedBox(height: 12),
          Text(user?.fullName ?? 'User', style: TextStyle(fontFamily: 'Inter', fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          const SizedBox(height: 4),
          Text(user?.email ?? 'user@email.com', style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.textHint)),
        ],
      ),
    );
  }

  Widget _buildLoggedOutHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary.withValues(alpha: 0.1), AppColors.primary.withValues(alpha: 0.03)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2), width: 1),
      ),
      child: Column(
        children: [
          Icon(Icons.person_outline_rounded, color: AppColors.primary, size: 48),
          const SizedBox(height: 12),
          Text('Welcome to FoodOS', style: TextStyle(fontFamily: 'Inter', fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          const SizedBox(height: 4),
          Text('Sign in to order food, track deliveries & more', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.textHint)),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => context.push('/login'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primary, width: 1),
                    ),
                    child: Center(
                      child: Text('Login', style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.primary)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () => context.push('/role-select'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [AppColors.gradientButtonStart, AppColors.gradientButtonEnd]),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 2))],
                    ),
                    child: const Center(
                      child: Text('Sign Up', style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        _buildStat('Orders', '28'),
        const SizedBox(width: 12),
        _buildStat('Favorites', '12'),
        const SizedBox(width: 12),
        _buildStat('Points', '1,250'),
      ],
    );
  }

  Widget _buildStat(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.borderLight, width: 1),
        ),
        child: Column(
          children: [
            Text(value, style: TextStyle(fontFamily: 'Inter', fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.primary)),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textHint)),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context, WidgetRef ref, {required bool isAuthenticated}) {
    return Column(
      children: [
        _buildMenuItem(Icons.notifications_outlined, 'Notifications', '3 new', () => context.push('/customer/notifications')),
        _buildMenuItem(Icons.location_on_outlined, 'Delivery Addresses', '3 saved', () => context.push('/customer/delivery-addresses')),
        _buildMenuItem(Icons.payment_outlined, 'Payment Methods', '', () => context.push('/customer/payment-methods')),
        _buildMenuItem(Icons.favorite_border, 'Favorites', '12 items', () => context.push('/customer/favorites')),
        _buildMenuItem(Icons.receipt_long_outlined, 'Order History', '28 orders', () => context.push('/customer/orders')),
        _buildMenuItem(Icons.local_offer_outlined, 'Promo Codes', '2 available', () => context.push('/customer/promo-codes')),
        _buildMenuItem(Icons.restaurant_outlined, 'List Your Restaurant', 'Earn with FoodOS', () => context.push('/vendor/register')),
        _buildMenuItem(Icons.admin_panel_settings_outlined, 'Admin Dashboard', '', () => context.push('/admin/dashboard')),
        _buildMenuItem(Icons.help_outline, 'Help & Support', '', () => context.push('/settings/help')),
        _buildMenuItem(Icons.info_outline, 'About', 'v1.0.0', () => context.push('/settings/about')),
        const SizedBox(height: 16),

        if (isAuthenticated)
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
              child: Center(
                child: Text('Sign Out', style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.error)),
              ),
            ),
          )
        else
          GestureDetector(
            onTap: () => context.push('/role-select'),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [AppColors.gradientButtonStart, AppColors.gradientButtonEnd]),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 2))],
              ),
              child: Center(
                child: Text('Login / Sign Up', style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
              ),
            ),
          ),
        const SizedBox(height: 32),
      ],
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
            Expanded(
              child: Text(title, style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
            ),
            if (subtitle.isNotEmpty)
              Text(subtitle, style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textHint)),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right_rounded, color: AppColors.textHint, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleSwitcher(BuildContext context, WidgetRef ref, dynamic user) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary.withValues(alpha: 0.08), const Color(0xFF4CAF50).withValues(alpha: 0.08)],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2), width: 1),
      ),
      child: Row(
        children: [
          Icon(Icons.swap_horiz, color: AppColors.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Currently viewing: Customer',
                  style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                ),
                Text(
                  'You also have restaurant access',
                  style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textHint),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () async {
              await ref.read(authProvider.notifier).switchToVendor();
              if (context.mounted) context.go('/vendor/home');
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)]),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Switch to Restaurant',
                style: TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
