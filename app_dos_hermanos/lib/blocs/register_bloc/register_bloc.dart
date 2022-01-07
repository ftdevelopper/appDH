import 'package:app_dos_hermanos/classes/user.dart';
import 'package:app_dos_hermanos/classes/validators.dart';
import 'package:app_dos_hermanos/repository/authentication_repository.dart';
import 'package:app_dos_hermanos/repository/users_repository.dart';
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
      // ignore: invalid_use_of_visible_for_testing_member
      emit(new LoadingRegister());
      try {
        await authenticationRepository.signUp(email: event.user.email, password: event.password);
        final User _newuser = await authenticationRepository.user.first;
        await UserRepository(uid: _newuser.id).updateUserData(User(id: _newuser.id,location: event.user.location, name: event.user.name, email: event.user.email, photo: event.user.photo));
        // ignore: invalid_use_of_visible_for_testing_member
        emit(SuccesRegister());
      } catch (_) {
        // ignore: invalid_use_of_visible_for_testing_member
        emit(FailRegister());
      }
    });
  }
}
