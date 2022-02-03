import 'dart:async';

import 'package:app_dos_hermanos/classes/filter.dart';
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

  ShippingsBloc({required this.shippingRepository}) : super(ShippingsLoading(filter: Filter(duration: Duration(days: 3)))) {

    on<LoadShippings>((event, emit) async {
      try {
        _shippingsSubscription?.cancel();  
      } catch (e) {
        print(e);
      }
      emit(ShippingsLoading(filter: event.filter));
      try {
        print('state filter: ${state.filter?.duration}, ${state.filter?.destination}');
        _shippingsSubscription = shippingRepository.getShippings(
          duration: state.filter?.duration ?? Duration(days: 3),
        ).listen(
          (shippings){
            return add(ShippingsUpdated(shippingList: filterShippings(shippings: shippings, filter: state.filter)));
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

List<Shipping> filterShippings({required List<Shipping> shippings, required Filter? filter}){

  String? destination = filter?.origin == 'SELECCIONAR' ? null : filter?.origin;
  String? origin = filter?.destination == 'SELECCIONAR' ? null : filter?.destination;

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
