import 'package:flutter/material.dart';
import 'package:foodos/core/theme/app_colors.dart';
import 'package:foodos/core/theme/app_text_styles.dart';

class NotificationCenterScreen extends StatelessWidget {
  const NotificationCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      {
        'title': 'Low Stock Alert',
        'body': 'Cooking Oil is below minimum stock level',
        'time': '5 min ago',
        'icon': Icons.warning_amber,
        'color': AppColors.warning,
        'isRead': false,
      },
      {
        'title': 'New Order',
        'body': 'Order #ORD-001 received at Table 5',
        'time': '15 min ago',
        'icon': Icons.receipt_long,
        'color': AppColors.info,
        'isRead': false,
      },
      {
        'title': 'Payment Received',
        'body': 'Rs 3,300 received for Order #ORD-003',
        'time': '1 hour ago',
        'icon': Icons.payment,
        'color': AppColors.success,
        'isRead': true,
      },
      {
        'title': 'Staff Clock In',
        'body': 'Ali Raza clocked in for today\'s shift',
        'time': '2 hours ago',
        'icon': Icons.person,
        'color': AppColors.primary,
        'isRead': true,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All notifications marked as read')),
              );
            },
            child: const Text('Mark all read'),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: (notification['isRead'] as bool)
                  ? AppColors.surface
                  : AppColors.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: (notification['isRead'] as bool)
                    ? AppColors.borderLight
                    : AppColors.primary.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: (notification['color'] as Color).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    notification['icon'] as IconData,
                    color: notification['color'] as Color,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification['title'] as String,
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          if ((notification['isRead'] as bool) == false)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification['body'] as String,
                        style: AppTextStyles.bodySmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification['time'] as String,
                        style: AppTextStyles.caption,
                      ),
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
