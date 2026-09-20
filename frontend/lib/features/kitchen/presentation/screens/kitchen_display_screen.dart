import 'package:flutter/material.dart';
import 'package:foodos/core/theme/app_colors.dart';

class KitchenDisplayScreen extends StatefulWidget {
  const KitchenDisplayScreen({super.key});

  @override
  State<KitchenDisplayScreen> createState() => _KitchenDisplayScreenState();
}

class _KitchenDisplayScreenState extends State<KitchenDisplayScreen> {
  int _selectedTab = 0;

  final List<Map<String, dynamic>> _orders = [
    {
      'id': 'ORD-001',
      'table': 'Table 5',
      'type': 'Dine-in',
      'time': '12:30 PM',
      'items': [
        {'name': 'Chicken Biryani', 'qty': 2, 'notes': 'Extra spicy'},
        {'name': 'Naan', 'qty': 4, 'notes': ''},
      ],
      'status': 'pending',
    },
    {
      'id': 'ORD-002',
      'table': 'Takeaway',
      'type': 'Takeaway',
      'time': '12:35 PM',
      'items': [
        {'name': 'Seekh Kabab', 'qty': 3, 'notes': ''},
        {'name': 'Cold Drink', 'qty': 2, 'notes': ''},
      ],
      'status': 'preparing',
    },
    {
      'id': 'ORD-003',
      'table': 'Table 2',
      'type': 'Dine-in',
      'time': '12:40 PM',
      'items': [
        {'name': 'Samosa', 'qty': 4, 'notes': ''},
        {'name': 'Lassi', 'qty': 2, 'notes': 'Less sugar'},
      ],
      'status': 'ready',
    },
  ];

  void _updateStatus(int index, String newStatus) {
    setState(() {
      _orders[index]['status'] = newStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    final pendingOrders = _orders.where((o) => o['status'] == 'pending').toList();
    final preparingOrders = _orders.where((o) => o['status'] == 'preparing').toList();
    final readyOrders = _orders.where((o) => o['status'] == 'ready').toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kitchen Display'),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.success.withValues(alpha: 0.3), width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  'Online',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: isMobile ? _buildMobileLayout(pendingOrders, preparingOrders, readyOrders) : _buildDesktopLayout(pendingOrders, preparingOrders, readyOrders),
    );
  }

  Widget _buildMobileLayout(List<Map<String, dynamic>> pending, List<Map<String, dynamic>> preparing, List<Map<String, dynamic>> ready) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border(bottom: BorderSide(color: AppColors.borderLight, width: 1)),
          ),
          child: Row(
            children: [
              _TabButton(
                label: 'Pending',
                count: pending.length,
                color: AppColors.orderPending,
                isSelected: _selectedTab == 0,
                onTap: () => setState(() => _selectedTab = 0),
              ),
              _TabButton(
                label: 'Preparing',
                count: preparing.length,
                color: AppColors.orderPreparing,
                isSelected: _selectedTab == 1,
                onTap: () => setState(() => _selectedTab = 1),
              ),
              _TabButton(
                label: 'Ready',
                count: ready.length,
                color: AppColors.orderReady,
                isSelected: _selectedTab == 2,
                onTap: () => setState(() => _selectedTab = 2),
              ),
            ],
          ),
        ),
        Expanded(
          child: _buildOrdersList(
            _selectedTab == 0 ? pending : _selectedTab == 1 ? preparing : ready,
            _selectedTab == 0 ? AppColors.orderPending : _selectedTab == 1 ? AppColors.orderPreparing : AppColors.orderReady,
            _selectedTab == 0 ? 'pending' : _selectedTab == 1 ? 'preparing' : 'ready',
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(List<Map<String, dynamic>> pending, List<Map<String, dynamic>> preparing, List<Map<String, dynamic>> ready) {
    return Row(
      children: [
        _buildColumn('Pending', AppColors.orderPending, pending, 'pending'),
        _buildColumn('Preparing', AppColors.orderPreparing, preparing, 'preparing'),
        _buildColumn('Ready', AppColors.orderReady, ready, 'ready'),
      ],
    );
  }

  Widget _buildOrdersList(List<Map<String, dynamic>> orders, Color color, String status) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline, size: 48, color: color.withValues(alpha: 0.3)),
            const SizedBox(height: 12),
            Text(
              'No $status orders',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return _KitchenOrderCard(
          order: order,
          color: color,
          onNextStatus: status == 'pending'
              ? () {
                  final idx = _orders.indexOf(order);
                  _updateStatus(idx, 'preparing');
                }
              : status == 'preparing'
                  ? () {
                      final idx = _orders.indexOf(order);
                      _updateStatus(idx, 'ready');
                    }
                  : null,
        );
      },
    );
  }

  Widget _buildColumn(String title, Color color, List<Map<String, dynamic>> orders, String status) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border(right: BorderSide(color: AppColors.borderLight, width: 1)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.08),
                border: Border(bottom: BorderSide(color: color.withValues(alpha: 0.2), width: 1)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${orders.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Inter',
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: orders.isEmpty
                  ? Center(
                      child: Text(
                        'No orders',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: AppColors.textHint,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        final order = orders[index];
                        return _KitchenOrderCard(
                          order: order,
                          color: color,
                          onNextStatus: status == 'pending'
                              ? () => _updateStatus(_orders.indexOf(order), 'preparing')
                              : status == 'preparing'
                                  ? () => _updateStatus(_orders.indexOf(order), 'ready')
                                  : null,
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

class _TabButton extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.count,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? color : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? color : AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected ? color : AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _KitchenOrderCard extends StatelessWidget {
  final Map<String, dynamic> order;
  final Color color;
  final VoidCallback? onNextStatus;

  const _KitchenOrderCard({
    required this.order,
    required this.color,
    this.onNextStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  order['id'],
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  order['table'],
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${order['type']} • ${order['time']}',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              color: AppColors.textHint,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Divider(height: 1, color: AppColors.borderLight),
          ),
          ...order['items'].map<Widget>((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.gradientButtonStart, AppColors.gradientButtonEnd],
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: Text(
                        '${item['qty']}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['name'],
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        if (item['notes'].isNotEmpty)
                          Text(
                            item['notes'],
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 11,
                              color: AppColors.warning,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
          if (onNextStatus != null)
            const SizedBox(height: 4),
          if (onNextStatus != null)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onNextStatus,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
                child: Text(
                  order['status'] == 'pending' ? 'Start Preparing' : 'Mark Ready',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
