import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:foodos/core/theme/app_colors.dart';
import 'package:foodos/core/widgets/shimmer_loading.dart';

class MenuListScreen extends StatefulWidget {
  const MenuListScreen({super.key});

  @override
  State<MenuListScreen> createState() => _MenuListScreenState();
}

class _MenuListScreenState extends State<MenuListScreen> {
  String _selectedCategory = 'All';
  String _searchQuery = '';
  bool _isLoading = true;

  Future<void> _loadData() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _onRefresh() async {
    setState(() => _isLoading = true);
    await _loadData();
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  final List<Map<String, dynamic>> _menuItems = [
    {
      'id': '1',
      'name': 'Chicken Biryani',
      'category': 'Main Course',
      'price': 300,
      'status': 'active',
      'isFeatured': true,
      'image': 'assets/images/biryani.jpg',
      'rating': 4.8,
      'orders': 324,
    },
    {
      'id': '2',
      'name': 'Seekh Kabab',
      'category': 'Main Course',
      'price': 200,
      'status': 'active',
      'isFeatured': false,
      'image': 'assets/images/kabab.jpg',
      'rating': 4.6,
      'orders': 218,
    },
    {
      'id': '3',
      'name': 'Naan',
      'category': 'Main Course',
      'price': 50,
      'status': 'active',
      'isFeatured': false,
      'image': 'assets/images/naan.jpg',
      'rating': 4.5,
      'orders': 456,
    },
    {
      'id': '4',
      'name': 'Samosa',
      'category': 'Appetizers',
      'price': 80,
      'status': 'active',
      'isFeatured': true,
      'image': 'assets/images/samosa.jpg',
      'rating': 4.7,
      'orders': 189,
    },
    {
      'id': '5',
      'name': 'Cold Drink',
      'category': 'Beverages',
      'price': 60,
      'status': 'inactive',
      'isFeatured': false,
      'image': 'assets/images/cold_drink.jpg',
      'rating': 4.3,
      'orders': 145,
    },
  ];

  List<Map<String, dynamic>> get _filteredItems {
    return _menuItems.where((item) {
      final matchesCategory = _selectedCategory == 'All' || item['category'] == _selectedCategory;
      final matchesSearch = item['name'].toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/menu/add-item'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: AppColors.primary,
        backgroundColor: AppColors.surface,
        child: _isLoading
            ? ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                itemCount: 6,
                itemBuilder: (context, index) => const ShimmerCard(),
              )
            : Column(
                children: [
                  // Search Bar
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextField(
                      onChanged: (value) => setState(() => _searchQuery = value),
                      decoration: InputDecoration(
                        hintText: 'Search menu items...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: AppColors.surfaceVariant,
                      ),
                    ),
                  ),

                  // Category Tabs
                  SizedBox(
                    height: 35,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: ['All', 'Main Course', 'Appetizers', 'Beverages', 'Desserts'].length,
                      separatorBuilder: (_, _) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final cat = ['All', 'Main Course', 'Appetizers', 'Beverages', 'Desserts'][index];
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
                  const SizedBox(height: 8),

                  // Menu Items List
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = _filteredItems[index];
                        return _MenuListItem(
                          item: item,
                          onEdit: () => context.push('/menu/edit-item/${item['id']}'),
                          onToggleStatus: () {
                            setState(() {
                              item['status'] = item['status'] == 'active' ? 'inactive' : 'active';
                            });
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _MenuListItem extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onEdit;
  final VoidCallback onToggleStatus;

  const _MenuListItem({
    required this.item,
    required this.onEdit,
    required this.onToggleStatus,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = item['status'] == 'active';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Image
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(14)),
                child: Image.asset(
                  item['image'] ?? 'assets/images/biryani.jpg',
                  width: 110,
                  height: 110,
                  fit: BoxFit.cover,
                ),
              ),
              if (item['isFeatured'])
                Positioned(
                  top: 8,
                  left: 8,
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
            ],
          ),
          const SizedBox(width: 12),
          // Info
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['name'],
                    style: TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, size: 14, color: Color(0xFFFFB27A)),
                      const SizedBox(width: 2),
                      Text('${item['rating']}', style: TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                      const SizedBox(width: 6),
                      Text('${item['orders']}+ orders', style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textHint)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Rs ${item['price']}',
                        style: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.primary),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isActive ? AppColors.success.withValues(alpha: 0.12) : AppColors.error.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          isActive ? 'Active' : 'Inactive',
                          style: TextStyle(fontFamily: 'Inter', fontSize: 10, fontWeight: FontWeight.w600, color: isActive ? AppColors.success : AppColors.error),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Actions
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit') onEdit();
              if (value == 'toggle') onToggleStatus();
            },
            icon: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.more_vert, size: 18, color: AppColors.textSecondary),
            ),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'edit', child: Text('Edit')),
              PopupMenuItem(value: 'toggle', child: Text(isActive ? 'Deactivate' : 'Activate')),
              const PopupMenuItem(value: 'delete', child: Text('Delete')),
            ],
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}
