import 'package:flutter/material.dart';
import 'package:foodos/core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';

class RatingReviewScreen extends StatefulWidget {
  const RatingReviewScreen({super.key});

  @override
  State<RatingReviewScreen> createState() => _RatingReviewScreenState();
}

class _RatingReviewScreenState extends State<RatingReviewScreen> {
  int _rating = 0;
  final _reviewController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Rate Your Order')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Restaurant info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.borderLight, width: 1),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset('assets/images/biryani.jpg', width: 56, height: 56, fit: BoxFit.cover),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('FoodOS Kitchen', style: TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                      SizedBox(height: 2),
                      Text('Order #ORD-001', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textHint)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Rating stars
          Center(
            child: Text('How was your order?', style: TextStyle(fontFamily: 'Inter', fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text('Tap a star to rate', style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.textHint)),
          ),
          const SizedBox(height: 20),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return GestureDetector(
                  onTap: () => setState(() => _rating = index + 1),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Icon(
                      index < _rating ? Icons.star_rounded : Icons.star_outline_rounded,
                      size: 44,
                      color: index < _rating ? const Color(0xFFFFB27A) : AppColors.textHint,
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              _getRatingLabel(_rating),
              style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.primary),
            ),
          ),
          const SizedBox(height: 32),

          // Quick feedback chips
          Text('Quick Feedback', style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildChip('Delicious Food'),
              _buildChip('Fast Delivery'),
              _buildChip('Good Packaging'),
              _buildChip('Friendly Rider'),
              _buildChip('Fresh Food'),
              _buildChip('Value for Money'),
            ],
          ),
          const SizedBox(height: 24),

          // Review text
          Text('Write a Review', style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.borderLight, width: 1),
            ),
            child: TextField(
              controller: _reviewController,
              maxLines: 4,
              style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Tell us about your experience...',
                hintStyle: TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.textHint),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(16),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Submit button
          GestureDetector(
            onTap: _rating > 0 && !_isSubmitting ? _submitRating : null,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                gradient: _rating > 0
                    ? LinearGradient(colors: [AppColors.gradientButtonStart, AppColors.gradientButtonEnd])
                    : null,
                color: _rating > 0 ? null : AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                boxShadow: _rating > 0
                    ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4))]
                    : null,
              ),
              child: Center(
                child: _isSubmitting
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Text(
                        'Submit Rating',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: _rating > 0 ? Colors.white : AppColors.textHint,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getRatingLabel(int rating) {
    switch (rating) {
      case 1: return 'Poor';
      case 2: return 'Fair';
      case 3: return 'Good';
      case 4: return 'Very Good';
      case 5: return 'Excellent!';
      default: return '';
    }
  }

  Widget _buildChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderLight, width: 1),
      ),
      child: Text(label, style: TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textSecondary)),
    );
  }

  void _submitRating() {
    setState(() => _isSubmitting = true);
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Thank you for your feedback!'), backgroundColor: AppColors.success),
        );
        context.go('/customer/home');
      }
    });
  }
}
