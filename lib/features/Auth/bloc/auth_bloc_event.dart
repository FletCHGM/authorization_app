part of 'auth_bloc_bloc.dart';

class AuthEvent {}

class TryToLogin extends AuthEvent {
  TryToLogin(this.login, this.passwd, this.context);
  final String? login;
  final String? passwd;
  final BuildContext? context;
}

class TryToReg extends AuthEvent {
  TryToReg(this.login, this.passwd, this.context);
  final String? login;
  final String? passwd;
  final BuildContext? context;
}
