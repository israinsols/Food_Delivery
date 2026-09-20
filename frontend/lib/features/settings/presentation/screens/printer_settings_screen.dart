import 'package:flutter/material.dart';
import 'package:foodos/core/theme/app_colors.dart';

class PrinterSettingsScreen extends StatefulWidget {
  const PrinterSettingsScreen({super.key});

  @override
  State<PrinterSettingsScreen> createState() => _PrinterSettingsScreenState();
}

class _PrinterSettingsScreenState extends State<PrinterSettingsScreen> {
  bool _autoPrint = true;
  bool _printKitchen = true;
  bool _printReceipt = true;
  String _selectedPrinter = 'Default Printer';
  String _paperSize = '80mm';

  final _printers = ['Default Printer', 'Receipt Printer', 'Kitchen Printer', 'Network Printer'];
  final _paperSizes = ['58mm', '80mm', 'A4'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Printer Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection('Printer', [
            _buildDropdown('Active Printer', _selectedPrinter, _printers, (v) => setState(() => _selectedPrinter = v!)),
            const SizedBox(height: 8),
            _buildDropdown('Paper Size', _paperSize, _paperSizes, (v) => setState(() => _paperSize = v!)),
          ]),
          const SizedBox(height: 16),
          _buildSection('Auto Print', [
            _buildSwitchTile('Auto Print Receipt', 'Print after order complete', _autoPrint, (v) => setState(() => _autoPrint = v)),
            _buildSwitchTile('Print to Kitchen', 'Send orders to kitchen printer', _printKitchen, (v) => setState(() => _printKitchen = v)),
            _buildSwitchTile('Print Receipt Copy', 'Auto print receipt copy', _printReceipt, (v) => setState(() => _printReceipt = v)),
          ]),
          const SizedBox(height: 16),
          _buildSection('Connection', [
            Container(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                    child: Icon(Icons.wifi, color: AppColors.success, size: 20),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Connected', style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                        Text('EPSON TM-T88VI', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textHint)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(6)),
                    child: Text('Online', style: TextStyle(fontFamily: 'Inter', fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.success)),
                  ),
                ],
              ),
            ),
          ]),
          const SizedBox(height: 24),
          _buildTestPrintButton(),
          const SizedBox(height: 12),
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

  Widget _buildDropdown(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.textSecondary),
          border: InputBorder.none,
        ),
        items: items.map((i) => DropdownMenuItem(value: i, child: Text(i, style: const TextStyle(fontFamily: 'Inter', fontSize: 14)))).toList(),
        onChanged: onChanged,
      ),
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

  Widget _buildTestPrintButton() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.info.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.info.withValues(alpha: 0.2), width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.print, color: AppColors.info, size: 18),
            SizedBox(width: 8),
            Text('Test Print', style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.info)),
          ],
        ),
      ),
    );
  }
}
