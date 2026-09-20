import 'package:flutter/material.dart';
import 'package:foodos/core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';

class OrderTrackingScreen extends StatefulWidget {
  const OrderTrackingScreen({super.key});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  int _currentStep = 2;

  final _steps = [
    {'title': 'Order Placed', 'subtitle': 'Your order has been placed', 'time': '12:30 PM', 'icon': Icons.receipt_long},
    {'title': 'Confirmed', 'subtitle': 'Restaurant confirmed your order', 'time': '12:32 PM', 'icon': Icons.check_circle},
    {'title': 'Preparing', 'subtitle': 'Your food is being prepared', 'time': '12:35 PM', 'icon': Icons.restaurant},
    {'title': 'Out for Delivery', 'subtitle': 'Rider is on the way', 'time': '12:55 PM', 'icon': Icons.delivery_dining},
    {'title': 'Delivered', 'subtitle': 'Enjoy your meal!', 'time': '1:10 PM', 'icon': Icons.home},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Order Tracking')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Order info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.borderLight, width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Order #ORD-045', style: TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                    const SizedBox(height: 4),
                    Text('2 items  •  Rs 700', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textHint)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('Preparing', style: TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // ETA
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary.withValues(alpha: 0.1), AppColors.primary.withValues(alpha: 0.05)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.2), width: 1),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [AppColors.gradientButtonStart, AppColors.gradientButtonEnd]),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.access_time, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Estimated Delivery', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textHint)),
                    Text('25-30 min', style: TextStyle(fontFamily: 'Inter', fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Status steps
          ...List.generate(_steps.length, (index) {
            final step = _steps[index];
            final isActive = index <= _currentStep;
            final isCurrent = index == _currentStep;
            final isLast = index == _steps.length - 1;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: isActive ? AppColors.primary : AppColors.borderLight,
                        shape: BoxShape.circle,
                        boxShadow: isCurrent ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 8)] : null,
                      ),
                      child: Icon(
                        isActive ? Icons.check : step['icon'] as IconData,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    if (!isLast)
                      Container(
                        width: 2,
                        height: 40,
                        color: isActive ? AppColors.primary : AppColors.borderLight,
                      ),
                  ],
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          step['title'] as String,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w600,
                            color: isActive ? AppColors.textPrimary : AppColors.textHint,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          step['subtitle'] as String,
                          style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: isActive ? AppColors.textSecondary : AppColors.textHint),
                        ),
                        if (isActive) ...[
                          const SizedBox(height: 4),
                          Text(
                            step['time'] as String,
                            style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textHint),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),

          // Rider info
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.borderLight, width: 1),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [AppColors.gradientButtonStart, AppColors.gradientButtonEnd]),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(child: Text('H', style: TextStyle(fontFamily: 'Inter', fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white))),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hamza Ali', style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                      Text('Your delivery rider', style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textHint)),
                    ],
                  ),
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.1), shape: BoxShape.circle),
                  child: Icon(Icons.phone, color: AppColors.success, size: 20),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(color: AppColors.info.withValues(alpha: 0.1), shape: BoxShape.circle),
                  child: Icon(Icons.chat, color: AppColors.info, size: 20),
                ),
              ],
            ),
          ),

          // Simulate button
          const SizedBox(height: 24),
          if (_currentStep < _steps.length - 1)
            GestureDetector(
              onTap: () {
                setState(() {
                  _currentStep++;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderLight, width: 1),
                ),
                child: Center(
                  child: Text('Simulate Next Step (Demo)', style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                ),
              ),
            ),
          if (_currentStep >= _steps.length - 1)
            GestureDetector(
              onTap: () {
                context.push('/customer/rating-review');
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [AppColors.gradientButtonStart, AppColors.gradientButtonEnd]),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Center(child: Text('Rate Order', style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white))),
              ),
            ),
        ],
      ),
    );
  }
}
