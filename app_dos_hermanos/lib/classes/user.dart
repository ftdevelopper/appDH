import 'package:equatable/equatable.dart';

import 'locations.dart';

class User extends Equatable {
  final String email;
  final String id;
  final String name;
  final String photo;
  final Location location;

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
  List<Object> get props => [email, id, name, photo];
} 