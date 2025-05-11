import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediverse/features/Login/data/repositories/login_repository.dart';
import 'package:mediverse/features/Login/presentaion/controller/cubit/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepository repository;

  LoginCubit({required this.repository}) : super(const LoginInitial());

  Future<void> login({
    required int nationalId,
    required String password,
  }) async {
    try {
      emit(const LoginLoading());
      final response = await repository.login(
        nationalId: nationalId,
        password: password,
      );
      emit(LoginSuccess(response));
    } catch (e) {
      emit(LoginError(e.toString()));
    }
  }
}