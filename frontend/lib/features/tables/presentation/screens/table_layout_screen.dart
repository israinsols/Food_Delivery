import 'package:flutter/material.dart';
import 'package:foodos/core/theme/app_colors.dart';
import 'package:foodos/core/theme/app_text_styles.dart';

class TableLayoutScreen extends StatelessWidget {
  const TableLayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tables = [
      {'number': '1', 'capacity': 2, 'status': 'available'},
      {'number': '2', 'capacity': 4, 'status': 'occupied'},
      {'number': '3', 'capacity': 4, 'status': 'available'},
      {'number': '4', 'capacity': 6, 'status': 'reserved'},
      {'number': '5', 'capacity': 2, 'status': 'occupied'},
      {'number': '6', 'capacity': 8, 'status': 'cleaning'},
      {'number': '7', 'capacity': 4, 'status': 'available'},
      {'number': '8', 'capacity': 2, 'status': 'available'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tables'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Legend
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _LegendItem(color: AppColors.tableAvailable, label: 'Available'),
                _LegendItem(color: AppColors.tableOccupied, label: 'Occupied'),
                _LegendItem(color: AppColors.tableReserved, label: 'Reserved'),
                _LegendItem(color: AppColors.tableCleaning, label: 'Cleaning'),
              ],
            ),
          ),

          // Table Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1,
              ),
              itemCount: tables.length,
              itemBuilder: (context, index) {
                final table = tables[index];
                return _TableCard(table: table);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }
}

class _TableCard extends StatelessWidget {
  final Map<String, dynamic> table;

  const _TableCard({required this.table});

  Color _getStatusColor(String status) {
    switch (status) {
      case 'available':
        return AppColors.tableAvailable;
      case 'occupied':
        return AppColors.tableOccupied;
      case 'reserved':
        return AppColors.tableReserved;
      case 'cleaning':
        return AppColors.tableCleaning;
      default:
        return AppColors.textHint;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(table['status']);
    return Container(
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: statusColor, width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.table_restaurant,
            size: 40,
            color: statusColor,
          ),
          const SizedBox(height: 8),
          Text(
            'Table ${table['number']}',
            style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            '${table['capacity']} seats',
            style: AppTextStyles.caption,
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              table['status'].toString().toUpperCase(),
              style: AppTextStyles.caption.copyWith(
                color: statusColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
