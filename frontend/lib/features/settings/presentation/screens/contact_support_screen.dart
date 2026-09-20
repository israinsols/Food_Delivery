import 'package:flutter/material.dart';
import 'package:foodos/core/theme/app_colors.dart';

class ContactSupportScreen extends StatefulWidget {
  const ContactSupportScreen({super.key});

  @override
  State<ContactSupportScreen> createState() => _ContactSupportScreenState();
}

class _ContactSupportScreenState extends State<ContactSupportScreen> {
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  String _selectedCategory = 'General Inquiry';

  final _categories = ['General Inquiry', 'Bug Report', 'Feature Request', 'Account Issue', 'Billing'];

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Contact Support')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.success.withValues(alpha: 0.2), width: 1),
            ),
            child: Row(
              children: [
                Icon(Icons.chat_bubble_outline_rounded, color: AppColors.success, size: 22),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Live Chat Available', style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                      Text('Mon-Sat, 9AM-6PM PKT', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textHint)),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: AppColors.textHint, size: 20),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('CATEGORY', style: TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textHint, letterSpacing: 1.2)),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderLight, width: 1)),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(border: InputBorder.none),
              items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontFamily: 'Inter', fontSize: 14)))).toList(),
              onChanged: (v) => setState(() => _selectedCategory = v!),
            ),
          ),
          const SizedBox(height: 16),
          Text('SUBJECT', style: TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textHint, letterSpacing: 1.2)),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderLight, width: 1)),
            child: TextField(
              controller: _subjectController,
              style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Brief description of your issue',
                hintStyle: TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.textHint),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(16),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('MESSAGE', style: TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textHint, letterSpacing: 1.2)),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderLight, width: 1)),
            child: TextField(
              controller: _messageController,
              maxLines: 6,
              style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Describe your issue in detail...',
                hintStyle: TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.textHint),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(16),
              ),
            ),
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [AppColors.gradientButtonStart, AppColors.gradientButtonEnd]),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4))],
              ),
              child: const Center(
                child: Text('Send Message', style: TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
