part of 'authenticaiton_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AuthenticationUserChanged extends AuthenticationEvent {
  @override
  List<Object> get props => [];
}

class AuthenticationLogoutRequested extends AuthenticationEvent {}
