import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'locations.dart';

// ignore: must_be_immutable
class User extends Equatable {
  String email;
  String id;
  String name;
  String photoURL;
  Location location;
  Image profilePhoto;

  User({
    required this.email,
    required this.id,
    required this.name,
    required this.photoURL,
    required this.location,
    required this.profilePhoto
  });

  factory User.empty() {
    return User(
      id: '',
      email: '',
      location: Location(name: ''),
      name: '',
      photoURL: '',
      profilePhoto: Image.asset('assets/default_profile_pic.jpg')
    );
  }

  @override
  List<Object> get props => [this.email, this.id, this.name, this.photoURL, this.location, this.profilePhoto];
} 