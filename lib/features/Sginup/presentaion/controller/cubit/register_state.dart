abstract class RegisterState {
  const RegisterState();
}

class RegisterInitial extends RegisterState {
  const RegisterInitial();
}

class RegisterLoading extends RegisterState {
  const RegisterLoading();
}

class RegisterSuccess extends RegisterState {
  final Map<String, dynamic> response;
  const RegisterSuccess(this.response);
}

class RegisterError extends RegisterState {
  final String message;
  const RegisterError(this.message);
} 