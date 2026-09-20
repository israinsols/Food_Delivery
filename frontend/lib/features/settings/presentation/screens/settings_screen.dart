import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodos/core/theme/app_colors.dart';
import 'package:foodos/core/theme/theme_provider.dart';
import 'package:foodos/core/widgets/gradient_text.dart';
import 'package:foodos/features/auth/presentation/providers/auth_provider.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    final themeState = ref.watch(themeProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Profile Header
          SliverToBoxAdapter(
            child: _buildProfileHeader(user),
          ),

          // Sections
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildSection(
                  title: 'Account',
                  children: [
                    _SettingsTile(
                      icon: Icons.person_outline_rounded,
                      iconColor: AppColors.primary,
                      title: 'Profile',
                      subtitle: 'Manage your profile details',
                      onTap: () => context.push('/settings/profile'),
                    ),
                    _SettingsTile(
                      icon: Icons.lock_outline_rounded,
                      iconColor: AppColors.info,
                      title: 'Change Password',
                      subtitle: 'Update your password',
                      onTap: () => context.push('/settings/change-password'),
                    ),
                    _SettingsTile(
                      icon: Icons.notifications_outlined,
                      iconColor: AppColors.warning,
                      title: 'Notifications',
                      subtitle: 'Push & email alerts',
                      onTap: () {},
                      trailing: _GradientBadge(count: '3'),
                    ),
                    _SettingsTile(
                      icon: Icons.dark_mode_outlined,
                      iconColor: const Color(0xFF7B61FF),
                      title: 'Dark Mode',
                      subtitle: themeState.isDarkMode ? 'Dark theme active' : 'Light theme active',
                      onTap: () => ref.read(themeProvider.notifier).toggleTheme(),
                      trailing: Switch(
                        value: themeState.isDarkMode,
                        onChanged: (v) => ref.read(themeProvider.notifier).toggleTheme(),
                        activeColor: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _buildSection(
                  title: 'Business',
                  children: [
                    _SettingsTile(
                      icon: Icons.storefront_outlined,
                      iconColor: AppColors.primary,
                      title: 'Business Info',
                      subtitle: 'Name, logo, type',
                      onTap: () => context.push('/settings/business-info'),
                    ),
                    _SettingsTile(
                      icon: Icons.location_city_outlined,
                      iconColor: AppColors.info,
                      title: 'Branches',
                      subtitle: 'Manage your branches',
                      onTap: () => context.push('/settings/branches'),
                      trailing: _GradientBadge(count: '2'),
                    ),
                    _SettingsTile(
                      icon: Icons.receipt_long_outlined,
                      iconColor: AppColors.success,
                      title: 'Tax Settings',
                      subtitle: 'Default tax rate',
                      onTap: () => context.push('/settings/tax'),
                    ),
                    _SettingsTile(
                      icon: Icons.print_outlined,
                      iconColor: AppColors.warning,
                      title: 'Printer Settings',
                      subtitle: 'Receipt printer setup',
                      onTap: () => context.push('/settings/printer'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _buildSection(
                  title: 'Subscription',
                  children: [
                    _SubscriptionTile(
                      planName: 'Starter Plan',
                      price: 'Rs 3,000/mo',
                      renewalDate: 'Sep 15, 2026',
                      onTap: () => context.push('/subscription'),
                    ),
                    _SettingsTile(
                      icon: Icons.receipt_outlined,
                      iconColor: AppColors.info,
                      title: 'Billing History',
                      subtitle: 'View past invoices',
                      onTap: () => context.push('/settings/billing'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _buildSection(
                  title: 'Support',
                  children: [
                    _SettingsTile(
                      icon: Icons.help_outline_rounded,
                      iconColor: AppColors.info,
                      title: 'Help Center',
                      subtitle: 'FAQs & guides',
                      onTap: () => context.push('/settings/help'),
                    ),
                    _SettingsTile(
                      icon: Icons.chat_bubble_outline_rounded,
                      iconColor: AppColors.success,
                      title: 'Contact Support',
                      subtitle: 'Chat with our team',
                      onTap: () => context.push('/settings/contact-support'),
                    ),
                    _SettingsTile(
                      icon: Icons.info_outline_rounded,
                      iconColor: AppColors.textSecondary,
                      title: 'About',
                      subtitle: 'Version 1.0.0',
                      onTap: () => context.push('/settings/about'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Sign Out
                GestureDetector(
                  onTap: () async {
                    await ref.read(authProvider.notifier).logout();
                    if (context.mounted) context.go('/login');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: AppColors.error.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.logout_rounded, color: AppColors.error, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Sign Out',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(dynamic user) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        border: Border(
          bottom: BorderSide(color: AppColors.borderLight, width: 1),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Avatar
            Stack(
              children: [
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [AppColors.gradientButtonStart, AppColors.gradientButtonEnd],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 24,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      (user?.fullName ?? 'U')[0].toUpperCase(),
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.borderLight, width: 2),
                    ),
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      color: AppColors.primary,
                      size: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Name
            Text(
              user?.fullName ?? 'User',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 4),

            // Email
            Text(
              user?.email ?? 'user@email.com',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),

            // Stats Row
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _ProfileStat(label: 'Orders', value: '284'),
                  _ProfileStatDivider(),
                  _ProfileStat(label: 'Revenue', value: 'Rs 2.4L'),
                  _ProfileStatDivider(),
                  _ProfileStat(label: 'Since', value: 'Aug 2026'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 12, 4, 8),
          child: Text(
            title.toUpperCase(),
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textHint,
                letterSpacing: 1.2,
              ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.borderLight, width: 1),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final String label;
  final String value;

  const _ProfileStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GradientText(
          text: value,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 11,
            color: AppColors.textHint,
          ),
        ),
      ],
    );
  }
}

class _ProfileStatDivider extends StatelessWidget {
  const _ProfileStatDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 32,
      color: AppColors.borderLight,
    );
  }
}

class _GradientBadge extends StatelessWidget {
  final String count;

  const _GradientBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.gradientButtonStart, AppColors.gradientButtonEnd],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        count,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _SubscriptionTile extends StatelessWidget {
  final String planName;
  final String price;
  final String renewalDate;
  final VoidCallback onTap;

  const _SubscriptionTile({
    required this.planName,
    required this.price,
    required this.renewalDate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary.withValues(alpha: 0.1),
              AppColors.primary.withValues(alpha: 0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.gradientButtonStart, AppColors.gradientButtonEnd],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.workspace_premium_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        planName,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Active',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: AppColors.success,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Renews $renewalDate',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: AppColors.textHint,
                    ),
                  ),
                ],
              ),
            ),
            GradientText(
              text: price,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 4),
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textHint,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: AppColors.textHint,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) ...[
                trailing!,
                const SizedBox(width: 8),
              ],
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textHint,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
