import 'package:flutter/material.dart';
import 'package:foodos/core/theme/app_colors.dart';
import 'package:foodos/core/widgets/shimmer_loading.dart';

class BranchesScreen extends StatefulWidget {
  const BranchesScreen({super.key});

  @override
  State<BranchesScreen> createState() => _BranchesScreenState();
}

class _BranchesScreenState extends State<BranchesScreen> {
  bool _isLoading = true;

  final List<Map<String, dynamic>> _branches = [
    {'name': 'Main Branch', 'address': 'Main Boulevard, Gulberg III, Lahore', 'phone': '+92 300 1234567', 'orders': 156, 'revenue': 'Rs 1.8L', 'isMain': true},
    {'name': 'DHA Branch', 'address': 'Phase 5, DHA, Lahore', 'phone': '+92 301 9876543', 'orders': 89, 'revenue': 'Rs 92K', 'isMain': false},
    {'name': 'Gulberg Branch', 'address': 'Main Market, Gulberg II, Lahore', 'phone': '+92 302 4567890', 'orders': 67, 'revenue': 'Rs 68K', 'isMain': false},
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

  void _showAddBranchSheet() {
    final nameController = TextEditingController();
    final addressController = TextEditingController();
    final phoneController = TextEditingController();
    final cityController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setSheetState) => Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: AppColors.borderLight, borderRadius: BorderRadius.circular(2)),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Add New Branch', style: TextStyle(fontFamily: 'Inter', fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                    GestureDetector(
                      onTap: () => Navigator.pop(ctx),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(8)),
                        child: Icon(Icons.close, size: 18, color: AppColors.textSecondary),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(height: 1, color: AppColors.borderLight),
              // Form
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Branch Name
                        Text('Branch Name', style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: nameController,
                          style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.textPrimary),
                          decoration: _inputDecoration('e.g. DHA Branch'),
                          validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                        ),
                        const SizedBox(height: 20),

                        // Address
                        Text('Address', style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: addressController,
                          style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.textPrimary),
                          decoration: _inputDecoration('Full address'),
                          validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                        ),
                        const SizedBox(height: 20),

                        // City
                        Text('City', style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: cityController,
                          style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.textPrimary),
                          decoration: _inputDecoration('e.g. Lahore'),
                          validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                        ),
                        const SizedBox(height: 20),

                        // Phone
                        Text('Phone Number', style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.textPrimary),
                          decoration: _inputDecoration('+92 300 1234567'),
                          validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                        ),
                        const SizedBox(height: 20),

                        // Operating Hours
                        Text('Operating Hours', style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.borderLight, width: 1),
                          ),
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               Text('9:00 AM - 11:00 PM', style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.textPrimary)),
                               Icon(Icons.access_time, color: AppColors.textHint, size: 20),
                             ],
                           ),
                        ),
                        const SizedBox(height: 20),

                        // Services
                        Text('Services', style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _buildServiceChip('Dine-In', true),
                            _buildServiceChip('Takeaway', true),
                            _buildServiceChip('Delivery', true),
                            _buildServiceChip('Catering', false),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Make Main Branch
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.borderLight, width: 1),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Make Main Branch', style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                                  SizedBox(height: 2),
                                  Text('Primary branch for operations', style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textHint)),
                                ],
                              ),
                              Switch(
                                value: false,
                                onChanged: (v) {},
                                activeColor: AppColors.primary,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Submit button
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 20, offset: const Offset(0, -5))],
                ),
                child: GestureDetector(
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      setState(() {
                        _branches.add({
                          'name': nameController.text,
                          'address': '${addressController.text}, ${cityController.text}',
                          'phone': phoneController.text,
                          'orders': 0,
                          'revenue': 'Rs 0',
                          'isMain': false,
                        });
                      });
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${nameController.text} added successfully'),
                          backgroundColor: AppColors.success,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [AppColors.gradientButtonStart, AppColors.gradientButtonEnd]),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4))],
                    ),
                    child: const Center(
                      child: Text('Add Branch', style: TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.textHint),
      filled: true,
      fillColor: AppColors.background,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  Widget _buildServiceChip(String label, bool initial) {
    bool isSelected = initial;
    return StatefulBuilder(
      builder: (context, setChipState) {
        return GestureDetector(
          onTap: () => setChipState(() => isSelected = !isSelected),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : AppColors.background,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: isSelected ? AppColors.primary : AppColors.borderLight, width: 1),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Branches')),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [AppColors.gradientButtonStart, AppColors.gradientButtonEnd]),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: FloatingActionButton(
          onPressed: _showAddBranchSheet,
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.add, color: Colors.white),
        ),
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
                itemCount: _branches.length,
                itemBuilder: (context, index) {
                  final branch = _branches[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildBranchCard(
                      name: branch['name'],
                      address: branch['address'],
                      phone: branch['phone'],
                      orders: branch['orders'],
                      revenue: branch['revenue'],
                      isMain: branch['isMain'],
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget _buildBranchCard({
    required String name,
    required String address,
    required String phone,
    required int orders,
    required String revenue,
    required bool isMain,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isMain ? AppColors.primary.withValues(alpha: 0.3) : AppColors.borderLight, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.location_city_outlined, color: AppColors.primary, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(name, style: TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                        if (isMain) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [AppColors.gradientButtonStart, AppColors.gradientButtonEnd]),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text('MAIN', style: TextStyle(fontFamily: 'Inter', fontSize: 9, fontWeight: FontWeight.w700, color: Colors.white)),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(address, style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textHint)),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: AppColors.textHint, size: 18),
                color: AppColors.surface,
                onSelected: (value) {
                  if (value == 'delete') {
                    setState(() => _branches.removeWhere((b) => b['name'] == name));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('$name removed'),
                        backgroundColor: AppColors.error,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    );
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'edit', child: Text('Edit', style: TextStyle(fontFamily: 'Inter', fontSize: 13))),
                  const PopupMenuItem(value: 'set_main', child: Text('Set as Main', style: TextStyle(fontFamily: 'Inter', fontSize: 13))),
                  PopupMenuItem(value: 'delete', child: Text('Delete', style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.error))),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStat('Orders', '$orders'),
                Container(width: 1, height: 24, color: AppColors.borderLight),
                _buildStat('Revenue', revenue),
                Container(width: 1, height: 24, color: AppColors.borderLight),
                _buildStat('Phone', phone),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(fontFamily: 'Inter', fontSize: 10, color: AppColors.textHint)),
      ],
    );
  }
}
