import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodos/core/models/restaurant_model.dart';
import 'package:foodos/core/providers/restaurant_provider.dart';
import 'package:foodos/core/providers/cart_provider.dart';
import 'package:foodos/core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';

class FoodItemDetailScreen extends ConsumerStatefulWidget {
  final String itemName;
  final MenuItem? item;

  const FoodItemDetailScreen({super.key, required this.itemName, this.item});

  @override
  ConsumerState<FoodItemDetailScreen> createState() => _FoodItemDetailScreenState();
}

class _FoodItemDetailScreenState extends ConsumerState<FoodItemDetailScreen> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final restaurantsForItem = ref.watch(restaurantsForItemProvider(widget.itemName));
    final displayItem = widget.item ?? (restaurantsForItem.isNotEmpty ? (restaurantsForItem.first['item'] as MenuItem) : null);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Hero Image
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: AppColors.background,
            leading: GestureDetector(
              onTap: () => context.pop(),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.4),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: displayItem != null
                  ? Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          displayItem.image,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: AppColors.surfaceVariant,
                            child: Icon(Icons.fastfood, color: AppColors.textHint, size: 64),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 16,
                          left: 16,
                          right: 16,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (displayItem.isBestseller)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(color: const Color(0xFFCB202D), borderRadius: BorderRadius.circular(4)),
                                  child: const Text('BESTSELLER', style: TextStyle(fontFamily: 'Inter', fontSize: 9, fontWeight: FontWeight.w800, color: Colors.white)),
                                ),
                              const SizedBox(height: 8),
                              Text(displayItem.name, style: const TextStyle(fontFamily: 'Inter', fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white)),
                              const SizedBox(height: 4),
                              Text(displayItem.description, style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: Colors.white70), maxLines: 2, overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Container(color: AppColors.surfaceVariant),
            ),
          ),

          // Item Stats
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  _buildStat(Icons.star_rounded, '${displayItem?.rating ?? 4.5}', 'Rating', const Color(0xFFFFB27A)),
                  const SizedBox(width: 12),
                  _buildStat(Icons.shopping_bag_rounded, '${displayItem?.orders ?? 0}', 'Orders', AppColors.primary),
                  const SizedBox(width: 12),
                  _buildStat(Icons.store_outlined, '${restaurantsForItem.length}', 'Restaurants', AppColors.info),
                ],
              ),
            ),
          ),

          // Section header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Available at (${restaurantsForItem.length})',
                style: TextStyle(fontFamily: 'Inter', fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),

          // Restaurant list
          if (restaurantsForItem.isEmpty)
            SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    children: [
                      Icon(Icons.restaurant_menu, color: AppColors.textHint, size: 48),
                      const SizedBox(height: 12),
                      Text('Not available at any restaurant yet', style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.textHint)),
                    ],
                  ),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final entry = restaurantsForItem[index];
                    final restaurant = entry['restaurant'] as Restaurant;
                    final restaurantItem = entry['item'] as MenuItem;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildRestaurantCard(context, restaurant, restaurantItem, displayItem),
                    );
                  },
                  childCount: restaurantsForItem.length,
                ),
              ),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildStat(IconData icon, String value, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.borderLight, width: 1),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 4),
            Text(value, style: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textHint)),
          ],
        ),
      ),
    );
  }

  Widget _buildRestaurantCard(BuildContext context, Restaurant restaurant, MenuItem restaurantItem, MenuItem? displayItem) {
    return GestureDetector(
      onTap: () => context.push('/customer/restaurant/${restaurant.id}'),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.borderLight, width: 1),
        ),
        child: Row(
          children: [
            // Restaurant image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(restaurant.image, width: 64, height: 64, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(width: 64, height: 64, color: AppColors.surfaceVariant, child: Icon(Icons.restaurant, color: AppColors.textHint))),
            ),
            const SizedBox(width: 14),
            // Restaurant info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(restaurant.name, style: TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                      ),
                      if (restaurant.isOpen)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(4)),
                          child: Text('Open', style: TextStyle(fontFamily: 'Inter', fontSize: 9, fontWeight: FontWeight.w600, color: AppColors.success)),
                        )
                      else
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(4)),
                          child: Text('Closed', style: TextStyle(fontFamily: 'Inter', fontSize: 9, fontWeight: FontWeight.w600, color: AppColors.error)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, size: 14, color: Color(0xFFFFB27A)),
                      const SizedBox(width: 2),
                      Text('${restaurant.rating}', style: TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                      const SizedBox(width: 8),
                      Icon(Icons.access_time, size: 12, color: AppColors.textHint),
                      const SizedBox(width: 4),
                      Text(restaurant.deliveryTime, style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textHint)),
                    ],
                  ),
                  const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Rs ${restaurantItem.price}',
                            style: TextStyle(fontFamily: 'Inter', fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.primary),
                          ),
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(8)),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () => setState(() => _quantity = _quantity > 1 ? _quantity - 1 : 1),
                                      child: Container(width: 30, height: 30, decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)), child: Icon(Icons.remove, size: 14, color: AppColors.primary)),
                                    ),
                                    Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: Text('$_quantity', style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary))),
                                    GestureDetector(
                                      onTap: () => setState(() => _quantity++),
                                      child: Container(width: 30, height: 30, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(6)), child: Icon(Icons.add, size: 14, color: Colors.white)),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () {
                                  final cartItem = CartItem(
                                    id: '${restaurantItem.name}_${restaurant.id}_${DateTime.now().millisecondsSinceEpoch}',
                                    name: restaurantItem.name,
                                    price: restaurantItem.price,
                                    image: restaurantItem.image,
                                    restaurantId: restaurant.id,
                                    restaurantName: restaurant.name,
                                    quantity: _quantity,
                                    size: 'Regular',
                                    spiceLevel: 'Medium',
                                  );
                                  ref.read(cartProvider.notifier).addItem(cartItem);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('$_quantity × ${restaurantItem.name} added to cart!'),
                                      backgroundColor: AppColors.success,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(colors: [AppColors.gradientButtonStart, AppColors.gradientButtonEnd]),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Text('Add to Cart', style: TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
