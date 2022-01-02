import 'package:app_dos_hermanos/classes/user.dart';
import 'package:app_dos_hermanos/repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'authenticaiton_event.dart';
part 'authenticaiton_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {

  final AuthenticationRepository _authenticationRepository;
  
  AuthenticationBloc({ required AuthenticationRepository authenticationRepository})
    : _authenticationRepository = authenticationRepository,
    super (AuthenticationInitialState()){
        
      on<AuthenticationUserChanged>((event, emit){

        event.user != User.empty
        ? emit(AuthenticatedUser(user: event.user))
        : emit (UnknownUser());
      });

      on<AuthenticationLogoutRequested>((event, emit){
        _authenticationRepository.logOut();
      });
  }
}