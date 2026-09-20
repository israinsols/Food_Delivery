import 'package:flutter/material.dart';
import 'package:foodos/core/theme/app_colors.dart';
import 'package:foodos/core/widgets/vendor_bottom_nav.dart';

class VendorOrdersScreen extends StatelessWidget {
  const VendorOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: const VendorBottomNav(currentIndex: 2),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: 8),
            Text('Orders', style: TextStyle(fontFamily: 'Inter', fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            const SizedBox(height: 16),
            _buildOrderCard('ORD-A1B2C3D4', 'Chicken Biryani x2, Lassi x1', 700, 'PENDING', '2 min ago'),
            _buildOrderCard('ORD-E5F6G7H8', 'Seekh Kabab x3, Naan x4', 1000, 'CONFIRMED', '15 min ago'),
            _buildOrderCard('ORD-I9J0K1L2', 'Smash Burger x1, Cold Drink x1', 610, 'DELIVERED', '1 hour ago'),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard(String id, String items, int total, String status, String time) {
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
          Text(items, style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textSecondary)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(time, style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textHint)),
              Text('Rs $total', style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary)),
            ],
          ),
        ],
      ),
    );
  }
}
