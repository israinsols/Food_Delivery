import 'package:dio/dio.dart';
import 'package:foodos/core/constants/app_constants.dart';

class OrderApi {
  final Dio _dio;

  OrderApi({Dio? dio})
      : _dio = dio ?? Dio(BaseOptions(baseUrl: '${AppConstants.baseUrl}/orders'));

  Future<Map<String, dynamic>> create(Map<String, dynamic> data, {String? token}) async {
    final res = await _dio.post('/', data: data, options: Options(headers: {'Authorization': 'Bearer $token'}));
    return res.data;
  }

  Future<List<dynamic>> getAll({String? token}) async {
    final res = await _dio.get('/', options: Options(headers: {'Authorization': 'Bearer $token'}));
    return res.data as List;
  }

  Future<Map<String, dynamic>> getById(String id, {String? token}) async {
    final res = await _dio.get('/$id', options: Options(headers: {'Authorization': 'Bearer $token'}));
    return res.data;
  }

  Future<Map<String, dynamic>> updateStatus(String id, String status, {String? token}) async {
    final res = await _dio.patch('/$id/status', data: {'status': status}, options: Options(headers: {'Authorization': 'Bearer $token'}));
    return res.data;
  }

  Future<Map<String, dynamic>> estimateFee(Map<String, dynamic> data, {String? token}) async {
    final res = await _dio.post('/estimate-fee', data: data, options: Options(headers: {'Authorization': 'Bearer $token'}));
    return res.data;
  }
}
