import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String email;
  final String id;
  final String name;
  final String photo;

  const User({
    required this.email,
    required this.id,
    required this.name,
    required this.photo
  });

  static const empty = User(email: '', id: '', name: '', photo: '');

  @override
  List<Object> get props => [email, id, name, photo];
} 