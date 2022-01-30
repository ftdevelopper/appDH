import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

part 'bluetooth_state.dart';

class BluetoothCubit extends Cubit<MyBluetoothState> {
  BluetoothCubit() : super(BluetoothInitial());

  BluetoothState bluetoothState = BluetoothState.UNKNOWN;

  late StreamSubscription<Uint8List> bluetoothSubscription;

  String? adress = '';
  String? name = '';

  bool isConnecting = true;
  bool isDisconnecting = true;
  var connection;

  void initBlutetooth() async {
    bluetoothState = await FlutterBluetoothSerial.instance.state;

    Future.doWhile(() async {
      return await FlutterBluetoothSerial.instance.isEnabled == true
          ? false
          : await Future.delayed(Duration(milliseconds: 500)).then((_) => true);
    }).then((_) async {
      adress = await FlutterBluetoothSerial.instance.address;
      name = await FlutterBluetoothSerial.instance.name;

      FlutterBluetoothSerial.instance
          .onStateChanged()
          .listen((BluetoothState state) {
        bluetoothState = state;
      });
    });
  }

  void connectBluetooth() {}

  void requresData() {}

  void entableConection(BluetoothDevice selectedDevice) async {
    // ignore: unnecessary_null_comparison
    if (selectedDevice != null) {
      print('Discovery -> selected ' + selectedDevice.address);
      BluetoothConnection.toAddress(selectedDevice.address).then(( _connection) {
        print('Connected to the device');
        connection = _connection;
        isConnecting = false;
        isDisconnecting = false;

        bluetoothSubscription = connection.input.listen(_reciveData);
        emit(ConnectedBluetooth());
      });
    } else {
      print('Discovery -> no device selected');
    }
  }

  void _reciveData(Uint8List data){
    print('Data recived: $data');
  }

  void requestWeight({required String comand, required String patent}){
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd kk:mm').format(now);
    print(formattedDate);
    connection.output.add(Uint8List.fromList(
      [0x02]
      + utf8.encode(comand).toList()
      + utf8.encode(patent).toList()
      + [0x0D, 0x0A]
      + utf8.encode(formattedDate.toString()).toList()
      + [0x0D, 0x0A]
      + [0x03]
    ));
  }
}
