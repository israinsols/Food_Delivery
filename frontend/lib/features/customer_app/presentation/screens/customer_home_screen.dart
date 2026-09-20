import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodos/core/models/restaurant_model.dart';
import 'package:foodos/core/providers/restaurant_provider.dart';
import 'package:foodos/core/theme/app_colors.dart';
import 'package:foodos/core/widgets/customer_bottom_nav.dart';
import 'package:go_router/go_router.dart';

class CustomerHomeScreen extends ConsumerStatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  ConsumerState<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends ConsumerState<CustomerHomeScreen> {
  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(foodCategoriesProvider);
    final restaurants = ref.watch(filteredRestaurantsProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final allItems = ref.watch(allMenuItemsProvider);

    // Filter items by selected category
    final filteredItems = selectedCategory == 'All'
        ? allItems
        : allItems.where((i) => i.category == selectedCategory).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: const CustomerBottomNav(currentIndex: 0),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          color: AppColors.primary,
          backgroundColor: AppColors.surface,
          child: ListView(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Deliver to', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textHint)),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(Icons.location_on, color: AppColors.primary, size: 16),
                            const SizedBox(width: 4),
                            Text('DHA Phase 5, Lahore', style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                            const SizedBox(width: 4),
                            Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary, size: 18),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.borderLight, width: 1),
                      ),
                      child: GestureDetector(
                        onTap: () => context.push('/customer/notifications'),
                        child: Icon(Icons.notifications_outlined, color: AppColors.textPrimary, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Search bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GestureDetector(
                  onTap: () => context.push('/customer/search'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.borderLight, width: 1),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search, color: AppColors.textHint, size: 20),
                        const SizedBox(width: 10),
                        Text('Search restaurants or food...', style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.textHint)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Food Categories
              SizedBox(
                height: 90,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final cat = categories[index];
                    final isSelected = selectedCategory == cat.name;
                    return GestureDetector(
                      onTap: () => ref.read(selectedCategoryProvider.notifier).state = cat.name,
                      child: Container(
                        width: 72,
                        margin: const EdgeInsets.only(right: 12),
                        child: Column(
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.primary.withValues(alpha: 0.15) : AppColors.surface,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: isSelected ? AppColors.primary : AppColors.borderLight, width: isSelected ? 2 : 1),
                              ),
                              child: Center(child: Text(cat.emoji, style: const TextStyle(fontSize: 28))),
                            ),
                            const SizedBox(height: 6),
                            Text(cat.name, style: TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.w600, color: isSelected ? AppColors.primary : AppColors.textPrimary)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Promo Banner
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFCB202D), Color(0xFFFF6B35)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('20% OFF', style: TextStyle(fontFamily: 'Inter', fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white)),
                            const SizedBox(height: 4),
                            const Text('On your first order', style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: Colors.white70)),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                              child: const Text('ORDER NOW', style: TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFFCB202D))),
                            ),
                          ],
                        ),
                      ),
                      const Text('🍕', style: TextStyle(fontSize: 64)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // All Food Items (flat list from all restaurants)
              if (filteredItems.isNotEmpty) ...[
                _buildSectionHeader('${selectedCategory == 'All' ? 'All Food Items' : selectedCategory} (${filteredItems.length})', () {}),
                const SizedBox(height: 8),
                SizedBox(
                  height: 220,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: _buildFoodItemCard(item),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Featured Restaurants
              if (selectedCategory == 'All') ...[
                _buildSectionHeader('Featured Restaurants', () {}),
                SizedBox(
                  height: 220,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: restaurants.where((r) => r.isFeatured).map((r) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: _buildRestaurantCard(r),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // All Restaurants
              _buildSectionHeader('${selectedCategory == 'All' ? 'All' : selectedCategory} Restaurants (${restaurants.length})', () {}),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: restaurants.map((r) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildRestaurantListCard(r),
                  )).toList(),
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onSeeAll) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontFamily: 'Inter', fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          GestureDetector(
            onTap: onSeeAll,
            child: Text('See All', style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodItemCard(MenuItem item) {
    return GestureDetector(
      onTap: () {
        // Navigate to food item detail showing all restaurants with this item
        context.push('/customer/food-item/${item.name}', extra: item);
      },
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 10, offset: const Offset(0, 3))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                  child: Image.asset(item.image, width: 160, height: 110, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(width: 160, height: 110, color: AppColors.surfaceVariant, child: Icon(Icons.fastfood, color: AppColors.textHint))),
                ),
                if (item.isBestseller)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(color: const Color(0xFFCB202D), borderRadius: BorderRadius.circular(4)),
                      child: const Text('BESTSELLER', style: TextStyle(fontFamily: 'Inter', fontSize: 8, fontWeight: FontWeight.w800, color: Colors.white)),
                    ),
                  ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text('Rs ${item.price}', style: const TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white)),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(item.restaurantName ?? '', style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textHint), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, size: 14, color: Color(0xFFFFB27A)),
                      const SizedBox(width: 2),
                      Text('${item.rating}', style: TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                      const SizedBox(width: 6),
                      Text('${item.orders} sold', style: TextStyle(fontFamily: 'Inter', fontSize: 10, color: AppColors.textHint)),
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

  Widget _buildRestaurantCard(Restaurant r) {
    return GestureDetector(
      onTap: () => context.push('/customer/restaurant/${r.id}'),
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 10, offset: const Offset(0, 3))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                  child: Image.asset(r.image, width: 200, height: 110, fit: BoxFit.cover),
                ),
                if (r.isFeatured)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(color: const Color(0xFFCB202D), borderRadius: BorderRadius.circular(4)),
                      child: const Text('FEATURED', style: TextStyle(fontFamily: 'Inter', fontSize: 8, fontWeight: FontWeight.w800, color: Colors.white)),
                    ),
                  ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4)]),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.delivery_dining, size: 12, color: Color(0xFFCB202D)),
                        const SizedBox(width: 2),
                        Text(r.deliveryTime, style: TextStyle(fontFamily: 'Inter', fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(r.name, style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                  const SizedBox(height: 2),
                  Text(r.cuisine, style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textHint)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, size: 14, color: Color(0xFFFFB27A)),
                      const SizedBox(width: 2),
                      Text('${r.rating}', style: TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                      const SizedBox(width: 8),
                      Icon(Icons.circle, size: 3, color: AppColors.textHint),
                      const SizedBox(width: 8),
                      Text(r.deliveryFee, style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: r.deliveryFee == 'Free' ? AppColors.success : AppColors.textHint)),
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

  Widget _buildRestaurantListCard(Restaurant r) {
    return GestureDetector(
      onTap: () => context.push('/customer/restaurant/${r.id}'),
      child: Container(
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
              child: Image.asset(r.image, width: 72, height: 72, fit: BoxFit.cover),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(r.name, style: TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                      ),
                      if (r.isOpen)
                        Icon(Icons.circle, size: 8, color: AppColors.success)
                      else
                        Icon(Icons.circle, size: 8, color: AppColors.error),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(r.cuisine, style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textHint)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, size: 14, color: Color(0xFFFFB27A)),
                      const SizedBox(width: 2),
                      Text('${r.rating} (${r.reviewCount})', style: TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                      const SizedBox(width: 10),
                      Icon(Icons.access_time, size: 12, color: AppColors.textHint),
                      const SizedBox(width: 4),
                      Text(r.deliveryTime, style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textHint)),
                      const SizedBox(width: 10),
                      Text(r.deliveryFee == 'Free' ? 'Free delivery' : r.deliveryFee, style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: r.deliveryFee == 'Free' ? AppColors.success : AppColors.textHint)),
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
