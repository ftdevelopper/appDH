import 'package:app_dos_hermanos/repositories/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../utils/validations/login_validators.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  late AuthenticationRepository authenticationRepository;

  LoginBloc({required this.authenticationRepository}) : super(EmptyLogin()) {
    on<EmailChanged>((event, emit) {
      emit(new UpdateLogin(
          isEmailValid: Validators.isValidEmail(event.email),
          isPasswordValid: state.isPasswordValid));
    });

    on<PasswordChanged>((event, emit) {
      emit(new UpdateLogin(
          isEmailValid: state.isEmailValid,
          isPasswordValid: Validators.isValidPassword(event.password)));
    });

    /*on<LoginWithGooglePressed>((event, emit) async {
      try {
        await authenticationRepository.logInWithGoogle();
        emit(SuccesLogin());
      } catch (_) {
        emit(FailLogin());
      }
    });*/

    on<LoginWithCredentialPressed>((event, emit) async {
      emit(LoadingLogin());
      try {
        await authenticationRepository.logInWithEmailAndPassword(
            password: event.password);
        emit(SuccesLogin());
      } catch (_) {
        emit(FailLogin());
      }
    });
  }
}
