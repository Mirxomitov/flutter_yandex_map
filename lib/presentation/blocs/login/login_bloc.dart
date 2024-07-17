import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/remote/services/registration_service.dart';
import '../../../domain/registration.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final Registration registrationService = RegistrationService();

  LoginBloc() : super(LoginState.initial()) {
    on<LoginUserEvent>((event, emit) async {
      emit(state.copyWith(status: LoginStatus.loading));

      try {
        await registrationService.login(event.email, event.password);

        emit(state.copyWith(status: LoginStatus.success));
      } catch (e) {
        emit(state.copyWith(status: LoginStatus.failure, errorMessage: e.toString()));
      }
    });

    on<ToRegisterEvent>((event, emit) {
      emit(state.copyWith(toRegister: true));
      emit(state.copyWith(toRegister: false));
    });
  }
}
