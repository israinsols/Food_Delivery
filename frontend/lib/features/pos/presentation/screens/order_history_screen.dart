import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:foodos/core/theme/app_colors.dart';
import 'package:foodos/core/theme/app_text_styles.dart';
import 'package:foodos/core/widgets/status_badge.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  String _selectedStatus = 'All';
  String _searchQuery = '';

  final List<Map<String, dynamic>> _orders = [
    {
      'id': 'ORD-001',
      'table': 'Table 5',
      'type': 'Dine-in',
      'status': 'completed',
      'total': 950,
      'items': 3,
      'time': '12:30 PM',
      'date': 'Today',
      'payment': 'Cash',
    },
    {
      'id': 'ORD-002',
      'table': 'Takeaway',
      'type': 'Takeaway',
      'status': 'completed',
      'total': 660,
      'items': 2,
      'time': '12:35 PM',
      'date': 'Today',
      'payment': 'Card',
    },
    {
      'id': 'ORD-003',
      'table': 'Table 2',
      'type': 'Dine-in',
      'status': 'preparing',
      'total': 380,
      'items': 2,
      'time': '12:40 PM',
      'date': 'Today',
      'payment': '-',
    },
    {
      'id': 'ORD-004',
      'table': 'Table 8',
      'type': 'Dine-in',
      'status': 'cancelled',
      'total': 500,
      'items': 2,
      'time': '11:15 AM',
      'date': 'Today',
      'payment': '-',
    },
    {
      'id': 'ORD-005',
      'table': 'Takeaway',
      'type': 'Takeaway',
      'status': 'completed',
      'total': 1200,
      'items': 4,
      'time': '6:30 PM',
      'date': 'Yesterday',
      'payment': 'Online',
    },
  ];

  List<Map<String, dynamic>> get _filteredOrders {
    return _orders.where((o) {
      final matchesStatus = _selectedStatus == 'All' || o['status'] == _selectedStatus;
      final matchesSearch = o['id'].toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesStatus && matchesSearch;
    }).toList();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed': return AppColors.success;
      case 'preparing': return AppColors.info;
      case 'pending': return AppColors.warning;
      case 'cancelled': return AppColors.error;
      default: return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        actions: [
          IconButton(icon: const Icon(Icons.filter_list), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // Search
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: InputDecoration(
                hintText: 'Search orders...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                filled: true,
                fillColor: AppColors.surfaceVariant,
              ),
            ),
          ),

          // Status Filter
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: ['All', 'pending', 'preparing', 'completed', 'cancelled'].map((s) {
                final isSelected = _selectedStatus == s;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(s == 'All' ? 'All' : s[0].toUpperCase() + s.substring(1)),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _selectedStatus = s),
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(color: isSelected ? Colors.white : AppColors.textPrimary),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),

          // Orders List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filteredOrders.length,
              itemBuilder: (context, index) {
                final order = _filteredOrders[index];
                return GestureDetector(
                  onTap: () => context.push('/orders/${order['id']}'),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: _getStatusColor(order['status']).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            order['type'] == 'Dine-in' ? Icons.restaurant : Icons.takeout_dining,
                            color: _getStatusColor(order['status']),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(order['id'], style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                                  const SizedBox(width: 8),
                                  StatusBadge(label: order['status'], color: _getStatusColor(order['status']), isSmall: true),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text('${order['table']} • ${order['items']} items • ${order['time']}', style: AppTextStyles.caption),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('Rs ${order['total']}', style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w700)),
                            Text(order['payment'], style: AppTextStyles.caption),
                          ],
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
    );
  }
}
