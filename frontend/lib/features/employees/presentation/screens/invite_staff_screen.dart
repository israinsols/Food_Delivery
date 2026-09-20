import 'package:flutter/material.dart';
import 'package:foodos/core/theme/app_colors.dart';
import 'package:foodos/core/theme/app_text_styles.dart';

class InviteStaffScreen extends StatefulWidget {
  const InviteStaffScreen({super.key});

  @override
  State<InviteStaffScreen> createState() => _InviteStaffScreenState();
}

class _InviteStaffScreenState extends State<InviteStaffScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  String _selectedRole = 'cashier';
  String _selectedBranch = 'Gulshan';

  final List<Map<String, String>> _roles = [
    {'value': 'manager', 'label': 'Manager'},
    {'value': 'cashier', 'label': 'Cashier'},
    {'value': 'kitchen', 'label': 'Kitchen Staff'},
    {'value': 'waiter', 'label': 'Waiter'},
    {'value': 'inventory_manager', 'label': 'Inventory Manager'},
  ];

  final List<String> _branches = ['Gulshan', 'DHA'];

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Invite Staff')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.info.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: AppColors.info),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Invite link email pe bheja jayega. Wo link se signup karke aapke business mein jud jayega.',
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.info),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (v) => v == null || v.trim().isEmpty ? 'Email required' : null,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  prefixIcon: Icon(Icons.email_outlined),
                  hintText: 'staff@example.com',
                ),
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedRole,
                items: _roles.map((r) => DropdownMenuItem(value: r['value'], child: Text(r['label']!))).toList(),
                onChanged: (v) => setState(() => _selectedRole = v!),
                decoration: const InputDecoration(labelText: 'Role', prefixIcon: Icon(Icons.work_outline)),
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedBranch,
                items: _branches.map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
                onChanged: (v) => setState(() => _selectedBranch = v!),
                decoration: const InputDecoration(labelText: 'Branch', prefixIcon: Icon(Icons.location_on_outlined)),
              ),
              const SizedBox(height: 32),

              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Invite sent to ${_emailController.text}'),
                          backgroundColor: AppColors.success,
                        ),
                      );
                    }
                  },
                  child: const Text('Send Invite'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
