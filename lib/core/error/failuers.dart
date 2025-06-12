import 'dart:convert';

import 'package:dio/dio.dart';

abstract class Failure {
  final String errMessage;

  const Failure(this.errMessage);

  @override
  String toString() => errMessage;
}

class ServerFailure extends Failure {
  ServerFailure(super.errMessage);

  factory ServerFailure.fromDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
        return ServerFailure("Connection timeout with API Server");
      case DioExceptionType.sendTimeout:
        return ServerFailure("Send timeout with API Server");
      case DioExceptionType.receiveTimeout:
        return ServerFailure("Receive timeout with API Server");
      case DioExceptionType.badResponse:
        if (dioError.response != null) {
          return ServerFailure.fromResponse(
              dioError.response!.statusCode, dioError.response!.data);
        }
        return ServerFailure("Received an invalid response from the server.");
      case DioExceptionType.cancel:
        return ServerFailure("Request was canceled.");
      case DioExceptionType.unknown:
        if (dioError.message?.contains("SocketException") ?? false) {
          return ServerFailure("No Internet Connection");
        }
        return ServerFailure("Unexpected error, please try again later.");
      case DioExceptionType.badCertificate:
        return ServerFailure("Unexpected certificate error.");
      case DioExceptionType.connectionError:
        return ServerFailure("No Internet Connection.");
    }
  }

  factory ServerFailure.fromResponse(int? statusCode, dynamic response) {
    if (response == null) {
      return ServerFailure(
          "Unexpected error occurred, please try again later.");
    }

    // Handle validation errors
    if (response is Map<String, dynamic>) {
      // Check for validation errors (ASP.NET format)
      if (response.containsKey('errors')) {
        final errors = response['errors'];
        if (errors is Map && errors.isNotEmpty) {
          // Get all error messages and combine them
          final List<String> errorMessages = [];
          errors.forEach((field, messages) {
            if (messages is List && messages.isNotEmpty) {
              errorMessages.addAll(messages.map((msg) => msg.toString()));
            } else {
              errorMessages.add(messages.toString());
            }
          });

          if (errorMessages.isNotEmpty) {
            return ServerFailure(errorMessages.join(', '));
          }
        }
      }
      
      // Handle other types of error messages
      if (response.containsKey('message')) {
        return ServerFailure(response['message']);
      } else if (response.containsKey('error')) {
        return ServerFailure(response['error']);
      } else if (response.containsKey('detail')) {
        return ServerFailure(response['detail']);
      } else if (response.containsKey('title')) {
        return ServerFailure(response['title']);
      }
    }

    // Handle string responses
    if (response is String) {
      if (response.contains("<html") || response.contains("<!DOCTYPE html>")) {
        return ServerFailure("Error occurred on server side");
      }
      return ServerFailure(response);
    }

    // Fallback
    return ServerFailure("An error occurred. Please try again.");
  }
}
