import 'package:flutter/material.dart';
import 'package:foodos/core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';

class DeliveryInstructionsScreen extends StatefulWidget {
  const DeliveryInstructionsScreen({super.key});

  @override
  State<DeliveryInstructionsScreen> createState() => _DeliveryInstructionsScreenState();
}

class _DeliveryInstructionsScreenState extends State<DeliveryInstructionsScreen> {
  String _selectedInstruction = 'Ring the bell';
  final _gateController = TextEditingController();
  final _notesController = TextEditingController();
  bool _leaveAtDoor = false;
  bool _contactless = false;

  final _instructions = [
    {'icon': Icons.doorbell_outlined, 'title': 'Ring the bell', 'subtitle': 'Ring doorbell on arrival'},
    {'icon': Icons.phone_outlined, 'title': 'Call on arrival', 'subtitle': 'Call when you reach'},
    {'icon': Icons.message_outlined, 'title': 'Send message', 'subtitle': 'Text on arrival'},
    {'icon': Icons.notification_important_outlined, 'title': 'Just leave it', 'subtitle': 'No need to contact'},
  ];

  @override
  void dispose() {
    _gateController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Delivery Instructions')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // How to contact
          Text('How should rider contact you?', style: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          const SizedBox(height: 12),
          ...List.generate(_instructions.length, (i) {
            final inst = _instructions[i];
            final isSelected = _selectedInstruction == inst['title'];
            return GestureDetector(
              onTap: () => setState(() => _selectedInstruction = inst['title'] as String),
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary.withValues(alpha: 0.06) : AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: isSelected ? AppColors.primary : AppColors.borderLight, width: isSelected ? 2 : 1),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(inst['icon'] as IconData, color: isSelected ? AppColors.primary : AppColors.textSecondary, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(inst['title'] as String, style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600, color: isSelected ? AppColors.primary : AppColors.textPrimary)),
                          const SizedBox(height: 2),
                          Text(inst['subtitle'] as String, style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textHint)),
                        ],
                      ),
                    ),
                    if (isSelected)
                      Icon(Icons.check_circle, color: AppColors.primary, size: 22),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 24),

          // Gate code / Floor
          Text('Gate / Floor / Apartment', style: TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderLight, width: 1),
            ),
            child: TextField(
              controller: _gateController,
              style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'e.g. Apt 5B, Floor 3, Gate #4',
                hintStyle: TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.textHint),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(16),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Additional notes
          Text('Additional Notes', style: TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderLight, width: 1),
            ),
            child: TextField(
              controller: _notesController,
              maxLines: 3,
              style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'e.g. Blue gate, near mosque, landmark...',
                hintStyle: TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.textHint),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(16),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Toggles
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderLight, width: 1),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Leave at door', style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                          SizedBox(height: 2),
                          Text('Rider will leave order at your door', style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textHint)),
                        ],
                      ),
                    ),
                    Switch(
                      value: _leaveAtDoor,
                      onChanged: (v) => setState(() => _leaveAtDoor = v),
                      activeColor: AppColors.primary,
                    ),
                  ],
                ),
                Divider(height: 24, color: AppColors.borderLight),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Contactless delivery', style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                          SizedBox(height: 2),
                          Text('No physical contact during delivery', style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textHint)),
                        ],
                      ),
                    ),
                    Switch(
                      value: _contactless,
                      onChanged: (v) => setState(() => _contactless = v),
                      activeColor: AppColors.primary,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Save button
          GestureDetector(
            onTap: () {
              context.pop({
                'instruction': _selectedInstruction,
                'gate': _gateController.text,
                'notes': _notesController.text,
                'leaveAtDoor': _leaveAtDoor,
                'contactless': _contactless,
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Instructions saved'), backgroundColor: AppColors.success),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [AppColors.gradientButtonStart, AppColors.gradientButtonEnd]),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4))],
              ),
              child: const Center(child: Text('Save Instructions', style: TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white))),
            ),
          ),
        ],
      ),
    );
  }
}
