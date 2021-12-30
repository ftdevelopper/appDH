part of 'login_bloc.dart';

class LoginState extends Equatable {

  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isSumbiting;
  final bool isSucces;
  final bool isFailure;

  bool get isFormValid => isEmailValid && isPasswordValid;
  
  const LoginState({required this.isEmailValid, required this.isPasswordValid, required this.isSumbiting, required this.isSucces, required this.isFailure});

  LoginState copyWith({
    bool? isEmailValid,
    bool? isPasswordValid,
    bool? isSumbiting,
    bool? isSucces,
    bool? isFailure,
  }){
    return LoginState(
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isSumbiting: isSumbiting ?? this.isSumbiting,
      isSucces: isSucces ?? this.isSucces,
      isFailure: isFailure ?? this.isFailure
    );
  }

  LoginState update({
    bool? isEmailvalid,
    bool? isPasswordBalid
  }){
    return copyWith(
      isEmailValid: isEmailValid,
      isPasswordValid: isPasswordValid,
      isSumbiting: false,
      isSucces: false,
      isFailure: false
    );
  }

  String toString(){
    return ''' LoginState {\n
      isEmailValid: $isEmailValid \n
      isPasswordValid: $isPasswordValid \n
      isSumbiting: $isSumbiting \n
      isSucces: $isSucces \n
      isFailure: $isFailure \n
      }''';
  }
  
  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

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
