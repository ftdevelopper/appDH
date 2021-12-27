import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'authenticaiton_event.dart';
part 'authenticaiton_state.dart';

class AuthenticaitonBloc extends Bloc<AuthenticaitonEvent, AuthenticaitonState> {
  AuthenticaitonBloc() : super(AuthenticaitonInitial()) {
    on<AuthenticaitonEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
