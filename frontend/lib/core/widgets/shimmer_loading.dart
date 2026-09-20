import 'package:flutter/material.dart';
import 'package:foodos/core/theme/app_colors.dart';

class ShimmerLoading extends StatefulWidget {
  final Widget child;
  final bool isLoading;

  const ShimmerLoading({super.key, required this.child, this.isLoading = true});

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))..repeat();
    _animation = Tween<double>(begin: -2, end: 2).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading) return widget.child;
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [AppColors.surface, Color(0xFF2A2019), AppColors.surface],
              stops: [
                (_animation.value - 1).clamp(0.0, 1.0),
                _animation.value.clamp(0.0, 1.0),
                (_animation.value + 1).clamp(0.0, 1.0),
              ],
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

// Pre-built shimmer skeletons
class ShimmerCard extends StatelessWidget {
  const ShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(width: 64, height: 64, decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(12))),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: 120, height: 14, decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(4))),
                const SizedBox(height: 8),
                Container(width: 80, height: 10, decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(4))),
                const SizedBox(height: 8),
                Container(width: 60, height: 10, decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(4))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ShimmerFoodCard extends StatelessWidget {
  const ShimmerFoodCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 200, height: 110, decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.vertical(top: Radius.circular(14)))),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: 100, height: 12, decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(4))),
                const SizedBox(height: 6),
                Container(width: 70, height: 10, decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(4))),
                const SizedBox(height: 6),
                Container(width: 50, height: 10, decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(4))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ShimmerFoodItem extends StatelessWidget {
  const ShimmerFoodItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(width: 72, height: 72, decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(10))),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: 100, height: 14, decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(4))),
                const SizedBox(height: 6),
                Container(width: 70, height: 10, decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(4))),
                const SizedBox(height: 6),
                Container(width: 40, height: 10, decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(4))),
              ],
            ),
          ),
          Column(
            children: [
              Container(width: 50, height: 14, decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(4))),
              const SizedBox(height: 8),
              Container(width: 28, height: 28, decoration: BoxDecoration(color: AppColors.background, shape: BoxShape.circle)),
            ],
          ),
        ],
      ),
    );
  }
}

class ShimmerCategoryChip extends StatelessWidget {
  const ShimmerCategoryChip({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Container(width: 56, height: 56, decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16))),
          const SizedBox(height: 6),
          Container(width: 40, height: 10, decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(4))),
        ],
      ),
    );
  }
}
