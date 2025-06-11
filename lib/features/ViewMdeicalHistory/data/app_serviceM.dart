import 'package:dio/dio.dart';

class DioHelper {
  static late Dio _dio;

  DioHelper._();

  static init() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'http://projectmetaverse.runasp.net/api/',
        receiveTimeout: const Duration(seconds: 60),
      ),
    );
  }

  //-------------------Get-----------------------//

  static Future<Response> getData({
    required String path,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
  }) async {
    final response = await _dio.get(
      path,
      queryParameters: queryParameters,
      data: body,
    );
    return response;
  }
}
