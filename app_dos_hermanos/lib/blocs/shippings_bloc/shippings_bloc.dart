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
  late StreamSubscription? _shippingsSubscription;

  ShippingsBloc({required this.shippingRepository}) : super(ShippingsLoading()) {

    _shippingsSubscription = shippingRepository.getShippings(duration: Duration(days: 2)).listen((event) {});

    on<LoadShippings>((event, emit) async {
      _shippingsSubscription?.cancel();
      emit(ShippingsLoading());
      try {
        _shippingsSubscription = shippingRepository.getShippings(
          duration: event.duration ?? Duration(days: 2),
        ).listen(
          (shippings){
            return add(ShippingsUpdated(shippingList: filterShippings(shippings: shippings, event: event)));
          }
        );
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
    _shippingsSubscription?.cancel();
    return super.close();
  }
}

List<Shipping> filterShippings({required List<Shipping> shippings, required LoadShippings event}){

  String? destination = event.reciverLocation == 'SELECCIONAR' ? null : event.reciverLocation;
  String? origin = event.remiterLocation == 'SELECCIONAR' ? null : event.remiterLocation;

  if (destination == null && origin == null){
    return shippings;
  }

  if (destination == null){
    return shippings.where((element) => element.remiterLocation == origin).toList();
  }

  if (origin == null){
    return shippings.where((element) => element.reciverLocation == destination).toList();
  }

  return shippings.where((element) => element.reciverLocation == destination || element.remiterLocation == origin).toList();
}
