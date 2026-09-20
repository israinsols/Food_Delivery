import 'package:flutter/material.dart';
import 'package:foodos/core/theme/app_colors.dart';
import 'package:foodos/core/widgets/admin_bottom_nav.dart';

class AdminRestaurantsScreen extends StatelessWidget {
  const AdminRestaurantsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: const AdminBottomNav(currentIndex: 1),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: 8),
            Text('All Restaurants', style: TextStyle(fontFamily: 'Inter', fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            const SizedBox(height: 16),
            _buildRestaurantCard('FoodOS Kitchen', 'Pakistani', 4.8, true),
            _buildRestaurantCard('Spice Hub', 'BBQ & Chinese', 4.6, true),
            _buildRestaurantCard('Burger House', 'Fast Food', 4.7, false),
            _buildRestaurantCard('Sweet Corner', 'Desserts', 4.9, true),
            _buildRestaurantCard('Pizza Corner', 'Pizza', 4.5, false),
            _buildRestaurantCard('Chai Wala', 'Pakistani', 4.4, false),
          ],
        ),
      ),
    );
  }

  Widget _buildRestaurantCard(String name, String cuisine, double rating, bool isOpen) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderLight, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(Icons.restaurant, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                Text(cuisine, style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textHint)),
              ],
            ),
          ),
          Icon(Icons.star_rounded, size: 14, color: const Color(0xFFFFB27A)),
          const SizedBox(width: 2),
          Text('$rating', style: TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          const SizedBox(width: 10),
          Icon(Icons.circle, size: 8, color: isOpen ? AppColors.success : AppColors.error),
        ],
      ),
    );
  }
}
