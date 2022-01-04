import 'package:app_dos_hermanos/classes/shipping.dart';
import 'package:app_dos_hermanos/repository/shipping_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'shippings_event.dart';
part 'shippings_state.dart';

class ShippingsBloc extends Bloc<ShippingsEvent, ShippingsState> {
  final ShippingRepository shippingRepository;
  ShippingsBloc({required this.shippingRepository}) : super(ShippingsLoading()) {
    on<LoadShippings>((event, emit) async {
      emit(ShippingsLoading());
      try {
        final List<Shipping> shippings = await shippingRepository.getSippings().first;
        emit(ShippingsLoaded(shippings: shippings));
        print('Shipping recived: ${shippings.toString()}');
      } catch (e) {
        print('Error recived: $e');
        emit(ShippingsNotLoaded());
      }
    });
  }
}
