import 'dart:io';
import 'package:app_dos_hermanos/repositories/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../utils/validations/login_validators.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  AuthenticationRepository authenticationRepository;

  RegisterBloc({required this.authenticationRepository})
      : super(EmptyRegister()) {
    on<EmailChanged>((event, emit) {
      emit(new UpdateRegister(
          isEmailValid: Validators.isValidEmail(event.email),
          isPasswordValid: state.isPasswordValid));
    });

    on<PasswordChanged>((event, emit) {
      emit(new UpdateRegister(
          isEmailValid: state.isEmailValid,
          isPasswordValid: Validators.isValidPassword(event.password)));
    });

    on<Sumbitted>((event, state) async {
      // ignore: invalid_use_of_visible_for_testing_member
      emit(new LoadingRegister());
      try {
        //authenticationRepository.user = await authenticationRepository.signUp(password: event.password, photoFile: event.photoFile);
        // ignore: invalid_use_of_visible_for_testing_member
        emit(SuccesRegister());
      } catch (_) {
        // ignore: invalid_use_of_visible_for_testing_member
        emit(FailRegister());
      }
    });
  }
}
