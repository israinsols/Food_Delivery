import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodos/core/theme/app_colors.dart';
import 'package:foodos/core/widgets/customer_bottom_nav.dart';
import 'package:foodos/core/providers/cart_provider.dart';
import 'package:go_router/go_router.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final addresses = ref.watch(deliveryAddressesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: const CustomerBottomNav(currentIndex: 2),
      appBar: AppBar(title: const Text('My Cart')),
      body: cart.items.isEmpty
          ? _buildEmptyCart(context)
          : Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      // Delivery address
                      _buildSectionTitle('Delivery Address'),
                      const SizedBox(height: 8),
                      _buildAddressSelector(context, ref, cart, addresses),
                      const SizedBox(height: 20),

                      // Cart items
                      _buildSectionTitle('Your Items (${cart.items.length})'),
                      const SizedBox(height: 8),
                      ...cart.items.map((item) => _buildCartItem(ref, item)),
                      const SizedBox(height: 20),

                      // Payment method
                      _buildSectionTitle('Payment Method'),
                      const SizedBox(height: 8),
                      _buildPaymentRow(context, cart.paymentMethod),
                      const SizedBox(height: 20),

                      // Delivery fee breakdown
                      _buildSectionTitle('Delivery Fee Calculation'),
                      const SizedBox(height: 8),
                      _buildFeeBreakdown(cart),
                    ],
                  ),
                ),

                // Order summary + Place order
                _buildOrderSummary(context, ref, cart),
              ],
            ),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 64, color: AppColors.textHint),
          const SizedBox(height: 16),
          Text('Your cart is empty', style: TextStyle(fontFamily: 'Inter', fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          Text('Add some food to get started', style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.textHint)),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () => context.go('/customer/home'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [AppColors.gradientButtonStart, AppColors.gradientButtonEnd]),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text('Browse Restaurants', style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary));
  }

  Widget _buildAddressSelector(BuildContext context, WidgetRef ref, CartState cart, List<DeliveryInfo> addresses) {
    return GestureDetector(
      onTap: () => _showAddressSheet(context, ref, addresses),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 1.5),
        ),
        child: Row(
          children: [
            Icon(Icons.location_on, color: AppColors.primary, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cart.deliveryAddress?.label ?? 'Select Delivery Address',
                    style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                  ),
                  if (cart.deliveryAddress != null)
                    Text(
                      cart.deliveryAddress!.address,
                      style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textHint),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.textHint, size: 20),
          ],
        ),
      ),
    );
  }

  void _showAddressSheet(BuildContext context, WidgetRef ref, List<DeliveryInfo> addresses) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select Address', style: TextStyle(fontFamily: 'Inter', fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            const SizedBox(height: 16),
            ...addresses.map((addr) => GestureDetector(
              onTap: () {
                ref.read(cartProvider.notifier).setDeliveryAddress(addr);
                Navigator.pop(ctx);
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderLight, width: 1),
                ),
                child: Row(
                  children: [
                    Icon(Icons.location_on, color: AppColors.primary, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(addr.label, style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                          Text(addr.address, style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textHint)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItem(WidgetRef ref, CartItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderLight, width: 1),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(item.image, width: 56, height: 56, fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(width: 56, height: 56, color: AppColors.surfaceVariant, child: Icon(Icons.fastfood, color: AppColors.textHint))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                const SizedBox(height: 2),
                Text('${item.size} • ${item.spiceLevel}', style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textHint)),
                if (item.addOns.isNotEmpty)
                  Text(item.addOns.join(', '), style: TextStyle(fontFamily: 'Inter', fontSize: 10, color: AppColors.primary)),
              ],
            ),
          ),
          // Quantity controls
          Container(
            decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(8)),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => ref.read(cartProvider.notifier).updateQuantity(item.id, item.quantity - 1),
                  child: Container(width: 28, height: 28, decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)), child: Icon(Icons.remove, size: 14, color: AppColors.primary)),
                ),
                Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: Text('${item.quantity}', style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary))),
                GestureDetector(
                  onTap: () => ref.read(cartProvider.notifier).updateQuantity(item.id, item.quantity + 1),
                  child: Container(width: 28, height: 28, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(6)), child: Icon(Icons.add, size: 14, color: Colors.white)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text('Rs ${item.total}', style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        ],
      ),
    );
  }

  Widget _buildPaymentRow(BuildContext context, String method) {
    final labels = {
      'CASH_ON_DELIVERY': 'Cash on Delivery',
      'JAZZCASH': 'JazzCash',
      'EASYPAISA': 'EasyPaisa',
      'CREDIT_CARD': 'Credit Card',
    };
    return GestureDetector(
      onTap: () => context.push('/customer/payment-methods'),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderLight, width: 1),
        ),
        child: Row(
          children: [
            Icon(Icons.payment, color: AppColors.primary, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text(labels[method] ?? method, style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary))),
            Icon(Icons.chevron_right, color: AppColors.textHint, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFeeBreakdown(CartState cart) {
    final distKm = 3 + (cart.deliveryAddress?.address.length ?? 0) % 5;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight, width: 1),
      ),
      child: Column(
        children: [
          _feeRow('Distance', '$distKm km'),
          const SizedBox(height: 6),
          _feeRow('Delivery Fee', 'Rs ${cart.deliveryFee} ($distKm km × Rs 25/km)'),
          const SizedBox(height: 6),
          _feeRow('Tax (8%)', 'Rs ${cart.tax}'),
          if (cart.tip > 0) ...[
            const SizedBox(height: 6),
            _feeRow('Tip', 'Rs ${cart.tip}'),
          ],
          if (cart.discount > 0) ...[
            const SizedBox(height: 6),
            _feeRow('First Order Discount (10%)', '- Rs ${cart.discount}', isGreen: true),
          ],
        ],
      ),
    );
  }

  Widget _feeRow(String label, String value, {bool isGreen = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textHint)),
        Text(value, style: TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w600, color: isGreen ? AppColors.success : AppColors.textPrimary)),
      ],
    );
  }

  Widget _buildOrderSummary(BuildContext context, WidgetRef ref, CartState cart) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 20, offset: const Offset(0, -5))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSummaryRow('Subtotal', 'Rs ${cart.subtotal}'),
          const SizedBox(height: 6),
          _buildSummaryRow('Delivery Fee', 'Rs ${cart.deliveryFee}'),
          const SizedBox(height: 6),
          _buildSummaryRow('Tax', 'Rs ${cart.tax}'),
          if (cart.tip > 0) ...[
            const SizedBox(height: 6),
            _buildSummaryRow('Tip', 'Rs ${cart.tip}'),
          ],
          if (cart.discount > 0) ...[
            const SizedBox(height: 6),
            _buildSummaryRow('Discount (10%)', '- Rs ${cart.discount}', isGreen: true),
          ],
          const SizedBox(height: 10),
          Container(height: 1, color: AppColors.borderLight),
          const SizedBox(height: 10),
          _buildSummaryRow('Grand Total', 'Rs ${cart.grandTotal}', isBold: true),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: cart.deliveryAddress == null
                ? () => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: const Text('Please select delivery address'), backgroundColor: AppColors.error))
                : () => context.push('/customer/payment-methods'),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [AppColors.gradientButtonStart, AppColors.gradientButtonEnd]),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4))],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_cart_checkout, color: Colors.white, size: 20),
                  const SizedBox(width: 10),
                  Text('Place Order  •  Rs ${cart.grandTotal}', style: const TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false, bool isGreen = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontFamily: 'Inter', fontSize: isBold ? 15 : 13, fontWeight: isBold ? FontWeight.w700 : FontWeight.w500, color: AppColors.textPrimary)),
        Text(value, style: TextStyle(fontFamily: 'Inter', fontSize: isBold ? 15 : 13, fontWeight: isBold ? FontWeight.w700 : FontWeight.w600, color: isGreen ? AppColors.success : (isBold ? AppColors.primary : AppColors.textSecondary))),
      ],
    );
  }
}
