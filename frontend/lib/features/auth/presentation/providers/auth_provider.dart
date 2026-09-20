import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodos/core/network/api/auth_api.dart';
import '../../domain/models/user.dart';

// Auth State
enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthState {
  final AuthStatus status;
  final User? user;
  final String? error;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.error,
  });

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? error,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      error: error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthApi _api;

  AuthNotifier(this._api) : super(const AuthState());

  Future<void> login(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final res = await _api.login(email, password);
      final userData = res['user'] as Map<String, dynamic>;
      final user = User(
        id: userData['id'] ?? '',
        fullName: userData['fullName'] ?? userData['full_name'] ?? '',
        email: userData['email'] ?? '',
        phone: userData['phone'],
        role: userData['role'] ?? 'CUSTOMER',
        accountType: userData['accountType'] ?? userData['account_type'] ?? 'customer',
        status: 'active',
      );
      state = state.copyWith(status: AuthStatus.authenticated, user: user);
    } catch (e) {
      state = state.copyWith(status: AuthStatus.error, error: _parseError(e));
    }
  }

  Future<void> signup(String fullName, String email, String password, {String accountType = 'customer'}) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final res = await _api.signup(fullName, email, password, accountType: accountType);
      final userData = res['user'] as Map<String, dynamic>;
      final user = User(
        id: userData['id'] ?? '',
        fullName: userData['fullName'] ?? userData['full_name'] ?? '',
        email: userData['email'] ?? '',
        phone: userData['phone'],
        role: userData['role'] ?? 'CUSTOMER',
        accountType: userData['accountType'] ?? userData['account_type'] ?? accountType,
        status: 'active',
      );
      state = state.copyWith(status: AuthStatus.authenticated, user: user);
    } catch (e) {
      state = state.copyWith(status: AuthStatus.error, error: _parseError(e));
    }
  }

  Future<void> becomeVendor() async {
    if (state.user == null) return;
    final upgraded = state.user!.copyWith(accountType: 'vendor', role: 'VENDOR', hasVendorAccess: true);
    state = state.copyWith(user: upgraded);
  }

  Future<void> switchToVendor() async {
    if (state.user == null || !state.user!.hasVendorAccess) return;
    final switched = state.user!.copyWith(accountType: 'vendor', role: 'VENDOR');
    state = state.copyWith(user: switched);
  }

  Future<void> switchToCustomer() async {
    if (state.user == null || !state.user!.hasVendorAccess) return;
    final switched = state.user!.copyWith(accountType: 'customer', role: 'CUSTOMER');
    state = state.copyWith(user: switched);
  }

  Future<void> logout() async {
    await _api.logout();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  Future<void> checkAuthStatus() async {
    try {
      final token = await _api.getToken();
      if (token == null) {
        state = const AuthState(status: AuthStatus.unauthenticated);
        return;
      }
      final res = await _api.getProfile();
      final user = User(
        id: res['id'] ?? '',
        fullName: res['fullName'] ?? res['full_name'] ?? '',
        email: res['email'] ?? '',
        phone: res['phone'],
        role: res['role'] ?? 'CUSTOMER',
        accountType: res['accountType'] ?? res['account_type'] ?? 'customer',
        status: 'active',
      );
      state = state.copyWith(status: AuthStatus.authenticated, user: user);
    } catch (e) {
      state = const AuthState(status: AuthStatus.unauthenticated);
    }
  }

  String _parseError(dynamic e) {
    if (e is Exception) {
      final msg = e.toString();
      if (msg.contains('401') || msg.contains('Invalid credentials')) return 'Email ya password galat hai';
      if (msg.contains('409') || msg.contains('already registered')) return 'Email pehle se registered hai';
      if (msg.contains('timeout') || msg.contains('connection')) return 'Connection timeout — server check karo';
    }
    return 'Kuch galat ho gaya. Dobara try karo.';
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(AuthApi());
});
