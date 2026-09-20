import 'package:flutter/material.dart';
import 'package:foodos/core/theme/app_colors.dart';
import 'package:foodos/core/theme/app_text_styles.dart';
import 'package:foodos/core/widgets/status_badge.dart';
import 'package:go_router/go_router.dart';

class StaffDetailScreen extends StatelessWidget {
  final String staffId;
  const StaffDetailScreen({super.key, required this.staffId});

  @override
  Widget build(BuildContext context) {
    final staff = {
      'name': 'Ali Raza',
      'role': 'Manager',
      'branch': 'Gulshan',
      'phone': '0300-1111111',
      'email': 'ali@email.com',
      'status': 'active',
      'joined': 'Jan 2026',
      'salary': 'Rs 45,000',
    };

    final attendance = [
      {'date': 'Aug 30', 'clockIn': '9:00 AM', 'clockOut': '6:00 PM', 'hours': '9h'},
      {'date': 'Aug 29', 'clockIn': '9:05 AM', 'clockOut': '5:55 PM', 'hours': '8h 50m'},
      {'date': 'Aug 28', 'clockIn': '8:55 AM', 'clockOut': '6:10 PM', 'hours': '9h 15m'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(staff['name'] as String),
        actions: [
          IconButton(icon: const Icon(Icons.edit), onPressed: () => context.push('/employees/edit/$staffId')),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  child: Text(
                    (staff['name'] as String)[0],
                    style: TextStyle(fontSize: 28, color: AppColors.primary, fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(height: 12),
                Text(staff['name'] as String, style: AppTextStyles.h3),
                const SizedBox(height: 4),
                StatusBadge(label: staff['role'] as String, color: AppColors.primary),
                const SizedBox(height: 8),
                Text(staff['phone'] as String, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                Text(staff['email'] as String, style: AppTextStyles.caption),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Info Cards
          Row(
            children: [
              Expanded(child: _InfoTile(icon: Icons.location_on, label: 'Branch', value: staff['branch'] as String)),
              const SizedBox(width: 8),
              Expanded(child: _InfoTile(icon: Icons.calendar_today, label: 'Joined', value: staff['joined'] as String)),
              const SizedBox(width: 8),
              Expanded(child: _InfoTile(icon: Icons.attach_money, label: 'Salary', value: staff['salary'] as String)),
            ],
          ),
          const SizedBox(height: 16),

          // Attendance
          Text('Recent Attendance', style: AppTextStyles.h4),
          const SizedBox(height: 8),
          ...attendance.map((a) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Row(
              children: [
                Expanded(child: Text(a['date'] as String, style: AppTextStyles.bodyMedium)),
                Column(
                  children: [
                    Text('In: ${a['clockIn']}', style: AppTextStyles.caption),
                    Text('Out: ${a['clockOut']}', style: AppTextStyles.caption),
                  ],
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(a['hours'] as String, style: TextStyle(color: AppColors.success, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoTile({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(height: 4),
          Text(value, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600)),
          Text(label, style: AppTextStyles.caption),
        ],
      ),
    );
  }
}
