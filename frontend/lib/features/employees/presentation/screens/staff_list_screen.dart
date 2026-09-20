import 'package:flutter/material.dart';
import 'package:foodos/core/theme/app_colors.dart';
import 'package:foodos/core/widgets/shimmer_loading.dart';
import 'package:foodos/core/widgets/status_badge.dart';
import 'package:go_router/go_router.dart';

class StaffListScreen extends StatefulWidget {
  const StaffListScreen({super.key});

  @override
  State<StaffListScreen> createState() => _StaffListScreenState();
}

class _StaffListScreenState extends State<StaffListScreen> {
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

  final List<Map<String, dynamic>> _staff = [
    {
      'name': 'Ali Raza',
      'role': 'Manager',
      'branch': 'Gulshan',
      'status': 'active',
      'phone': '0300-1111111',
    },
    {
      'name': 'Sara Khan',
      'role': 'Cashier',
      'branch': 'Gulshan',
      'status': 'active',
      'phone': '0321-2222222',
    },
    {
      'name': 'Hassan Ahmed',
      'role': 'Kitchen Staff',
      'branch': 'DHA',
      'status': 'active',
      'phone': '0333-3333333',
    },
    {
      'name': 'Ayesha Noor',
      'role': 'Waiter',
      'branch': 'Gulshan',
      'status': 'inactive',
      'phone': '0345-4444444',
    },
  ];

  Color _getRoleColor(String role) {
    switch (role) {
      case 'Manager':
        return AppColors.primary;
      case 'Cashier':
        return AppColors.info;
      case 'Kitchen Staff':
        return AppColors.warning;
      case 'Waiter':
        return AppColors.success;
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Staff'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_outlined),
            onPressed: () => context.push('/employees/invite'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: AppColors.primary,
        backgroundColor: AppColors.surface,
        child: _isLoading
            ? ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: 6,
                itemBuilder: (context, index) => const ShimmerCard(),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _staff.length,
                itemBuilder: (context, index) {
                  final member = _staff[index];
                  final isActive = member['status'] == 'active';
                  final roleColor = _getRoleColor(member['role']);
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.borderLight, width: 1),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: roleColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            member['name'][0],
                            style: TextStyle(
                              color: roleColor,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        member['name'],
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 2),
                          Text(
                            member['phone'],
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              color: AppColors.textHint,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              StatusBadge(
                                label: member['role'],
                                color: roleColor,
                                isSmall: true,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                member['branch'],
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 11,
                                  color: AppColors.textHint,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: PopupMenuButton<String>(
                        icon: Icon(Icons.more_vert, color: AppColors.textHint),
                        onSelected: (value) {},
                        itemBuilder: (context) => [
                          const PopupMenuItem(value: 'edit', child: Text('Edit')),
                          const PopupMenuItem(value: 'permissions', child: Text('Permissions')),
                          PopupMenuItem(
                            value: 'toggle',
                            child: Text(isActive ? 'Deactivate' : 'Activate'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
