import 'package:flutter/material.dart';
import 'package:foodos/core/theme/app_colors.dart';

class NotificationItem {
  final String title;
  final String body;
  final String time;
  final IconData icon;
  final Color iconColor;
  final bool isRead;

  const NotificationItem({
    required this.title,
    required this.body,
    required this.time,
    required this.icon,
    required this.iconColor,
    this.isRead = false,
  });
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      NotificationItem(title: 'Order Delivered!', body: 'Your Chicken Biryani order has been delivered. Enjoy your meal!', time: '2 min ago', icon: Icons.check_circle_rounded, iconColor: AppColors.success),
      NotificationItem(title: 'Order on the way', body: 'Your rider Ahmad is 1.2 km away from your location.', time: '15 min ago', icon: Icons.delivery_dining_rounded, iconColor: AppColors.primary),
      NotificationItem(title: '20% OFF on Pizza', body: 'Pizza Corner is offering 20% off on all pizzas. Order now!', time: '1 hour ago', icon: Icons.local_offer_rounded, iconColor: const Color(0xFFCB202D)),
      NotificationItem(title: 'Order Confirmed', body: 'Your order #ORD-2847 has been confirmed by FoodOS Kitchen.', time: '2 hours ago', icon: Icons.receipt_rounded, iconColor: AppColors.info),
      NotificationItem(title: 'Welcome to FoodOS!', body: 'Thanks for signing up. Use code FIRST20 for 20% off your first order.', time: '1 day ago', icon: Icons.waving_hand_rounded, iconColor: AppColors.warning),
      NotificationItem(title: 'Payment Successful', body: 'Rs 750 paid via JazzCash for order #ORD-2846.', time: '2 days ago', icon: Icons.payment_rounded, iconColor: AppColors.success, isRead: true),
      NotificationItem(title: 'Rate your order', body: 'How was your Chicken Biryani from FoodOS Kitchen? Rate it now.', time: '3 days ago', icon: Icons.star_rounded, iconColor: const Color(0xFFFFB27A), isRead: true),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('All notifications marked as read'), backgroundColor: AppColors.success),
              );
            },
            child: Text('Mark all read', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.primary)),
          ),
        ],
      ),
      body: notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_none_rounded, color: AppColors.textHint, size: 64),
                  const SizedBox(height: 16),
                  Text('No notifications yet', style: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                  const SizedBox(height: 8),
                  Text('We\'ll notify you about orders and offers', style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.textHint)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final n = notifications[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: n.isRead ? AppColors.surface : AppColors.primary.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: n.isRead ? AppColors.borderLight : AppColors.primary.withValues(alpha: 0.15),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: n.iconColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(n.icon, color: n.iconColor, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(n.title, style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                                ),
                                if (!n.isRead)
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.primary),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(n.body, style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textHint, height: 1.4)),
                            const SizedBox(height: 6),
                            Text(n.time, style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textHint)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
