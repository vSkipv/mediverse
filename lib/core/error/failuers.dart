import 'dart:convert';

import 'package:dio/dio.dart';

abstract class Faliuer {
  final String errMessage;

  const Faliuer(this.errMessage);
}

class ServerFailuer extends Faliuer {
  ServerFailuer(super.errMessage);

  factory ServerFailuer.fromDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
        return ServerFailuer("Connection timeout with API Server");
      case DioExceptionType.sendTimeout:
        return ServerFailuer("Send timeout with API Server");
      case DioExceptionType.receiveTimeout:
        return ServerFailuer("Receive timeout with API Server");
      case DioExceptionType.badResponse:
        if (dioError.response != null) {
          return ServerFailuer.fromResponse(
              dioError.response!.statusCode, dioError.response!.data);
        }
        return ServerFailuer("Received an invalid response from the server.");
      case DioExceptionType.cancel:
        return ServerFailuer("Request was canceled.");
      case DioExceptionType.unknown:
        if (dioError.message?.contains("SocketException") ?? false) {
          return ServerFailuer("No Internet Connection");
        }
        return ServerFailuer("Unexpected error, please try again later.");
      case DioExceptionType.badCertificate:
        return ServerFailuer("Unexpected certificate error.");
      case DioExceptionType.connectionError:
        return ServerFailuer("No Internet Connection.");
    }
  }

  factory ServerFailuer.fromResponse(int? statusCode, dynamic response) {
    if (response == null) {
      return ServerFailuer("Unexpected error occurred, please try again later.");
    }

    // Handle validation errors
    if (response is Map<String, dynamic>) {
      // Check for validation errors
      if (response.containsKey('errors')) {
        final errors = response['errors'];
        if (errors is Map && errors.isNotEmpty) {
          // Get the first error message
          final firstError = errors.values.first;
          if (firstError is List && firstError.isNotEmpty) {
            return ServerFailuer(firstError.first.toString());
          } else {
            return ServerFailuer(firstError.toString());
          }
        }
      }
      
      // Handle other types of error messages
      if (response.containsKey('message')) {
        return ServerFailuer(response['message']);
      } else if (response.containsKey('error')) {
        return ServerFailuer(response['error']);
      } else if (response.containsKey('detail')) {
        return ServerFailuer(response['detail']);
      }
    }

    // Handle string responses
    if (response is String) {
      if (response.contains("<html") || response.contains("<!DOCTYPE html>")) {
        return ServerFailuer("Error occurred on server side");
      }
      return ServerFailuer(response);
    }

    // Fallback
    return ServerFailuer(response.toString());
  }
}
