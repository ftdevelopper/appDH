import 'dart:async';
import 'package:app_dos_hermanos/classes/humidity_calculation.dart';
import 'package:app_dos_hermanos/features/get_shippings_feature/models/shipping.dart';
import 'package:app_dos_hermanos/features/connect_bluetooth_feature/cubit/bluetootu_cubit/bluetooth_cubit.dart';
import 'package:app_dos_hermanos/repository/authentication_repository.dart';
import 'package:app_dos_hermanos/repository/shipping_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'edit_shipping_state.dart';

class EditShippingCubit extends Cubit<EditShippingState> {
  EditShippingCubit(
      {required this.bluetoothCubit, required this.authenticationRepository})
      : super(EditShippingEmpty());

  final BluetoothCubit bluetoothCubit;
  final AuthenticationRepository authenticationRepository;

  late StreamSubscription? bluetoothSubscription;

  void init() {
    if (bluetoothSubscription == null) {
      bluetoothSubscription!.cancel();
    }
    bluetoothSubscription = bluetoothCubit.stream.listen((bluetoothState) {
      if (bluetoothState is ConnectedBluetooth) {
        switch (state.shipping.shippingState) {
          case ShippingStatus.newShipping:
            emit(EditShippingUpdate(
                shipping: state.shipping.copyWith(
                    Shipping(remiterFullWeight: bluetoothState.data))));
            break;
          case ShippingStatus.inTravelShipping:
            emit(EditShippingUpdate(
                shipping: state.shipping.copyWith(
                    Shipping(reciverFullWeight: bluetoothState.data))));
            break;
          case ShippingStatus.newShipping:
            emit(EditShippingUpdate(
                shipping: state.shipping
                    .copyWith(Shipping(reciverTara: bluetoothState.data))));
            break;
          default:
        }
      }
    });
  }

  void setShipping(Shipping shipping) {
    emit(EditShippingUpdate(shipping: shipping));
  }

  void updateShippingParameter(Shipping shipping) {
    emit(EditShippingUpdate(shipping: state.shipping.copyWith(shipping)));
  }

  void uploadSihpping() {
    emit(EditShippingUploading(shipping: state.shipping));
    Shipping _shipping = state.shipping;
    try {
      _shipping.nextStatus();
      if (_shipping.shippingState == ShippingStatus.inTravelShipping) {
        _shipping.addAction(
            action: 'Peso Bruto',
            user: authenticationRepository.user.id,
            date: DateTime.now().toString());
        double realWeight = double.parse(state.shipping.remiterFullWeight!) -
            double.parse(state.shipping.remiterTara!);
        _shipping.copyWith(Shipping(remiterWetWeight: realWeight.toString()));
      } else if (_shipping.shippingState == ShippingStatus.downloadedShipping) {
         _shipping.addAction(
            action: 'Peso Bruto',
            user: authenticationRepository.user.id,
            date: DateTime.now().toString());
        _shipping.copyWith(
          Shipping(
            remiterDryWeight: (double.parse(_shipping.remiterWetWeight!) *
                    HumidityCalculaiton.getMerme(
                        double.parse(_shipping.humidity!)))
                .toString(),
          ),
        );
      } else if (_shipping.shippingState == ShippingStatus.completedShipping) {
         _shipping.addAction(
            action: 'Peso Tara',
            user: authenticationRepository.user.id,
            date: DateTime.now().toString());
        double realWeight = double.parse(state.shipping.reciverFullWeight!) -
            double.parse(state.shipping.reciverTara!);
        _shipping.copyWith(
          Shipping(
            reciverWetWeight: realWeight.toString(),
            reciverDryWeight: (realWeight *
                    HumidityCalculaiton.getMerme(
                        double.parse(_shipping.humidity!)))
                .toString(),
          ),
        );
      }
      ShippingRepository()
          .updateParameter(shipping: state.shipping.copyWith(_shipping));
    } catch (e) {
      emit(EditShippingFailUpload(shipping: state.shipping));
    }
  }

  Future<void> confirmRecive() async {
    Shipping _shipping = state.shipping;
    _shipping.nextStatus();
    final String userID = authenticationRepository.user.id;
    final DateTime date = DateTime.now();
    late String action;
    switch (_shipping.shippingState) {
      case ShippingStatus.inTravelShipping:
        _shipping = _shipping.copyWith(Shipping(
            remiterFullWeightUser: userID, remiterFullWeightTime: date));
        action = 'Peso bruto';
        break;
      case ShippingStatus.downloadedShipping:
        action = 'Peso bruto';
        _shipping = _shipping.copyWith(Shipping(
            reciverFullWeightUser: userID, reciverFullWeightTime: date));
        break;
      case ShippingStatus.completedShipping:
        action = 'Taro';
        _shipping = _shipping
            .copyWith(Shipping(reciverTaraUser: userID, reciverTaraTime: date));
        break;
      case ShippingStatus.unknownStatus:
        action = 'Desconocido';
        break;
      case ShippingStatus.deletedShipping:
        action = 'Elimino';
        break;
      default:
    }
    _shipping.addAction(action: action, user: userID, date: date.toString());
    try {
      ShippingRepository().updateParameter(shipping: _shipping);
    } catch (e) {
      emit(EditShippingFailUpload(shipping: state.shipping));
    }
  }

  void getDryWet({required bool isRemiter}) {
    double? humidity = double.tryParse(state.shipping.humidity ?? '');
    double? reciverNet = double.tryParse(state.shipping.reciverWetWeight ?? '');
    double? remiterNet = double.tryParse(state.shipping.remiterWetWeight ?? '');
    if(humidity != null && reciverNet != null && remiterNet != null){
      if (isRemiter){
        emit(EditShippingUpdate(
          shipping: state.shipping.copyWith(
            Shipping(
              remiterDryWeight: (remiterNet * HumidityCalculaiton.getMerme(humidity)).toString()
            ),
          ),
        ));
      }
      else {
       emit(EditShippingUpdate(
          shipping: state.shipping.copyWith(
            Shipping(
              reciverDryWeight: (reciverNet * HumidityCalculaiton.getMerme(humidity)).toString(),
            )
          ),
        ));
      } 
    }
  }

  @override
  Future<void> close() {
    if (bluetoothSubscription != null) {
      bluetoothSubscription!.cancel();
    }
    return super.close();
  }
}
