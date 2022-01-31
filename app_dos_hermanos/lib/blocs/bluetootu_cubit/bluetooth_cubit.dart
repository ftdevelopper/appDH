import 'dart:async';
import 'dart:typed_data';

import 'package:app_dos_hermanos/classes/bluetooth_routines.dart';
import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

part 'bluetooth_state.dart';

class BluetoothCubit extends Cubit<MyBluetoothState> {
  BluetoothCubit() : super(BluetoothInitial());

  BluetoothState bluetoothState = BluetoothState.UNKNOWN;

  late StreamSubscription<Uint8List> bluetoothSubscription;

  var connection;

  void initBlutetooth() async {
    bluetoothState = await FlutterBluetoothSerial.instance.state;

    Future.doWhile(() async {
      return await FlutterBluetoothSerial.instance.isEnabled == true
          ? false
          : await Future.delayed(Duration(milliseconds: 500)).then((_) => true);
    }).then((_) async {

      FlutterBluetoothSerial.instance
      .onStateChanged()
      .listen((BluetoothState state) {
        bluetoothState = state;
        if (state == BluetoothState.STATE_OFF){
          emit(DisconnectedBluetooth());
        }
      });

    });
  }

  void entableConection(BluetoothDevice selectedDevice) async {
    if (!selectedDevice.isConnected) {
      print('Discovery -> selected ' + selectedDevice.address);
      try {
        BluetoothConnection.toAddress(selectedDevice.address).catchError((e){print(e);}).then(( _connection) {
        print('Connected to the device');
        connection = _connection;

        bluetoothSubscription = connection.input.listen(_reciveData).onDone((){
          if (state.isDiconnecting) {
          print('Disconnecting locally!');
        } else {
          print('Disconnected remotely!');
        }
        });
        emit(ConnectedBluetooth(data: 'Conectado'));
      });  
      } catch (e) {
        print('Cannot enable connection: $e');
      }
      
    } else {
      print('Discovery -> device no ready');
      emit(ConnectedBluetooth(data: 'Reinicie el Bluetooth'));
    }
  }

  void _reciveData(Uint8List data){
    emit(ConnectedBluetooth(data: String.fromCharCodes(data)));
    print('Data recived: ${String.fromCharCodes(data)}');
  }

  void requestWeight({required String comand, required String patent}) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd kk:mm').format(now);
    print('Request Weight -- Comand:$comand, Patent:$patent, date: $formattedDate');
    try {
      connection.output.add(BluetoothRoutines.btSendBuffer(comand, patent, formattedDate));
      await connection.output.allSent;
    } catch (e) {
      print(e);
    }
  }

  void disconectBluetooth() async {
    if (connection != null && connection.isConnected){
      emit(ChangingBluetoothState(isConnecting: false, isDiconnecting: true));
      try {
        await connection.dispose();
        connection = null;
        emit(DisconnectedBluetooth());
      } catch (e) {
        print('Error in disconnection: $e');
      }
    }
  }
}
