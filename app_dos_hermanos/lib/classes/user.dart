import 'package:equatable/equatable.dart';

import 'locations.dart';

// ignore: must_be_immutable
class User extends Equatable {
  String email;
  String id;
  String name;
  String photo;
  Location location;

  User({
    required this.email,
    required this.id,
    required this.name,
    required this.photo,
    required this.location
  });

  factory User.empty(){
    return User(
      id: '',
      email: '',
      location: Location(name: ''),
      name: '',
      photo: '',
    );
  }

  @override
  List<Object> get props => [email, id, name, photo, location];
} 