import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodos/core/theme/app_colors.dart';
import 'package:foodos/features/auth/presentation/providers/auth_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authProvider).user;
    _nameController = TextEditingController(text: user?.fullName ?? 'Ahmed Khan');
    _emailController = TextEditingController(text: user?.email ?? 'ahmed@email.com');
    _phoneController = TextEditingController(text: user?.phone ?? '0300-1234567');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          TextButton.icon(
            onPressed: () {
              if (_isEditing) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Profile updated successfully!'),
                    backgroundColor: AppColors.success,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                );
              }
              setState(() => _isEditing = !_isEditing);
            },
            icon: Icon(_isEditing ? Icons.check_rounded : Icons.edit_rounded, size: 18),
            label: Text(_isEditing ? 'Save' : 'Edit'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Avatar
          Center(
            child: Stack(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [AppColors.gradientButtonStart, AppColors.gradientButtonEnd],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 24,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      (user?.fullName ?? 'A')[0].toUpperCase(),
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                if (_isEditing)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.background, width: 3),
                      ),
                      child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          if (_isEditing)
            Center(
              child: Text('Tap to change photo', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.textHint)),
            ),
          const SizedBox(height: 32),

          // Name field
          _buildField(
            label: 'Full Name',
            controller: _nameController,
            icon: Icons.person_outlined,
            enabled: _isEditing,
          ),
          const SizedBox(height: 16),

          // Email field
          _buildField(
            label: 'Email',
            controller: _emailController,
            icon: Icons.email_outlined,
            enabled: false,
          ),
          const SizedBox(height: 16),

          // Phone field
          _buildField(
            label: 'Phone',
            controller: _phoneController,
            icon: Icons.phone_outlined,
            enabled: _isEditing,
          ),
          const SizedBox(height: 32),

          // Account Info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.borderLight, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Account Info', style: TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                const SizedBox(height: 12),
                _buildInfoRow('User ID', user?.id ?? 'USR-001'),
                _buildInfoRow('Role', user?.isSuperAdmin == true ? 'Super Admin' : 'Staff'),
                _buildInfoRow('Status', user?.status ?? 'Active'),
                if (user?.createdAt != null) _buildInfoRow('Joined', _formatDate(user!.createdAt!)),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Change Password
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderLight, width: 1),
              ),
              child: Row(
                children: [
                  const Icon(Icons.lock_outlined, color: AppColors.primary, size: 20),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Change Password', style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                        const SizedBox(height: 2),
                        Text('Update your password', style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.textHint)),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded, color: AppColors.textHint, size: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required bool enabled,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: enabled ? AppColors.primary.withValues(alpha: 0.3) : AppColors.borderLight,
          width: enabled ? 1.5 : 1,
        ),
      ),
      child: TextField(
        controller: controller,
        enabled: enabled,
        style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.textPrimary),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            color: enabled ? AppColors.primary : AppColors.textHint,
          ),
          prefixIcon: Icon(icon, color: enabled ? AppColors.primary : AppColors.textHint, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          filled: true,
          fillColor: enabled ? AppColors.primary.withValues(alpha: 0.03) : Colors.transparent,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.textSecondary)),
          Text(value, style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
