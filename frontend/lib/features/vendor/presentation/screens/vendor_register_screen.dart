import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodos/core/theme/app_colors.dart';
import 'package:foodos/core/models/restaurant_model.dart';
import 'package:foodos/core/providers/restaurant_provider.dart';
import 'package:foodos/features/auth/presentation/providers/auth_provider.dart';
import 'package:go_router/go_router.dart';

class VendorRegisterScreen extends ConsumerStatefulWidget {
  const VendorRegisterScreen({super.key});

  @override
  ConsumerState<VendorRegisterScreen> createState() => _VendorRegisterScreenState();
}

class _VendorRegisterScreenState extends ConsumerState<VendorRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _restaurantNameController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  String _selectedCity = 'Lahore';
  String _selectedCuisine = 'Pakistani';
  bool _isAgreed = false;

  final _cities = ['Lahore', 'Karachi', 'Islamabad', 'Rawalpindi', 'Faisalabad', 'Multan', 'Peshawar'];
  final _cuisines = ['Pakistani', 'Chinese', 'Fast Food', 'Italian', 'Continental', 'BBQ', 'Desserts', 'Mixed'];

  @override
  void dispose() {
    _restaurantNameController.dispose();
    _ownerNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (!_formKey.currentState!.validate() || !_isAgreed) return;

    final id = 'r${DateTime.now().millisecondsSinceEpoch}';
    final restaurant = Restaurant(
      id: id,
      name: _restaurantNameController.text.trim(),
      address: _addressController.text.trim(),
      phone: _phoneController.text.trim(),
      cuisine: _selectedCuisine,
      isOpen: true,
      isFeatured: false,
      categories: [_selectedCuisine],
      menuItems: [],
    );

    ref.read(restaurantsProvider.notifier).addRestaurant(restaurant);

    // Upgrade customer to vendor
    ref.read(authProvider.notifier).becomeVendor();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_restaurantNameController.text} registered! Now add your menu items.'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    context.go('/vendor/menu', extra: id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Register Restaurant')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary.withValues(alpha: 0.1), AppColors.primary.withValues(alpha: 0.03)],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.2), width: 1),
              ),
              child: Column(
                children: [
                  Icon(Icons.storefront, color: AppColors.primary, size: 40),
                  const SizedBox(height: 12),
                  Text('Start Selling on FoodOS', style: TextStyle(fontFamily: 'Inter', fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                  const SizedBox(height: 4),
                  Text('Register your restaurant and reach thousands of customers', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.textHint)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Restaurant Name
            _buildField('Restaurant Name', _restaurantNameController, Icons.store_outlined, 'e.g. FoodOS Kitchen',
                validator: (v) => v == null || v.trim().isEmpty ? 'Restaurant name is required' : null),
            const SizedBox(height: 16),

            // Owner Name
            _buildField('Owner Name', _ownerNameController, Icons.person_outlined, 'Full name',
                validator: (v) => v == null || v.trim().isEmpty ? 'Owner name is required' : null),
            const SizedBox(height: 16),

            // Email
            _buildField('Email', _emailController, Icons.email_outlined, 'restaurant@email.com',
                keyboardType: TextInputType.emailAddress,
                validator: (v) => v == null || !v.contains('@') ? 'Enter valid email' : null),
            const SizedBox(height: 16),

            // Phone
            _buildField('Phone Number', _phoneController, Icons.phone_outlined, '+92 300 1234567',
                keyboardType: TextInputType.phone,
                validator: (v) => v == null || v.trim().isEmpty ? 'Phone number is required' : null),
            const SizedBox(height: 16),

            // City
            Text('City', style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderLight, width: 1)),
              child: DropdownButtonFormField<String>(
                value: _selectedCity,
                dropdownColor: AppColors.surface,
                style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.textPrimary),
                decoration: InputDecoration(prefixIcon: Icon(Icons.location_city_outlined, color: AppColors.textHint, size: 20), border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14)),
                items: _cities.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (v) => setState(() => _selectedCity = v!),
              ),
            ),
            const SizedBox(height: 16),

            // Address
            _buildField('Address', _addressController, Icons.location_on_outlined, 'Full restaurant address',
                validator: (v) => v == null || v.trim().isEmpty ? 'Address is required' : null),
            const SizedBox(height: 16),

            // Cuisine Type
            Text('Cuisine Type', style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _cuisines.map((c) {
                final isSelected = _selectedCuisine == c;
                return GestureDetector(
                  onTap: () => setState(() => _selectedCuisine = c),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: isSelected ? AppColors.primary : AppColors.borderLight, width: 1),
                    ),
                    child: Text(c, style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600, color: isSelected ? AppColors.primary : AppColors.textSecondary)),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Agreement
            Row(
              children: [
                Checkbox(
                  value: _isAgreed,
                  onChanged: (v) => setState(() => _isAgreed = v ?? false),
                  activeColor: AppColors.primary,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _isAgreed = !_isAgreed),
                    child: Text('I agree to the Terms & Conditions and Vendor Policy', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textHint)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Register button
            GestureDetector(
              onTap: _isAgreed ? _handleRegister : null,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: _isAgreed ? LinearGradient(colors: [AppColors.gradientButtonStart, AppColors.gradientButtonEnd]) : null,
                  color: _isAgreed ? null : AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: _isAgreed ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4))] : null,
                ),
                child: Center(
                  child: Text('Register & Add Menu', style: TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w700, color: _isAgreed ? Colors.white : AppColors.textHint)),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, IconData icon, String hint,
      {TextInputType? keyboardType, String? Function(String?)? validator}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderLight, width: 1)),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            validator: validator,
            style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.textPrimary),
            decoration: InputDecoration(icon: Icon(icon, color: AppColors.textHint, size: 20), hintText: hint, hintStyle: TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.textHint), border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14)),
          ),
        ),
      ],
    );
  }
}
