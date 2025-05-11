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

    // Extract error message from API response
    String errorMessage = "Unexpected error occurred";
    if (response is Map<String, dynamic>) {
      errorMessage = response["error"]?["message"] ??
          response["msg"] ??
          response["message"] ??
          jsonEncode(response); // Fallback: return full response as string
    } else if(response is String){
      if (response.contains("<html") || response.contains("<!DOCTYPE html>")) {
        errorMessage = "Error occurred on server side";
      } else {
        errorMessage = response; // Plain text error message
      }

    }else{
      errorMessage = response.toString();

    }

    return ServerFailuer(errorMessage);
  }

}
