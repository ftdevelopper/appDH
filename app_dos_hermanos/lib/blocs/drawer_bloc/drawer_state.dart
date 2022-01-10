part of 'drawer_bloc.dart';

@immutable
abstract class DrawerState {}

class DrawerInitial extends DrawerState {}

class LoadingDrawer extends DrawerState{}

class LoadedDrawer extends DrawerState{}
