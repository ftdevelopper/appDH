part of 'bluetooth_cubit.dart';

@immutable
abstract class MyBluetoothState {

  MyBluetoothState();

}

class BluetoothInitial extends MyBluetoothState {}

class DisconnectedBluetooth extends MyBluetoothState {}

class ConectingBluetooth extends MyBluetoothState {}

class ConnectedBluetooth extends MyBluetoothState {}