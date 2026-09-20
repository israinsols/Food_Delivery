import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:foodos/core/theme/app_colors.dart';
import 'package:foodos/core/theme/app_text_styles.dart';

class CreateBusinessScreen extends StatefulWidget {
  const CreateBusinessScreen({super.key});

  @override
  State<CreateBusinessScreen> createState() => _CreateBusinessScreenState();
}

class _CreateBusinessScreenState extends State<CreateBusinessScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String _selectedType = 'restaurant';

  final List<Map<String, dynamic>> _businessTypes = [
    {'value': 'restaurant', 'label': 'Restaurant', 'icon': Icons.restaurant},
    {'value': 'cafe', 'label': 'Cafe', 'icon': Icons.coffee},
    {'value': 'bakery', 'label': 'Bakery', 'icon': Icons.bakery_dining},
    {'value': 'fast_food', 'label': 'Fast Food', 'icon': Icons.lunch_dining},
    {'value': 'food_truck', 'label': 'Food Truck', 'icon': Icons.local_shipping},
    {'value': 'other', 'label': 'Other', 'icon': Icons.store},
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Your Business'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Let's set up your business",
                  style: AppTextStyles.h3,
                ),
                const SizedBox(height: 8),
                Text(
                  'This will be your business name on FoodOS',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 32),

                // Business Name
                TextFormField(
                  controller: _nameController,
                  textInputAction: TextInputAction.next,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Business name is required';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Business Name',
                    hintText: 'e.g., Karachi Biryani House',
                    prefixIcon: Icon(Icons.store_outlined),
                  ),
                ),
                const SizedBox(height: 24),

                // Business Type
                Text(
                  'Business Type',
                  style: AppTextStyles.h4,
                ),
                const SizedBox(height: 12),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1,
                  ),
                  itemCount: _businessTypes.length,
                  itemBuilder: (context, index) {
                    final type = _businessTypes[index];
                    final isSelected = _selectedType == type['value'];
                    return GestureDetector(
                      onTap: () {
                        setState(() => _selectedType = type['value']);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary.withOpacity(0.1)
                              : AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.border,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              type['icon'],
                              size: 32,
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.textSecondary,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              type['label'],
                              style: AppTextStyles.bodySmall.copyWith(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.textSecondary,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 32),

                // Continue Button
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.push('/onboarding/branch-setup');
                      }
                    },
                    child: const Text('Continue'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
