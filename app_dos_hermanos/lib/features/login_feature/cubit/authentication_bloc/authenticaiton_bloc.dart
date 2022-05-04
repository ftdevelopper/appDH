import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:app_dos_hermanos/features/login_feature/models/user.dart';
import 'package:app_dos_hermanos/repositories/authentication_repository.dart';

part 'authenticaiton_event.dart';
part 'authenticaiton_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository _authenticationRepository;

  AuthenticationBloc(
      {required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(AuthenticationInitialState()) {
    on<AuthenticationUserChanged>((event, emit) async {
      if (authenticationRepository.isLoggedIn()) {
        await authenticationRepository.getUser;
        emit(AuthenticatedUser(user: authenticationRepository.user));
      } else {
        emit(UnknownUser());
      }

      print('Authenticaiton User Changed with the following parameters:');
      print(
          'ID: ${authenticationRepository.user.id}, Name: ${authenticationRepository.user.name}, email: ${authenticationRepository.user.email}, photoURL ${authenticationRepository.user.photoURL}');
    });

    on<AuthenticationLogoutRequested>((event, emit) {
      _authenticationRepository.logOut();
      emit(UnaunthenticatedUser());
    });
  }
}
