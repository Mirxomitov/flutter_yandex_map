import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_yandex_map/data/model/user_data.dart';
import 'package:flutter_yandex_map/data/remote/services/registration_service.dart';
import 'package:flutter_yandex_map/data/remote/services/users_location_service.dart';
import 'package:flutter_yandex_map/domain/users_location.dart';
import 'package:flutter_yandex_map/util/status.dart';

import '../../../domain/registration.dart';

part 'friends_event.dart';
part 'friends_state.dart';

class FriendsBloc extends Bloc<FriendsEvent, FriendsState> {
  final UsersLocation usersLocation = UsersLocationService();
  final Registration registerUser = RegistrationService();

  FriendsBloc() : super(FriendsState.initial()) {
    on<LoadFriendsEvent>((event, emit) async {
      emit(state.copyWith(status: Status.loading));
      final users = await usersLocation.getUsersLocation();
      emit(state.copyWith(friends: users, status: Status.success));
    });

    on<LogoutEvent>((event, emit) async {
      await registerUser.logout();

      emit(state.copyWith(status: Status.success, logout: true));
    });
  }
}
