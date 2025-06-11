import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:http_parser/http_parser.dart';
import '../models/prediction_response.dart';

class AiModelRepository {
  late final Dio _dio;
  static const String baseUrl = 'http://thrista.com:8171';

  AiModelRepository() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: Duration(seconds: 60),
      receiveTimeout: Duration(seconds: 60),
      sendTimeout: Duration(seconds: 60),
      validateStatus: (status) {
        return status != null && status < 500;
      },
    ));

    // Configure HTTP client with more permissive settings
    (_dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) {
        print('Certificate warning for $host:$port');
        return true;
      };
      
      // Set more permissive security context
      client.findProxy = (uri) {
        return 'DIRECT';
      };
      
      // Set connection timeout
      client.connectionTimeout = Duration(seconds: 60);
      return client;
    };

    // Add interceptor for better error handling
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        print('Request: ${options.method} ${options.path}');
        print('Headers: ${options.headers}');
        handler.next(options);
      },
      onResponse: (response, handler) {
        print('Response: ${response.statusCode}');
        print('Response data: ${response.data}');
        handler.next(response);
      },
      onError: (error, handler) {
        print('Interceptor Error: ${error.message}');
        print('Error Type: ${error.type}');
        print('Error Response: ${error.response?.data}');
        print('Error Response Status: ${error.response?.statusCode}');
        handler.next(error);
      },
    ));
  }

  Future<PredictionResponse> uploadMriImage(File imageFile) async {
    try {
      // Check if file exists
      if (!await imageFile.exists()) {
        throw Exception('Image file does not exist');
      }

      String fileName = imageFile.path.split('/').last;
      String fileExtension = fileName.split('.').last.toLowerCase();

      // Create FormData with the correct field name and content type
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
          contentType: MediaType('image', fileExtension),
        ),
      });

      print('Uploading file: $fileName');
      print('File size: ${await imageFile.length()} bytes');
      print('Making request to: $baseUrl/prediction/mri-brain-tumor');

      final response = await _dio.post(
        '/prediction/mri-brain-tumor',
        data: formData,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'User-Agent': 'Flutter-App/1.0',
          },
          followRedirects: true,
          maxRedirects: 5,
          receiveDataWhenStatusError: true,
        ),
      );

      print('Response received: ${response.statusCode}');
      print('Response headers: ${response.headers}');

      if (response.statusCode == 200) {
        if (response.data == null) {
          throw Exception('No data received from server');
        }

        print('Response data: ${response.data}');

        try {
          return PredictionResponse.fromJson(response.data);
        } catch (e) {
          print('Parse error: $e');
          throw Exception('Failed to parse server response: $e');
        }
      } else {
        String errorMessage = 'Server error';
        if (response.data != null) {
          if (response.data is Map && response.data['detail'] != null) {
            // Handle FastAPI validation errors
            if (response.data['detail'] is List) {
              errorMessage = response.data['detail'][0]['msg'];
            } else {
              errorMessage = response.data['detail'].toString();
            }
          } else if (response.data is Map && response.data['message'] != null) {
            errorMessage = response.data['message'];
          } else {
            errorMessage = response.data.toString();
          }
        }
        throw Exception('Server returned error: $errorMessage (Status: ${response.statusCode})');
      }
    } on DioException catch (e) {
      print('DioException caught:');
      print('  Type: ${e.type}');
      print('  Message: ${e.message}');
      print('  Error: ${e.error}');
      print('  Response: ${e.response?.data}');
      print('  Response Status: ${e.response?.statusCode}');

      String errorMessage = 'Network error';

      if (e.error is HandshakeException) {
        errorMessage = 'Unable to establish secure connection. Please check if the server is running and accessible.';
      } else if (e.error is SocketException) {
        errorMessage = 'Cannot connect to server. Please check your internet connection and try again.';
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = 'Connection timeout - please check your internet connection';
      } else if (e.type == DioExceptionType.sendTimeout) {
        errorMessage = 'Send timeout - the image may be too large';
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'Receive timeout - server is taking too long to respond';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'Connection error - please check your internet connection and try again';
        if (e.error != null) {
          errorMessage += '\nDetails: ${e.error}';
        }
      }

      print('Final error message: $errorMessage');
      throw Exception(errorMessage);
    } catch (e) {
      print('Unexpected error: $e');
      print('Error type: ${e.runtimeType}');
      throw Exception('Unexpected error: $e');
    }
  }
}
