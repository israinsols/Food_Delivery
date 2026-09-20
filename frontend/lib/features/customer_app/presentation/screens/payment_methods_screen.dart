import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodos/core/theme/app_colors.dart';
import 'package:foodos/core/providers/cart_provider.dart';
import 'package:foodos/features/auth/presentation/providers/auth_provider.dart';
import 'package:go_router/go_router.dart';

class PaymentMethodsScreen extends ConsumerStatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  ConsumerState<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends ConsumerState<PaymentMethodsScreen> {
  String _selectedMethod = 'CASH_ON_DELIVERY';
  bool _isPlacing = false;

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Payment Methods')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.borderLight, width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Order Total', style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.textHint)),
                Text('Rs ${cart.grandTotal}', style: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              ],
            ),
          ),
          const SizedBox(height: 24),

          Text('Select Payment Method', style: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          const SizedBox(height: 12),

          _buildPaymentOption(id: 'CASH_ON_DELIVERY', title: 'Cash on Delivery', subtitle: 'Pay when your order arrives', icon: Icons.money_rounded, iconColor: AppColors.success),
          const SizedBox(height: 12),
          _buildPaymentOption(id: 'JAZZCASH', title: 'JazzCash', subtitle: 'Mobile account payment', icon: Icons.phone_android_rounded, iconColor: const Color(0xFFD4232A)),
          const SizedBox(height: 12),
          _buildPaymentOption(id: 'EASYPAISA', title: 'EasyPaisa', subtitle: 'Telenor mobile account', icon: Icons.phone_iphone_rounded, iconColor: const Color(0xFF00A651)),
          const SizedBox(height: 12),
          _buildPaymentOption(id: 'CREDIT_CARD', title: 'Credit / Debit Card', subtitle: 'Visa, Mastercard, UnionPay', icon: Icons.credit_card_rounded, iconColor: AppColors.info),
          const SizedBox(height: 32),

          GestureDetector(
            onTap: _isPlacing ? null : () => _placeOrder(cart),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                gradient: _isPlacing
                    ? null
                    : const LinearGradient(colors: [AppColors.gradientButtonStart, AppColors.gradientButtonEnd]),
                color: _isPlacing ? AppColors.textHint : null,
                borderRadius: BorderRadius.circular(14),
                boxShadow: _isPlacing ? [] : [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4))],
              ),
              child: Center(
                child: _isPlacing
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : Text('Place Order  •  Rs ${cart.grandTotal}', style: TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w700, color: _isPlacing ? AppColors.surface : Colors.white)),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _placeOrder(CartState cart) {
    final auth = ref.read(authProvider);
    if (auth.status != AuthStatus.authenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Please login to place order'), backgroundColor: AppColors.warning),
      );
      context.push('/login');
      return;
    }

    if (cart.deliveryAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Please select delivery address'), backgroundColor: AppColors.error));
      return;
    }
    if (cart.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Cart is empty'), backgroundColor: AppColors.error));
      return;
    }

    setState(() => _isPlacing = true);

    ref.read(cartProvider.notifier).setPaymentMethod(_selectedMethod);

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => _isPlacing = false);

      ref.read(cartProvider.notifier).clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Order placed successfully!'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );

      context.go('/customer/order-tracking', extra: {'animate': true});
    });
  }

  Widget _buildPaymentOption({required String id, required String title, required String subtitle, required IconData icon, required Color iconColor}) {
    final isSelected = _selectedMethod == id;
    return GestureDetector(
      onTap: () => setState(() => _selectedMethod = id),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.borderLight, width: isSelected ? 2 : 1),
        ),
        child: Row(
          children: [
            Container(width: 44, height: 44, decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: iconColor, size: 22)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                const SizedBox(height: 2),
                Text(subtitle, style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textHint)),
              ]),
            ),
            Container(
              width: 22, height: 22,
              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: isSelected ? AppColors.primary : AppColors.textHint, width: 2)),
              child: isSelected ? Center(child: Container(width: 12, height: 12, decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.primary))) : null,
            ),
          ],
        ),
      ),
    );
  }
}
