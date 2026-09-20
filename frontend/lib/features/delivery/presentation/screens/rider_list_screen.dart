import 'package:flutter/material.dart';
import 'package:foodos/core/theme/app_colors.dart';
import 'package:foodos/core/widgets/shimmer_loading.dart';
import 'package:go_router/go_router.dart';

class RiderListScreen extends StatefulWidget {
  const RiderListScreen({super.key});

  @override
  State<RiderListScreen> createState() => _RiderListScreenState();
}

class _RiderListScreenState extends State<RiderListScreen> {
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

  final riders = [
    {'name': 'Hamza Ali', 'phone': '0311-1234567', 'status': 'online', 'deliveries': 12, 'rating': 4.8, 'earnings': 'Rs 12,400'},
    {'name': 'Bilal Khan', 'phone': '0322-2345678', 'status': 'online', 'deliveries': 8, 'rating': 4.6, 'earnings': 'Rs 8,200'},
    {'name': 'Faisal Ahmed', 'phone': '0333-3456789', 'status': 'offline', 'deliveries': 15, 'rating': 4.9, 'earnings': 'Rs 15,800'},
    {'name': 'Danish Raza', 'phone': '0344-4567890', 'status': 'busy', 'deliveries': 6, 'rating': 4.5, 'earnings': 'Rs 6,100'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Riders'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/delivery/riders/add'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: AppColors.primary,
        backgroundColor: AppColors.surface,
        child: _isLoading
            ? ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: 6,
                itemBuilder: (context, index) => const ShimmerCard(),
              )
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Summary
                  Row(
                    children: [
                      _buildSummaryCard('Total', '${riders.length}', AppColors.info),
                      const SizedBox(width: 12),
                      _buildSummaryCard('Online', '${riders.where((r) => r['status'] == 'online').length}', AppColors.success),
                      const SizedBox(width: 12),
                      _buildSummaryCard('Busy', '${riders.where((r) => r['status'] == 'busy').length}', AppColors.warning),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Rider list
                  ...riders.map((rider) => _buildRiderCard(rider)),
                ],
              ),
      ),
    );
  }

  Widget _buildSummaryCard(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderLight, width: 1)),
        child: Column(
          children: [
            Text(value, style: TextStyle(fontFamily: 'Inter', fontSize: 20, fontWeight: FontWeight.w800, color: color)),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textHint)),
          ],
        ),
      ),
    );
  }

  Widget _buildRiderCard(Map<String, dynamic> rider) {
    final statusColor = rider['status'] == 'online' ? AppColors.success : rider['status'] == 'busy' ? AppColors.warning : AppColors.textHint;
    final statusText = rider['status'].toString().toUpperCase();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.borderLight, width: 1)),
      child: Column(
        children: [
          Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [AppColors.gradientButtonStart, AppColors.gradientButtonEnd]),
                      shape: BoxShape.circle,
                    ),
                    child: Center(child: Text(rider['name'][0], style: const TextStyle(fontFamily: 'Inter', fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white))),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle, border: Border.all(color: AppColors.surface, width: 2)),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(rider['name'], style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(4)),
                          child: Text(statusText, style: TextStyle(fontFamily: 'Inter', fontSize: 9, fontWeight: FontWeight.w700, color: statusColor)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(rider['phone'], style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textHint)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildRiderStat('Deliveries', '${rider['deliveries']}'),
                Container(width: 1, height: 24, color: AppColors.borderLight),
                _buildRiderStat('Rating', '${rider['rating']}'),
                Container(width: 1, height: 24, color: AppColors.borderLight),
                _buildRiderStat('Earnings', rider['earnings']),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRiderStat(String label, String value) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(fontFamily: 'Inter', fontSize: 10, color: AppColors.textHint)),
      ],
    );
  }
}
