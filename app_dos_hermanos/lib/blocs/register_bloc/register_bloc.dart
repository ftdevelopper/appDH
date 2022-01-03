import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(EmptyRegister()) {
    on<RegisterEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
