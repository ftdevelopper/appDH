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