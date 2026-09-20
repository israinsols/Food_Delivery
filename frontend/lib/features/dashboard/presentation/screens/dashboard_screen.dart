import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodos/core/theme/app_colors.dart';
import 'package:foodos/core/widgets/gradient_text.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => context.push('/notifications'),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {},
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildWelcomeHeader(),
            const SizedBox(height: 20),
            _buildSummaryCards(context),
            const SizedBox(height: 20),
            _buildQuickActions(context),
            const SizedBox(height: 20),
            _buildSalesChart(),
            const SizedBox(height: 20),
            _buildBestSellingItems(context),
            const SizedBox(height: 20),
            _buildLowStockAlerts(context),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Good Morning',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            letterSpacing: -0.5,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Here\'s what\'s happening today',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
            letterSpacing: 0.1,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCards(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.15,
      children: [
        _SummaryCard(
          title: 'Today\'s Sales',
          value: 'Rs 45,200',
          subtitle: '+12% vs yesterday',
          icon: Icons.trending_up,
          glowColor: AppColors.glowOrange,
          iconColor: AppColors.primary,
          isGradient: true,
          onTap: () => context.push('/reports/sales'),
        ),
        _SummaryCard(
          title: 'Orders',
          value: '28',
          subtitle: '5 pending',
          icon: Icons.receipt_long,
          glowColor: AppColors.glowBlue,
          iconColor: AppColors.info,
          onTap: () => context.push('/orders'),
        ),
        _SummaryCard(
          title: 'Customers',
          value: '22',
          subtitle: '3 new today',
          icon: Icons.people_outline,
          glowColor: AppColors.glowOrange,
          iconColor: AppColors.primary,
          onTap: () => context.push('/customers'),
        ),
        _SummaryCard(
          title: 'Low Stock',
          value: '3',
          subtitle: 'Needs attention',
          icon: Icons.warning_amber,
          glowColor: AppColors.glowRed,
          iconColor: AppColors.error,
          onTap: () => context.push('/inventory'),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _QuickActionButton(
                icon: Icons.add_shopping_cart,
                label: 'New Order',
                onTap: () => context.go('/pos'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickActionButton(
                icon: Icons.delivery_dining,
                label: 'Deliveries',
                onTap: () => context.push('/delivery'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickActionButton(
                icon: Icons.receipt_long,
                label: 'Orders',
                onTap: () => context.push('/orders'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _QuickActionButton(
                icon: Icons.add_chart,
                label: 'Add Expense',
                onTap: () => context.push('/expenses/add'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickActionButton(
                icon: Icons.inventory_2_outlined,
                label: 'Inventory',
                onTap: () => context.push('/inventory'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickActionButton(
                icon: Icons.summarize_outlined,
                label: 'Reports',
                onTap: () => context.push('/reports'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSalesChart() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sales Overview',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.gradientButtonStart, AppColors.gradientButtonEnd],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'This Week',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: CustomPaint(
              size: const Size(double.infinity, 200),
              painter: _SalesChartPainter(),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _ChartLabel(label: 'Mon', value: 'Rs 32K'),
              _ChartLabel(label: 'Tue', value: 'Rs 28K'),
              _ChartLabel(label: 'Wed', value: 'Rs 45K'),
              _ChartLabel(label: 'Thu', value: 'Rs 38K'),
              _ChartLabel(label: 'Fri', value: 'Rs 52K'),
              _ChartLabel(label: 'Sat', value: 'Rs 41K'),
              _ChartLabel(label: 'Sun', value: 'Rs 45K'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBestSellingItems(BuildContext context) {
    final items = [
      {'name': 'Chicken Biryani', 'orders': 45, 'revenue': 'Rs 13,500', 'image': 'assets/images/biryani.jpg', 'rating': 4.8},
      {'name': 'Seekh Kabab', 'orders': 32, 'revenue': 'Rs 6,400', 'image': 'assets/images/kabab.jpg', 'rating': 4.6},
      {'name': 'Naan', 'orders': 28, 'revenue': 'Rs 1,400', 'image': 'assets/images/naan.jpg', 'rating': 4.5},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Best Selling Items',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
           ...items.asMap().entries.map((entry) {
            final item = entry.value;
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Rank
                  Container(
                    width: 28,
                    height: 64,
                    decoration: const BoxDecoration(
                      color: Color(0xFFCB202D),
                      borderRadius: BorderRadius.horizontal(left: Radius.circular(14)),
                    ),
                    child: Center(
                      child: Text(
                        '#${entry.key + 1}',
                        style: const TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white),
                      ),
                    ),
                  ),
                  // Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      item['image'] as String? ?? 'assets/images/biryani.jpg',
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['name'] as String,
                          style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded, size: 14, color: Color(0xFFFFB27A)),
                            const SizedBox(width: 2),
                            Text('${item['rating']}', style: TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                            const SizedBox(width: 6),
                            Text('${item['orders']} orders', style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textHint)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Revenue
                  Padding(
                    padding: const EdgeInsets.only(right: 14),
                    child: GradientText(
                      text: item['revenue'] as String,
                      style: const TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildLowStockAlerts(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/inventory'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderLight, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.glowRed,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.warning_amber, color: AppColors.error, size: 18),
                ),
                const SizedBox(width: 10),
                Text(
                  'Low Stock Alerts',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _StockAlertItem(name: 'Chicken', current: '2 kg', min: '5 kg'),
            _StockAlertItem(name: 'Rice', current: '3 kg', min: '10 kg'),
            _StockAlertItem(name: 'Oil', current: '1 L', min: '5 L'),
          ],
        ),
      ),
    );
  }
}

// â”€â”€â”€ Summary Card with Radial Glow â”€â”€â”€
class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color glowColor;
  final Color iconColor;
  final bool isGradient;
  final VoidCallback? onTap;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.glowColor,
    required this.iconColor,
    this.isGradient = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderLight, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Radial glow behind icon
            SizedBox(
              width: 40,
              height: 40,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Blurred glow circle
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: glowColor,
                          blurRadius: 16,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                  ),
                  Icon(icon, color: iconColor, size: 22),
                ],
              ),
            ),
            const Spacer(),
            if (isGradient)
              GradientText(
                text: value,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              )
            else
              Text(
                value,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
            const SizedBox(height: 2),
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: iconColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// â”€â”€â”€ Quick Action Button with Gradient Fill + Glow â”€â”€â”€
class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.gradientButtonStart, AppColors.gradientButtonEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppColors.glowShadow,
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// â”€â”€â”€ Chart Label â”€â”€â”€
class _ChartLabel extends StatelessWidget {
  final String label;
  final String value;

  const _ChartLabel({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 9,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 10,
            color: AppColors.textHint,
          ),
        ),
      ],
    );
  }
}

// â”€â”€â”€ Stock Alert Item â”€â”€â”€
class _StockAlertItem extends StatelessWidget {
  final String name;
  final String current;
  final String min;

  const _StockAlertItem({
    required this.name,
    required this.current,
    required this.min,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            '$current / $min',
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.error,
            ),
          ),
        ],
      ),
    );
  }
}

// â”€â”€â”€ Custom Gradient Line Chart Painter â”€â”€â”€
class _SalesChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // Data points (normalized 0-1)
    final data = [0.62, 0.54, 0.87, 0.73, 1.0, 0.79, 0.87];
    final stepX = w / (data.length - 1);

    // Grid lines
    final gridPaint = Paint()
      ..color = AppColors.borderLight
      ..strokeWidth = 0.5;

    for (int i = 0; i <= 4; i++) {
      final y = h * i / 4;
      canvas.drawLine(Offset(0, y), Offset(w, y), gridPaint);
    }

    // Build path
    final path = Path();
    final points = <Offset>[];
    for (int i = 0; i < data.length; i++) {
      final x = i * stepX;
      final y = h - (data[i] * h * 0.85) - 10;
      points.add(Offset(x, y));
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        // Smooth curve
        final prev = points[i - 1];
        final controlX1 = prev.dx + stepX * 0.4;
        final controlX2 = x - stepX * 0.4;
        path.cubicTo(controlX1, prev.dy, controlX2, y, x, y);
      }
    }

    // Gradient fill under line
    final fillPath = Path.from(path);
    fillPath.lineTo(w, h);
    fillPath.lineTo(0, h);
    fillPath.close();

    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primary.withValues(alpha: 0.3),
            AppColors.primary.withValues(alpha: 0.0),
          ],
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );

    // Gradient line
    canvas.drawPath(
      path,
      Paint()
        ..shader = const LinearGradient(
          colors: [AppColors.gradientStart, AppColors.gradientEnd],
        ).createShader(Rect.fromLTWH(0, 0, w, h))
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    // Dots at each point
    final dotPaint = Paint()..color = AppColors.primary;
    final dotBorderPaint = Paint()..color = AppColors.surface;
    for (final p in points) {
      canvas.drawCircle(p, 5, dotBorderPaint);
      canvas.drawCircle(p, 3, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
