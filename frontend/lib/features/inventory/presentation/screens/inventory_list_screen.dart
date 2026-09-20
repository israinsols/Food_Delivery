import 'package:flutter/material.dart';
import 'package:foodos/core/theme/app_colors.dart';
import 'package:foodos/core/widgets/gradient_text.dart';
import 'package:foodos/core/widgets/shimmer_loading.dart';
import 'package:foodos/core/widgets/status_badge.dart';
import 'package:go_router/go_router.dart';

class InventoryListScreen extends StatefulWidget {
  const InventoryListScreen({super.key});

  @override
  State<InventoryListScreen> createState() => _InventoryListScreenState();
}

class _InventoryListScreenState extends State<InventoryListScreen> {
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

  final List<Map<String, dynamic>> _inventoryItems = [
    {'name': 'Chicken', 'unit': 'kg', 'stock': 8, 'minStock': 5, 'cost': 800, 'status': 'ok'},
    {'name': 'Rice (Basmati)', 'unit': 'kg', 'stock': 15, 'minStock': 10, 'cost': 200, 'status': 'ok'},
    {'name': 'Cooking Oil', 'unit': 'L', 'stock': 3, 'minStock': 5, 'cost': 400, 'status': 'low'},
    {'name': 'Onions', 'unit': 'kg', 'stock': 4, 'minStock': 3, 'cost': 100, 'status': 'ok'},
    {'name': 'Tomatoes', 'unit': 'kg', 'stock': 2, 'minStock': 3, 'cost': 150, 'status': 'low'},
    {'name': 'Spices Mix', 'unit': 'kg', 'stock': 1, 'minStock': 2, 'cost': 500, 'status': 'low'},
  ];

  List<Map<String, dynamic>> get _filteredItems {
    return _inventoryItems
        .where((item) => item['name'].toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/inventory/add-item'),
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
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextField(
                      onChanged: (value) => setState(() => _searchQuery = value),
                      decoration: InputDecoration(
                        hintText: 'Search inventory...',
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
                  if (_inventoryItems.any((i) => i['status'] == 'low'))
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.borderLight, width: 1),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: AppColors.glowRed,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.warning_amber, color: AppColors.error, size: 16),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '${_inventoryItems.where((i) => i['status'] == 'low').length} items below minimum stock',
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppColors.error,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = _filteredItems[index];
                        final isLow = item['status'] == 'low';
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.borderLight, width: 1),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  gradient: isLow
                                      ? null
                                      : const LinearGradient(
                                          colors: [AppColors.gradientButtonStart, AppColors.gradientButtonEnd],
                                        ),
                                  color: isLow ? AppColors.glowRed : null,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.inventory_2_outlined,
                                  color: isLow ? AppColors.error : Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['name'],
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Min: ${item['minStock']} ${item['unit']} â€¢ Rs ${item['cost']}/${item['unit']}',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 12,
                                        color: AppColors.textHint,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  isLow
                                      ? GradientText(
                                          text: '${item['stock']} ${item['unit']}',
                                          colors: [AppColors.gradientStart, AppColors.error],
                                          style: const TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        )
                                      : Text(
                                          '${item['stock']} ${item['unit']}',
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                  const SizedBox(height: 4),
                                  StatusBadge(
                                    label: isLow ? 'Low Stock' : 'In Stock',
                                    color: isLow ? AppColors.error : AppColors.success,
                                    isSmall: true,
                                  ),
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
      ),
    );
  }
}
