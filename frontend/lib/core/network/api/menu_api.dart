import 'package:dio/dio.dart';
import 'package:foodos/core/constants/app_constants.dart';

class MenuApi {
  final Dio _dio;

  MenuApi({Dio? dio})
      : _dio = dio ?? Dio(BaseOptions(baseUrl: '${AppConstants.baseUrl}/menu'));

  Future<List<dynamic>> getAll({String? restaurantId, String? category, String? search}) async {
    final params = <String, dynamic>{};
    if (restaurantId != null) params['restaurantId'] = restaurantId;
    if (category != null) params['category'] = category;
    if (search != null) params['search'] = search;

    final res = await _dio.get('/', queryParameters: params);
    return res.data as List;
  }

  Future<Map<String, dynamic>> getById(String id) async {
    final res = await _dio.get('/$id');
    return res.data;
  }

  Future<Map<String, dynamic>> create(Map<String, dynamic> data, {String? token}) async {
    final res = await _dio.post('/', data: data, options: Options(headers: {'Authorization': 'Bearer $token'}));
    return res.data;
  }

  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> data, {String? token}) async {
    final res = await _dio.put('/$id', data: data, options: Options(headers: {'Authorization': 'Bearer $token'}));
    return res.data;
  }

  Future<void> delete(String id, {String? token}) async {
    await _dio.delete('/$id', options: Options(headers: {'Authorization': 'Bearer $token'}));
  }

  Future<Map<String, dynamic>> toggleAvailability(String id, {String? token}) async {
    final res = await _dio.patch('/$id/toggle-availability', options: Options(headers: {'Authorization': 'Bearer $token'}));
    return res.data;
  }
}
