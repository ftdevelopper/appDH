import 'package:app_dos_hermanos/classes/validators.dart';
import 'package:app_dos_hermanos/repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  AuthenticationRepository authenticationRepository;

  RegisterBloc({required this.authenticationRepository})
  : super(EmptyRegister()){
    on<EmailChanged>((event, emit) {
      emit(new UpdateRegister(
        isEmailValid: Validators.isValidEmail(event.email),
        isPasswordValid: state.isPasswordValid
      ));
    });

    on<PasswordChanged>((event,emit){
      emit(new UpdateRegister(
        isEmailValid: state.isEmailValid,
        isPasswordValid: Validators.isValidPassword(event.password)
      ));
    });

    on<Sumbitted>((event, state) async {
      emit(new LoadingRegister());
      try {
        await authenticationRepository.signUp(email: event.email, password: event.password);
        emit(SuccesRegister());
      } catch (_) {
        emit(FailRegister());
      }
    });
  }
}
