part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class EmailChanged extends LoginEvent  {
  final String email;

  EmailChanged({required this.email});

  @override
  List<Object> get props => [email];

  @override
  String toString() => 'EmailChanged: $email';
}

class PasswordChanged extends LoginEvent {
  final String password;

  PasswordChanged({required this.password});

  @override
  List<Object> get props => [password];

  String toString() => 'PasswordChanged password: $password';
}

class Sumbitted extends LoginEvent {
  final String email;
  final String password;

  Sumbitted({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];

  @override
  String toString() => 'Sumbbited: {email: $email, password: $password}';
}

//class LoginWithGooglePressed extends LoginEvent {}

class LoginWithCredentialPressed extends LoginEvent {
  final String password;

  LoginWithCredentialPressed({required this.password});

  @override
  List<Object> get props => [password];

  @override
  String toString() => 'LoginWithCredential: {password: $password}';
}