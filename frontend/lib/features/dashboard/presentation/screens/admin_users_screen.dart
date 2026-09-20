import 'package:flutter/material.dart';
import 'package:foodos/core/theme/app_colors.dart';
import 'package:foodos/core/widgets/admin_bottom_nav.dart';

class AdminUsersScreen extends StatelessWidget {
  const AdminUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: const AdminBottomNav(currentIndex: 3),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: 8),
            Text('All Users', style: TextStyle(fontFamily: 'Inter', fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            const SizedBox(height: 16),
            _buildUserCard('Hamza Malik', 'customer@foodos.com', 'CUSTOMER'),
            _buildUserCard('Ahmed Khan', 'ahmed@foodos.com', 'VENDOR'),
            _buildUserCard('Sara Ali', 'sara@foodos.com', 'VENDOR'),
            _buildUserCard('Admin User', 'admin@foodos.com', 'ADMIN'),
            _buildUserCard('Bilal Ahmed', 'rider@foodos.com', 'RIDER'),
          ],
        ),
      ),
    );
  }

  Widget _buildUserCard(String name, String email, String role) {
    Color roleColor;
    switch (role) {
      case 'ADMIN': roleColor = AppColors.error;
      case 'VENDOR': roleColor = AppColors.primary;
      case 'RIDER': roleColor = AppColors.success;
      default: roleColor = AppColors.textHint;
    }

    return Container(
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
            width: 42, height: 42,
            decoration: BoxDecoration(color: roleColor.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Center(child: Text(name[0], style: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w700, color: roleColor))),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                Text(email, style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textHint)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: roleColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
            child: Text(role, style: TextStyle(fontFamily: 'Inter', fontSize: 10, fontWeight: FontWeight.w600, color: roleColor)),
          ),
        ],
      ),
    );
  }
}
