import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

final currentBusinessIdProvider = StateProvider<String?>((ref) => null);
final currentBranchIdProvider = StateProvider<String?>((ref) => null);

final isAuthenticatedProvider = StateProvider<bool>((ref) => false);

final currentUserProvider = StateProvider<Map<String, dynamic>?>((ref) => null);
