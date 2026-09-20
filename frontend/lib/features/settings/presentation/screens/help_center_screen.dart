import 'package:flutter/material.dart';
import 'package:foodos/core/theme/app_colors.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Help Center')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [AppColors.primary.withValues(alpha: 0.1), AppColors.primary.withValues(alpha: 0.05)]),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.2), width: 1),
            ),
            child: Column(
              children: [
                Icon(Icons.help_outline_rounded, color: AppColors.primary, size: 36),
                SizedBox(height: 12),
                Text('How can we help?', style: TextStyle(fontFamily: 'Inter', fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                SizedBox(height: 4),
                Text('Browse FAQs or contact our support team', style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.textSecondary)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildFAQItem('How do I add a new menu item?', 'Go to Menu > Add Item. Fill in the name, price, category, and description. Tap Save to add it to your menu.'),
          _buildFAQItem('How do I process a refund?', 'Open the order from Order History, tap on it, and select "Refund". Choose full or partial refund and confirm.'),
          _buildFAQItem('How do I add a new staff member?', 'Go to Employees > Invite Staff. Enter their email, select a role, and assign a branch. They will receive an invite email.'),
          _buildFAQItem('How do I update my subscription plan?', 'Go to Settings > Subscription > Current Plan. You can upgrade or downgrade from there.'),
          _buildFAQItem('How do I generate a sales report?', 'Go to Reports > Sales Report. Select the date range and view detailed analytics for your selected period.'),
          _buildFAQItem('How do I manage inventory items?', 'Go to Inventory to view all items. You can add new items, adjust stock, and set low-stock alerts from there.'),
        ],
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderLight, width: 1),
      ),
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          leading: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
            child: Icon(Icons.question_answer_outlined, color: AppColors.primary, size: 16),
          ),
          title: Text(question, style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          iconColor: AppColors.textHint,
          children: [
            Text(answer, style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.textSecondary, height: 1.5)),
          ],
        ),
      ),
    );
  }
}
