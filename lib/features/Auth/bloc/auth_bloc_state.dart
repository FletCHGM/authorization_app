part of 'auth_bloc_bloc.dart';

class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoadig extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthFailure extends AuthState {
  AuthFailure(this.error);
  String? error;
}
