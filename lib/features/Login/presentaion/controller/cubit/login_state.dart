abstract class LoginState {
  const LoginState();
}

class LoginInitial extends LoginState {
  const LoginInitial();
}

class LoginLoading extends LoginState {
  const LoginLoading();
}

class LoginSuccess extends LoginState {
  final Map<String, dynamic> data;
  const LoginSuccess(this.data);
}

class LoginError extends LoginState {
  final String message;
  const LoginError(this.message);
}