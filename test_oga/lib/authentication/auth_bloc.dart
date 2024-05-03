import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_oga/authentication/auth_repository.dart';

abstract class AuthEvent {}

class CheckAuthEvent extends AuthEvent {}

class LoginEvent extends AuthEvent {
  final String phoneNumber;
  final String password;

  LoginEvent(this.phoneNumber, this.password);
}

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final String token;

  AuthAuthenticated(this.token);
}

class AuthUnauthenticated extends AuthState {}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<CheckAuthEvent>((event, emit) async {
      emit(AuthLoading());
      final token = await authRepository.getToken();
      if (token != null) {
        emit(AuthAuthenticated(token));
      } else {
        emit(AuthUnauthenticated());
      }
    });

    on<LoginEvent>((event, emit) async {
      emit(AuthLoading());
      final result = await authRepository.login(event.phoneNumber, event.password);
      if (result != null) {
        emit(AuthAuthenticated(result));
      } else {
        emit(AuthUnauthenticated());
      }
    });
  }
}