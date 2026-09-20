import 'package:flutter/material.dart';
import 'package:foodos/core/theme/app_colors.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  String _currentPlan = 'Starter';
  String _currentPrice = 'Rs 3,000/month';
  int _branchLimit = 1;
  int _staffLimit = 5;
  List<String> _planFeatures = ['1 Branch', '5 Staff', 'Basic POS'];

  final Map<String, Map<String, dynamic>> _plans = {
    'Starter': {
      'price': 'Rs 3,000/month',
      'branches': 1,
      'staff': 5,
      'features': ['1 Branch', '5 Staff', 'Basic POS'],
    },
    'Growth': {
      'price': 'Rs 7,000/month',
      'branches': 3,
      'staff': 15,
      'features': ['3 Branches', '15 Staff', 'Inventory & CRM', 'Kitchen Display'],
    },
    'Pro': {
      'price': 'Rs 15,000/month',
      'branches': 10,
      'staff': 50,
      'features': ['10 Branches', '50 Staff', 'Advanced Reports', 'Multi-Branch Dashboard'],
    },
  };

  void _upgradeTo(String planName) {
    final plan = _plans[planName]!;
    setState(() {
      _currentPlan = planName;
      _currentPrice = plan['price'];
      _branchLimit = plan['branches'];
      _staffLimit = plan['staff'];
      _planFeatures = List<String>.from(plan['features']);
    });
  }

  void _showUpgradeDialog(BuildContext context, String planName, String price) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(color: AppColors.borderLight, borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 20),
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [AppColors.gradientButtonStart, AppColors.gradientButtonEnd]),
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 20, spreadRadius: 2)],
              ),
              child: const Icon(Icons.workspace_premium_rounded, color: Colors.white, size: 28),
            ),
            const SizedBox(height: 16),
            Text('Upgrade to $planName', style: TextStyle(fontFamily: 'Inter', fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            const SizedBox(height: 8),
            Text(price, style: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.primary)),
            const SizedBox(height: 8),
            Text(
              'You will be charged immediately. Your current plan will be replaced and the remaining days will be prorated.',
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(ctx),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.borderLight, width: 1),
                      ),
                      child: Center(
                        child: Text('Cancel', style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(ctx);
                      _upgradeTo(planName);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Upgraded to $planName successfully!', style: const TextStyle(fontFamily: 'Inter')),
                          backgroundColor: AppColors.success,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [AppColors.gradientButtonStart, AppColors.gradientButtonEnd]),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))],
                      ),
                      child: const Center(
                        child: Text('Confirm Upgrade', style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Subscription')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Current Plan Card
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: Container(
              key: ValueKey(_currentPlan),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 6))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.workspace_premium, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        '$_currentPlan Plan',
                        style: const TextStyle(fontFamily: 'Inter', fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(6)),
                        child: const Text('Active', style: TextStyle(fontFamily: 'Inter', fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _currentPrice,
                    style: const TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white70),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: _planFeatures.map((f) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
                      child: Text(f, style: const TextStyle(fontFamily: 'Inter', fontSize: 12, color: Colors.white)),
                    )).toList(),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.white60, size: 14),
                      const SizedBox(width: 6),
                      Text(
                        'Next billing: Sep 30, 2026',
                        style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: Colors.white.withValues(alpha: 0.6)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Usage
          Text('Usage', style: TextStyle(fontFamily: 'Inter', fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          const SizedBox(height: 12),
          _UsageIndicator(label: 'Branches', used: 1, total: _branchLimit),
          const SizedBox(height: 8),
          _UsageIndicator(label: 'Staff', used: 3, total: _staffLimit),
          const SizedBox(height: 24),

          // Upgrade Plans
          Text('Upgrade Plan', style: TextStyle(fontFamily: 'Inter', fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          const SizedBox(height: 12),
          _PlanCard(
            name: 'Growth',
            price: 'Rs 7,000/mo',
            features: ['Up to 3 branches', '15 staff accounts', 'Inventory & CRM', 'Kitchen Display'],
            isCurrent: _currentPlan == 'Growth',
            onTap: _currentPlan == 'Growth' ? null : () => _showUpgradeDialog(context, 'Growth', 'Rs 7,000/mo'),
          ),
          const SizedBox(height: 8),
          _PlanCard(
            name: 'Pro',
            price: 'Rs 15,000/mo',
            features: ['Up to 10 branches', '50 staff accounts', 'Advanced reports', 'Multi-branch dashboard'],
            isCurrent: _currentPlan == 'Pro',
            onTap: _currentPlan == 'Pro' ? null : () => _showUpgradeDialog(context, 'Pro', 'Rs 15,000/mo'),
          ),
        ],
      ),
    );
  }
}

class _UsageIndicator extends StatelessWidget {
  final String label;
  final int used;
  final int total;

  const _UsageIndicator({required this.label, required this.used, required this.total});

  @override
  Widget build(BuildContext context) {
    final progress = used / total;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.textPrimary)),
            Text('$used / $total', style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            backgroundColor: AppColors.borderLight,
            color: progress > 0.8 ? AppColors.warning : AppColors.primary,
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}

class _PlanCard extends StatelessWidget {
  final String name;
  final String price;
  final List<String> features;
  final bool isCurrent;
  final VoidCallback? onTap;

  const _PlanCard({
    required this.name,
    required this.price,
    required this.features,
    required this.isCurrent,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isCurrent ? AppColors.primary : AppColors.borderLight,
          width: isCurrent ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(name, style: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                  if (isCurrent) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [AppColors.gradientButtonStart, AppColors.gradientButtonEnd]),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text('Current', style: TextStyle(fontFamily: 'Inter', fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white)),
                    ),
                  ],
                ],
              ),
              Text(price, style: TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            ],
          ),
          const SizedBox(height: 12),
          ...features.map((f) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: [
                Icon(Icons.check_circle, size: 16, color: AppColors.success),
                const SizedBox(width: 8),
                Text(f, style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.textSecondary)),
              ],
            ),
          )),
          const SizedBox(height: 12),
          if (!isCurrent)
            SizedBox(
              width: double.infinity,
              child: GestureDetector(
                onTap: onTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [AppColors.gradientButtonStart, AppColors.gradientButtonEnd]),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))],
                  ),
                  child: const Center(
                    child: Text('Upgrade', style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                  ),
                ),
              ),
            )
          else
            SizedBox(
              width: double.infinity,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.success.withValues(alpha: 0.3), width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, size: 16, color: AppColors.success),
                    SizedBox(width: 6),
                    Text('Current Plan', style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.success)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
