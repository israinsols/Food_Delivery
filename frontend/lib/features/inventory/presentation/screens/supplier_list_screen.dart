import 'package:flutter/material.dart';
import 'package:foodos/core/theme/app_colors.dart';
import 'package:foodos/core/theme/app_text_styles.dart';
import 'package:go_router/go_router.dart';

class SupplierListScreen extends StatelessWidget {
  const SupplierListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final suppliers = [
      {'name': 'Khan Fresh Chicken', 'phone': '0300-1234567', 'items': ['Chicken', 'Mutton'], 'lastOrder': '2 days ago'},
      {'name': 'Basmati Rice Traders', 'phone': '0321-7654321', 'items': ['Rice', 'Flour'], 'lastOrder': '1 week ago'},
      {'name': 'Spice World', 'phone': '0333-9876543', 'items': ['Spices', 'Oil'], 'lastOrder': '3 days ago'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Suppliers'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/inventory/add-supplier'),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: suppliers.length,
        itemBuilder: (context, index) {
          final s = suppliers[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundColor: AppColors.warning.withValues(alpha: 0.1),
                child: Icon(Icons.local_shipping, color: AppColors.warning),
              ),
              title: Text(s['name'] as String, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s['phone'] as String, style: AppTextStyles.caption),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 4,
                    children: (s['items'] as List).map((item) => Chip(
                      label: Text(item, style: TextStyle(fontSize: 10)),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    )).toList(),
                  ),
                ],
              ),
              trailing: const Icon(Icons.chevron_right),
            ),
          );
        },
      ),
    );
  }
}
