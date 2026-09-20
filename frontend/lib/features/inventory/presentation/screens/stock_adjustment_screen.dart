import 'package:flutter/material.dart';
import 'package:foodos/core/theme/app_colors.dart';
import 'package:foodos/core/theme/app_text_styles.dart';

class StockAdjustmentScreen extends StatefulWidget {
  const StockAdjustmentScreen({super.key});

  @override
  State<StockAdjustmentScreen> createState() => _StockAdjustmentScreenState();
}

class _StockAdjustmentScreenState extends State<StockAdjustmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  final _reasonController = TextEditingController();
  String _selectedItem = 'Chicken';
  String _adjustmentType = 'stock_in';

  final List<String> _items = ['Chicken', 'Rice', 'Oil', 'Onions', 'Tomatoes'];

  @override
  void dispose() {
    _quantityController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stock Adjustment')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Adjustment Type
              Text('Adjustment Type', style: AppTextStyles.h4),
              const SizedBox(height: 8),
              Row(
                children: [
                  _TypeChip(label: 'Stock In', icon: Icons.add_circle_outline, value: 'stock_in', groupValue: _selectedType, onChanged: (v) => setState(() => _adjustmentType = v)),
                  const SizedBox(width: 8),
                  _TypeChip(label: 'Stock Out', icon: Icons.remove_circle_outline, value: 'stock_out', groupValue: _selectedType, onChanged: (v) => setState(() => _adjustmentType = v)),
                  const SizedBox(width: 8),
                  _TypeChip(label: 'Wastage', icon: Icons.delete_outline, value: 'wastage', groupValue: _selectedType, onChanged: (v) => setState(() => _adjustmentType = v)),
                ],
              ),
              const SizedBox(height: 16),

              // Item
              DropdownButtonFormField<String>(
                value: _selectedItem,
                items: _items.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(),
                onChanged: (v) => setState(() => _selectedItem = v!),
                decoration: const InputDecoration(labelText: 'Inventory Item', prefixIcon: Icon(Icons.inventory_2_outlined)),
              ),
              const SizedBox(height: 16),

              // Quantity
              TextFormField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.trim().isEmpty ? 'Quantity required' : null,
                decoration: const InputDecoration(labelText: 'Quantity', prefixIcon: Icon(Icons.numbers)),
              ),
              const SizedBox(height: 16),

              // Reason
              TextFormField(
                controller: _reasonController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Reason / Notes',
                  prefixIcon: Icon(Icons.note_outlined),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 32),

              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Stock adjusted!'), backgroundColor: AppColors.success),
                      );
                    }
                  },
                  child: const Text('Submit Adjustment'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String get _selectedType => _adjustmentType;
}

class _TypeChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final String value;
  final String groupValue;
  final Function(String) onChanged;

  const _TypeChip({required this.label, required this.icon, required this.value, required this.groupValue, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final isSelected = groupValue == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isSelected ? AppColors.primary : AppColors.border),
          ),
          child: Column(
            children: [
              Icon(icon, color: isSelected ? Colors.white : AppColors.textSecondary, size: 20),
              const SizedBox(height: 4),
              Text(label, style: TextStyle(color: isSelected ? Colors.white : AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}
