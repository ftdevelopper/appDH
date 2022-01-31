part of 'bluetooth_cubit.dart';

abstract class MyBluetoothState {
  MyBluetoothState({required this.isConnecting, required this.isDiconnecting, required this.data});

  bool isConnecting;
  bool isDiconnecting;

  String data;
}

class ChangingBluetoothState extends MyBluetoothState {
  ChangingBluetoothState ({required this.isConnecting, required this.isDiconnecting})
  : super(isConnecting: isConnecting, isDiconnecting: isDiconnecting, data: 'No Conectado');

  final bool isConnecting;
  final bool isDiconnecting;
}

class BluetoothInitial extends MyBluetoothState {
  BluetoothInitial() : super(data: 'No Conectado', isConnecting: false, isDiconnecting: false);
}

class DisconnectedBluetooth extends MyBluetoothState {
  DisconnectedBluetooth() : super(isConnecting: false, isDiconnecting: false, data: 'No Conectado');
}

class ConnectedBluetooth extends MyBluetoothState {
  ConnectedBluetooth({required this.data}) : super (isConnecting: false, isDiconnecting: false, data: data);

  String data;
}