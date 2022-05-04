part of 'drawer_bloc.dart';

@immutable
abstract class DrawerState {

  final LocalDataBase localDataBase;
  DrawerState({required this.localDataBase});
}

class DrawerInitial extends DrawerState {
  DrawerInitial({required this.localDataBase}) : super(localDataBase: localDataBase);

  final LocalDataBase localDataBase;
}

class LoadingDrawer extends DrawerState{
  LoadingDrawer({required this.localDataBase}) : super(localDataBase: localDataBase);

  final LocalDataBase localDataBase;
}

class DrawerLoaded extends DrawerState{
  DrawerLoaded({required this.localDataBase}) : super(localDataBase: localDataBase);

  final LocalDataBase localDataBase;
}

class LoadingLocations extends DrawerState{
  LoadingLocations({required this.localDataBase}) : super(localDataBase: localDataBase);

  final LocalDataBase localDataBase;
}

class LoadingRices extends DrawerState{
  LoadingRices({required this.localDataBase}) : super(localDataBase: localDataBase);

  final LocalDataBase localDataBase;
}

class LoadingDrivers extends DrawerState{
  LoadingDrivers({required this.localDataBase, required this.progress}) : super(localDataBase: localDataBase);

  final LocalDataBase localDataBase;
  double progress;
}