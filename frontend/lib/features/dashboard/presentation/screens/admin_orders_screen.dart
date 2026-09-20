import 'package:flutter/material.dart';
import 'package:foodos/core/theme/app_colors.dart';
import 'package:foodos/core/widgets/admin_bottom_nav.dart';

class AdminOrdersScreen extends StatelessWidget {
  const AdminOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: const AdminBottomNav(currentIndex: 2),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: 8),
            Text('All Orders', style: TextStyle(fontFamily: 'Inter', fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            const SizedBox(height: 16),
            _buildOrderCard('ORD-07294A46', 'Hamza Malik', 'FoodOS Kitchen', 255, 'DELIVERED'),
            _buildOrderCard('ORD-B3C4D5E6', 'Ali Raza', 'Spice Hub', 1000, 'CONFIRMED'),
            _buildOrderCard('ORD-F7G8H9I0', 'Sara Khan', 'Burger House', 610, 'PENDING'),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard(String id, String customer, String restaurant, int total, String status) {
    Color statusColor;
    switch (status) {
      case 'PENDING': statusColor = AppColors.warning;
      case 'CONFIRMED': statusColor = AppColors.primary;
      case 'DELIVERED': statusColor = AppColors.success;
      default: statusColor = AppColors.textHint;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderLight, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(id, style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(6)),
                child: Text(status, style: TextStyle(fontFamily: 'Inter', fontSize: 10, fontWeight: FontWeight.w600, color: statusColor)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('$customer → $restaurant', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textSecondary)),
          const SizedBox(height: 4),
          Text('Rs $total', style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary)),
        ],
      ),
    );
  }
}
