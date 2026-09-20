import 'package:flutter/material.dart';
import 'package:foodos/core/theme/app_colors.dart';

class BusinessInfoScreen extends StatefulWidget {
  const BusinessInfoScreen({super.key});

  @override
  State<BusinessInfoScreen> createState() => _BusinessInfoScreenState();
}

class _BusinessInfoScreenState extends State<BusinessInfoScreen> {
  final _nameController = TextEditingController(text: 'FoodOS Restaurant');
  final _phoneController = TextEditingController(text: '+92 300 1234567');
  final _emailController = TextEditingController(text: 'info@foodos.com');
  final _addressController = TextEditingController(text: 'Main Boulevard, Gulberg III, Lahore');
  String _selectedType = 'Restaurant';

  final _types = ['Restaurant', 'Cafe', 'Cloud Kitchen', 'Food Truck', 'Bakery', 'Catering'];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Business Info')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Stack(
              children: [
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.borderLight, width: 1),
                  ),
                  child: Icon(Icons.storefront_outlined, color: AppColors.primary, size: 40),
                ),
                Positioned(
                  bottom: -2,
                  right: -2,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [AppColors.gradientButtonStart, AppColors.gradientButtonEnd]),
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.surface, width: 2),
                    ),
                    child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 14),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildField(_nameController, 'Business Name', Icons.store_outlined),
          const SizedBox(height: 16),
          _buildTypeDropdown(),
          const SizedBox(height: 16),
          _buildField(_phoneController, 'Phone', Icons.phone_outlined, keyboardType: TextInputType.phone),
          const SizedBox(height: 16),
          _buildField(_emailController, 'Email', Icons.email_outlined, keyboardType: TextInputType.emailAddress),
          const SizedBox(height: 16),
          _buildField(_addressController, 'Address', Icons.location_on_outlined, maxLines: 2),
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
              child: const Center(
                child: Text('Save Changes', style: TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String label, IconData icon, {TextInputType? keyboardType, int maxLines = 1}) {
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
      ),
    );
  }

  Widget _buildTypeDropdown() {
    return Container(
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderLight, width: 1)),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButtonFormField<String>(
        value: _selectedType,
        decoration: InputDecoration(labelText: 'Business Type', labelStyle: TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.textSecondary), border: InputBorder.none),
        items: _types.map((t) => DropdownMenuItem(value: t, child: Text(t, style: const TextStyle(fontFamily: 'Inter', fontSize: 14)))).toList(),
        onChanged: (v) => setState(() => _selectedType = v!),
      ),
    );
  }
}
