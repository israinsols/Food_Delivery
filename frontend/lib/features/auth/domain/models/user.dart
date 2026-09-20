class User {
  final String id;
  final String fullName;
  final String email;
  final String? phone;
  final String? avatarUrl;
  final bool isSuperAdmin;
  final String role;
  final String accountType; // customer, vendor, super_admin
  final bool hasVendorAccess; // customer who became vendor
  final String status;
  final DateTime? createdAt;

  const User({
    required this.id,
    required this.fullName,
    required this.email,
    this.phone,
    this.avatarUrl,
    this.isSuperAdmin = false,
    this.role = 'CUSTOMER',
    this.accountType = 'customer',
    this.hasVendorAccess = false,
    required this.status,
    this.createdAt,
  });

  bool get isCustomer => accountType == 'customer';
  bool get isVendor => accountType == 'vendor';
  bool get isSuperAdminType => accountType == 'super_admin';
  bool get canOrder => true; // all users can order
  bool get canManageRestaurant => isVendor || hasVendorAccess;
  bool get canSwitchRole => hasVendorAccess && isCustomer; // customer with vendor access can switch

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      fullName: json['full_name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      isSuperAdmin: json['is_super_admin'] as bool? ?? false,
      role: json['role'] as String? ?? 'CUSTOMER',
      accountType: json['account_type'] as String? ?? 'customer',
      hasVendorAccess: json['has_vendor_access'] as bool? ?? false,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'avatar_url': avatarUrl,
      'is_super_admin': isSuperAdmin,
      'role': role,
      'account_type': accountType,
      'has_vendor_access': hasVendorAccess,
      'status': status,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  User copyWith({
    String? accountType,
    String? role,
    bool? hasVendorAccess,
  }) {
    return User(
      id: id,
      fullName: fullName,
      email: email,
      phone: phone,
      avatarUrl: avatarUrl,
      isSuperAdmin: isSuperAdmin,
      role: role ?? this.role,
      accountType: accountType ?? this.accountType,
      hasVendorAccess: hasVendorAccess ?? this.hasVendorAccess,
      status: status,
      createdAt: createdAt,
    );
  }
}

class UserBusinessRole {
  final String id;
  final String userId;
  final String businessId;
  final String? branchId;
  final String role;
  final Map<String, dynamic>? permissionsOverride;
  final String status;

  const UserBusinessRole({
    required this.id,
    required this.userId,
    required this.businessId,
    this.branchId,
    required this.role,
    this.permissionsOverride,
    required this.status,
  });

  factory UserBusinessRole.fromJson(Map<String, dynamic> json) {
    return UserBusinessRole(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      businessId: json['business_id'] as String,
      branchId: json['branch_id'] as String?,
      role: json['role'] as String,
      permissionsOverride: json['permissions_override'] as Map<String, dynamic>?,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'business_id': businessId,
      'branch_id': branchId,
      'role': role,
      'permissions_override': permissionsOverride,
      'status': status,
    };
  }
}

class AuthTokens {
  final String accessToken;
  final String refreshToken;

  const AuthTokens({
    required this.accessToken,
    required this.refreshToken,
  });

  factory AuthTokens.fromJson(Map<String, dynamic> json) {
    return AuthTokens(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
    };
  }
}

class AuthResponse {
  final User user;
  final AuthTokens tokens;
  final UserBusinessRole? businessRole;

  const AuthResponse({
    required this.user,
    required this.tokens,
    this.businessRole,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      tokens: AuthTokens.fromJson(json['tokens'] as Map<String, dynamic>),
      businessRole: json['business_role'] != null
          ? UserBusinessRole.fromJson(json['business_role'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'tokens': tokens.toJson(),
      'business_role': businessRole?.toJson(),
    };
  }
}
