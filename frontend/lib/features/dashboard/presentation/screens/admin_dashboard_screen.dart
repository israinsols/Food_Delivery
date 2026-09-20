import 'package:flutter/material.dart';
import 'package:foodos/core/theme/app_colors.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Revenue overview
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFCB202D), Color(0xFFFF6B35)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total Revenue', style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: Colors.white70)),
                const SizedBox(height: 8),
                const Text('Rs 12,45,600', style: TextStyle(fontFamily: 'Inter', fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(4)),
                      child: const Text('+18.2%', style: TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white)),
                    ),
                    const SizedBox(width: 8),
                    Text('vs last month', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: Colors.white60)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Quick stats
          Row(
            children: [
              _buildQuickStat('Users', '3,847', Icons.people_rounded, AppColors.info),
              const SizedBox(width: 12),
              _buildQuickStat('Restaurants', '42', Icons.store_rounded, AppColors.primary),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildQuickStat('Orders', '8,234', Icons.shopping_bag_rounded, AppColors.success),
              const SizedBox(width: 12),
              _buildQuickStat('Revenue', 'Rs 12.4L', Icons.trending_up_rounded, AppColors.warning),
            ],
          ),
          const SizedBox(height: 24),

          // Today's overview
          _buildSectionHeader('Today\'s Overview'),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.borderLight, width: 1),
            ),
            child: Column(
              children: [
                _buildOverviewRow('Orders Today', '284', AppColors.primary),
                _buildOverviewRow('Revenue Today', 'Rs 2,45,000', AppColors.success),
                _buildOverviewRow('New Users Today', '47', AppColors.info),
                _buildOverviewRow('Pending Orders', '12', AppColors.warning),
                _buildOverviewRow('Cancelled Orders', '3', AppColors.error),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Top restaurants
          _buildSectionHeader('Top Performing Restaurants'),
          const SizedBox(height: 12),
          _buildTopRestaurant('FoodOS Kitchen', 'Rs 2,45,000', '4.8 ⭐', 0.95),
          _buildTopRestaurant('Pizza Corner', 'Rs 1,89,000', '4.7 ⭐', 0.82),
          _buildTopRestaurant('Burger House', 'Rs 1,56,000', '4.6 ⭐', 0.71),
          _buildTopRestaurant('Sweet Corner', 'Rs 1,23,000', '4.9 ⭐', 0.65),
          const SizedBox(height: 24),

          // Recent orders
          _buildSectionHeader('Recent Orders'),
          const SizedBox(height: 12),
          _buildRecentOrder('#ORD-2847', 'Ahmed Khan', 'Chicken Biryani', 'Rs 300', 'Delivered'),
          _buildRecentOrder('#ORD-2846', 'Sara Ali', 'Pepperoni Pizza', 'Rs 800', 'On the way'),
          _buildRecentOrder('#ORD-2845', 'Usman Raza', 'Smash Burger', 'Rs 550', 'Preparing'),
          _buildRecentOrder('#ORD-2844', 'Fatima Noor', 'Gulab Jamun', 'Rs 180', 'Delivered'),
          const SizedBox(height: 24),

          // Commission summary
          _buildSectionHeader('Commission Summary'),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.borderLight, width: 1),
            ),
            child: Column(
              children: [
                _buildOverviewRow('Total Commission (15%)', 'Rs 1,86,840', AppColors.success),
                _buildOverviewRow('Pending Payouts', 'Rs 45,200', AppColors.warning),
                _buildOverviewRow('Paid Out', 'Rs 1,41,640', AppColors.info),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildQuickStat(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.borderLight, width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: TextStyle(fontFamily: 'Inter', fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                Text(title, style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textHint)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(title, style: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary));
  }

  Widget _buildOverviewRow(String label, String value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.textHint)),
          Text(value, style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600, color: valueColor)),
        ],
      ),
    );
  }

  Widget _buildTopRestaurant(String name, String revenue, String rating, double ratio) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderLight, width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                const SizedBox(height: 2),
                Text('$revenue • $rating', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textHint)),
              ],
            ),
          ),
          Container(
            width: 60,
            height: 6,
            decoration: BoxDecoration(color: AppColors.borderLight, borderRadius: BorderRadius.circular(3)),
            child: FractionallySizedBox(
              widthFactor: ratio,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [AppColors.gradientButtonStart, AppColors.gradientButtonEnd]),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentOrder(String orderId, String customer, String item, String amount, String status) {
    Color statusColor;
    switch (status) {
      case 'Delivered':
        statusColor = AppColors.success;
        break;
      case 'On the way':
        statusColor = AppColors.primary;
        break;
      case 'Preparing':
        statusColor = AppColors.warning;
        break;
      default:
        statusColor = AppColors.textHint;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderLight, width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(orderId, style: TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                    const SizedBox(width: 8),
                    Text(amount, style: TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary)),
                  ],
                ),
                const SizedBox(height: 4),
                Text('$customer • $item', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textHint)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(4)),
            child: Text(status, style: TextStyle(fontFamily: 'Inter', fontSize: 10, fontWeight: FontWeight.w600, color: statusColor)),
          ),
        ],
      ),
    );
  }
}
