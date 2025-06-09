import 'package:dio/dio.dart';

import '../../../constants.dart' as Constant;
import '../../error/failuers.dart';
import '../../utililes/cached_sp.dart';


class ApiService {
  final String _baseUrl = "http://projectmetaverse.runasp.net/api/";
  final Dio _dio;

  ApiService(this._dio) {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  // GET request
  Future<dynamic> get({required String endpoint, Map<String, dynamic>? data}) async {
    try {
      final token = await CachedData.getToken();
      print("token: $token");
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final response = await _dio.get(
        endpoint,
        data: data?.isNotEmpty == true ? data : null,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
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
  Future<dynamic> post({
    required String endpoint,
    required Map<String, dynamic> data,
    bool token = true,
  }) async {
    try {
      String? authToken;
      if (token) {
        authToken = await CachedData.getData(Constant.accessToekn);
        if (authToken == null) {
          throw Exception('Authentication token not found');
        }
      }

      print('Sending request to: $endpoint');
      print('Request data: $data');

      final response = await _dio.post(
        endpoint,
        data: data,
        options: Options(
          headers: {
            if (token) 'Authorization': 'Bearer $authToken',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );

      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return response.data;
      } else {
        String errorMessage;
        if (response.data is Map) {
          errorMessage = response.data['message'] ?? 'Request failed with status: ${response.statusCode}';
        } else if (response.data is String) {
          errorMessage = response.data;
        } else {
          errorMessage = 'Request failed with status: ${response.statusCode}';
        }
        
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: errorMessage,
        );
      }
    } on DioException catch (e) {
      print('DioError: ${e.message}');
      print('DioError Response: ${e.response?.data}');
      
      if (e.response?.data != null) {
        String errorMessage;
        if (e.response?.data is Map) {
          errorMessage = e.response?.data['message'] ?? e.message ?? 'Unknown error occurred';
        } else if (e.response?.data is String) {
          errorMessage = e.response?.data;
        } else {
          errorMessage = e.message ?? 'Unknown error occurred';
        }
        
        throw DioException(
          requestOptions: e.requestOptions,
          response: e.response,
          error: errorMessage,
        );
      }
      throw e;
    } catch (e) {
      print('Unexpected error: $e');
      throw Exception('Unexpected error: $e');
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