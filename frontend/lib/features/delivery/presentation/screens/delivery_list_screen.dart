import 'package:flutter/material.dart';
import 'package:foodos/core/theme/app_colors.dart';
import 'package:foodos/core/widgets/shimmer_loading.dart';
import 'package:go_router/go_router.dart';

class DeliveryListScreen extends StatefulWidget {
  const DeliveryListScreen({super.key});

  @override
  State<DeliveryListScreen> createState() => _DeliveryListScreenState();
}

class _DeliveryListScreenState extends State<DeliveryListScreen> {
  String _selectedStatus = 'All';
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

  final _statuses = ['All', 'Pending', 'Assigned', 'Picked Up', 'On the Way', 'Delivered', 'Cancelled'];

  final List<Map<String, dynamic>> _deliveries = [
    {
      'id': 'DEL-001',
      'orderId': 'ORD-045',
      'customer': 'Ahmed Khan',
      'phone': '0300-1234567',
      'address': 'House 12, Street 4, DHA Phase 5',
      'rider': 'Hamza Ali',
      'status': 'On the Way',
      'total': 950,
      'deliveryFee': 100,
      'time': '12 min ago',
      'items': ['Chicken Biryani x2', 'Lassi x1'],
    },
    {
      'id': 'DEL-002',
      'orderId': 'ORD-046',
      'customer': 'Fatima Noor',
      'phone': '0321-7654321',
      'address': 'Apartment 3B, Gulberg Heights',
      'rider': 'Unassigned',
      'status': 'Pending',
      'total': 1200,
      'deliveryFee': 150,
      'time': '5 min ago',
      'items': ['Seekh Kabab x3', 'Naan x4', 'Cold Drink x2'],
    },
    {
      'id': 'DEL-003',
      'orderId': 'ORD-044',
      'customer': 'Usman Raza',
      'phone': '0333-9876543',
      'address': 'Office 201, MM Alam Road',
      'rider': 'Bilal Khan',
      'status': 'Delivered',
      'total': 660,
      'deliveryFee': 80,
      'time': '1 hour ago',
      'items': ['Samosa x4', 'Cold Drink x2'],
    },
    {
      'id': 'DEL-004',
      'orderId': 'ORD-043',
      'customer': 'Sara Malik',
      'phone': '0345-1112233',
      'address': 'House 5, Cavalry Ground',
      'rider': 'Hamza Ali',
      'status': 'Picked Up',
      'total': 1450,
      'deliveryFee': 120,
      'time': '18 min ago',
      'items': ['Chicken Biryani x1', 'Gulab Jamun x4', 'Naan x2'],
    },
    {
      'id': 'DEL-005',
      'orderId': 'ORD-042',
      'customer': 'Hassan Javed',
      'phone': '0300-5556677',
      'address': 'Flat 8, Liberty Market',
      'rider': 'Unassigned',
      'status': 'Cancelled',
      'total': 480,
      'deliveryFee': 80,
      'time': '2 hours ago',
      'items': ['Pakora x2', 'Lassi x2'],
    },
  ];

  List<Map<String, dynamic>> get _filteredDeliveries {
    if (_selectedStatus == 'All') return _deliveries;
    return _deliveries.where((d) => d['status'] == _selectedStatus).toList();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending': return AppColors.warning;
      case 'Assigned': return AppColors.info;
      case 'Picked Up': return const Color(0xFF7B61FF);
      case 'On the Way': return AppColors.primary;
      case 'Delivered': return AppColors.success;
      case 'Cancelled': return AppColors.error;
      default: return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Deliveries'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delivery_dining_outlined),
            onPressed: () => context.push('/delivery/riders'),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/delivery/settings'),
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
                  // Status filter
                  SizedBox(
                    height: 44,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: _statuses.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final status = _statuses[index];
                        final isSelected = _selectedStatus == status;
                        final count = status == 'All'
                            ? _deliveries.length
                            : _deliveries.where((d) => d['status'] == status).length;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedStatus = status),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              gradient: isSelected
                                  ? LinearGradient(colors: [AppColors.gradientButtonStart, AppColors.gradientButtonEnd])
                                  : null,
                              color: isSelected ? null : AppColors.surface,
                              borderRadius: BorderRadius.circular(20),
                              border: isSelected ? null : Border.all(color: AppColors.borderLight, width: 1),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  status,
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 12,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                    color: isSelected ? Colors.white : AppColors.textSecondary,
                                  ),
                                ),
                                if (count > 0) ...[
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                    decoration: BoxDecoration(
                                      color: isSelected ? Colors.white.withValues(alpha: 0.25) : AppColors.primary.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '$count',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: isSelected ? Colors.white : AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Delivery list
                  Expanded(
                    child: _filteredDeliveries.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.delivery_dining_outlined, size: 48, color: AppColors.textHint),
                                SizedBox(height: 12),
                                Text('No deliveries found', style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.textHint)),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: _filteredDeliveries.length,
                            itemBuilder: (context, index) {
                              final delivery = _filteredDeliveries[index];
                              return _buildDeliveryCard(delivery);
                            },
                          ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildDeliveryCard(Map<String, dynamic> delivery) {
    final statusColor = _getStatusColor(delivery['status']);
    final isAssigned = delivery['rider'] != 'Unassigned';

    return GestureDetector(
      onTap: () => context.push('/delivery/${delivery['id']}'),
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
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.delivery_dining, color: statusColor, size: 18),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(delivery['id'], style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                        Text(delivery['orderId'], style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textHint)),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(delivery['status'], style: TextStyle(fontFamily: 'Inter', fontSize: 10, fontWeight: FontWeight.w600, color: statusColor)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Customer + Address
            Row(
              children: [
                Icon(Icons.person_outline, size: 14, color: AppColors.textHint),
                const SizedBox(width: 6),
                Expanded(child: Text(delivery['customer'], style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis)),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.location_on_outlined, size: 14, color: AppColors.textHint),
                const SizedBox(width: 6),
                Expanded(child: Text(delivery['address'], style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis)),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.two_wheeler, size: 14, color: AppColors.textHint),
                const SizedBox(width: 6),
                Text(
                  isAssigned ? delivery['rider'] : 'No rider assigned',
                  style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: isAssigned ? AppColors.textPrimary : AppColors.warning, fontWeight: isAssigned ? FontWeight.w500 : FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Order Total', style: TextStyle(fontFamily: 'Inter', fontSize: 10, color: AppColors.textHint)),
                      Text('Rs ${delivery['total']}', style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Delivery Fee', style: TextStyle(fontFamily: 'Inter', fontSize: 10, color: AppColors.textHint)),
                      Text('Rs ${delivery['deliveryFee']}', style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Items', style: TextStyle(fontFamily: 'Inter', fontSize: 10, color: AppColors.textHint)),
                      Text('${(delivery['items'] as List).length} items', style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
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
