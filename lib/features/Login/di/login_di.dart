import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediverse/features/Login/data/repositories/login_repository.dart';
import 'package:mediverse/features/Login/data/repositories/login_repository_impl.dart';

import '../../../core/network/api/api_service.dart';
import '../presentaion/controller/cubit/login_cubit.dart';

class LoginDI {
  static List<BlocProvider> getProviders() {
    return [
      BlocProvider<LoginCubit>(
        create: (context) => LoginCubit(
          repository: LoginRepositoryImpl(
            apiService: ApiService(Dio()),
          ),
        ),
      ),
    ];
  }
} 