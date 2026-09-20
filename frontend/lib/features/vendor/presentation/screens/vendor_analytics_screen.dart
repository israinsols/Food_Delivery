import 'package:flutter/material.dart';
import 'package:foodos/core/theme/app_colors.dart';

class VendorAnalyticsScreen extends StatefulWidget {
  const VendorAnalyticsScreen({super.key});

  @override
  State<VendorAnalyticsScreen> createState() => _VendorAnalyticsScreenState();
}

class _VendorAnalyticsScreenState extends State<VendorAnalyticsScreen> {
  String _selectedPeriod = 'This Month';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Analytics')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Period selector
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderLight, width: 1),
            ),
            child: Row(
              children: ['Today', 'This Week', 'This Month', 'All Time'].map((period) {
                final isSelected = period == _selectedPeriod;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedPeriod = period),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(period, style: TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w600, color: isSelected ? Colors.white : AppColors.textHint)),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),

          // Stats grid
          Row(
            children: [
              _buildStatCard('Total Revenue', 'Rs 2.4L', Icons.trending_up_rounded, AppColors.success, '+12%'),
              const SizedBox(width: 12),
              _buildStatCard('Total Orders', '284', Icons.shopping_bag_rounded, AppColors.primary, '+8%'),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildStatCard('Avg. Order Value', 'Rs 845', Icons.receipt_rounded, AppColors.info, '+5%'),
              const SizedBox(width: 12),
              _buildStatCard('Pending Orders', '12', Icons.pending_actions_rounded, AppColors.warning, ''),
            ],
          ),
          const SizedBox(height: 24),

          // Sales chart (mock bar chart)
          _buildSectionHeader('Sales Overview'),
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
                SizedBox(
                  height: 160,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildBar('Mon', 0.4, true),
                      _buildBar('Tue', 0.7, true),
                      _buildBar('Wed', 0.5, true),
                      _buildBar('Thu', 0.9, true),
                      _buildBar('Fri', 1.0, true),
                      _buildBar('Sat', 0.8, true),
                      _buildBar('Sun', 0.3, false),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Peak Hours
          _buildSectionHeader('Peak Hours'),
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
                _buildPeakHour('12:00 PM - 2:00 PM', 'Lunch Rush', 0.95, AppColors.primary),
                const SizedBox(height: 12),
                _buildPeakHour('6:00 PM - 9:00 PM', 'Dinner Rush', 1.0, const Color(0xFFCB202D)),
                const SizedBox(height: 12),
                _buildPeakHour('3:00 PM - 5:00 PM', 'Tea Time', 0.6, AppColors.info),
                const SizedBox(height: 12),
                _buildPeakHour('9:00 AM - 11:00 AM', 'Breakfast', 0.4, AppColors.success),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Top selling items
          _buildSectionHeader('Top Selling Items'),
          const SizedBox(height: 12),
          _buildTopItem('Chicken Biryani', 324, 'Rs 97,200', 0.95),
          _buildTopItem('Seekh Kabab', 218, 'Rs 43,600', 0.72),
          _buildTopItem('Naan', 456, 'Rs 22,800', 0.65),
          _buildTopItem('Gulab Jamun', 156, 'Rs 18,720', 0.55),
          _buildTopItem('Lassi', 234, 'Rs 23,400', 0.48),
          const SizedBox(height: 24),

          // Customer insights
          _buildSectionHeader('Customer Insights'),
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
                _buildInsightRow('Total Customers', '1,847'),
                _buildInsightRow('New Customers (This Month)', '234'),
                _buildInsightRow('Repeat Customers', '68%'),
                _buildInsightRow('Avg. Rating', '4.8 ⭐'),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color, String change) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.borderLight, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
                  child: Icon(icon, color: color, size: 18),
                ),
                const Spacer(),
                if (change.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(4)),
                    child: Text(change, style: TextStyle(fontFamily: 'Inter', fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.success)),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(value, style: TextStyle(fontFamily: 'Inter', fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
            const SizedBox(height: 2),
            Text(title, style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textHint)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(title, style: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary));
  }

  Widget _buildBar(String day, double height, bool isActive) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: 120 * height,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: isActive ? AppColors.primary.withValues(alpha: 0.8) : AppColors.textHint.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          const SizedBox(height: 8),
          Text(day, style: TextStyle(fontFamily: 'Inter', fontSize: 10, color: AppColors.textHint)),
        ],
      ),
    );
  }

  Widget _buildPeakHour(String time, String label, double intensity, Color color) {
    return Row(
      children: [
        SizedBox(
          width: 140,
          child: Text(time, style: TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textHint)),
              const SizedBox(height: 4),
              Container(
                height: 8,
                decoration: BoxDecoration(color: AppColors.borderLight, borderRadius: BorderRadius.circular(4)),
                child: FractionallySizedBox(
                  widthFactor: intensity,
                  alignment: Alignment.centerLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [color, color.withValues(alpha: 0.6)]),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTopItem(String name, int orders, String revenue, double ratio) {
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
                const SizedBox(height: 4),
                Text('$orders orders • $revenue', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textHint)),
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

  Widget _buildInsightRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.textHint)),
          Text(value, style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}
