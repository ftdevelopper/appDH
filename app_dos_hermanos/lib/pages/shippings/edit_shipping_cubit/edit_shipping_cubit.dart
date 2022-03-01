import 'dart:async';

import 'package:app_dos_hermanos/blocs/bluetootu_cubit/bluetooth_cubit.dart';
import 'package:app_dos_hermanos/classes/shipping.dart';
import 'package:app_dos_hermanos/repository/shipping_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'edit_shipping_state.dart';

class EditShippingCubit extends Cubit<EditShippingState> {
  EditShippingCubit({required this.bluetoothCubit}) : super(EditShippingEmpty());

  final BluetoothCubit bluetoothCubit;

  late StreamSubscription? bluetoothSubscription;

  void init(){
    if (bluetoothSubscription == null){
      bluetoothSubscription!.cancel();
    }
    bluetoothSubscription = bluetoothCubit.stream.listen((bluetoothState) {
      if (bluetoothState is ConnectedBluetooth){
        switch (state.shipping.shippingState) {
          case ShippingStatus.newShipping:
            emit(EditShippingUpdate(shipping: state.shipping.copyWith(Shipping(
              remiterFullWeight: bluetoothState.data
            ))));
          break;
          case ShippingStatus.inTravelShipping:
            emit(EditShippingUpdate(shipping: state.shipping.copyWith(Shipping(
              reciverFullWeight: bluetoothState.data
            ))));
          break;
          case ShippingStatus.newShipping:
            emit(EditShippingUpdate(shipping: state.shipping.copyWith(Shipping(
              reciverTara: bluetoothState.data
            ))));
          break;
          default:
        }
      }
    });
  }
  
  void loadShipping(Shipping shipping){
    emit(EditShippingUpdate(shipping: shipping));
  }

  void updateShippingParameter(Shipping shipping){
    emit(EditShippingUpdate(shipping: state.shipping.copyWith(shipping)));
  }

  void uploadSihpping(){
    emit(EditShippingUploading(shipping: state.shipping));
    try {
      ShippingRepository().updateParameter(shipping: state.shipping);
    } catch (e) {
      emit(EditShippingFailUpload(shipping: state.shipping));
    }
  }

  @override
  Future<void> close() {
    if (bluetoothSubscription != null){
      bluetoothSubscription!.cancel();
    }
    return super.close();
  }
}
