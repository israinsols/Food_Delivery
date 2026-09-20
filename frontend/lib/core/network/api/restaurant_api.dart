import 'package:dio/dio.dart';
import 'package:foodos/core/constants/app_constants.dart';

class RestaurantApi {
  final Dio _dio;

  RestaurantApi({Dio? dio})
      : _dio = dio ?? Dio(BaseOptions(baseUrl: '${AppConstants.baseUrl}/restaurants'));

  Future<List<dynamic>> getAll({String? cuisine, String? search, bool? isOpen, bool? isFeatured}) async {
    final params = <String, dynamic>{};
    if (cuisine != null) params['cuisine'] = cuisine;
    if (search != null) params['search'] = search;
    if (isOpen != null) params['isOpen'] = isOpen.toString();
    if (isFeatured != null) params['isFeatured'] = isFeatured.toString();

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

  Future<Map<String, dynamic>> toggleOpen(String id, {String? token}) async {
    final res = await _dio.patch('/$id/toggle-open', options: Options(headers: {'Authorization': 'Bearer $token'}));
    return res.data;
  }
}
