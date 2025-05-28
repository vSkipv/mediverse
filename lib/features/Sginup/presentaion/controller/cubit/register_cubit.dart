import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediverse/features/Sginup/presentaion/controller/cubit/register_state.dart';

import '../../../data/repositories/register_repository.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterRepository repository;

  RegisterCubit({required this.repository}) : super(const RegisterInitial());

  Future<void> register({
    required int nationalId,
    required String email,
    required String firstName,
    required String lastName,
    required String gender,
    required String phoneNumber,
    required String country,
    required String city,
    required String fullAddress,
    required String password,
  }) async {
    try {
      emit(const RegisterLoading());
      final response = await repository.register(
        nationalId: nationalId,
        email: email,
        firstName: firstName,
        lastName: lastName,
        gender: gender,
        phoneNumber: phoneNumber,
        country: country,
        city: city,
        fullAddress: fullAddress,
        password: password,
      );
      emit(RegisterSuccess(response));
    } catch (e) {
      emit(RegisterError(e.toString()));
    }
  }
} 