import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodos/core/network/api_client.dart';
import 'package:foodos/shared_providers/shared_providers.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  return ApiClient(secureStorage: secureStorage);
});
