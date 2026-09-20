import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodos/core/models/restaurant_model.dart';
import 'package:foodos/core/providers/restaurant_provider.dart';
import 'package:foodos/core/providers/cart_provider.dart';
import 'package:foodos/core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';

class RestaurantDetailScreen extends ConsumerStatefulWidget {
  final String restaurantId;

  const RestaurantDetailScreen({super.key, required this.restaurantId});

  @override
  ConsumerState<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends ConsumerState<RestaurantDetailScreen> {
  String _selectedMenuCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final restaurant = ref.watch(restaurantByIdProvider(widget.restaurantId));

    if (restaurant == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Restaurant')),
        body: const Center(child: Text('Restaurant not found')),
      );
    }

    final menuCategories = ['All', ...restaurant.menuItems.map((m) => m.category).toSet()];
    final filteredMenu = _selectedMenuCategory == 'All'
        ? restaurant.menuItems
        : restaurant.menuItems.where((m) => m.category == _selectedMenuCategory).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Hero image
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: AppColors.background,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(restaurant.image, fit: BoxFit.cover),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, AppColors.background],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Restaurant info
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(restaurant.name, style: TextStyle(fontFamily: 'Inter', fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                            const SizedBox(height: 4),
                            Text(restaurant.cuisine, style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.textHint)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: restaurant.isOpen ? AppColors.success.withValues(alpha: 0.12) : AppColors.error.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          restaurant.isOpen ? 'Open' : 'Closed',
                          style: TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w600, color: restaurant.isOpen ? AppColors.success : AppColors.error),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Stats row
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStat(Icons.star_rounded, '${restaurant.rating}', '${restaurant.reviewCount} reviews', const Color(0xFFFFB27A)),
                        Container(width: 1, height: 30, color: AppColors.borderLight),
                        _buildStat(Icons.access_time, restaurant.deliveryTime, 'Delivery', AppColors.primary),
                        Container(width: 1, height: 30, color: AppColors.borderLight),
                        _buildStat(Icons.delivery_dining, restaurant.deliveryFee, 'Fee', AppColors.info),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Min order: Rs ${restaurant.minOrder}', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textHint)),
                  const SizedBox(height: 20),

                  // Menu categories
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: menuCategories.length,
                      itemBuilder: (context, index) {
                        final cat = menuCategories[index];
                        final isSelected = _selectedMenuCategory == cat;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedMenuCategory = cat),
                          child: Container(
                            margin: const EdgeInsets.only(right: 10),
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
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // Menu items
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final item = filteredMenu[index];
                  return _buildMenuItem(item);
                },
                childCount: filteredMenu.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildStat(IconData icon, String value, String label, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        Text(label, style: TextStyle(fontFamily: 'Inter', fontSize: 10, color: AppColors.textHint)),
      ],
    );
  }

  Widget _buildMenuItem(MenuItem item) {
    final restaurant = ref.read(restaurantByIdProvider(widget.restaurantId));
    return GestureDetector(
      onTap: () => context.push('/customer/food-detail', extra: {
        'name': item.name,
        'image': item.image,
        'price': 'Rs ${item.price}',
        'rating': '${item.rating}',
        'restaurant': restaurant?.name ?? '',
        'restaurantId': restaurant?.id ?? '',
        'description': item.description,
        'category': item.category,
      }),
      child: Container(
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
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(item.image, width: 80, height: 80, fit: BoxFit.cover),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(item.name, style: TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                      ),
                      if (item.isBestseller)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(4)),
                          child: const Text('BESTSELLER', style: TextStyle(fontFamily: 'Inter', fontSize: 8, fontWeight: FontWeight.w800, color: Colors.white)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(item.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textHint)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, size: 14, color: Color(0xFFFFB27A)),
                      const SizedBox(width: 2),
                      Text('${item.rating}', style: TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                      const SizedBox(width: 8),
                      Text('${item.orders}+ orders', style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textHint)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text('Rs ${item.price}', style: TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.primary)),
                ],
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                final cartItem = CartItem(
                  id: '${item.name}_${widget.restaurantId}_${DateTime.now().millisecondsSinceEpoch}',
                  name: item.name,
                  price: item.price,
                  image: item.image,
                  restaurantId: widget.restaurantId,
                  restaurantName: restaurant?.name ?? '',
                  quantity: 1,
                  size: 'Regular',
                  spiceLevel: 'Medium',
                );
                ref.read(cartProvider.notifier).addItem(cartItem);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${item.name} added to cart!'),
                    backgroundColor: AppColors.success,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                );
              },
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [AppColors.gradientButtonStart, AppColors.gradientButtonEnd]),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
