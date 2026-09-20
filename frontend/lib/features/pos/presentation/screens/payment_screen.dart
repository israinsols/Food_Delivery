import 'package:flutter/material.dart';
import 'package:foodos/core/theme/app_colors.dart';
import 'package:foodos/core/theme/app_text_styles.dart';
import 'package:go_router/go_router.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedPaymentMethod = 'cash';
  final _amountController = TextEditingController(text: '0');

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _showPaymentSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 48),
            ),
            const SizedBox(height: 24),
            Text('Payment Successful!', style: AppTextStyles.h3),
            const SizedBox(height: 8),
            Text(
              'Order has been placed successfully',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.go('/pos');
                },
                child: const Text('Back to POS'),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  context.go('/orders');
                },
                child: const Text('View Orders'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Total Amount
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      'Total Amount',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Rs 3,300',
                      style: AppTextStyles.h1.copyWith(
                        color: AppColors.primary,
                        fontSize: 36,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Payment Methods
              Text('Payment Method', style: AppTextStyles.h4),
              const SizedBox(height: 12),
              Row(
                children: [
                  _PaymentMethodChip(
                    icon: Icons.money,
                    label: 'Cash',
                    isSelected: _selectedPaymentMethod == 'cash',
                    onTap: () => setState(() => _selectedPaymentMethod = 'cash'),
                  ),
                  const SizedBox(width: 12),
                  _PaymentMethodChip(
                    icon: Icons.credit_card,
                    label: 'Card',
                    isSelected: _selectedPaymentMethod == 'card',
                    onTap: () => setState(() => _selectedPaymentMethod = 'card'),
                  ),
                  const SizedBox(width: 12),
                  _PaymentMethodChip(
                    icon: Icons.phone_android,
                    label: 'Online',
                    isSelected: _selectedPaymentMethod == 'online',
                    onTap: () => setState(() => _selectedPaymentMethod = 'online'),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Amount Received (for cash)
              if (_selectedPaymentMethod == 'cash') ...[
                Text('Amount Received', style: AppTextStyles.h4),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  style: AppTextStyles.h3,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    hintText: 'Enter amount',
                    prefixText: 'Rs ',
                    prefixStyle: TextStyle(fontSize: 24),
                  ),
                ),
                const SizedBox(height: 12),
                // Quick amount buttons
                Row(
                  children: [
                    _QuickAmountButton(amount: 3000, onTap: () {
                      _amountController.text = '3000';
                    }),
                    const SizedBox(width: 8),
                    _QuickAmountButton(amount: 3500, onTap: () {
                      _amountController.text = '3500';
                    }),
                    const SizedBox(width: 8),
                    _QuickAmountButton(amount: 4000, onTap: () {
                      _amountController.text = '4000';
                    }),
                    const SizedBox(width: 8),
                    _QuickAmountButton(amount: 5000, onTap: () {
                      _amountController.text = '5000';
                    }),
                  ],
                ),
              ],
              const Spacer(),

              // Pay Button
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    _showPaymentSuccessDialog(context);
                  },
                  child: const Text(
                    'Complete Payment',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaymentMethodChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentMethodChip({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
            ),
          ),
          child: Column(
            children: [
              Icon(icon, color: isSelected ? Colors.white : AppColors.textSecondary),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickAmountButton extends StatelessWidget {
  final int amount;
  final VoidCallback onTap;

  const _QuickAmountButton({required this.amount, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: OutlinedButton(
        onPressed: onTap,
        child: Text('Rs $amount'),
      ),
    );
  }
}
