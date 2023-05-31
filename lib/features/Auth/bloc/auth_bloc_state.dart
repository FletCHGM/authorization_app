part of 'auth_bloc_bloc.dart';

sealed class AuthState {}

class AuthInitial implements AuthState {}

class AuthLoadig implements AuthState {}

class AuthSuccess implements AuthState {}

class AuthFailure implements AuthState {
  AuthFailure(this.error);
  String? error;
}
