import 'package:flutter/material.dart';
import 'package:foodos/core/theme/app_colors.dart';
import 'package:foodos/core/theme/app_text_styles.dart';

class MenuCategoryScreen extends StatefulWidget {
  const MenuCategoryScreen({super.key});

  @override
  State<MenuCategoryScreen> createState() => _MenuCategoryScreenState();
}

class _MenuCategoryScreenState extends State<MenuCategoryScreen> {
  final List<Map<String, dynamic>> _categories = [
    {'name': 'Main Course', 'itemCount': 8, 'sortOrder': 1, 'isActive': true},
    {'name': 'Appetizers', 'itemCount': 5, 'sortOrder': 2, 'isActive': true},
    {'name': 'Beverages', 'itemCount': 6, 'sortOrder': 3, 'isActive': true},
    {'name': 'Desserts', 'itemCount': 4, 'sortOrder': 4, 'isActive': true},
    {'name': 'Specials', 'itemCount': 2, 'sortOrder': 5, 'isActive': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Categories'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddDialog(),
          ),
        ],
      ),
      body: ReorderableListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _categories.length,
        onReorder: (oldIndex, newIndex) {
          setState(() {
            if (newIndex > oldIndex) newIndex--;
            final item = _categories.removeAt(oldIndex);
            _categories.insert(newIndex, item);
          });
        },
        itemBuilder: (context, index) {
          final cat = _categories[index];
          return Container(
            key: ValueKey(index),
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.drag_handle, color: AppColors.textHint),
              title: Text(cat['name'], style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
              subtitle: Text('${cat['itemCount']} items', style: AppTextStyles.caption),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Switch(
                    value: cat['isActive'],
                    onChanged: (v) => setState(() => cat['isActive'] = v),
                    activeColor: AppColors.primary,
                  ),
                  PopupMenuButton(
                    itemBuilder: (_) => [
                      const PopupMenuItem(value: 'edit', child: Text('Edit')),
                      const PopupMenuItem(value: 'delete', child: Text('Delete')),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showAddDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Category'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Category name'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() {
                  _categories.add({
                    'name': controller.text,
                    'itemCount': 0,
                    'sortOrder': _categories.length + 1,
                    'isActive': true,
                  });
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
