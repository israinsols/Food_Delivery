import 'package:flutter/material.dart';
import 'package:foodos/core/theme/app_colors.dart';

class EditStaffScreen extends StatefulWidget {
  final String staffId;
  const EditStaffScreen({super.key, required this.staffId});

  @override
  State<EditStaffScreen> createState() => _EditStaffScreenState();
}

class _EditStaffScreenState extends State<EditStaffScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Sara Ahmed');
  final _emailController = TextEditingController(text: 'sara@foodos.com');
  final _phoneController = TextEditingController(text: '+92 301 5551234');
  String _selectedRole = 'Manager';
  String _selectedBranch = 'Main Branch';
  String _selectedStatus = 'Active';

  final _roles = ['Manager', 'Cashier', 'Chef', 'Waiter', 'Inventory Staff'];
  final _branches = ['Main Branch', 'DHA Branch', 'Gulberg Branch'];
  final _statuses = ['Active', 'Inactive'];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Edit Staff')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [AppColors.gradientButtonStart, AppColors.gradientButtonEnd]),
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 20, spreadRadius: 2)],
                    ),
                    child: const Center(
                      child: Text('S', style: TextStyle(fontFamily: 'Inter', fontSize: 32, fontWeight: FontWeight.w800, color: Colors.white)),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(color: AppColors.surface, shape: BoxShape.circle, border: Border.all(color: AppColors.borderLight, width: 2)),
                      child: Icon(Icons.camera_alt_rounded, color: AppColors.primary, size: 14),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildField(_nameController, 'Full Name', Icons.person_outline_rounded),
            const SizedBox(height: 16),
            _buildField(_emailController, 'Email', Icons.email_outlined, keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 16),
            _buildField(_phoneController, 'Phone', Icons.phone_outlined, keyboardType: TextInputType.phone),
            const SizedBox(height: 16),
            _buildDropdown('Role', _selectedRole, _roles, (v) => setState(() => _selectedRole = v!)),
            const SizedBox(height: 16),
            _buildDropdown('Branch', _selectedBranch, _branches, (v) => setState(() => _selectedBranch = v!)),
            const SizedBox(height: 16),
            _buildDropdown('Status', _selectedStatus, _statuses, (v) => setState(() => _selectedStatus = v!)),
            const SizedBox(height: 32),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [AppColors.gradientButtonStart, AppColors.gradientButtonEnd]),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4))],
                ),
                child: const Center(child: Text('Update Staff', style: TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white))),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String label, IconData icon, {TextInputType? keyboardType}) {
    return Container(
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderLight, width: 1)),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.textPrimary),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.textSecondary),
          prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 18),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Container(
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderLight, width: 1)),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(labelText: label, labelStyle: TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.textSecondary), border: InputBorder.none),
        items: items.map((i) => DropdownMenuItem(value: i, child: Text(i, style: const TextStyle(fontFamily: 'Inter', fontSize: 14)))).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
