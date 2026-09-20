import 'package:flutter/material.dart';
import 'package:foodos/core/theme/app_colors.dart';

class AddRiderScreen extends StatefulWidget {
  const AddRiderScreen({super.key});

  @override
  State<AddRiderScreen> createState() => _AddRiderScreenState();
}

class _AddRiderScreenState extends State<AddRiderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cnicController = TextEditingController();
  final _vehicleController = TextEditingController();
  final _plateController = TextEditingController();
  String _selectedArea = 'All Areas';

  final _areas = ['All Areas', 'DHA', 'Gulberg', 'Cavalry Ground', 'Model Town', 'Johar Town'];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _cnicController.dispose();
    _vehicleController.dispose();
    _plateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Add Rider')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Avatar
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
                    child: const Center(child: Icon(Icons.two_wheeler, color: Colors.white, size: 36)),
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
            ),
            const SizedBox(height: 24),
            _buildField(_nameController, 'Full Name', Icons.person_outline_rounded),
            const SizedBox(height: 16),
            _buildField(_phoneController, 'Phone Number', Icons.phone_outlined, keyboardType: TextInputType.phone),
            const SizedBox(height: 16),
            _buildField(_cnicController, 'CNIC Number', Icons.badge_outlined, keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            _buildField(_vehicleController, 'Vehicle Type', Icons.two_wheeler),
            const SizedBox(height: 16),
            _buildField(_plateController, 'License Plate', Icons.pin_outlined),
            const SizedBox(height: 16),
            _buildAreaDropdown(),
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
                  child: Text('Add Rider', style: TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
                ),
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
        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
      ),
    );
  }

  Widget _buildAreaDropdown() {
    return Container(
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderLight, width: 1)),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButtonFormField<String>(
        value: _selectedArea,
        decoration: InputDecoration(labelText: 'Delivery Area', labelStyle: TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.textSecondary), border: InputBorder.none),
        items: _areas.map((a) => DropdownMenuItem(value: a, child: Text(a, style: const TextStyle(fontFamily: 'Inter', fontSize: 14)))).toList(),
        onChanged: (v) => setState(() => _selectedArea = v!),
      ),
    );
  }
}
