part of 'authenticaiton_bloc.dart';

enum AuthenticationStatus{ authenticated, unaunthenticated, unknown}

abstract class AuthenticationState extends Equatable {

  final AuthenticationStatus status;
  final User user;

  const AuthenticationState({
    required this.status,
    required this.user
  });

  @override
  List<Object> get props => [this.status, this.user];
}

class AuthenticationInitialState extends AuthenticationState{

  AuthenticationInitialState() : super(status: AuthenticationStatus.unknown, user: User.empty);

  @override
  List<Object> get props => [this.status, this.user];
}

class UnknownUser extends AuthenticationState{

  UnknownUser() : super(status:AuthenticationStatus.unknown, user: User.empty);

  @override
  List<Object> get props => [this.status, this.user];
}

class UnaunthenticatedUser extends AuthenticationState{

  UnaunthenticatedUser() : super(status: AuthenticationStatus.unaunthenticated, user: User.empty);

  @override
  List<Object> get props => [this.status, this.user];
}

class AuthenticatedUser extends AuthenticationState{
  final User user;

  AuthenticatedUser({required this. user}) : super(status: AuthenticationStatus.authenticated, user: user);

  @override
  List<Object> get props => [this.status, this.user];
}