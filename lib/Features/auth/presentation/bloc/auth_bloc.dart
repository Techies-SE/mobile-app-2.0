import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app_2/Features/auth/domain/usecases/change_password.dart';
import 'package:mobile_app_2/Features/auth/domain/usecases/login.dart';
import 'package:mobile_app_2/Features/auth/domain/usecases/logout.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Login loginUsecase;
  final Logout logoutUsecase;
  final Changepassword changePasswordUseCase;

  AuthBloc({
    required this.loginUsecase,
    required this.logoutUsecase,
    required this.changePasswordUseCase,
  }) : super(AuthInitial()) {
    on<LoginRequest>(_loginRequest);
    on<LogoutRequest>(_logoutRequest);
    on<ChangePasswordEvent>(_changePassword);
  }

  Future<void> _loginRequest(
      LoginRequest event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final result = await loginUsecase(event.phone_no, event.password);
      emit(AuthLoginSuccess(authEntity: result));
    } catch (e) {
      emit(AuthFail(error: e.toString()));
    }
  }

  Future<void> _logoutRequest(
      LogoutRequest event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await logoutUsecase();
      emit(AuthLogoutSuccess());
    } catch (e) {
      emit(AuthFail(error: e.toString()));
    }
  }

  Future<void> _changePassword(
      ChangePasswordEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await changePasswordUseCase(event.password);
      emit(ChangePasswordSuccess());
    } catch (e) {
      emit(AuthFail(error: e.toString()));
    }
  }
}
