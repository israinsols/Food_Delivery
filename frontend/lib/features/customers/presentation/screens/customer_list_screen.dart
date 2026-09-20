import 'package:flutter/material.dart';
import 'package:foodos/core/theme/app_colors.dart';
import 'package:foodos/core/widgets/gradient_text.dart';
import 'package:foodos/core/widgets/shimmer_loading.dart';
import 'package:go_router/go_router.dart';

class CustomerListScreen extends StatefulWidget {
  const CustomerListScreen({super.key});

  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
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

  final List<Map<String, dynamic>> _customers = [
    {
      'name': 'Ahmed Khan',
      'phone': '0300-1234567',
      'totalOrders': 24,
      'totalSpent': 18500,
      'lastOrder': '2 days ago',
    },
    {
      'name': 'Fatima Ali',
      'phone': '0321-7654321',
      'totalOrders': 15,
      'totalSpent': 12000,
      'lastOrder': '1 week ago',
    },
    {
      'name': 'Usman Malik',
      'phone': '0333-9876543',
      'totalOrders': 8,
      'totalSpent': 6400,
      'lastOrder': '3 days ago',
    },
  ];

  List<Map<String, dynamic>> get _filteredCustomers {
    return _customers
        .where((c) => c['name'].toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customers'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_outlined),
            onPressed: () => context.push('/customers/add'),
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
                        hintText: 'Search customers...',
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
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _filteredCustomers.length,
                      itemBuilder: (context, index) {
                        final customer = _filteredCustomers[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.borderLight, width: 1),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [AppColors.gradientButtonStart, AppColors.gradientButtonEnd],
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  customer['name'][0],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            title: Text(
                              customer['name'],
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            subtitle: Text(
                              customer['phone'],
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                color: AppColors.textHint,
                              ),
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                GradientText(
                                  text: 'Rs ${customer['totalSpent']}',
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${customer['totalOrders']} orders',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 11,
                                    color: AppColors.textHint,
                                  ),
                                ),
                              ],
                            ),
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
