import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediverse/core/network/api/api_service.dart';
import 'package:mediverse/features/Login/data/repositories/login_repository.dart';
import 'package:mediverse/features/Login/data/repositories/login_repository_impl.dart';
import 'package:mediverse/features/Login/presentaion/controller/cubit/login_cubit.dart';

class LoginDI {
  static List<BlocProvider> getProviders() {
    final dio = Dio();
    final apiService = ApiService(dio);
    final loginRepository = LoginRepositoryImpl(apiService: apiService);

    return [
      BlocProvider<LoginCubit>(
        create: (context) => LoginCubit(repository: loginRepository),
      ),
    ];
  }
} 