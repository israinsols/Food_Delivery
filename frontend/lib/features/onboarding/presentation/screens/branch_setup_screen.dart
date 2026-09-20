import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:foodos/core/theme/app_colors.dart';
import 'package:foodos/core/theme/app_text_styles.dart';

class BranchSetupScreen extends StatefulWidget {
  const BranchSetupScreen({super.key});

  @override
  State<BranchSetupScreen> createState() => _BranchSetupScreenState();
}

class _BranchSetupScreenState extends State<BranchSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Branch'),
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
                  'Add your first branch',
                  style: AppTextStyles.h3,
                ),
                const SizedBox(height: 8),
                Text(
                  'You can always add more branches later',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 32),

                // Branch Name
                TextFormField(
                  controller: _nameController,
                  textInputAction: TextInputAction.next,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Branch name is required';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Branch Name',
                    hintText: 'e.g., Gulshan Branch',
                    prefixIcon: Icon(Icons.location_on_outlined),
                  ),
                ),
                const SizedBox(height: 16),

                // Address
                TextFormField(
                  controller: _addressController,
                  textInputAction: TextInputAction.done,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Address',
                    hintText: 'Full address',
                    prefixIcon: Icon(Icons.map_outlined),
                  ),
                ),
                const SizedBox(height: 32),

                // Continue Button
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.push('/onboarding/menu-setup');
                      }
                    },
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
      ),
    );
  }
}
