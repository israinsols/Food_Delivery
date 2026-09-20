import 'package:flutter/material.dart';
import 'package:foodos/core/theme/app_colors.dart';

class TaxSettingsScreen extends StatefulWidget {
  const TaxSettingsScreen({super.key});

  @override
  State<TaxSettingsScreen> createState() => _TaxSettingsScreenState();
}

class _TaxSettingsScreenState extends State<TaxSettingsScreen> {
  bool _gstEnabled = true;
  double _gstRate = 17.0;
  bool _serviceChargeEnabled = true;
  double _serviceChargeRate = 10.0;
  bool _inclusiveTax = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Tax Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection('GST / Sales Tax', [
            _buildSwitchTile('Enable GST', 'Apply GST on sales', _gstEnabled, (v) => setState(() => _gstEnabled = v)),
            if (_gstEnabled) ...[
              const SizedBox(height: 12),
              _buildSliderTile('GST Rate', _gstRate, '%', (v) => setState(() => _gstRate = v)),
            ],
          ]),
          const SizedBox(height: 16),
          _buildSection('Service Charge', [
            _buildSwitchTile('Enable Service Charge', 'Auto-add service charge', _serviceChargeEnabled, (v) => setState(() => _serviceChargeEnabled = v)),
            if (_serviceChargeEnabled) ...[
              const SizedBox(height: 12),
              _buildSliderTile('Service Charge Rate', _serviceChargeRate, '%', (v) => setState(() => _serviceChargeRate = v)),
            ],
          ]),
          const SizedBox(height: 16),
          _buildSection('Tax Inclusive', [
            _buildSwitchTile('Tax Inclusive Pricing', 'Prices include tax', _inclusiveTax, (v) => setState(() => _inclusiveTax = v)),
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

  Widget _buildSliderTile(String label, double value, String suffix, ValueChanged<double> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.textSecondary)),
              Text('${value.toStringAsFixed(1)}$suffix', style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary)),
            ],
          ),
          Slider(
            value: value,
            min: 0,
            max: 30,
            divisions: 60,
            activeColor: AppColors.primary,
            inactiveColor: AppColors.borderLight,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
