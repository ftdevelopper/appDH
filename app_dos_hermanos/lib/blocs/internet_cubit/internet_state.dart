part of 'internet_cubit.dart';

@immutable
abstract class InternetState {}

class InternetInitial extends InternetState {}


class InternetDisconnected extends InternetState {}

class InternetConnected extends InternetState{}