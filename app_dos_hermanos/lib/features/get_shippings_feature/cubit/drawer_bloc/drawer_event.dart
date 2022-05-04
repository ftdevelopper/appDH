part of 'drawer_bloc.dart';

@immutable
abstract class DrawerEvent extends Equatable{}

class LogoutPressed extends DrawerEvent{

  @override
  List<Object?> get props => [];
}

class ChangeProfilePhoto extends DrawerEvent{
  final Image newphoto;
  final File newphotoFile;

  ChangeProfilePhoto({required this.newphoto, required this.newphotoFile});

  @override
  List<Object?> get props => [this.newphoto, this.newphotoFile];
}

class ChangeLocation extends DrawerEvent{
  final String locationName;

  ChangeLocation({required this.locationName});
  @override
  List<Object?> get props => [];
}

class LoadLocations extends DrawerEvent {
  
  @override
  List<Object?> get props => [];
}

class LoadRices extends DrawerEvent {
  @override
  
  List<Object?> get props => [];
}

class ChangeName extends DrawerEvent {
  ChangeName({required this.name});

  final String name;

  @override
  List<Object?> get props => [this.name];
}

class LoadDrivers extends DrawerEvent {
  
  @override
  List<Object?> get props => [];
}
