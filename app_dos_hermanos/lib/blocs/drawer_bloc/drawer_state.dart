part of 'drawer_bloc.dart';

@immutable
abstract class DrawerState {

  final List<Location>? locations;
  DrawerState({this.locations});
}

class DrawerInitial extends DrawerState {}

class LoadingDrawer extends DrawerState{}

class LoadedDrawer extends DrawerState{}

class LoadingLocations extends DrawerState{}

class LoadedLocations extends DrawerState{
  final List<Location> locations;

  LoadedLocations({required this.locations});
}