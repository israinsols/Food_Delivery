import 'package:flutter/material.dart';
import 'package:foodos/core/theme/app_colors.dart';

class DeliverySettingsScreen extends StatefulWidget {
  const DeliverySettingsScreen({super.key});

  @override
  State<DeliverySettingsScreen> createState() => _DeliverySettingsScreenState();
}

class _DeliverySettingsScreenState extends State<DeliverySettingsScreen> {
  bool _deliveryEnabled = true;
  bool _autoAssign = true;
  double _deliveryFee = 100;
  double _minOrder = 300;
  double _maxDistance = 5.0;
  String _freeDeliveryThreshold = '1000';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Delivery Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection('General', [
            _buildSwitchTile('Enable Delivery', 'Accept delivery orders', _deliveryEnabled, (v) => setState(() => _deliveryEnabled = v)),
            _buildSwitchTile('Auto-Assign Rider', 'Automatically assign nearest rider', _autoAssign, (v) => setState(() => _autoAssign = v)),
          ]),
          const SizedBox(height: 16),
          _buildSection('Pricing', [
            _buildSliderTile('Delivery Fee', _deliveryFee, 'Rs', (v) => setState(() => _deliveryFee = v), max: 500),
            _buildSliderTile('Minimum Order', _minOrder, 'Rs', (v) => setState(() => _minOrder = v), max: 2000),
          ]),
          const SizedBox(height: 16),
          _buildSection('Coverage', [
            _buildSliderTile('Max Distance', _maxDistance, 'km', (v) => setState(() => _maxDistance = v), max: 20),
          ]),
          const SizedBox(height: 16),
          _buildSection('Promotions', [
            Container(
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderLight, width: 1)),
              child: TextFormField(
                initialValue: _freeDeliveryThreshold,
                keyboardType: TextInputType.number,
                style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.textPrimary),
                decoration: InputDecoration(
                  labelText: 'Free Delivery Threshold (Rs)',
                  labelStyle: TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.textSecondary),
                  prefixIcon: Icon(Icons.local_offer_outlined, color: AppColors.textSecondary, size: 18),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                onChanged: (v) => _freeDeliveryThreshold = v,
              ),
            ),
          ]),
          const SizedBox(height: 32),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [AppColors.gradientButtonStart, AppColors.gradientButtonEnd]),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4))],
              ),
              child: const Center(
                child: Text('Save Settings', style: TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
              ),
            ),
          ),
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
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.borderLight, width: 1)),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: Text(title, style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
      subtitle: Text(subtitle, style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textHint)),
      value: value,
      onChanged: onChanged,
      activeColor: AppColors.primary,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14),
    );
  }

  Widget _buildSliderTile(String label, double value, String suffix, ValueChanged<double> onChanged, {double max = 100}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.textSecondary)),
              Text(
                suffix == 'Rs' ? '${value.toStringAsFixed(0)} $suffix' : '${value.toStringAsFixed(1)} $suffix',
                style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary),
              ),
            ],
          ),
          Slider(
            value: value,
            min: 0,
            max: max,
            divisions: max.toInt(),
            activeColor: AppColors.primary,
            inactiveColor: AppColors.borderLight,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
