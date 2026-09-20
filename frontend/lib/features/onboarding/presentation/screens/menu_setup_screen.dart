import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:foodos/core/theme/app_colors.dart';
import 'package:foodos/core/theme/app_text_styles.dart';

class MenuSetupScreen extends StatefulWidget {
  const MenuSetupScreen({super.key});

  @override
  State<MenuSetupScreen> createState() => _MenuSetupScreenState();
}

class _MenuSetupScreenState extends State<MenuSetupScreen> {
  final List<Map<String, dynamic>> _categories = [
    {'name': 'Appetizers', 'icon': Icons.tapas},
    {'name': 'Main Course', 'icon': Icons.restaurant},
    {'name': 'Beverages', 'icon': Icons.local_drink},
    {'name': 'Desserts', 'icon': Icons.cake},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Up Menu'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Add menu categories',
                style: AppTextStyles.h3,
              ),
              const SizedBox(height: 8),
              Text(
                'We\'ve added some common categories. You can customize them.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),

              // Category chips
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _categories.map((cat) {
                  return Chip(
                    avatar: Icon(cat['icon'], size: 18),
                    label: Text(cat['name']),
                    deleteIcon: const Icon(Icons.close, size: 18),
                    onDeleted: () {
                      setState(() {
                        _categories.remove(cat);
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Add category
              OutlinedButton.icon(
                onPressed: () {
                  // TODO: Show add category dialog
                },
                icon: const Icon(Icons.add),
                label: const Text('Add Category'),
              ),
              const SizedBox(height: 32),

              // Info card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.info.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.info.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: AppColors.info),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'You can add menu items and customize categories later from the Menu section.',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.info,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Continue Button
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: () => context.push('/onboarding/complete'),
                  child: const Text('Continue'),
                ),
              ),
              const SizedBox(height: 12),

              // Skip Button
              TextButton(
                onPressed: () => context.push('/onboarding/complete'),
                child: const Text('Skip for now'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
