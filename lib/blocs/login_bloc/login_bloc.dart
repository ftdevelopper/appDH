import 'package:app_dos_hermanos/classes/validators.dart';
import 'package:app_dos_hermanos/repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  late AuthenticationRepository authenticationRepository;

  LoginBloc({required this.authenticationRepository})
  : super(EmptyLogin()){
    on<EmailChanged>((event, emit) {
      emit(state.update(
        isEmailvalid: Validators.isValidEmail(event.email)
      ));
    });

    on<PasswordChanged>((event,emit){
      emit(state.update(
        isPasswordBalid: Validators.isValidPassword(event.password)
      ));
    });

    on<LoginWithGooglePressed>((event, emit) async {
      try {
        await authenticationRepository.logInWithGoogle();
        emit(SuccesLogin());
      } catch (_) {
        emit(FailLogin());
      }
    });

    on<LoginWithCredentialPressed>((event, emit) async {
      emit(LoadingLogin());
      try {
        await authenticationRepository.logInWithEmailAndPassword(email: event.email, password: event.password);
        emit(SuccesLogin());
      } catch (_) {
        emit(FailLogin());
      }
    });
  }
}
