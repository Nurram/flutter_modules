import 'package:dio/dio.dart';

import 'interceptor.dart';

class ApiProvider {
  ApiProvider._internal();

  static final _singleton = ApiProvider._internal();

  factory ApiProvider() => _singleton;

  late Dio _dio;

  String baseUrl = '';

  init({required String baseUrl}) {
    this.baseUrl = baseUrl;

    _dio = Dio(
      BaseOptions(
          baseUrl: baseUrl,
          receiveTimeout: const Duration(seconds: 15),
          connectTimeout: const Duration(seconds: 15),
          sendTimeout: const Duration(seconds: 15),
          headers: {
            'Connection': 'Keep-Alive',
          },
          receiveDataWhenStatusError: true),
    )..interceptors.add(CustomInterceptor());
  }

  Future<dynamic> get({
    required String endpoint,
    String? token,
  }) async {
    try {
      if (baseUrl.isEmpty) throw 'Network not yet initialized!';

      if (token != null) {
        _dio.options.headers.addAll({'Authorization': 'Bearer $token'});
      }

      final response = await _dio.get(endpoint);
      return _handleResponse(response: response.data);
    } on DioException catch (e) {
      throw e.message ?? 'Something happened!';
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> post({
    required String endpoint,
    required dynamic requestBody,
    String? token,
  }) async {
    try {
      if (baseUrl.isEmpty) throw 'Network not yet initialized!';

      if (token != null) {
        _dio.options.headers.addAll({'Authorization': 'Bearer $token'});
      }

      final response = await _dio.post(endpoint, data: requestBody);
      return _handleResponse(response: response.data);
    } on DioException catch (e) {
      throw e.message ?? 'Something happened!';
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> put({
    required String endpoint,
    required dynamic requestBody,
    String? token,
  }) async {
    try {
      if (baseUrl.isEmpty) throw 'Network not yet initialized!';

      if (token != null) {
        _dio.options.headers.addAll({'Authorization': 'Bearer $token'});
      }

      final response = await _dio.put(endpoint, data: requestBody);
      return _handleResponse(response: response.data);
    } on DioException catch (e) {
      throw e.message ?? 'Something happened!';
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> delete(
    String endpoint,
    String? token,
  ) async {
    try {
      if (baseUrl.isEmpty) throw 'Network not yet initialized!';

      _dio.options.headers.addAll({'Authorization': 'Bearer $token'});

      await _dio.delete(endpoint);
    } on DioException catch (e) {
      throw e.message ?? 'Something happened!';
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> uploadPut({
    required String endpoint,
    required dynamic requestBody,
    String? token,
  }) async {
    try {
      if (baseUrl.isEmpty) throw 'Network not yet initialized!';

      if (token != null) {
        _dio.options.headers.addAll({'Authorization': 'Bearer $token'});
      }
      _dio.options.headers['content-type'] = 'multipart/form-data';

      final response = await _dio.put(endpoint, data: requestBody);
      return _handleResponse(response: response.data);
    } on DioException catch (e) {
      throw e.message ?? 'Something happened!';
    } catch (e) {
      rethrow;
    }
  }

  _handleResponse({required dynamic response}) {
    try {
      final data = response.data;

      if (data['response']['status'] != 200) {
        throw data['error_desc'];
      }

      return data['data'];
    } catch (e) {
      rethrow;
    }
  }
}
