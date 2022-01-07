part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class EmailChanged extends RegisterEvent  {
  final String email;

  EmailChanged({required this.email});

  @override
  List<Object> get props => [email];

  @override
  String toString() => 'EmailChanged: $email';
}

class PasswordChanged extends RegisterEvent {
  final String password;

  PasswordChanged({required this.password});

  @override
  List<Object> get props => [password];

  String toString() => 'PasswordChanged password: $password';
}

class Sumbitted extends RegisterEvent {
  final String password;
  final User user;

  Sumbitted({required this.password, required this.user});

  @override
  List<Object> get props => [password, user];

  @override
  String toString() => 'Sumbbited: {password: $password, user: $user}';
}