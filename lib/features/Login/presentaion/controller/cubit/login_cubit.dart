import 'package:bloc/bloc.dart';
import 'package:mediverse/features/Login/data/repositories/login_repository.dart';

import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepository repository;

  LoginCubit({required this.repository}) : super(LoginInitial());

  Future<void> login({
    required int nationalId,
    required String password,
  }) async {
    try {
      emit(LoginLoading());
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