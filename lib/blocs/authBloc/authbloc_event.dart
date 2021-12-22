part of 'authbloc_bloc.dart';

abstract class AuthblocEvent extends Equatable {
  const AuthblocEvent();

  @override
  List<Object> get props => [];
}

class AppStartedEvent extends AuthblocEvent{
  
}
