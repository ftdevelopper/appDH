import 'dart:async';

import 'package:app_dos_hermanos/classes/shipping.dart';
import 'package:app_dos_hermanos/repository/shipping_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'shippings_event.dart';
part 'shippings_state.dart';

class ShippingsBloc extends Bloc<ShippingsEvent, ShippingsState> {
  final ShippingRepository shippingRepository;
  late StreamSubscription _shippingsSubscription;

  ShippingsBloc({required this.shippingRepository}) : super(ShippingsLoading()) {

    on<LoadShippings>((event, emit) async {
      emit(ShippingsLoading());
      try {
        _shippingsSubscription = shippingRepository.getSippings().listen((event){
          (shippings) => add(ShippingsUpdated(shippingList: shippings));
        });
      } catch (e) {
        print('Error recived: $e');
        emit(ShippingsNotLoaded());
      }
    });

    on<AddShipping>((event, emit) async {
      await shippingRepository.putShipping(event.shipping);
    });

    on<ShippingsUpdated>((event, emit){
      emit(ShippingsLoaded(shippings: event.shippingList));
    });
  }

  @override
  Future<void> close() {
    _shippingsSubscription.cancel();
    return super.close();
  }
}
