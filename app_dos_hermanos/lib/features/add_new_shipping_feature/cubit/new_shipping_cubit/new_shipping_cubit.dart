import 'dart:async';
import 'package:app_dos_hermanos/features/get_shippings_feature/models/shipping.dart';
import 'package:app_dos_hermanos/features/connect_bluetooth_feature/cubit/bluetootu_cubit/bluetooth_cubit.dart';
import 'package:app_dos_hermanos/repository/authentication_repository.dart';
import 'package:app_dos_hermanos/repository/shipping_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

part 'new_shipping_state.dart';

class NewShippingCubit extends Cubit<NewShippingState> {
  NewShippingCubit({required this.bluetoothCubit, required this.authenticationRepository}) : super(NewShippingEmpty());

  final BluetoothCubit bluetoothCubit;
  final AuthenticationRepository authenticationRepository;

  late StreamSubscription? bluetoothSubscription;

  void init(){
    if (bluetoothSubscription == null){
      bluetoothSubscription!.cancel();
    }
    bluetoothSubscription = bluetoothCubit.stream.listen((bluetoothState) {
      if (bluetoothState is ConnectedBluetooth){
        emit(NewShippingUpdate(shipping: state.shipping.copyWith(
          Shipping(remiterTara: bluetoothState.data)
        )));
      }
    });
  }

  void setNewShipping(){
    emit(NewShippingUpdate(shipping: Shipping(
      remiterLocation: authenticationRepository.user.location.name,
      shippingState: ShippingStatus.newShipping,
      isOnLine: true,
    )));
  }

  void updateShippingParameter(Shipping newshipping){
    emit(NewShippingUpdate(shipping: state.shipping.copyWith(newshipping)));
  }

  Future<void> confirmButtonPressed() async {
    final DateTime dateTime = DateTime.now();
    final String _formattedDate = DateFormat('yy-MM-dd-kk:mm:ss').format(dateTime);
    Shipping _shipping = Shipping(
      id: (state.shipping.chasisPatent ?? '') + ' - ' + _formattedDate,
      remiterTaraTime: dateTime,
      remiterTaraUser: authenticationRepository.user.id,
    );
    _shipping.addAction(action: 'Taro', user: authenticationRepository.user.id, date: dateTime.toString(),);

    emit(NewShippingUploading(shipping: state.shipping));
    try {
      ShippingRepository().putShipping(state.shipping.copyWith(_shipping)); 
    } catch (e) {
      emit(NewShippingFailUpload(shipping: state.shipping));
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
