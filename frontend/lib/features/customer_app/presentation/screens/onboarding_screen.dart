import 'package:flutter/material.dart';
import 'package:foodos/core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  final _pages = [
    {
      'emoji': '🍔',
      'title': 'Discover Food',
      'subtitle': 'Browse from hundreds of restaurants and cuisines near you',
      'color': const Color(0xFFCB202D),
    },
    {
      'emoji': '📱',
      'title': 'Easy Ordering',
      'subtitle': 'Customize your order, add notes, and pay your way',
      'color': const Color(0xFFFF6B35),
    },
    {
      'emoji': '🛵',
      'title': 'Fast Delivery',
      'subtitle': 'Track your order in real-time and get it delivered fast',
      'color': const Color(0xFFE8622C),
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Pages
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemBuilder: (context, index) {
              final page = _pages[index];
              return Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        color: (page['color'] as Color).withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(child: Text(page['emoji'] as String, style: const TextStyle(fontSize: 72))),
                    ),
                    const SizedBox(height: 40),
                    Text(page['title'] as String, style: TextStyle(fontFamily: 'Inter', fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                    const SizedBox(height: 12),
                    Text(
                      page['subtitle'] as String,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: 'Inter', fontSize: 15, color: AppColors.textSecondary, height: 1.5),
                    ),
                  ],
                ),
              );
            },
          ),

          // Skip button
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 20,
            child: GestureDetector(
              onTap: () => context.go('/login'),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.borderLight, width: 1),
                ),
                child: Text('Skip', style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
              ),
            ),
          ),

          // Bottom
          Positioned(
            left: 0, right: 0, bottom: 0,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_pages.length, (i) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == i ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == i ? AppColors.primary : AppColors.borderLight,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 24),

                  // Next / Get Started button
                  GestureDetector(
                    onTap: () {
                      if (_currentPage < _pages.length - 1) {
                        _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                      } else {
                        context.go('/login');
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [AppColors.gradientButtonStart, AppColors.gradientButtonEnd]),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4))],
                      ),
                      child: Center(
                        child: Text(
                          _currentPage < _pages.length - 1 ? 'Next' : 'Get Started',
                          style: const TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
