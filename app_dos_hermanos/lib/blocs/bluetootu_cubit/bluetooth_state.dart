part of 'bluetooth_cubit.dart';

@immutable
abstract class BluetoothState {}

class BluetoothInitial extends BluetoothState {}

class DisconnectedBluetooth extends BluetoothState {}

class ConectingBluetooth extends BluetoothState {}

class ConnectedBluetooth extends BluetoothState {}