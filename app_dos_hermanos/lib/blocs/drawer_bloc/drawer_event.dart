part of 'drawer_bloc.dart';

@immutable
abstract class DrawerEvent {}

class LogoutPressed extends DrawerEvent{}

class ChangeProfilePhoto extends DrawerEvent{}

class ChangeLocation extends DrawerEvent{}