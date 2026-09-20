import 'package:flutter/material.dart';
import 'package:foodos/core/theme/app_colors.dart';

class StaffPerformanceReportScreen extends StatelessWidget {
  const StaffPerformanceReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Staff Performance')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSummaryCards(),
          const SizedBox(height: 20),
          _buildSection('Top Performers', [
            _buildStaffItem('Sara Ahmed', 'Manager', 'Rs 2.4L', '98%', 4.9),
            _buildStaffItem('Ali Khan', 'Cashier', 'Rs 1.8L', '95%', 4.7),
            _buildStaffItem('Usman Malik', 'Chef', 'Rs 1.5L', '92%', 4.5),
          ]),
          const SizedBox(height: 20),
          _buildSection('Attendance Overview', [
            _buildAttendanceRow('Sara Ahmed', '26/28', '93%'),
            _buildAttendanceRow('Ali Khan', '25/28', '89%'),
            _buildAttendanceRow('Usman Malik', '27/28', '96%'),
            _buildAttendanceRow('Fatima Noor', '24/28', '86%'),
          ]),
          const SizedBox(height: 20),
          _buildSection('Orders Handled', [
            _buildOrdersBar('Ali Khan', 156, 200),
            _buildOrdersBar('Sara Ahmed', 142, 200),
            _buildOrdersBar('Usman Malik', 128, 200),
            _buildOrdersBar('Fatima Noor', 98, 200),
          ]),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Row(
      children: [
        Expanded(child: _buildCard('Total Staff', '12', AppColors.info)),
        const SizedBox(width: 12),
        Expanded(child: _buildCard('Avg Rating', '4.6', AppColors.warning)),
        const SizedBox(width: 12),
        Expanded(child: _buildCard('Attendance', '92%', AppColors.success)),
      ],
    );
  }

  Widget _buildCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.borderLight, width: 1)),
      child: Column(children: [
        Text(value, style: TextStyle(fontFamily: 'Inter', fontSize: 20, fontWeight: FontWeight.w800, color: color)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textHint)),
      ]),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title.toUpperCase(), style: TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textHint, letterSpacing: 1.2)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.borderLight, width: 1)),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildStaffItem(String name, String role, String revenue, String rating, double stars) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            child: Text(name[0], style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                Text(role, style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textHint)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(revenue, style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary)),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star_rounded, color: AppColors.warning, size: 14),
                  const SizedBox(width: 2),
                  Text(stars.toString(), style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textHint)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceRow(String name, String days, String pct) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(child: Text(name, style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.textPrimary))),
          Text(days, style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textSecondary)),
          const SizedBox(width: 12),
          Container(
            width: 48,
            padding: const EdgeInsets.symmetric(vertical: 3),
            decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(6)),
            child: Center(child: Text(pct, style: TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.success))),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersBar(String name, int orders, int max) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.textPrimary)),
              Text('$orders orders', style: TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: orders / max,
              backgroundColor: AppColors.borderLight,
              valueColor: AlwaysStoppedAnimation(AppColors.primary),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}
