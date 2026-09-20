import 'package:flutter/material.dart';
import 'package:foodos/core/theme/app_colors.dart';

class PromoCode {
  final String code;
  final String title;
  final String description;
  final String discount;
  final String minOrder;
  final DateTime expiry;
  final bool isUsed;

  const PromoCode({
    required this.code,
    required this.title,
    required this.description,
    required this.discount,
    required this.minOrder,
    required this.expiry,
    this.isUsed = false,
  });
}

class PromoCodesScreen extends StatelessWidget {
  const PromoCodesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final promos = [
      PromoCode(code: 'FIRST20', title: 'First Order Discount', description: 'Get 20% off on your first order', discount: '20% OFF', minOrder: 'Rs 500', expiry: DateTime(2026, 12, 31)),
      PromoCode(code: 'FREEDEL', title: 'Free Delivery', description: 'Free delivery on orders above Rs 300', discount: 'FREE DEL', minOrder: 'Rs 300', expiry: DateTime(2026, 10, 15)),
      PromoCode(code: 'WEEKEND50', title: 'Weekend Special', description: 'Rs 50 off on weekend orders', discount: 'Rs 50', minOrder: 'Rs 400', expiry: DateTime(2026, 9, 30)),
      PromoCode(code: 'REFER100', title: 'Referral Bonus', description: 'Rs 100 off when you refer a friend', discount: 'Rs 100', minOrder: 'Rs 600', expiry: DateTime(2026, 11, 30)),
      PromoCode(code: 'VIP30', title: 'VIP Member', description: '30% off for VIP members only', discount: '30% OFF', minOrder: 'Rs 800', expiry: DateTime(2026, 12, 25), isUsed: true),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Promo Codes')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Apply code field
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.borderLight, width: 1),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'Enter promo code',
                      hintStyle: TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.textHint),
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.local_offer_outlined, color: AppColors.primary, size: 20),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: const Text('Promo code applied!'), backgroundColor: AppColors.success, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [AppColors.gradientButtonStart, AppColors.gradientButtonEnd]),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text('Apply', style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Available promos
          Text('Available Offers', style: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          const SizedBox(height: 12),
          ...promos.where((p) => !p.isUsed).map((p) => _buildPromoCard(context, p)),

          const SizedBox(height: 24),

          // Used promos
          Text('Used / Expired', style: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textHint)),
          const SizedBox(height: 12),
          ...promos.where((p) => p.isUsed).map((p) => _buildPromoCard(context, p, isExpired: true)),
        ],
      ),
    );
  }

  Widget _buildPromoCard(BuildContext context, PromoCode promo, {bool isExpired = false}) {
    return Opacity(
      opacity: isExpired ? 0.5 : 1.0,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: isExpired ? AppColors.borderLight : AppColors.primary.withValues(alpha: 0.3), width: 1),
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              // Left discount badge
              Container(
                width: 90,
                decoration: BoxDecoration(
                  gradient: isExpired ? null : const LinearGradient(colors: [AppColors.gradientButtonStart, AppColors.gradientButtonEnd]),
                  color: isExpired ? AppColors.surfaceVariant : null,
                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(14)),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(promo.discount, style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w800, color: isExpired ? AppColors.textHint : Colors.white)),
                      const SizedBox(height: 4),
                      Text(promo.minOrder, style: TextStyle(fontFamily: 'Inter', fontSize: 9, color: isExpired ? AppColors.textHint : Colors.white70)),
                    ],
                  ),
                ),
              ),
              // Right details
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(promo.title, style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                      const SizedBox(height: 4),
                      Text(promo.description, style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textHint)),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                            child: Text(promo.code, style: TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary)),
                          ),
                          const SizedBox(width: 8),
                          Text('Expires: ${promo.expiry.day}/${promo.expiry.month}/${promo.expiry.year}', style: TextStyle(fontFamily: 'Inter', fontSize: 10, color: AppColors.textHint)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Copy button
              if (!isExpired)
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Code "${promo.code}" copied!'), backgroundColor: AppColors.success, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                      );
                    },
                    child: Icon(Icons.copy_rounded, color: AppColors.primary, size: 18),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
