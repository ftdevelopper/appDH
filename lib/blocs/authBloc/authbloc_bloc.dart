import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'authbloc_event.dart';
part 'authbloc_state.dart';

class AuthblocBloc extends Bloc<AuthblocEvent, AuthblocState> {
  AuthblocBloc() : super(AuthblocInitial()) {
    on<AuthblocEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
