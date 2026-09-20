import 'package:flutter/material.dart';
import 'package:foodos/core/theme/app_colors.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('About')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 20),
          Center(
            child: Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [AppColors.gradientButtonStart, AppColors.gradientButtonEnd]),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 24, spreadRadius: 4)],
              ),
              child: const Center(
                child: Text('F', style: TextStyle(fontFamily: 'Inter', fontSize: 40, fontWeight: FontWeight.w900, color: Colors.white)),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text('FoodOS', style: TextStyle(fontFamily: 'Inter', fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
          ),
          const SizedBox(height: 4),
          Center(
            child: Text('Multi-Tenant Food Business Management', style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.textSecondary)),
          ),
          const SizedBox(height: 8),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [AppColors.gradientButtonStart, AppColors.gradientButtonEnd]),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('v1.0.0', style: TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white)),
            ),
          ),
          const SizedBox(height: 32),
          _buildInfoTile('Version', '1.0.0 (Build 1)', Icons.info_outline_rounded),
          _buildInfoTile('Flutter SDK', '3.22.x', Icons.flutter_dash_outlined),
          _buildInfoTile('License', 'MIT License', Icons.description_outlined),
          _buildInfoTile('Developer', 'FoodOS Team', Icons.code_outlined),
          const SizedBox(height: 24),
          Text('LEGAL', style: TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textHint, letterSpacing: 1.2)),
          const SizedBox(height: 8),
          _buildLinkTile('Terms of Service', Icons.gavel_outlined),
          _buildLinkTile('Privacy Policy', Icons.privacy_tip_outlined),
          _buildLinkTile('Open Source Licenses', Icons.balance_outlined),
        ],
      ),
    );
  }

  Widget _buildInfoTile(String title, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderLight, width: 1)),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textSecondary, size: 18),
          const SizedBox(width: 14),
          Expanded(child: Text(title, style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary))),
          Text(value, style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.textHint)),
        ],
      ),
    );
  }

  Widget _buildLinkTile(String title, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderLight, width: 1)),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 18),
          const SizedBox(width: 14),
          Expanded(child: Text(title, style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary))),
          Icon(Icons.chevron_right_rounded, color: AppColors.textHint, size: 18),
        ],
      ),
    );
  }
}
