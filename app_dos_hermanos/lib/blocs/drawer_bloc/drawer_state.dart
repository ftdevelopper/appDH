part of 'drawer_bloc.dart';

@immutable
abstract class DrawerState {

  final LocalDataBase? localDataBase;
  DrawerState({this.localDataBase});
}

class DrawerInitial extends DrawerState {
  DrawerInitial({required this.localDataBase}) : super(localDataBase: localDataBase);

  final LocalDataBase localDataBase;
}

class LoadingDrawer extends DrawerState{
  LoadingDrawer({required this.localDataBase});

  final LocalDataBase localDataBase;
}

class DrawerLoaded extends DrawerState{
  DrawerLoaded({required this.localDataBase});

  final LocalDataBase localDataBase;
}

class LoadingLocations extends DrawerState{}

class LoadingRices extends DrawerState{}

class LoadingDrivers extends DrawerState{}

class LoadedLocations extends DrawerState{
  LoadedLocations({required this.localDataBase});

  final LocalDataBase localDataBase;
}

class LoadedRices extends DrawerState {
  LoadedRices({required this.localDataBase});

  final LocalDataBase localDataBase;
}

class LoadedDrivers extends DrawerState{
  
}