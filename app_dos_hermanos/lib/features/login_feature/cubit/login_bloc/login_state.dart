part of 'login_bloc.dart';

class LoginState extends Equatable {

  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isSumbiting;
  final bool isSucces;
  final bool isFailure;

  bool get isFormValid => isEmailValid && isPasswordValid;
  
  const LoginState({required this.isEmailValid, required this.isPasswordValid, required this.isSumbiting, required this.isSucces, required this.isFailure});

  String toString(){
    return ''' LoginState {
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

class UpdateLogin extends LoginState{

  final bool isEmailValid;
  final bool isPasswordValid;

  UpdateLogin({required this.isEmailValid, required this.isPasswordValid}) : super(
    isEmailValid: isEmailValid,
    isPasswordValid: isPasswordValid,
    isFailure: false,
    isSucces: false,
    isSumbiting: false
  );

  @override
  List<Object> get props => [isEmailValid, isPasswordValid, isFailure, isSucces, isSumbiting];
}


class EmptyLogin extends LoginState {
  EmptyLogin() : super (
    isEmailValid: true,
    isPasswordValid: true,
    isSumbiting: false,
    isSucces: false,
    isFailure: false
  );
}

class LoadingLogin extends LoginState {
  LoadingLogin() : super(
    isEmailValid: true,
    isPasswordValid: true,
    isSumbiting: true,
    isSucces: false,
    isFailure: false
  );
}

class FailLogin extends LoginState {
  FailLogin() : super(
    isEmailValid: true,
    isPasswordValid: true,
    isSumbiting: false,
    isSucces: false,
    isFailure: true
  );
}

class SuccesLogin extends LoginState {
  SuccesLogin() : super(
    isEmailValid: true,
    isPasswordValid: true,
    isSumbiting: false,
    isSucces: true,
    isFailure: false
  );
}
