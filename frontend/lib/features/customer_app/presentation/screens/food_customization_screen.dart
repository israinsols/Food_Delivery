import 'package:flutter/material.dart';
import 'package:foodos/core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';

class FoodCustomizationScreen extends StatefulWidget {
  final String name;
  final String image;
  final String basePrice;

  const FoodCustomizationScreen({
    super.key,
    required this.name,
    required this.image,
    required this.basePrice,
  });

  @override
  State<FoodCustomizationScreen> createState() => _FoodCustomizationScreenState();
}

class _FoodCustomizationScreenState extends State<FoodCustomizationScreen> {
  String _selectedSize = 'Regular';
  String _selectedSpice = 'Medium';
  int _quantity = 1;
  final _notesController = TextEditingController();

  final _sizes = [
    {'name': 'Regular', 'price': 0},
    {'name': 'Large', 'price': 200},
    {'name': 'Family', 'price': 500},
  ];

  final _spiceLevels = ['Mild', 'Medium', 'Spicy', 'Extra Spicy'];

  final _addOns = [
    {'name': 'Extra Cheese', 'price': 80, 'selected': false},
    {'name': 'Extra Chicken', 'price': 120, 'selected': false},
    {'name': 'Raita', 'price': 30, 'selected': false},
    {'name': 'Salan', 'price': 40, 'selected': false},
    {'name': 'Pickle', 'price': 20, 'selected': false},
    {'name': 'Green Salad', 'price': 50, 'selected': false},
  ];

  int get _basePrice {
    final base = int.tryParse(widget.basePrice.replaceAll(RegExp(r'[^0-9]'), '')) ?? 300;
    final sizePrice = _sizes.firstWhere((s) => s['name'] == _selectedSize)['price'] as int;
    return base + sizePrice;
  }

  int get _addOnsTotal {
    return _addOns.where((a) => a['selected'] == true).fold(0, (sum, a) => sum + (a['price'] as int));
  }

  int get _total => (_basePrice + _addOnsTotal) * _quantity;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Customize Order'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Item info
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.borderLight, width: 1),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(widget.image, width: 64, height: 64, fit: BoxFit.cover),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.name, style: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                              const SizedBox(height: 4),
                              Text('Rs $_basePrice', style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.primary)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Portion Size
                  Text('Portion Size', style: TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                  const SizedBox(height: 10),
                  Row(
                    children: _sizes.map((size) {
                      final isSelected = _selectedSize == size['name'];
                      final price = size['price'] as int;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedSize = size['name'] as String),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : AppColors.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: isSelected ? AppColors.primary : AppColors.borderLight, width: isSelected ? 2 : 1),
                            ),
                            child: Column(
                              children: [
                                Text(size['name'] as String, style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600, color: isSelected ? AppColors.primary : AppColors.textPrimary)),
                                const SizedBox(height: 2),
                                Text(price > 0 ? '+Rs $price' : 'Base', style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: isSelected ? AppColors.primary : AppColors.textHint)),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Spice Level
                  Text('Spice Level', style: TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _spiceLevels.map((level) {
                      final isSelected = _selectedSpice == level;
                      final spiceIcons = {'Mild': 'ðŸŒ¶ï¸', 'Medium': 'ðŸŒ¶ï¸ðŸŒ¶ï¸', 'Spicy': 'ðŸŒ¶ï¸ðŸŒ¶ï¸ðŸŒ¶ï¸', 'Extra Spicy': 'ðŸŒ¶ï¸ðŸŒ¶ï¸ðŸŒ¶ï¸ðŸŒ¶ï¸'};
                      return GestureDetector(
                        onTap: () => setState(() => _selectedSpice = level),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: isSelected ? AppColors.primary : AppColors.borderLight, width: isSelected ? 2 : 1),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(spiceIcons[level] ?? '', style: const TextStyle(fontSize: 14)),
                              const SizedBox(width: 6),
                              Text(level, style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600, color: isSelected ? AppColors.primary : AppColors.textPrimary)),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Add-ons
                  Text('Add-ons', style: TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                  const SizedBox(height: 10),
                  ...List.generate(_addOns.length, (i) {
                    final addon = _addOns[i];
                    final isSelected = addon['selected'] == true;
                    return GestureDetector(
                      onTap: () => setState(() => _addOns[i]['selected'] = !isSelected),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary.withValues(alpha: 0.06) : AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: isSelected ? AppColors.primary : AppColors.borderLight, width: 1),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.primary : Colors.transparent,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: isSelected ? AppColors.primary : AppColors.borderLight, width: 2),
                              ),
                              child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 14) : null,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(addon['name'] as String, style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.textPrimary)),
                            ),
                            Text('+Rs ${addon['price']}', style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600, color: isSelected ? AppColors.primary : AppColors.textSecondary)),
                          ],
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 24),

                  // Special Instructions
                  Text('Special Instructions', style: TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.borderLight, width: 1),
                    ),
                    child: TextField(
                      controller: _notesController,
                      maxLines: 3,
                      style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'e.g. No onions, extra spicy, well cooked...',
                        hintStyle: TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.textHint),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),

          // Bottom bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 20, offset: const Offset(0, -5))],
            ),
            child: Row(
              children: [
                // Quantity
                Container(
                  decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (_quantity > 1) setState(() => _quantity--);
                        },
                        child: Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10))), child: Icon(Icons.remove, size: 18, color: AppColors.primary)),
                      ),
                      Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Text('$_quantity', style: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary))),
                      GestureDetector(
                        onTap: () => setState(() => _quantity++),
                        child: Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.primary, borderRadius: const BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10))), child: Icon(Icons.add, size: 18, color: Colors.white)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),

                // Add to cart
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      context.pop({
                        'name': widget.name,
                        'image': widget.image,
                        'size': _selectedSize,
                        'spice': _selectedSpice,
                        'addOns': _addOns.where((a) => a['selected'] == true).map((a) => a['name']).toList(),
                        'notes': _notesController.text,
                        'quantity': _quantity,
                        'total': _total,
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [AppColors.gradientButtonStart, AppColors.gradientButtonEnd]),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4))],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 20),
                          const SizedBox(width: 10),
                          Text('Add to Cart  â€¢  Rs $_total', style: const TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
