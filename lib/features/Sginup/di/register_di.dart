import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediverse/core/network/api/api_service.dart';

import '../../Sginup/data/repositories/register_repository_impl.dart';
import '../../Sginup/presentaion/controller/cubit/register_cubit.dart';

class RegisterDI {
  static List<BlocProvider> getProviders() {
    final dio = Dio();
    final apiService = ApiService(dio);
    final registerRepository = RegisterRepositoryImpl(apiService: apiService);

    return [
      BlocProvider<RegisterCubit>(
        create: (context) => RegisterCubit(repository: registerRepository),
      ),
    ];
  }
} 