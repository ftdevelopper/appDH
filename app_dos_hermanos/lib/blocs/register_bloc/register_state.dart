part of 'register_bloc.dart';

class RegisterState extends Equatable {

  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isSumbiting;
  final bool isSucces;
  final bool isFailure;

  bool get isFormValid => isEmailValid && isPasswordValid;
  
  const RegisterState({required this.isEmailValid, required this.isPasswordValid, required this.isSumbiting, required this.isSucces, required this.isFailure});

  String toString(){
    return ''' RegisterState {
      isEmailValid: $isEmailValid
      isPasswordValid: $isPasswordValid
      isSumbiting: $isSumbiting
      isSucces: $isSucces
      isFailure: $isFailure
      }''';
  }
  
  @override
  List<Object> get props => [isEmailValid, isPasswordValid, isFailure, isSucces, isSumbiting];
}

class UpdateRegister extends RegisterState{

  final bool isEmailValid;
  final bool isPasswordValid;

  UpdateRegister({required this.isEmailValid, required this.isPasswordValid}) : super(
    isEmailValid: isEmailValid,
    isPasswordValid: isPasswordValid,
    isFailure: false,
    isSucces: false,
    isSumbiting: false
  );

  @override
  List<Object> get props => [isEmailValid, isPasswordValid, isFailure, isSucces, isSumbiting];
}


class EmptyRegister extends RegisterState {
  EmptyRegister() : super (
    isEmailValid: true,
    isPasswordValid: true,
    isSumbiting: false,
    isSucces: false,
    isFailure: false
  );
}

class LoadingRegister extends RegisterState {
  LoadingRegister() : super(
    isEmailValid: true,
    isPasswordValid: true,
    isSumbiting: true,
    isSucces: false,
    isFailure: false
  );
}

class FailRegister extends RegisterState {
  FailRegister() : super(
    isEmailValid: true,
    isPasswordValid: true,
    isSumbiting: false,
    isSucces: false,
    isFailure: true
  );
}

class SuccesRegister extends RegisterState {
  SuccesRegister() : super(
    isEmailValid: true,
    isPasswordValid: true,
    isSumbiting: false,
    isSucces: true,
    isFailure: false
  );
}
