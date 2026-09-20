import 'package:flutter/material.dart';
import 'package:foodos/core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';

class ScheduledOrderScreen extends StatefulWidget {
  const ScheduledOrderScreen({super.key});

  @override
  State<ScheduledOrderScreen> createState() => _ScheduledOrderScreenState();
}

class _ScheduledOrderScreenState extends State<ScheduledOrderScreen> {
  bool _isScheduled = false;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 12, minute: 0);

  final _dates = List.generate(7, (i) => DateTime.now().add(Duration(days: i)));
  final _times = [
    '9:00 AM', '10:00 AM', '11:00 AM', '12:00 PM',
    '1:00 PM', '2:00 PM', '3:00 PM', '4:00 PM',
    '5:00 PM', '6:00 PM', '7:00 PM', '8:00 PM',
    '9:00 PM', '10:00 PM',
  ];

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    if (date.day == now.day && date.month == now.month && date.year == now.year) return 'Today';
    if (date.day == now.day + 1) return 'Tomorrow';
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}';
  }

  String _getDayName(DateTime date) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[date.weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Schedule Order')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Toggle
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
                    Text('Schedule for later', style: TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                    SizedBox(height: 2),
                    Text('Choose date & time for delivery', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textHint)),
                  ],
                ),
                Switch(
                  value: _isScheduled,
                  onChanged: (v) => setState(() => _isScheduled = v),
                  activeColor: AppColors.primary,
                ),
              ],
            ),
          ),

          if (_isScheduled) ...[
            const SizedBox(height: 24),

            // Date selection
            Text('Select Date', style: TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            const SizedBox(height: 12),
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _dates.length,
                itemBuilder: (context, index) {
                  final date = _dates[index];
                  final isSelected = _selectedDate.day == date.day;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedDate = date),
                    child: Container(
                      width: 64,
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: isSelected ? AppColors.primary : AppColors.borderLight, width: 1),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(_getDayName(date), style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: isSelected ? Colors.white70 : AppColors.textHint)),
                          const SizedBox(height: 4),
                          Text('${date.day}', style: TextStyle(fontFamily: 'Inter', fontSize: 20, fontWeight: FontWeight.w700, color: isSelected ? Colors.white : AppColors.textPrimary)),
                          const SizedBox(height: 2),
                          Text(_formatDate(date), style: TextStyle(fontFamily: 'Inter', fontSize: 10, color: isSelected ? Colors.white70 : AppColors.textHint)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // Time selection
            Text('Select Time', style: TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _times.map((time) {
                final isSelected = _selectedTime.hour == int.parse(time.split(':')[0]) && 
                    ((time.contains('PM') && _selectedTime.period == DayPeriod.pm) || 
                     (time.contains('AM') && _selectedTime.period == DayPeriod.am));
                return GestureDetector(
                  onTap: () {
                    final parts = time.split(':');
                    var hour = int.parse(parts[0]);
                    if (time.contains('PM') && hour != 12) hour += 12;
                    if (time.contains('AM') && hour == 12) hour = 0;
                    setState(() => _selectedTime = TimeOfDay(hour: hour, minute: 0));
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : AppColors.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: isSelected ? AppColors.primary : AppColors.borderLight, width: 1),
                    ),
                    child: Text(time, style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600, color: isSelected ? Colors.white : AppColors.textPrimary)),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary.withValues(alpha: 0.08), AppColors.primary.withValues(alpha: 0.03)],
                ),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.2), width: 1),
              ),
              child: Row(
                children: [
                  Icon(Icons.access_time, color: AppColors.primary, size: 24),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Scheduled Delivery', style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                      Text('${_formatDate(_selectedDate)} at ${_selectedTime.format(context)}', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textHint)),
                    ],
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 32),

          // Confirm button
          GestureDetector(
            onTap: () {
              context.pop({
                'isScheduled': _isScheduled,
                'date': _selectedDate,
                'time': _selectedTime,
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_isScheduled ? 'Order scheduled for ${_formatDate(_selectedDate)}' : 'Order will be delivered now'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [AppColors.gradientButtonStart, AppColors.gradientButtonEnd]),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4))],
              ),
              child: Center(
                child: Text(_isScheduled ? 'Confirm Schedule' : 'Continue', style: const TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
