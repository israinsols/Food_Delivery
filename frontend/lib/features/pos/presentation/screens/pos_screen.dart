import 'package:flutter/material.dart';
import 'package:foodos/core/theme/app_colors.dart';
import 'package:foodos/core/theme/app_text_styles.dart';
import 'package:go_router/go_router.dart';

class POSScreen extends StatefulWidget {
  const POSScreen({super.key});

  @override
  State<POSScreen> createState() => _POSSScreenState();
}

class _POSSScreenState extends State<POSScreen> {
  String _selectedCategory = 'All';
  final List<Map<String, dynamic>> _cart = [];

  final List<String> _categories = ['All', 'Appetizers', 'Main Course', 'Beverages', 'Desserts'];

  final List<Map<String, dynamic>> _menuItems = [
    {'name': 'Chicken Biryani', 'price': 300, 'category': 'Main Course', 'image': 'assets/images/biryani.jpg', 'rating': 4.8, 'time': '25-30 min', 'isBestseller': true},
    {'name': 'Seekh Kabab', 'price': 200, 'category': 'Main Course', 'image': 'assets/images/kabab.jpg', 'rating': 4.6, 'time': '20-25 min', 'isBestseller': false},
    {'name': 'Naan', 'price': 50, 'category': 'Main Course', 'image': 'assets/images/naan.jpg', 'rating': 4.5, 'time': '10-15 min', 'isBestseller': false},
    {'name': 'Samosa', 'price': 80, 'category': 'Appetizers', 'image': 'assets/images/samosa.jpg', 'rating': 4.7, 'time': '15-20 min', 'isBestseller': true},
    {'name': 'Pakora', 'price': 120, 'category': 'Appetizers', 'image': 'assets/images/pakora.jpg', 'rating': 4.4, 'time': '15-20 min', 'isBestseller': false},
    {'name': 'Cold Drink', 'price': 60, 'category': 'Beverages', 'image': 'assets/images/cold_drink.jpg', 'rating': 4.3, 'time': '5 min', 'isBestseller': false},
    {'name': 'Lassi', 'price': 100, 'category': 'Beverages', 'image': 'assets/images/lassi.jpg', 'rating': 4.6, 'time': '10 min', 'isBestseller': false},
    {'name': 'Gulab Jamun', 'price': 150, 'category': 'Desserts', 'image': 'assets/images/gulab_jamun.jpg', 'rating': 4.9, 'time': '10 min', 'isBestseller': true},
  ];

  List<Map<String, dynamic>> get _filteredItems {
    if (_selectedCategory == 'All') return _menuItems;
    return _menuItems.where((item) => item['category'] == _selectedCategory).toList();
  }

  double get _subtotal => _cart.fold(0, (sum, item) => sum + (item['price'] * item['quantity']));
  double get _tax => _subtotal * 0.10;
  double get _total => _subtotal + _tax;

  void _addToCart(Map<String, dynamic> item) {
    setState(() {
      final existingIndex = _cart.indexWhere((c) => c['name'] == item['name']);
      if (existingIndex >= 0) {
        _cart[existingIndex]['quantity']++;
      } else {
        _cart.add({...item, 'quantity': 1});
      }
    });
  }

  void _removeFromCart(int index) {
    setState(() {
      if (_cart[index]['quantity'] > 1) {
        _cart[index]['quantity']--;
      } else {
        _cart.removeAt(index);
      }
    });
  }

  void _showCartSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CartBottomSheet(
        cart: _cart,
        subtotal: _subtotal,
        tax: _tax,
        total: _total,
        onIncrement: (index) {
          setState(() => _cart[index]['quantity']++);
          Navigator.pop(context);
          _showCartSheet();
        },
        onDecrement: (index) {
          _removeFromCart(index);
          Navigator.pop(context);
          if (_cart.isNotEmpty) _showCartSheet();
        },
        onClear: () {
          setState(() => _cart.clear());
          Navigator.pop(context);
        },
        onCheckout: () {
          Navigator.pop(context);
          context.push('/pos/payment');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Point of Sale'),
        actions: [
          if (isMobile && _cart.isNotEmpty)
            Badge(
              label: Text('${_cart.fold(0, (sum, item) => sum + (item['quantity'] as int))}'),
              child: IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: _showCartSheet,
              ),
            ),
        ],
      ),
      body: isMobile ? _buildMobileLayout() : _buildTabletLayout(),
      floatingActionButton: isMobile && _cart.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: _showCartSheet,
              backgroundColor: AppColors.primary,
              label: Text('Rs ${_total.toInt()}', style: const TextStyle(color: Colors.white)),
              icon: const Icon(Icons.shopping_cart, color: Colors.white),
            )
          : null,
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        // Category Filter
        const SizedBox(height: 10),
        SizedBox(
          height: 32,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _categories.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final cat = _categories[index];
              final isSelected = _selectedCategory == cat;
              return GestureDetector(
                onTap: () => setState(() => _selectedCategory = cat),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? const LinearGradient(
                            colors: [AppColors.gradientButtonStart, AppColors.gradientButtonEnd],
                          )
                        : null,
                    borderRadius: BorderRadius.circular(10),
                    border: isSelected
                        ? null
                        : Border.all(color: AppColors.borderLight, width: 1),
                  ),
                  child: Text(
                    cat,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),

        // Menu Grid
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 0.9,
            ),
            itemCount: _filteredItems.length,
            itemBuilder: (context, index) {
              final item = _filteredItems[index];
              return _MenuGridItem(
                item: item,
                onTap: () => _addToCart(item),
              );
            },
          ),
        ),

      ],
    );
  }

  Widget _buildTabletLayout() {
    return Row(
      children: [
        // Menu Section
        Expanded(
          flex: 3,
          child: Column(
            children: [
              // Category Filter
              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _categories.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final cat = _categories[index];
                    final isSelected = _selectedCategory == cat;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedCategory = cat),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          gradient: isSelected
                              ? const LinearGradient(
                                  colors: [AppColors.gradientButtonStart, AppColors.gradientButtonEnd],
                                )
                              : null,
                          borderRadius: BorderRadius.circular(10),
                          border: isSelected
                              ? null
                              : Border.all(color: AppColors.borderLight, width: 1),
                        ),
                        child: Text(
                          cat,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            color: isSelected ? Colors.white : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Menu Grid
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 1.4,
                  ),
                  itemCount: _filteredItems.length,
                  itemBuilder: (context, index) {
                    final item = _filteredItems[index];
                    return _MenuGridItem(
                      item: item,
                      onTap: () => _addToCart(item),
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        // Cart Section
        Container(
          width: 320,
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border(left: BorderSide(color: AppColors.border)),
          ),
          child: Column(
            children: [
              // Cart Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: AppColors.border)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.shopping_cart, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text('Cart', style: AppTextStyles.h4),
                    const Spacer(),
                    if (_cart.isNotEmpty)
                      TextButton(
                        onPressed: () => setState(() => _cart.clear()),
                        child: Text('Clear', style: TextStyle(color: AppColors.error)),
                      ),
                  ],
                ),
              ),

              // Cart Items
              Expanded(
                child: _cart.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.shopping_cart_outlined, size: 48, color: AppColors.textHint),
                            SizedBox(height: 12),
                            Text('Cart is empty', style: TextStyle(color: AppColors.textSecondary)),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: _cart.length,
                        itemBuilder: (context, index) {
                          final item = _cart[index];
                          return _CartItem(
                            item: item,
                            onIncrement: () {
                              setState(() => item['quantity']++);
                            },
                            onDecrement: () => _removeFromCart(index),
                          );
                        },
                      ),
              ),

              // Cart Summary
              if (_cart.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: AppColors.border)),
                  ),
                  child: Column(
                    children: [
                      _SummaryRow(label: 'Subtotal', value: 'Rs ${_subtotal.toInt()}'),
                      const SizedBox(height: 4),
                      _SummaryRow(label: 'Tax (10%)', value: 'Rs ${_tax.toInt()}'),
                      const Divider(),
                      _SummaryRow(
                        label: 'Total',
                        value: 'Rs ${_total.toInt()}',
                        isBold: true,
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {
                            context.push('/pos/payment');
                          },
                          child: Text('Checkout - Rs ${_total.toInt()}'),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

// Cart Bottom Sheet for Mobile
class _CartBottomSheet extends StatelessWidget {
  final List<Map<String, dynamic>> cart;
  final double subtotal;
  final double tax;
  final double total;
  final Function(int) onIncrement;
  final Function(int) onDecrement;
  final VoidCallback onClear;
  final VoidCallback onCheckout;

  const _CartBottomSheet({
    required this.cart,
    required this.subtotal,
    required this.tax,
    required this.total,
    required this.onIncrement,
    required this.onDecrement,
    required this.onClear,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.shopping_cart, color: AppColors.primary),
                const SizedBox(width: 8),
                Text('Cart (${cart.length} items)', style: AppTextStyles.h4),
                const Spacer(),
                if (cart.isNotEmpty)
                  TextButton(
                    onPressed: onClear,
                    child: Text('Clear', style: TextStyle(color: AppColors.error)),
                  ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          const Divider(),

          // Cart Items
          Expanded(
            child: cart.isEmpty
                ? Center(
                    child: Text('Cart is empty', style: TextStyle(color: AppColors.textSecondary)),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: cart.length,
                    itemBuilder: (context, index) {
                      final item = cart[index];
                      return _CartItem(
                        item: item,
                        onIncrement: () => onIncrement(index),
                        onDecrement: () => onDecrement(index),
                      );
                    },
                  ),
          ),

          // Summary & Checkout
          if (cart.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: Column(
                children: [
                  _SummaryRow(label: 'Subtotal', value: 'Rs ${subtotal.toInt()}'),
                  const SizedBox(height: 4),
                  _SummaryRow(label: 'Tax (10%)', value: 'Rs ${tax.toInt()}'),
                  const Divider(),
                  _SummaryRow(label: 'Total', value: 'Rs ${total.toInt()}', isBold: true),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: onCheckout,
                      child: Text('Checkout - Rs ${total.toInt()}'),
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

class _MenuGridItem extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onTap;

  const _MenuGridItem({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isBestseller = item['isBestseller'] == true;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Full image
              Image.asset(
                item['image'] ?? 'assets/images/biryani.jpg',
                fit: BoxFit.cover,
              ),
              // Dark gradient at bottom
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  height: 60,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.8),
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['name'],
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Rs ${item['price']}',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFFFFB27A),
                              shadows: [Shadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 4)],
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.star_rounded, size: 12, color: Color(0xFFFFB27A)),
                              const SizedBox(width: 2),
                              Text(
                                '${item['rating']}',
                                style: const TextStyle(fontFamily: 'Inter', fontSize: 10, color: Colors.white70),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Bestseller badge
              if (isBestseller)
                Positioned(
                  top: 6,
                  left: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFCB202D),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'BESTSELLER',
                      style: TextStyle(fontFamily: 'Inter', fontSize: 7, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 0.3),
                    ),
                  ),
                ),
              // Add button
              Positioned(
                top: 6,
                right: 6,
                child: GestureDetector(
                  onTap: onTap,
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 4)],
                    ),
                    child: const Icon(Icons.add, color: Color(0xFFCB202D), size: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CartItem extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _CartItem({
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['name'], style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                Text('Rs ${item['price']} each', style: AppTextStyles.caption),
              ],
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: onDecrement,
                child: Icon(Icons.remove_circle_outline, size: 24, color: AppColors.error),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text('${item['quantity']}', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
              ),
              GestureDetector(
                onTap: onIncrement,
                child: Icon(Icons.add_circle_outline, size: 24, color: AppColors.primary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const _SummaryRow({required this.label, required this.value, this.isBold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: (isBold ? AppTextStyles.bodyLarge : AppTextStyles.bodyMedium)
                .copyWith(fontWeight: isBold ? FontWeight.w700 : FontWeight.normal),
          ),
          Text(
            value,
            style: (isBold ? AppTextStyles.h4 : AppTextStyles.bodyMedium)
                .copyWith(fontWeight: isBold ? FontWeight.w700 : FontWeight.normal),
          ),
        ],
      ),
    );
  }
}
