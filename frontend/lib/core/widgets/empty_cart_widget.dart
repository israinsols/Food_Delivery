import 'package:flutter/material.dart';
import 'package:foodos/core/theme/app_colors.dart';

class EmptyCartWidget extends StatelessWidget {
  final VoidCallback? onAddItem;

  const EmptyCartWidget({super.key, this.onAddItem});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 64,
            color: AppColors.textHint.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Cart is empty',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add items from the menu',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          if (onAddItem != null) ...[
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: onAddItem,
              icon: const Icon(Icons.add),
              label: const Text('Add Items'),
            ),
          ],
        ],
      ),
    );
  }
}
