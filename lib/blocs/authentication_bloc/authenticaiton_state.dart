part of 'authenticaiton_bloc.dart';

abstract class AuthenticaitonState extends Equatable {
  const AuthenticaitonState();
  
  @override
  List<Object> get props => [];
}

class AuthenticaitonInitial extends AuthenticaitonState {}
