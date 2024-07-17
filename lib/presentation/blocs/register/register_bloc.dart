import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_yandex_map/data/model/app_lat_long.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/remote/services/registration_service.dart';
import '../../../domain/registration.dart';
import '../../../util/status.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final Registration registrationService = RegistrationService();

  RegisterBloc() : super(RegisterState.initial()) {
    on<RegisterImageSelected>((event, emit) {
      emit(state.copyWith(pickedImage: event.image));
      print(state.pickedImage?.path);
    });

    on<RegisterUser>((event, emit) async {
      print('bloc register user');
      emit(state.copyWith(status: Status.loading));

      try {
        await registrationService.register(
          email: event.email,
          password: event.password,
          imagePath: event.image.path,
          name: event.userName,
          lat: event.location.lat,
          long: event.location.long,
        );

        emit(state.copyWith(isRegistered: true, status: Status.success));
      } catch (e) {
        emit(state.copyWith(status: Status.failure, isRegistered: false));
      }
    });
  }
}
