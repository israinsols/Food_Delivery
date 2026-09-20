import 'package:flutter/material.dart';
import 'package:foodos/core/theme/app_colors.dart';

class AppBottomSheet extends StatelessWidget {
  final String title;
  final Widget child;
  final double? height;

  const AppBottomSheet({
    super.key,
    required this.title,
    required this.child,
    this.height,
  });

  static void show(BuildContext context, {
    required String title,
    required Widget child,
    double? height,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AppBottomSheet(
        title: title,
        child: child,
        height: height,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(child: child),
        ],
      ),
    );
  }
}
