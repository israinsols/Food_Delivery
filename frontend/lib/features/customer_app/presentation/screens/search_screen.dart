import 'package:flutter/material.dart';
import 'package:foodos/core/theme/app_colors.dart';
import 'package:foodos/core/widgets/customer_bottom_nav.dart';
import 'package:go_router/go_router.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  final _recentSearches = ['Biryani', 'Pizza', 'Burger', 'Chinese', 'BBQ'];
  final _allItems = [
    {'name': 'Chicken Biryani', 'restaurant': 'FoodOS Kitchen', 'price': 'Rs 300', 'image': 'assets/images/biryani.jpg', 'rating': '4.8', 'category': 'Biryani', 'description': 'Aromatic basmati rice layered with tender chicken, saffron, and traditional spices. Served with raita and salan.'},
    {'name': 'Seekh Kabab', 'restaurant': 'Spice Hub', 'price': 'Rs 200', 'image': 'assets/images/kabab.jpg', 'rating': '4.6', 'category': 'BBQ & Grilled', 'description': 'Juicy grilled minced meat kababs marinated in secret spices, cooked to perfection over charcoal.'},
    {'name': 'Naan', 'restaurant': 'FoodOS Kitchen', 'price': 'Rs 50', 'image': 'assets/images/naan.jpg', 'rating': '4.5', 'category': 'Pakistani', 'description': 'Freshly baked tandoori naan bread, soft and fluffy, perfect to pair with your favorite curry.'},
    {'name': 'Samosa (4 pcs)', 'restaurant': 'FoodOS Kitchen', 'price': 'Rs 80', 'image': 'assets/images/samosa.jpg', 'rating': '4.7', 'category': 'Pakistani', 'description': 'Crispy golden pastry filled with spiced potato and peas, served with mint chutney.'},
    {'name': 'Cold Drink', 'restaurant': 'Spice Hub', 'price': 'Rs 60', 'image': 'assets/images/cold_drink.jpg', 'rating': '4.3', 'category': 'Drinks', 'description': 'Refreshing cold beverage to complement your meal.'},
    {'name': 'Lassi', 'restaurant': 'FoodOS Kitchen', 'price': 'Rs 100', 'image': 'assets/images/lassi.jpg', 'rating': '4.6', 'category': 'Drinks', 'description': 'Refreshing traditional yogurt drink, available sweet or salted.'},
    {'name': 'Gulab Jamun', 'restaurant': 'Sweet Corner', 'price': 'Rs 180', 'image': 'assets/images/gulab_jamun.jpg', 'rating': '4.9', 'category': 'Desserts', 'description': 'Soft, spongy milk-solid dumplings soaked in rose-flavored sugar syrup.'},
    {'name': 'Smash Burger', 'restaurant': 'Burger House', 'price': 'Rs 550', 'image': 'assets/images/pakora.jpg', 'rating': '4.8', 'category': 'Fast Food', 'description': 'Double smashed beef patty with cheese, pickles, and special sauce in a toasted bun.'},
    {'name': 'Pepperoni Pizza', 'restaurant': 'Pizza Corner', 'price': 'Rs 800', 'image': 'assets/images/samosa.jpg', 'rating': '4.7', 'category': 'Pizza', 'description': 'Classic pepperoni pizza with premium mozzarella cheese on a crispy hand-tossed base.'},
    {'name': 'Chicken Manchurian', 'restaurant': 'Spice Hub', 'price': 'Rs 350', 'image': 'assets/images/kabab.jpg', 'rating': '4.5', 'category': 'Chinese', 'description': 'Indo-Chinese style chicken in a tangy, spicy manchurian sauce.'},
    {'name': 'Karak Chai', 'restaurant': 'Chai Wala', 'price': 'Rs 80', 'image': 'assets/images/lassi.jpg', 'rating': '4.6', 'category': 'Drinks', 'description': 'Strong Pakistani-style tea brewed with cardamom and fresh milk.'},
    {'name': 'Pakora (6 pcs)', 'restaurant': 'Chai Wala', 'price': 'Rs 80', 'image': 'assets/images/pakora.jpg', 'rating': '4.7', 'category': 'Pakistani', 'description': 'Crispy vegetable fritters made with gram flour and fresh spices, served with chutney.'},
  ];

  List<Map<String, dynamic>> get _filteredItems {
    if (_query.isEmpty) return _allItems;
    return _allItems.where((i) => (i['name']?.toLowerCase() ?? '').contains(_query.toLowerCase()) || (i['category']?.toLowerCase() ?? '').contains(_query.toLowerCase())).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: const CustomerBottomNav(currentIndex: 1),
      body: SafeArea(
        child: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.go('/customer/home'),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderLight, width: 1)),
                      child: Icon(Icons.arrow_back, size: 20, color: AppColors.textPrimary),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      autofocus: true,
                      onChanged: (v) => setState(() => _query = v),
                      style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Search food or restaurants...',
                        hintStyle: TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.textHint),
                        filled: true,
                        fillColor: AppColors.surface,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        suffixIcon: _query.isNotEmpty
                            ? IconButton(
                                icon: Icon(Icons.clear, size: 18, color: AppColors.textHint),
                                onPressed: () => setState(() { _searchController.clear(); _query = ''; }),
                              )
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: _query.isEmpty ? _buildRecentSearches() : _buildSearchResults(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentSearches() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        Text('Recent Searches', style: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _recentSearches.map((s) => GestureDetector(
            onTap: () => setState(() { _query = s; _searchController.text = s; }),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.borderLight, width: 1),
              ),
              child: Text(s, style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.textSecondary)),
            ),
          )).toList(),
        ),
        const SizedBox(height: 24),
        Text('Popular Categories', style: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        const SizedBox(height: 12),
        _buildCategoryTile('🍛', 'Biryani'),
        _buildCategoryTile('🍔', 'Burgers'),
        _buildCategoryTile('🍕', 'Pizza'),
        _buildCategoryTile('🥙', 'Kebabs'),
      ],
    );
  }

  Widget _buildCategoryTile(String emoji, String label) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderLight, width: 1)),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 14),
          Text(label, style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _filteredItems.length,
      itemBuilder: (context, index) {
        final item = _filteredItems[index];
        return GestureDetector(
          onTap: () => context.push('/customer/food-detail', extra: {
            'name': item['name'],
            'restaurant': item['restaurant'],
            'rating': item['rating'],
            'price': item['price'],
            'image': item['image'],
            'description': item['description'] ?? '',
            'category': item['category'] ?? '',
          }),
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))]),
            child: Row(
              children: [
                ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.asset(item['image']!, width: 64, height: 64, fit: BoxFit.cover)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item['name']!, style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                      const SizedBox(height: 2),
                      Text(item['restaurant']!, style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textHint)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, size: 12, color: Color(0xFFFFB27A)),
                          const SizedBox(width: 2),
                          Text(item['rating']!, style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textPrimary)),
                        ],
                      ),
                    ],
                  ),
                ),
                Text(item['price']!, style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.primary)),
              ],
            ),
          ),
        );
      },
    );
  }
}
