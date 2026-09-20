class LoginRequest {
  final String email;
  final String password;

  const LoginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() => {'email': email, 'password': password};
}

class SignupRequest {
  final String fullName;
  final String email;
  final String password;
  final String? phone;

  const SignupRequest({
    required this.fullName,
    required this.email,
    required this.password,
    this.phone,
  });

  Map<String, dynamic> toJson() => {
        'full_name': fullName,
        'email': email,
        'password': password,
        if (phone != null) 'phone': phone,
      };
}

class ForgotPasswordRequest {
  final String email;

  const ForgotPasswordRequest({required this.email});

  Map<String, dynamic> toJson() => {'email': email};
}

class ResetPasswordRequest {
  final String token;
  final String newPassword;

  const ResetPasswordRequest({required this.token, required this.newPassword});

  Map<String, dynamic> toJson() => {
        'token': token,
        'new_password': newPassword,
      };
}

class ChangePasswordRequest {
  final String currentPassword;
  final String newPassword;

  const ChangePasswordRequest({
    required this.currentPassword,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() => {
        'current_password': currentPassword,
        'new_password': newPassword,
      };
}
