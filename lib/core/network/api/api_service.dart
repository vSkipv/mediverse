import 'package:dio/dio.dart';

import '../../../constants.dart' as Constant;
import '../../error/failuers.dart';
import '../../utililes/cached_sp.dart';


class ApiService {
  final String _baseUrl = "http//projectmetaverse.runasp.net/api/";
  final Dio _dio;

  ApiService(this._dio);

  // GET request
  Future<dynamic> get({required String endpoint}) async {
    try {
      final token = await CachedData.getData(Constant.accessToekn);
      final response = await _dio.get(
        "$_baseUrl$endpoint",
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Unexpected error during GET request: $e');
    }
  }


  // POST request
  Future<Map<String, dynamic>> post({
    required String endpoint,
    required dynamic data,
    bool? token = false,
    ResponseType? responseType,
    Function(int sent, int total)? onSendProgress,
  }) async {
    try {
      final response = await _dio.post(
        "$_baseUrl$endpoint",
        data: data,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            if (token == true)
              'Authorization': 'Bearer ${await CachedData.getData(Constant.accessToekn)}',
          },
          responseType: responseType ?? ResponseType.json,
        ),
        onSendProgress: onSendProgress,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        throw ServerFailuer.fromResponse(response.statusCode, response.data);
      }
    } on DioException catch (dioError) {
      throw ServerFailuer.fromDioError(dioError);
    } catch (e) {
      throw ServerFailuer("Unexpected error: ${e.toString()}");
    }
  }


  Future<Map<String, dynamic>> postContent({
    required String endpoint,
    required dynamic data,
    bool? token = false,
    ResponseType? responseType,
    Function(int sent, int total)? onSendProgress,
  }) async {
    try {
      final response = await _dio.post(
        "$_baseUrl$endpoint",
        data: data,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            if (token == true)
              'Authorization': 'Bearer ${await CachedData.getData(Constant.accessToekn)}',
          },
          responseType: responseType ?? ResponseType.json,
        ),
        onSendProgress: onSendProgress,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        throw ServerFailuer.fromResponse(response.statusCode, response.data);
      }
    } on DioException catch (dioError) {
      throw ServerFailuer.fromDioError(dioError);
    } catch (e) {
      throw ServerFailuer("Unexpected error: ${e.toString()}");
    }
  }


  // DELETE request
  Future<Map<String, dynamic>> delete({required String endpoint}) async {
    try {
      final token = await CachedData.getData(Constant.accessToekn);
      final response = await _dio.delete(
        "$_baseUrl$endpoint",
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Unexpected error during DELETE request: $e');
    }
  }

  //download request
  Future<void> downloadFile({
    required String endpoint,
    required String savePath,
    Function(int received, int total)? onReceiveProgress,
  }) async {
    try {
      final token = await CachedData.getData(Constant.accessToekn);

      await _dio.download(
        "$_baseUrl$endpoint",
        savePath,
        onReceiveProgress: onReceiveProgress,
        options: Options(headers: {'Authorization': 'Bearer $token'}),

      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Unexpected error during file download: $e');
    }
  }

  // PUT request
  Future<Map<String, dynamic>> put({
    required String endpoint,
    required dynamic data,
    bool? token = false,
  }) async {
    try {
      final response = await _dio.put(
        "$_baseUrl$endpoint",
        data: data,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            if (token == true)
              'Authorization': 'Bearer ${await CachedData.getData(Constant.accessToekn)}',
          },
        ),
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Unexpected error during PUT request: $e');
    }
  }

  // Handle API responses
  dynamic _handleResponse(Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.data;
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: response.data?['message'] ?? 'Unknown error occurred',
      );
    }
  }


  Exception _handleDioError(DioException e) {
    String message = "Unexpected error occurred";

    if (e.response != null) {
      final responseData = e.response?.data;

      if (responseData is Map<String, dynamic>) {
        message = responseData['message']?.toString() ?? e.response?.statusMessage ?? message;
      }
    } else if (e.type == DioExceptionType.connectionTimeout) {
      message = "Connection timeout with API Server";
    }

    return Exception('API Error: $message');
  }


}