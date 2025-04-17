import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import 'package:variant_master/core/usecases/usecase.dart';
import 'package:variant_master/features/auth/domain/entities/user.dart';
import 'package:variant_master/features/auth/domain/usecases/check_auth.dart';
import 'package:variant_master/features/auth/domain/usecases/login.dart';
import 'package:variant_master/features/auth/domain/usecases/logout.dart';

part 'auth_event.dart';
part 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final CheckAuth _checkAuth;
  final Login _login;
  final Logout _logout;

  AuthBloc({
    required CheckAuth checkAuth,
    required Login login,
    required Logout logout,
  })  : _checkAuth = checkAuth,
        _login = login,
        _logout = logout,
        super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _checkAuth(NoParams());
    result.fold(
      (failure) => emit(AuthUnauthenticated()),
      (user) => user != null
          ? emit(AuthAuthenticated(user))
          : emit(AuthUnauthenticated()),
    );
  }

  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _login(
      LoginParams(
        email: event.email,
        password: event.password,
      ),
    );
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _logout(NoParams());
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(AuthUnauthenticated()),
    );
  }
}
