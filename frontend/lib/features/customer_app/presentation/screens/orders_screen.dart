import 'package:flutter/material.dart';
import 'package:foodos/core/theme/app_colors.dart';
import 'package:foodos/core/widgets/customer_bottom_nav.dart';
import 'package:foodos/core/widgets/shimmer_loading.dart';
import 'package:go_router/go_router.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool _isLoading = true;

  final _orders = [
    {'id': 'ORD-045', 'items': 'Chicken Biryani x2, Lassi x1', 'total': 700, 'status': 'Delivered', 'date': 'Today, 12:30 PM', 'restaurant': 'FoodOS Kitchen'},
    {'id': 'ORD-042', 'items': 'Seekh Kabab x3, Naan x4', 'total': 1000, 'status': 'Delivered', 'date': 'Yesterday, 8:15 PM', 'restaurant': 'Spice Hub'},
    {'id': 'ORD-038', 'items': 'Samosa x4, Cold Drink x2', 'total': 440, 'status': 'Delivered', 'date': 'Aug 28, 6:00 PM', 'restaurant': 'FoodOS Kitchen'},
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
      bottomNavigationBar: const CustomerBottomNav(currentIndex: 3),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          color: AppColors.primary,
          backgroundColor: AppColors.surface,
          child: _isLoading
              ? ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: 5,
                  itemBuilder: (context, index) => const ShimmerCard(),
                )
              : _orders.isEmpty
                  ? Center(child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.receipt_long_outlined, size: 48, color: AppColors.textHint),
                        SizedBox(height: 12),
                        Text('No orders yet', style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.textHint)),
                      ],
                    ))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _orders.length,
                      itemBuilder: (context, index) {
                        final order = _orders[index];
                        return GestureDetector(
                          onTap: () => context.push('/customer/order-tracking'),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppColors.borderLight, width: 1),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(order['id'] as String, style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                                        Text(order['restaurant'] as String, style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textHint)),
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(6)),
                                      child: Text(order['status'] as String, style: TextStyle(fontFamily: 'Inter', fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.success)),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(order['items'] as String, style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(order['date'] as String, style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textHint)),
                                    Text('Rs ${order['total']}', style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
        ),
      ),
    );
  }
}
