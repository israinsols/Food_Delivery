import 'package:flutter/material.dart';
import 'package:foodos/core/theme/app_colors.dart';

class AddSupplierScreen extends StatefulWidget {
  const AddSupplierScreen({super.key});

  @override
  State<AddSupplierScreen> createState() => _AddSupplierScreenState();
}

class _AddSupplierScreenState extends State<AddSupplierScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _companyController = TextEditingController();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();
  String _selectedCategory = 'General';

  final _categories = ['General', 'Fresh Produce', 'Meat & Seafood', 'Dairy', 'Beverages', 'Packaging'];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _companyController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Add Supplier')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildAvatar(),
            const SizedBox(height: 24),
            _buildTextField(_nameController, 'Supplier Name', Icons.business_outlined),
            const SizedBox(height: 16),
            _buildTextField(_phoneController, 'Phone Number', Icons.phone_outlined, keyboardType: TextInputType.phone),
            const SizedBox(height: 16),
            _buildTextField(_emailController, 'Email (Optional)', Icons.email_outlined, keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 16),
            _buildTextField(_companyController, 'Company Name', Icons.domain_outlined),
            const SizedBox(height: 16),
            _buildCategoryDropdown(),
            const SizedBox(height: 16),
            _buildTextField(_addressController, 'Address', Icons.location_on_outlined, maxLines: 2),
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
              color: AppColors.info.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.borderLight, width: 1),
            ),
            child: Icon(Icons.business_outlined, color: AppColors.info, size: 36),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [AppColors.gradientButtonStart, AppColors.gradientButtonEnd]),
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.surface, width: 2),
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {TextInputType? keyboardType, int maxLines = 1}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight, width: 1),
      ),
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

  Widget _buildCategoryDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight, width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButtonFormField<String>(
        value: _selectedCategory,
        decoration: InputDecoration(
          labelText: 'Category',
          labelStyle: TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.textSecondary),
          prefixIcon: Icon(Icons.category_outlined, color: AppColors.textSecondary, size: 18),
          border: InputBorder.none,
        ),
        items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontFamily: 'Inter', fontSize: 14)))).toList(),
        onChanged: (v) => setState(() => _selectedCategory = v!),
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
        child: const Center(
          child: Text('Save Supplier', style: TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
        ),
      ),
    );
  }
}
