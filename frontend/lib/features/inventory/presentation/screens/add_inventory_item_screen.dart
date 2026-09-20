import 'package:flutter/material.dart';
import 'package:foodos/core/theme/app_colors.dart';

class AddInventoryItemScreen extends StatefulWidget {
  const AddInventoryItemScreen({super.key});

  @override
  State<AddInventoryItemScreen> createState() => _AddInventoryItemScreenState();
}

class _AddInventoryItemScreenState extends State<AddInventoryItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _skuController = TextEditingController();
  final _stockController = TextEditingController(text: '0');
  final _minStockController = TextEditingController(text: '10');
  final _unitController = TextEditingController(text: 'pcs');
  final _costController = TextEditingController();
  String _selectedCategory = 'General';
  String _selectedStatus = 'In Stock';

  final _categories = ['General', 'Fresh Produce', 'Meat & Seafood', 'Dairy', 'Beverages', 'Packaging', 'Frozen'];
  final _statuses = ['In Stock', 'Low Stock', 'Out of Stock'];

  @override
  void dispose() {
    _nameController.dispose();
    _skuController.dispose();
    _stockController.dispose();
    _minStockController.dispose();
    _unitController.dispose();
    _costController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Add Inventory Item')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildTextField(_nameController, 'Item Name', Icons.inventory_2_outlined),
            const SizedBox(height: 16),
            _buildTextField(_skuController, 'SKU / Code', Icons.qr_code_outlined),
            const SizedBox(height: 16),
            _buildCategoryDropdown(),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildTextField(_stockController, 'Current Stock', Icons.numbers, keyboardType: TextInputType.number)),
                const SizedBox(width: 12),
                Expanded(child: _buildTextField(_minStockController, 'Min Stock', Icons.warning_amber_outlined, keyboardType: TextInputType.number)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildTextField(_unitController, 'Unit', Icons.straighten)),
                const SizedBox(width: 12),
                Expanded(child: _buildTextField(_costController, 'Cost Price (Rs)', Icons.payments_outlined, keyboardType: TextInputType.number)),
              ],
            ),
            const SizedBox(height: 16),
            _buildStatusDropdown(),
            const SizedBox(height: 32),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {TextInputType? keyboardType}) {
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

  Widget _buildCategoryDropdown() {
    return Container(
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderLight, width: 1)),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButtonFormField<String>(
        value: _selectedCategory,
        decoration: InputDecoration(labelText: 'Category', labelStyle: TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.textSecondary), border: InputBorder.none),
        items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontFamily: 'Inter', fontSize: 14)))).toList(),
        onChanged: (v) => setState(() => _selectedCategory = v!),
      ),
    );
  }

  Widget _buildStatusDropdown() {
    return Container(
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderLight, width: 1)),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButtonFormField<String>(
        value: _selectedStatus,
        decoration: InputDecoration(labelText: 'Status', labelStyle: TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.textSecondary), border: InputBorder.none),
        items: _statuses.map((s) => DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(fontFamily: 'Inter', fontSize: 14)))).toList(),
        onChanged: (v) => setState(() => _selectedStatus = v!),
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
          child: Text('Save Item', style: TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
        ),
      ),
    );
  }
}
