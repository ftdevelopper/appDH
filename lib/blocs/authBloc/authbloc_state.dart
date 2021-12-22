part of 'authbloc_bloc.dart';

abstract class AuthblocState extends Equatable {
  const AuthblocState();
  
  @override
  List<Object> get props => [];
}

class AuthblocInitial extends AuthblocState {}

class AuthenticatedState extends AuthblocState{
  final User user;

  AuthenticatedState({required this.user});
}

class UnAuthenticadedState extends AuthblocState{}
