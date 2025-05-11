abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final Map<String, dynamic> data;
  LoginSuccess(this.data);
}

class LoginError extends LoginState {
  final String message;
  LoginError(this.message);
}