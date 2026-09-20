import 'package:flutter/material.dart';
import 'package:foodos/core/theme/app_colors.dart';

class AddCustomerScreen extends StatefulWidget {
  final String? customerId;
  const AddCustomerScreen({super.key, this.customerId});

  @override
  State<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();
  String _selectedType = 'Regular';

  final _types = ['Regular', 'VIP', 'Wholesale'];

  bool get _isEditing => widget.customerId != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _nameController.text = 'Ahmed Khan';
      _phoneController.text = '+92 300 1234567';
      _emailController.text = 'ahmed@email.com';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(_isEditing ? 'Edit Customer' : 'Add Customer')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildAvatar(),
            const SizedBox(height: 24),
            _buildTextField(_nameController, 'Full Name', Icons.person_outline_rounded),
            const SizedBox(height: 16),
            _buildTextField(_phoneController, 'Phone Number', Icons.phone_outlined, keyboardType: TextInputType.phone),
            const SizedBox(height: 16),
            _buildTextField(_emailController, 'Email (Optional)', Icons.email_outlined, keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 16),
            _buildTypeDropdown(),
            const SizedBox(height: 16),
            _buildTextField(_addressController, 'Address (Optional)', Icons.location_on_outlined, maxLines: 2),
            const SizedBox(height: 16),
            _buildTextField(_notesController, 'Notes (Optional)', Icons.notes_outlined, maxLines: 3),
            const SizedBox(height: 32),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Center(
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
            child: Center(
              child: Text(
                _nameController.text.isEmpty ? 'A' : _nameController.text[0].toUpperCase(),
                style: const TextStyle(fontFamily: 'Inter', fontSize: 32, fontWeight: FontWeight.w800, color: Colors.white),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.borderLight, width: 2),
              ),
              child: Icon(Icons.camera_alt_rounded, color: AppColors.primary, size: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {TextInputType? keyboardType, int maxLines = 1}) {
    return Container(
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderLight, width: 1)),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.textPrimary),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.textSecondary),
          prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 18),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
      ),
    );
  }

  Widget _buildTypeDropdown() {
    return Container(
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderLight, width: 1)),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButtonFormField<String>(
        value: _selectedType,
        decoration: InputDecoration(labelText: 'Customer Type', labelStyle: TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.textSecondary), border: InputBorder.none),
        items: _types.map((t) => DropdownMenuItem(value: t, child: Text(t, style: const TextStyle(fontFamily: 'Inter', fontSize: 14)))).toList(),
        onChanged: (v) => setState(() => _selectedType = v!),
      ),
    );
  }

  Widget _buildSaveButton() {
    return GestureDetector(
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
        child: Center(
          child: Text(
            _isEditing ? 'Update Customer' : 'Save Customer',
            style: const TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
