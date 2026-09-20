import 'package:flutter/material.dart';
import 'package:foodos/core/theme/app_colors.dart';
import 'package:foodos/core/theme/app_text_styles.dart';
import 'package:foodos/core/widgets/shimmer_loading.dart';
import 'package:go_router/go_router.dart';

class ExpenseListScreen extends StatefulWidget {
  const ExpenseListScreen({super.key});

  @override
  State<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  bool _isLoading = true;

  Future<void> _loadData() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _onRefresh() async {
    setState(() => _isLoading = true);
    await _loadData();
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  final List<Map<String, dynamic>> _expenses = [
    {
      'category': 'Rent',
      'description': 'Monthly shop rent',
      'amount': 35000,
      'date': 'Aug 1, 2026',
      'branch': 'Gulshan',
    },
    {
      'category': 'Utilities',
      'description': 'Electricity bill',
      'amount': 8500,
      'date': 'Aug 5, 2026',
      'branch': 'Gulshan',
    },
    {
      'category': 'Supplies',
      'description': 'Packaging materials',
      'amount': 3200,
      'date': 'Aug 10, 2026',
      'branch': 'DHA',
    },
    {
      'category': 'Salary',
      'description': 'Staff salary - August',
      'amount': 45000,
      'date': 'Aug 28, 2026',
      'branch': 'All',
    },
  ];

  double get _totalExpenses => _expenses.fold(0, (sum, e) => sum + e['amount']);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/expenses/add'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: AppColors.primary,
        backgroundColor: AppColors.surface,
        child: _isLoading
            ? ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                itemCount: 6,
                itemBuilder: (context, index) => const ShimmerCard(),
              )
            : Column(
                children: [
                  // Total Summary
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Total Expenses', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                            const SizedBox(height: 4),
                            Text(
                              'Rs ${_totalExpenses.toInt()}',
                              style: AppTextStyles.h3.copyWith(color: AppColors.primary),
                            ),
                          ],
                        ),
                        Text('This Month', style: AppTextStyles.caption),
                      ],
                    ),
                  ),

                  // Expense List
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _expenses.length,
                      itemBuilder: (context, index) {
                        final expense = _expenses[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.borderLight),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: AppColors.error.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(Icons.receipt_long, color: AppColors.error),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      expense['category'],
                                      style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                                    ),
                                    Text(expense['description'], style: AppTextStyles.caption),
                                    Text(
                                      '${expense['date']} â€¢ ${expense['branch']}',
                                      style: AppTextStyles.caption,
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                'Rs ${expense['amount']}',
                                style: AppTextStyles.bodyLarge.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.error,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
