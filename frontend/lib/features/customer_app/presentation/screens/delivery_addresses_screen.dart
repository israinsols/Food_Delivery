import 'package:flutter/material.dart';
import 'package:foodos/core/theme/app_colors.dart';
import 'package:foodos/core/widgets/shimmer_loading.dart';

class DeliveryAddressesScreen extends StatefulWidget {
  const DeliveryAddressesScreen({super.key});

  @override
  State<DeliveryAddressesScreen> createState() => _DeliveryAddressesScreenState();
}

class _DeliveryAddressesScreenState extends State<DeliveryAddressesScreen> {
  bool _isLoading = true;

  final _addresses = [
    {'label': 'Home', 'address': 'House 12, Street 4, DHA Phase 5', 'detail': 'Lahore, Pakistan', 'isDefault': true, 'icon': Icons.home_outlined},
    {'label': 'Office', 'address': 'Floor 3, Tech Hub Building', 'detail': 'Gulberg III, Lahore', 'isDefault': false, 'icon': Icons.work_outline},
    {'label': 'Other', 'address': 'Plot 45, Main Boulevard', 'detail': 'Liberty Market, Lahore', 'isDefault': false, 'icon': Icons.location_on_outlined},
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
      appBar: AppBar(title: const Text('Delivery Addresses')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Add address form coming soon!'),
              backgroundColor: AppColors.primary,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: AppColors.primary,
        backgroundColor: AppColors.surface,
        child: _isLoading
            ? ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: 4,
                itemBuilder: (context, index) => const ShimmerCard(),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _addresses.length,
                itemBuilder: (context, index) {
                  final addr = _addresses[index];
                  final isDefault = addr['isDefault'] as bool;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isDefault ? AppColors.primary : AppColors.borderLight,
                        width: isDefault ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(addr['icon'] as IconData, color: AppColors.primary, size: 22),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(addr['label'] as String, style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                                  if (isDefault) ...[
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                                      child: Text('DEFAULT', style: TextStyle(fontFamily: 'Inter', fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.primary)),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(addr['address'] as String, style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textSecondary)),
                              Text(addr['detail'] as String, style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textHint)),
                            ],
                          ),
                        ),
                        PopupMenuButton<String>(
                          icon: Icon(Icons.more_vert, color: AppColors.textHint, size: 18),
                          color: AppColors.surface,
                          onSelected: (value) {
                            if (value == 'edit') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Edit address coming soon!'), backgroundColor: AppColors.primary),
                              );
                            } else if (value == 'delete') {
                              setState(() => _addresses.removeAt(index));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Address deleted'), backgroundColor: AppColors.error),
                              );
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(value: 'edit', child: Text('Edit', style: TextStyle(fontFamily: 'Inter', fontSize: 13))),
                            PopupMenuItem(value: 'delete', child: Text('Delete', style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.error))),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
