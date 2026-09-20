import 'package:flutter/material.dart';
import 'package:foodos/core/theme/app_colors.dart';

class DeliveryDetailScreen extends StatefulWidget {
  final String deliveryId;
  const DeliveryDetailScreen({super.key, required this.deliveryId});

  @override
  State<DeliveryDetailScreen> createState() => _DeliveryDetailScreenState();
}

class _DeliveryDetailScreenState extends State<DeliveryDetailScreen> {
  String _currentStatus = 'Assigned';

  final _statusSteps = ['Pending', 'Assigned', 'Picked Up', 'On the Way', 'Delivered'];

  @override
  void initState() {
    super.initState();
    _currentStatus = 'Assigned';
  }

  int get _currentStep => _statusSteps.indexOf(_currentStatus);

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending': return AppColors.warning;
      case 'Assigned': return AppColors.info;
      case 'Picked Up': return const Color(0xFF7B61FF);
      case 'On the Way': return AppColors.primary;
      case 'Delivered': return AppColors.success;
      default: return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.deliveryId),
        actions: [
          PopupMenuButton<String>(
            onSelected: (v) {},
            icon: const Icon(Icons.more_vert),
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'cancel', child: Text('Cancel Delivery')),
              const PopupMenuItem(value: 'call', child: Text('Call Customer')),
              const PopupMenuItem(value: 'call_rider', child: Text('Call Rider')),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Status Tracker
          _buildStatusTracker(),
          const SizedBox(height: 20),

          // Customer Info
          _buildSection('Customer Details', [
            _buildInfoRow(Icons.person_outline, 'Name', 'Ahmed Khan'),
            _buildInfoRow(Icons.phone_outlined, 'Phone', '0300-1234567'),
            _buildInfoRow(Icons.location_on_outlined, 'Address', 'House 12, Street 4, DHA Phase 5, Lahore'),
          ]),
          const SizedBox(height: 16),

          // Rider Info
          _buildSection('Rider', [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [AppColors.gradientButtonStart, AppColors.gradientButtonEnd]),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(child: Text('H', style: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white))),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hamza Ali', style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                      Text('0311-1234567', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textHint)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(6)),
                  child: Text('Online', style: TextStyle(fontFamily: 'Inter', fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.success)),
                ),
              ],
            ),
          ]),
          const SizedBox(height: 16),

          // Order Items
          _buildSection('Order Items', [
            _buildOrderItem('Chicken Biryani x2', 'Rs 600'),
            _buildOrderItem('Lassi x1', 'Rs 100'),
          ]),
          const SizedBox(height: 16),

          // Payment Summary
          _buildSection('Payment', [
            _buildPaymentRow('Subtotal', 'Rs 700'),
            _buildPaymentRow('Delivery Fee', 'Rs 100'),
            _buildPaymentRow('Tax', 'Rs 70'),
            Container(height: 1, color: AppColors.borderLight),
            _buildPaymentRow('Total', 'Rs 870', isBold: true),
          ]),
          const SizedBox(height: 20),

          // Action Buttons
          if (_currentStatus != 'Delivered')
            Row(
              children: [
                if (_currentStep < _statusSteps.length - 1)
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _currentStatus = _statusSteps[_currentStep + 1];
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [AppColors.gradientButtonStart, AppColors.gradientButtonEnd]),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))],
                        ),
                        child: Center(
                          child: Text('Mark as ${_statusSteps[_currentStep + 1]}', style: const TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildStatusTracker() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderLight, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('DELIVERY STATUS', style: TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textHint, letterSpacing: 1.2)),
          const SizedBox(height: 16),
          ...List.generate(_statusSteps.length, (index) {
            final step = _statusSteps[index];
            final isActive = index <= _currentStep;
            final isCurrent = index == _currentStep;
            final color = _getStatusColor(step);

            return Row(
              children: [
                Column(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: isActive ? color : AppColors.borderLight,
                        shape: BoxShape.circle,
                        border: isCurrent ? Border.all(color: color, width: 3) : null,
                        boxShadow: isCurrent ? [BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 8)] : null,
                      ),
                      child: Center(
                        child: isActive
                            ? const Icon(Icons.check, size: 12, color: Colors.white)
                            : Text('${index + 1}', style: TextStyle(fontFamily: 'Inter', fontSize: 10, color: AppColors.textHint)),
                      ),
                    ),
                    if (index < _statusSteps.length - 1)
                      Container(width: 2, height: 24, color: isActive ? color : AppColors.borderLight),
                  ],
                ),
                const SizedBox(width: 12),
                Text(
                  step,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                    color: isActive ? AppColors.textPrimary : AppColors.textHint,
                  ),
                ),
                if (isCurrent) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(4)),
                    child: Text('Current', style: TextStyle(fontFamily: 'Inter', fontSize: 9, fontWeight: FontWeight.w600, color: color)),
                  ),
                ],
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title.toUpperCase(), style: TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textHint, letterSpacing: 1.2)),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.borderLight, width: 1)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.textHint),
          const SizedBox(width: 10),
          Text('$label: ', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textHint)),
          Expanded(child: Text(value, style: TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textPrimary))),
        ],
      ),
    );
  }

  Widget _buildOrderItem(String name, String price) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.textPrimary)),
          Text(price, style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildPaymentRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontFamily: 'Inter', fontSize: isBold ? 14 : 13, fontWeight: isBold ? FontWeight.w700 : FontWeight.w500, color: AppColors.textPrimary)),
          Text(value, style: TextStyle(fontFamily: 'Inter', fontSize: isBold ? 14 : 13, fontWeight: isBold ? FontWeight.w700 : FontWeight.w600, color: isBold ? AppColors.primary : AppColors.textSecondary)),
        ],
      ),
    );
  }
}
