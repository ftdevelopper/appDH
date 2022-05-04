import 'package:cloud_firestore/cloud_firestore.dart';

class Location {
  final String name;

  Location ({required this.name});

  static Location fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Location(
      name: data['name']
    );
  }

  factory Location.fromName(String newname){
    return Location(name: newname);
  }

  factory Location.fromJson(Map<String, dynamic> json){
    return Location(
      name: json["name"]
    );
  }

  Map<String, String> toJson(){
    return {
      "name":name,
    };
  }
}