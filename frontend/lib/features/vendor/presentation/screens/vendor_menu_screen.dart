import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodos/core/theme/app_colors.dart';
import 'package:foodos/core/models/restaurant_model.dart';
import 'package:foodos/core/providers/restaurant_provider.dart';
import 'package:go_router/go_router.dart';

class VendorMenuScreen extends ConsumerStatefulWidget {
  final String? restaurantId;

  const VendorMenuScreen({super.key, this.restaurantId});

  @override
  ConsumerState<VendorMenuScreen> createState() => _VendorMenuScreenState();
}

class _VendorMenuScreenState extends ConsumerState<VendorMenuScreen> {
  String _selectedCategory = 'All';
  String? _restaurantId;

  final _categories = ['All', 'Biryani', 'Fast Food', 'Pizza', 'BBQ & Grilled', 'Chinese', 'Continental', 'Desserts', 'Drinks', 'Pakistani'];

  @override
  void initState() {
    super.initState();
    _restaurantId = widget.restaurantId;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final extra = GoRouterState.of(context).extra;
    if (extra is String && _restaurantId == null) {
      _restaurantId = extra;
    }
  }

  Restaurant? get _restaurant {
    if (_restaurantId == null) return null;
    return ref.read(restaurantByIdProvider(_restaurantId!));
  }

  List<MenuItem> get _menuItems {
    if (_restaurant == null) return [];
    if (_selectedCategory == 'All') return _restaurant!.menuItems;
    return _restaurant!.menuItems.where((i) => i.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    final restaurant = _restaurant;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(restaurant?.name ?? 'Menu Management'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.go('/customer/home'),
        ),
      ),
      body: restaurant == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.restaurant_menu, color: AppColors.textHint, size: 64),
                  const SizedBox(height: 16),
                  Text('No restaurant found', style: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                  const SizedBox(height: 8),
                  Text('Register your restaurant first', style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.textHint)),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: () => context.go('/vendor/register'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [AppColors.gradientButtonStart, AppColors.gradientButtonEnd]),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text('Register Restaurant', style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                // Restaurant info banner
                if (restaurant.menuItems.isEmpty)
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary.withValues(alpha: 0.1), AppColors.primary.withValues(alpha: 0.03)],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.2), width: 1),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.add_circle_outline, color: AppColors.primary, size: 28),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Start Building Your Menu', style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                              const SizedBox(height: 2),
                              Text('Add items so customers can discover your food', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textHint)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                // Category filter
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final cat = _categories[index];
                      final isSelected = _selectedCategory == cat;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedCategory = cat),
                        child: Container(
                          margin: const EdgeInsets.only(right: 10, top: 8, bottom: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primary : AppColors.surface,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: isSelected ? AppColors.primary : AppColors.borderLight, width: 1),
                          ),
                          child: Center(
                            child: Text(cat, style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600, color: isSelected ? Colors.white : AppColors.textSecondary)),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Menu items
                Expanded(
                  child: _menuItems.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.restaurant_menu, color: AppColors.textHint, size: 48),
                              const SizedBox(height: 12),
                              Text('No items in this category', style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.textHint)),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _menuItems.length,
                          itemBuilder: (context, index) {
                            final item = _menuItems[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: AppColors.borderLight, width: 1),
                              ),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(item.image, width: 64, height: 64, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(width: 64, height: 64, color: AppColors.surfaceVariant, child: Icon(Icons.fastfood, color: AppColors.textHint))),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(item.name, style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: item.isAvailable ? AppColors.success.withValues(alpha: 0.12) : AppColors.error.withValues(alpha: 0.12),
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                item.isAvailable ? 'Active' : 'Inactive',
                                                style: TextStyle(fontFamily: 'Inter', fontSize: 9, fontWeight: FontWeight.w600, color: item.isAvailable ? AppColors.success : AppColors.error),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(item.category, style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textHint)),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Text('Rs ${item.price}', style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary)),
                                            const SizedBox(width: 12),
                                            Text('${item.orders} orders', style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textHint)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  PopupMenuButton<String>(
                                    icon: Icon(Icons.more_vert, color: AppColors.textHint, size: 18),
                                    color: AppColors.surface,
                                    onSelected: (value) {
                                      if (value == 'edit') {
                                        _showEditItemSheet(item);
                                      } else if (value == 'toggle') {
                                        ref.read(restaurantsProvider.notifier).toggleItemAvailability(_restaurantId!, item.id);
                                      } else if (value == 'delete') {
                                        ref.read(restaurantsProvider.notifier).removeMenuItem(_restaurantId!, item.id);
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      const PopupMenuItem(value: 'edit', child: Text('Edit', style: TextStyle(fontFamily: 'Inter', fontSize: 13))),
                                      PopupMenuItem(value: 'toggle', child: Text(item.isAvailable ? 'Deactivate' : 'Activate', style: const TextStyle(fontFamily: 'Inter', fontSize: 13))),
                                      PopupMenuItem(value: 'delete', child: Text('Delete', style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.error))),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: restaurant != null
          ? FloatingActionButton(
              onPressed: () => _showAddItemSheet(),
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }

  void _showAddItemSheet() {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final descController = TextEditingController();
    String selectedCategory = 'Biryani';

    final availableCategories = _categories.where((c) => c != 'All').toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Container(
          height: MediaQuery.of(context).size.height * 0.75,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Add Menu Item', style: TextStyle(fontFamily: 'Inter', fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              const SizedBox(height: 20),

              // Item Name
              _buildSheetField('Item Name', nameController, 'e.g. Chicken Biryani'),
              const SizedBox(height: 16),

              // Price
              _buildSheetField('Price (Rs)', priceController, 'e.g. 300', keyboardType: TextInputType.number),
              const SizedBox(height: 16),

              // Description
              _buildSheetField('Description', descController, 'Short description'),
              const SizedBox(height: 16),

              // Category
              Text('Category', style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: availableCategories.map((c) {
                  final isSelected = selectedCategory == c;
                  return GestureDetector(
                    onTap: () => setSheetState(() => selectedCategory = c),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : AppColors.background,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: isSelected ? AppColors.primary : AppColors.borderLight, width: 1),
                      ),
                      child: Text(c, style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600, color: isSelected ? AppColors.primary : AppColors.textSecondary)),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              const Spacer(),

              // Add button
              GestureDetector(
                onTap: () {
                  if (nameController.text.trim().isEmpty || priceController.text.trim().isEmpty) return;
                  final price = int.tryParse(priceController.text.trim()) ?? 0;
                  if (price <= 0) return;

                  final itemId = 'mi${DateTime.now().millisecondsSinceEpoch}';
                  final item = MenuItem(
                    id: itemId,
                    name: nameController.text.trim(),
                    description: descController.text.trim(),
                    price: price,
                    category: selectedCategory,
                    restaurantId: _restaurantId,
                    restaurantName: _restaurant?.name,
                  );

                  ref.read(restaurantsProvider.notifier).addMenuItem(_restaurantId!, item);
                  Navigator.pop(ctx);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${item.name} added to menu!'),
                      backgroundColor: AppColors.success,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [AppColors.gradientButtonStart, AppColors.gradientButtonEnd]),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Center(child: Text('Add Item', style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditItemSheet(MenuItem item) {
    final nameController = TextEditingController(text: item.name);
    final priceController = TextEditingController(text: item.price.toString());
    final descController = TextEditingController(text: item.description);
    String selectedCategory = item.category;

    final availableCategories = _categories.where((c) => c != 'All').toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Container(
          height: MediaQuery.of(context).size.height * 0.75,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Edit Menu Item', style: TextStyle(fontFamily: 'Inter', fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              const SizedBox(height: 20),

              _buildSheetField('Item Name', nameController, ''),
              const SizedBox(height: 16),
              _buildSheetField('Price (Rs)', priceController, '', keyboardType: TextInputType.number),
              const SizedBox(height: 16),
              _buildSheetField('Description', descController, ''),
              const SizedBox(height: 16),

              Text('Category', style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: availableCategories.map((c) {
                  final isSelected = selectedCategory == c;
                  return GestureDetector(
                    onTap: () => setSheetState(() => selectedCategory = c),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : AppColors.background,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: isSelected ? AppColors.primary : AppColors.borderLight, width: 1),
                      ),
                      child: Text(c, style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600, color: isSelected ? AppColors.primary : AppColors.textSecondary)),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              const Spacer(),

              GestureDetector(
                onTap: () {
                  if (nameController.text.trim().isEmpty || priceController.text.trim().isEmpty) return;
                  final price = int.tryParse(priceController.text.trim()) ?? 0;
                  if (price <= 0) return;

                  final updated = item.copyWith(
                    name: nameController.text.trim(),
                    description: descController.text.trim(),
                    price: price,
                    category: selectedCategory,
                  );

                  ref.read(restaurantsProvider.notifier).updateMenuItem(_restaurantId!, item.id, updated);
                  Navigator.pop(ctx);
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [AppColors.gradientButtonStart, AppColors.gradientButtonEnd]),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Center(child: Text('Save Changes', style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSheetField(String label, TextEditingController controller, String hint, {TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(12)),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.textHint),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
      ],
    );
  }
}
