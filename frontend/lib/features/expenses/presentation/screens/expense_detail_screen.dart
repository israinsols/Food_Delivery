import 'package:flutter/material.dart';
import 'package:foodos/core/theme/app_colors.dart';

class ExpenseDetailScreen extends StatelessWidget {
  final String? expenseId;
  const ExpenseDetailScreen({super.key, this.expenseId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Expense'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Category
            DropdownButtonFormField<String>(
              items: ['Rent', 'Utilities', 'Salaries', 'Supplies', 'Maintenance', 'Other']
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) {},
              decoration: const InputDecoration(
                labelText: 'Category',
                prefixIcon: Icon(Icons.category_outlined),
              ),
            ),
            const SizedBox(height: 16),

            // Amount
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount (Rs)',
                prefixIcon: Icon(Icons.attach_money),
              ),
            ),
            const SizedBox(height: 16),

            // Date
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Date',
                prefixIcon: Icon(Icons.calendar_today),
              ),
              onTap: () {
                // TODO: Show date picker
              },
            ),
            const SizedBox(height: 16),

            // Description
            TextFormField(
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Description',
                prefixIcon: Icon(Icons.description_outlined),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 32),

            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Expense added!'), backgroundColor: AppColors.success),
                  );
                },
                child: const Text('Add Expense'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
