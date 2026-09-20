import 'package:flutter/material.dart';
import 'package:foodos/core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';

class TipRiderScreen extends StatefulWidget {
  const TipRiderScreen({super.key});

  @override
  State<TipRiderScreen> createState() => _TipRiderScreenState();
}

class _TipRiderScreenState extends State<TipRiderScreen> {
  int _selectedTip = 0;
  final _customController = TextEditingController();

  final _tips = [20, 50, 100, 200];

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Tip Rider')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Rider info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.borderLight, width: 1),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [AppColors.gradientButtonStart, AppColors.gradientButtonEnd]),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(child: Text('H', style: TextStyle(fontFamily: 'Inter', fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white))),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hamza Ali', style: TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                      SizedBox(height: 2),
                      Text('Delivered your order', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textHint)),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.star_rounded, size: 16, color: Color(0xFFFFB27A)),
                    SizedBox(width: 2),
                    Text('4.8', style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Thank you
          Center(
            child: Text('Say thanks with a tip!', style: TextStyle(fontFamily: 'Inter', fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text('100% of your tip goes to the rider', style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.textHint)),
          ),
          const SizedBox(height: 24),

          // Tip options
          Row(
            children: _tips.map((tip) {
              final isSelected = _selectedTip == tip;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() {
                    _selectedTip = tip;
                    _customController.clear();
                  }),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: isSelected ? AppColors.primary : AppColors.borderLight, width: isSelected ? 2 : 1),
                    ),
                    child: Column(
                      children: [
                        Text('Rs $tip', style: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w700, color: isSelected ? AppColors.primary : AppColors.textPrimary)),
                        const SizedBox(height: 2),
                        Text('Tip', style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: isSelected ? AppColors.primary : AppColors.textHint)),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // Custom tip
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderLight, width: 1),
            ),
            child: Row(
              children: [
                Text('Rs', style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _customController,
                    keyboardType: TextInputType.number,
                    onChanged: (v) {
                      final amount = int.tryParse(v);
                      if (amount != null && amount > 0) {
                        setState(() => _selectedTip = amount);
                      }
                    },
                    style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'Custom amount',
                      hintStyle: TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.textHint),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // No tip
          GestureDetector(
            onTap: () => setState(() {
              _selectedTip = 0;
              _customController.clear();
            }),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: _selectedTip == 0 ? AppColors.primary.withValues(alpha: 0.06) : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _selectedTip == 0 ? AppColors.primary : AppColors.borderLight, width: 1),
              ),
              child: Center(
                child: Text('No tip', style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600, color: _selectedTip == 0 ? AppColors.primary : AppColors.textSecondary)),
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Confirm button
          GestureDetector(
            onTap: () {
              context.pop(_selectedTip);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_selectedTip > 0 ? 'Tip of Rs $_selectedTip added' : 'No tip added'),
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
                child: Text(
                  _selectedTip > 0 ? 'Add Tip  â€¢  Rs $_selectedTip' : 'Continue',
                  style: const TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
