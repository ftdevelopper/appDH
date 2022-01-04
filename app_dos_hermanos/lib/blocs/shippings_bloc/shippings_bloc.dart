import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'shippings_event.dart';
part 'shippings_state.dart';

class ShippingsBloc extends Bloc<ShippingsEvent, ShippingsState> {
  ShippingsBloc() : super(ShippingsInitial()) {
    on<ShippingsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
