import 'package:flutter/material.dart';
import 'package:foodos/core/theme/app_colors.dart';
import 'package:foodos/core/theme/app_text_styles.dart';

class AddEditMenuItemScreen extends StatefulWidget {
  final String? itemId;

  const AddEditMenuItemScreen({super.key, this.itemId});

  @override
  State<AddEditMenuItemScreen> createState() => _AddEditMenuItemScreenState();
}

class _AddEditMenuItemScreenState extends State<AddEditMenuItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  String _selectedCategory = 'Main Course';
  bool _isFeatured = false;

  bool get _isEditing => widget.itemId != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      // TODO: Load existing item data
      _nameController.text = 'Chicken Biryani';
      _descriptionController.text = 'Delicious chicken biryani with aromatic spices';
      _priceController.text = '300';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Menu Item' : 'Add Menu Item'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image Upload
              GestureDetector(
                onTap: () {
                  // TODO: Pick image
                },
                child: Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.border,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt_outlined, size: 48, color: AppColors.textHint),
                      const SizedBox(height: 8),
                      Text('Add Photo', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Name
              TextFormField(
                controller: _nameController,
                validator: (v) => v == null || v.trim().isEmpty ? 'Name is required' : null,
                decoration: const InputDecoration(
                  labelText: 'Item Name',
                  hintText: 'e.g., Chicken Biryani',
                ),
              ),
              const SizedBox(height: 16),

              // Description
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Brief description of the item',
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 16),

              // Category
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: ['Main Course', 'Appetizers', 'Beverages', 'Desserts']
                    .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                    .toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _selectedCategory = value);
                },
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              const SizedBox(height: 16),

              // Price
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.trim().isEmpty ? 'Price is required' : null,
                decoration: const InputDecoration(
                  labelText: 'Price (Rs)',
                  hintText: '0',
                ),
              ),
              const SizedBox(height: 16),

              // Featured Toggle
              SwitchListTile(
                title: const Text('Featured Item'),
                subtitle: const Text('Show this item prominently on the menu'),
                value: _isFeatured,
                onChanged: (value) => setState(() => _isFeatured = value),
                activeColor: AppColors.primary,
              ),
              const SizedBox(height: 32),

              // Save Button
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // TODO: Save item
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(_isEditing ? 'Item updated!' : 'Item added!'),
                          backgroundColor: AppColors.success,
                        ),
                      );
                    }
                  },
                  child: Text(_isEditing ? 'Update Item' : 'Add Item'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
