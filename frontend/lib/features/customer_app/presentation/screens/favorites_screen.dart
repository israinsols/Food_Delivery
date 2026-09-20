import 'package:flutter/material.dart';
import 'package:foodos/core/theme/app_colors.dart';
import 'package:foodos/core/widgets/shimmer_loading.dart';
import 'package:go_router/go_router.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  bool _isLoading = true;

  final _favorites = [
    {'name': 'Chicken Biryani', 'restaurant': 'FoodOS Kitchen', 'rating': '4.8', 'price': 'Rs 300', 'image': 'assets/images/biryani.jpg'},
    {'name': 'Seekh Kabab Platter', 'restaurant': 'Spice Hub', 'rating': '4.6', 'price': 'Rs 200', 'image': 'assets/images/kabab.jpg'},
    {'name': 'Samosa (4 pcs)', 'restaurant': 'FoodOS Kitchen', 'rating': '4.7', 'price': 'Rs 80', 'image': 'assets/images/samosa.jpg'},
    {'name': 'Gulab Jamun', 'restaurant': 'Sweet Corner', 'rating': '4.9', 'price': 'Rs 120', 'image': 'assets/images/gulab_jamun.jpg'},
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _onRefresh() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Favorites')),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: AppColors.primary,
        backgroundColor: AppColors.surface,
        child: _isLoading
            ? ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: 5,
                itemBuilder: (context, index) => const ShimmerCard(),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _favorites.length,
                itemBuilder: (context, index) {
                  final item = _favorites[index];
                  return GestureDetector(
                    onTap: () => context.push('/customer/food-detail', extra: item),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.borderLight, width: 1),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(item['image']!, width: 72, height: 72, fit: BoxFit.cover),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item['name']!, style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                                const SizedBox(height: 2),
                                Text(item['restaurant']!, style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textHint)),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(Icons.star_rounded, size: 14, color: Color(0xFFFFB27A)),
                                    const SizedBox(width: 2),
                                    Text(item['rating']!, style: TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Text(item['price']!, style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.primary)),
                              const SizedBox(height: 8),
                              Icon(Icons.favorite, color: AppColors.error, size: 20),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
