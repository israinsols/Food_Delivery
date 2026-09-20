import 'package:flutter/material.dart';
import 'package:foodos/core/theme/app_colors.dart';

class CreatePurchaseOrderScreen extends StatefulWidget {
  const CreatePurchaseOrderScreen({super.key});

  @override
  State<CreatePurchaseOrderScreen> createState() => _CreatePurchaseOrderScreenState();
}

class _CreatePurchaseOrderScreenState extends State<CreatePurchaseOrderScreen> {
  String? _selectedSupplier;
  String _selectedPriority = 'Normal';
  final _items = <_POItem>[];
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _items.add(_POItem(name: '', quantity: 1, unitPrice: 0));
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  double get _total => _items.fold(0, (sum, item) => sum + (item.quantity * item.unitPrice));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Create Purchase Order')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection('Supplier', [
            _buildDropdown(
              value: _selectedSupplier,
              hint: 'Select Supplier',
              items: ['Khan Fresh Chicken', 'Basmati Rice Traders', 'Spice World', 'Fresh Farm Suppliers'],
              onChanged: (v) => setState(() => _selectedSupplier = v),
            ),
          ]),
          const SizedBox(height: 16),
          _buildSection('Priority', [
            Row(
              children: ['Urgent', 'Normal', 'Low'].map((p) {
                final isSelected = _selectedPriority == p;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedPriority = p),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        gradient: isSelected ? LinearGradient(colors: [AppColors.gradientButtonStart, AppColors.gradientButtonEnd]) : null,
                        color: isSelected ? null : AppColors.surface,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: isSelected ? AppColors.primary : AppColors.borderLight, width: 1),
                      ),
                      child: Center(
                        child: Text(p, style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600, color: isSelected ? Colors.white : AppColors.textSecondary)),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ]),
          const SizedBox(height: 20),
          _buildSection('Items', [
            ...List.generate(_items.length, (i) => _buildItemRow(i)),
            GestureDetector(
              onTap: () => setState(() => _items.add(_POItem(name: '', quantity: 1, unitPrice: 0))),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.2), width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: AppColors.primary, size: 18),
                    SizedBox(width: 6),
                    Text('Add Item', style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary)),
                  ],
                ),
              ),
            ),
          ]),
          const SizedBox(height: 16),
          _buildSection('Notes', [
            Container(
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderLight, width: 1)),
              child: TextField(
                controller: _notesController,
                maxLines: 3,
                style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Any special instructions...',
                  hintStyle: TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.textHint),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(14),
                ),
              ),
            ),
          ]),
          const SizedBox(height: 20),
          _buildTotalCard(),
          const SizedBox(height: 16),
          _buildSubmitButton(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title.toUpperCase(), style: TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textHint, letterSpacing: 1.2)),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }

  Widget _buildDropdown({String? value, String? hint, required List<String> items, required ValueChanged<String?> onChanged}) {
    return Container(
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderLight, width: 1)),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: DropdownButtonFormField<String>(
        value: value,
        hint: Text(hint ?? '', style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.textHint)),
        decoration: const InputDecoration(border: InputBorder.none),
        items: items.map((i) => DropdownMenuItem(value: i, child: Text(i, style: const TextStyle(fontFamily: 'Inter', fontSize: 14)))).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildItemRow(int index) {
    final item = _items[index];
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderLight, width: 1)),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: _buildMiniDropdown(
                  value: item.name.isEmpty ? null : item.name,
                  hint: 'Item',
                  items: ['Chicken Breast', 'Basmati Rice', 'Cooking Oil', 'Tomatoes', 'Onions', 'Spices Mix', 'Fresh Milk', 'Bread', 'Eggs'],
                  onChanged: (v) => setState(() => _items[index].name = v ?? ''),
                ),
              ),
              const SizedBox(width: 8),
              if (_items.length > 1)
                GestureDetector(
                  onTap: () => setState(() => _items.removeAt(index)),
                  child: Icon(Icons.close, color: AppColors.error, size: 18),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildNumberField(
                  value: item.quantity.toString(),
                  label: 'Qty',
                  onChanged: (v) => setState(() => _items[index].quantity = int.tryParse(v) ?? 1),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildNumberField(
                  value: item.unitPrice.toStringAsFixed(0),
                  label: 'Unit Price',
                  onChanged: (v) => setState(() => _items[index].unitPrice = double.tryParse(v) ?? 0),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                child: Text(
                  'Rs ${(item.quantity * item.unitPrice).toStringAsFixed(0)}',
                  style: TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniDropdown({String? value, String? hint, required List<String> items, required ValueChanged<String?> onChanged}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.borderLight, width: 1)),
      child: DropdownButtonFormField<String>(
        value: value,
        isDense: true,
        hint: Text(hint ?? '', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textHint)),
        decoration: const InputDecoration(border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.symmetric(vertical: 8)),
        items: items.map((i) => DropdownMenuItem(value: i, child: Text(i, style: const TextStyle(fontFamily: 'Inter', fontSize: 12)))).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildNumberField({required String value, required String label, required ValueChanged<String> onChanged}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.borderLight, width: 1)),
      child: TextField(
        controller: TextEditingController(text: value),
        keyboardType: TextInputType.number,
        style: const TextStyle(fontFamily: 'Inter', fontSize: 12),
        decoration: InputDecoration(hintText: label, hintStyle: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textHint), border: InputBorder.none, isDense: true, contentPadding: const EdgeInsets.symmetric(vertical: 8)),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildTotalCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [AppColors.primary.withValues(alpha: 0.1), AppColors.primary.withValues(alpha: 0.05)]),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Total Amount', style: TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          Text(
            'Rs ${_total.toStringAsFixed(0)}',
            style: TextStyle(fontFamily: 'Inter', fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [AppColors.gradientButtonStart, AppColors.gradientButtonEnd]),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: const Center(
          child: Text('Create Purchase Order', style: TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
        ),
      ),
    );
  }
}

class _POItem {
  String name;
  int quantity;
  double unitPrice;
  _POItem({required this.name, required this.quantity, required this.unitPrice});
}
