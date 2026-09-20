import 'package:flutter/material.dart';
import 'package:foodos/core/theme/app_colors.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _showCurrent = false;
  bool _showNew = false;
  bool _showConfirm = false;

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Change Password')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.info.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.info.withValues(alpha: 0.2), width: 1),
              ),
              child: Row(
                children: [
                  Icon(Icons.shield_outlined, color: AppColors.info, size: 24),
                  SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      'Use at least 8 characters with a mix of letters, numbers, and symbols.',
                      style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildPasswordField(_currentController, 'Current Password', _showCurrent, () => setState(() => _showCurrent = !_showCurrent)),
            const SizedBox(height: 16),
            _buildPasswordField(_newController, 'New Password', _showNew, () => setState(() => _showNew = !_showNew)),
            const SizedBox(height: 16),
            _buildPasswordField(_confirmController, 'Confirm New Password', _showConfirm, () => setState(() => _showConfirm = !_showConfirm)),
            const SizedBox(height: 32),
            GestureDetector(
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  Navigator.pop(context);
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [AppColors.gradientButtonStart, AppColors.gradientButtonEnd]),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4))],
                ),
                child: const Center(
                  child: Text('Update Password', style: TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String label, bool show, VoidCallback toggle) {
    return Container(
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderLight, width: 1)),
      child: TextFormField(
        controller: controller,
        obscureText: !show,
        style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.textPrimary),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.textSecondary),
          prefixIcon: Icon(Icons.lock_outline_rounded, color: AppColors.textSecondary, size: 18),
          suffixIcon: IconButton(
            icon: Icon(show ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: AppColors.textHint, size: 18),
            onPressed: toggle,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
      ),
    );
  }
}
