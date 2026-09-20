import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodos/core/theme/app_colors.dart';
import 'package:foodos/core/providers/cart_provider.dart';
import 'package:go_router/go_router.dart';

class FoodDetailScreen extends ConsumerStatefulWidget {
  final String name;
  final String image;
  final String restaurant;
  final String restaurantId;
  final String rating;
  final String price;
  final String description;
  final String category;
  final List<String> addOns;

  const FoodDetailScreen({
    super.key,
    this.name = 'Chicken Biryani',
    this.image = 'assets/images/biryani.jpg',
    this.restaurant = 'FoodOS Kitchen',
    this.restaurantId = '',
    this.rating = '4.8',
    this.price = 'Rs 300',
    this.description = '',
    this.category = 'Main Course',
    this.addOns = const [],
  });

  @override
  ConsumerState<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends ConsumerState<FoodDetailScreen> {
  int _selectedSize = 0;
  int _quantity = 1;
  final Set<int> _selectedAddOns = {};

  late final List<Map<String, String>> _sizes;
  late final List<Map<String, String>> _addOnsList;

  @override
  void initState() {
    super.initState();
    final basePrice = int.tryParse(widget.price.replaceAll(RegExp(r'[^0-9]'), '')) ?? 300;
    _sizes = [
      {'label': 'Regular', 'price': 'Rs $basePrice'},
      {'label': 'Large', 'price': 'Rs ${basePrice + 200}'},
      {'label': 'Family', 'price': 'Rs ${basePrice + 500}'},
    ];
    _addOnsList = widget.addOns.map((a) => {'name': a, 'price': 'Rs 50'}).toList();
    if (_addOnsList.isEmpty) {
      _addOnsList.addAll([
        {'name': 'Extra Cheese', 'price': 'Rs 80'},
        {'name': 'Extra Chicken', 'price': 'Rs 120'},
        {'name': 'Raita', 'price': 'Rs 30'},
        {'name': 'Cold Drink', 'price': 'Rs 60'},
      ]);
    }
  }

  int get _basePrice {
    final p = int.tryParse(widget.price.replaceAll(RegExp(r'[^0-9]'), '')) ?? 300;
    switch (_selectedSize) {
      case 0: return p;
      case 1: return p + 200;
      case 2: return p + 500;
      default: return p;
    }
  }

  int get _addOnsTotal {
    int total = 0;
    for (final i in _selectedAddOns) {
      final price = int.tryParse(_addOnsList[i]['price']!.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      total += price;
    }
    return total;
  }

  int get _totalPrice => (_basePrice + _addOnsTotal) * _quantity;

  String get _description {
    if (widget.description.isNotEmpty) return widget.description;
    // Default descriptions based on common items
    final lowerName = widget.name.toLowerCase();
    if (lowerName.contains('biryani')) return 'Aromatic basmati rice layered with tender chicken, saffron, and traditional spices. Served with raita and salan.';
    if (lowerName.contains('kabab') || lowerName.contains('kebab')) return 'Juicy grilled minced meat kababs marinated in secret spices, cooked to perfection over charcoal.';
    if (lowerName.contains('pizza')) return 'Hand-tossed pizza with premium mozzarella cheese, fresh toppings, and our signature tomato sauce on a crispy base.';
    if (lowerName.contains('burger')) return 'Juicy grilled patty with fresh lettuce, tomato, pickles, and our special sauce in a toasted brioche bun.';
    if (lowerName.contains('naan')) return 'Freshly baked tandoori naan bread, soft and fluffy, perfect to pair with your favorite curry.';
    if (lowerName.contains('samosa')) return 'Crispy golden pastry filled with spiced potato and peas, served with mint chutney.';
    if (lowerName.contains('wing')) return 'Crispy fried chicken wings tossed in your choice of buffalo, BBQ, or honey garlic sauce.';
    if (lowerName.contains('fries')) return 'Golden crispy French fries seasoned with our special spice blend.';
    if (lowerName.contains('shake')) return 'Thick and creamy milkshake made with premium ice cream and topped with whipped cream.';
    if (lowerName.contains('gulab jamun')) return 'Soft, spongy milk-solid dumplings soaked in rose-flavored sugar syrup.';
    if (lowerName.contains('jalebi')) return 'Crispy, hot jalebi drizzled with saffron-infused sugar syrup.';
    if (lowerName.contains('lassi')) return 'Refreshing traditional yogurt drink, available sweet or salted.';
    if (lowerName.contains('chai') || lowerName.contains('tea')) return 'Strong Pakistani-style tea brewed with cardamom and fresh milk.';
    if (lowerName.contains('drink') || lowerName.contains('cola') || lowerName.contains('pepsi') || lowerName.contains('coke')) return 'Refreshing cold beverage to complement your meal.';
    if (lowerName.contains('pakora')) return 'Crispy vegetable fritters made with gram flour and fresh spices, served with chutney.';
    if (lowerName.contains('manchurian')) return 'Indo-Chinese style chicken in a tangy, spicy manchurian sauce.';
    if (lowerName.contains('fried rice')) return 'Wok-fried jasmine rice with chicken, vegetables, and soy sauce.';
    if (lowerName.contains('daal') || lowerName.contains('dal')) return 'Creamy black lentils slow-cooked overnight with butter and cream.';
    if (lowerName.contains('pasta')) return 'Al dente pasta tossed in a creamy Alfredo sauce with grilled chicken.';
    if (lowerName.contains('wings')) return 'Crispy chicken wings marinated and fried to golden perfection.';
    if (lowerName.contains('mango') || lowerName.contains('smoothie')) return 'Fresh fruit smoothie blended with ice and natural flavors.';
    if (lowerName.contains('kulfi')) return 'Traditional Pakistani ice cream made with reduced milk, cardamom, and pistachios.';
    if (lowerName.contains('ras malai')) return 'Soft paneer balls soaked in saffron-flavored sweetened milk.';
    if (lowerName.contains('ice cream') || lowerName.contains('icecream')) return 'Creamy premium ice cream available in multiple flavors.';
    return 'A delicious dish made with fresh ingredients and authentic recipes.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Hero image
          Image.asset(widget.image, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: AppColors.surfaceVariant)),
          // Gradient overlay — stronger to make text readable
          Positioned(
            left: 0, right: 0, bottom: 0,
            child: Container(
              height: 450,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.3),
                    AppColors.background.withValues(alpha: 0.85),
                    AppColors.background,
                  ],
                  stops: const [0.0, 0.3, 0.6, 0.85],
                ),
              ),
            ),
          ),
          // Dark overlay on entire image for readability
          Positioned.fill(
            child: Container(color: Colors.black.withValues(alpha: 0.25)),
          ),
          // Back button
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            left: 16,
            child: _buildCircleButton(Icons.arrow_back, () => context.pop()),
          ),
          // Favorite
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            right: 16,
            child: _buildCircleButton(Icons.favorite_border, () {}),
          ),
          // Content
          Positioned(
            left: 0, right: 0, bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.background.withValues(alpha: 0.6),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title & Rating
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.name, style: TextStyle(fontFamily: 'Inter', fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                              const SizedBox(height: 4),
                              Text('${widget.restaurant} • ${widget.category}', style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.textHint)),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.star_rounded, size: 16, color: Color(0xFFFFB27A)),
                                  const SizedBox(width: 4),
                                  Text(widget.rating, style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                                  const SizedBox(width: 12),
                                  Icon(Icons.access_time, size: 14, color: AppColors.textHint),
                                  const SizedBox(width: 4),
                                  Text('25-30 min', style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.textHint)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.success.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text('In Stock', style: TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.success)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Description
                    Text('About this item', style: TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                    const SizedBox(height: 8),
                    Text(_description, style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.textSecondary, height: 1.5)),
                    const SizedBox(height: 16),

                    // Size options
                    Text('Portion', style: TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                    const SizedBox(height: 10),
                    Row(
                      children: List.generate(_sizes.length, (i) {
                        final s = _sizes[i];
                        final isSelected = _selectedSize == i;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedSize = i),
                            child: Container(
                              margin: EdgeInsets.only(right: i < _sizes.length - 1 ? 10 : 0),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : AppColors.surface,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: isSelected ? AppColors.primary : AppColors.borderLight, width: isSelected ? 2 : 1),
                              ),
                              child: Column(
                                children: [
                                  Text(s['label']!, style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600, color: isSelected ? AppColors.primary : AppColors.textPrimary)),
                                  const SizedBox(height: 2),
                                  Text(s['price']!, style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: isSelected ? AppColors.primary : AppColors.textHint)),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 16),

                    // Add-ons
                    if (_addOnsList.isNotEmpty) ...[
                      Text('Add-ons', style: TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                      const SizedBox(height: 10),
                      ...List.generate(_addOnsList.length, (i) {
                        final addon = _addOnsList[i];
                        final isSelected = _selectedAddOns.contains(i);
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                _selectedAddOns.remove(i);
                              } else {
                                _selectedAddOns.add(i);
                              }
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primary.withValues(alpha: 0.06) : AppColors.surface,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: isSelected ? AppColors.primary : AppColors.borderLight, width: 1),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isSelected ? Icons.check_circle : Icons.add_circle_outline,
                                  color: isSelected ? AppColors.primary : AppColors.textHint,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(addon['name']!, style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
                                ),
                                Text(addon['price']!, style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.textHint)),
                              ],
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 12),
                    ],

                    // Quantity
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Quantity', style: TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                        Row(
                          children: [
                            _buildQtyButton(Icons.remove, () {
                              if (_quantity > 1) setState(() => _quantity--);
                            }),
                            Container(
                              width: 48,
                              alignment: Alignment.center,
                              child: Text('$_quantity', style: TextStyle(fontFamily: 'Inter', fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                            ),
                            _buildQtyButton(Icons.add, () => setState(() => _quantity++)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Add to cart
                    GestureDetector(
                      onTap: () {
                        final basePrice = int.tryParse(widget.price.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
                        final sizePrice = _sizes[_selectedSize]['price'] ?? '';
                        final totalItemPrice = basePrice + (int.tryParse(sizePrice.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0);

                        final cartItem = CartItem(
                          id: '${widget.name}_${DateTime.now().millisecondsSinceEpoch}',
                          name: widget.name,
                          price: totalItemPrice,
                          image: widget.image,
                          restaurantId: widget.restaurantId,
                          restaurantName: widget.restaurant,
                          quantity: _quantity,
                          size: _sizes[_selectedSize]['name'] ?? 'Regular',
                          spiceLevel: 'Medium',
                          addOns: _selectedAddOns.map((i) => _addOnsList[i]['name'] ?? '').toList(),
                        );

                        ref.read(cartProvider.notifier).addItem(cartItem);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${widget.name} added to cart!'),
                            backgroundColor: AppColors.success,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
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
                            Text('Add to Cart  •  Rs $_totalPrice', style: const TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.surface.withValues(alpha: 0.9),
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 8)],
        ),
        child: Icon(icon, color: AppColors.textPrimary, size: 20),
      ),
    );
  }

  Widget _buildQtyButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.borderLight, width: 1),
        ),
        child: Icon(icon, color: AppColors.textPrimary, size: 18),
      ),
    );
  }
}
