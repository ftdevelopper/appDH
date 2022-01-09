import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:app_dos_hermanos/classes/locations.dart';
import 'package:app_dos_hermanos/classes/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepository {

  final CollectionReference userReference = FirebaseFirestore.instance.collection('users');

  Future updateUserData(User user) async {
    return await userReference.doc(user.id).set(
      _mapUser(user)
    );
  }

  Future<User> getUserData(String uid) async {
    return await userReference.doc(uid).get().then((DocumentSnapshot value) {
      return fromSnapshot(value);
    });
  }

  Future<String> putProfileImage({required File image, required String name}) async {
    final firebase_storage.Reference profileImage = firebase_storage.FirebaseStorage.instance.ref()
    .child('Profile Images');

    final firebase_storage.UploadTask uploadTask = profileImage.child(name + ".jpg").putFile(image);
    firebase_storage.TaskSnapshot snapshot = await uploadTask.snapshot;
    String imageURL = await snapshot.ref.getDownloadURL();
    return imageURL;
  }

  Map<String, String> _mapUser(User user){
    Map<String, String> _map = {
      'email':user.email,
      'uid':user.id,
      'name':user.name,
      'photo':user.photo,
      'location':user.location.name
    };
    return _map;
  }

  static User fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return User(
      id: data['uid'],
      name: data['name'],
      email: data['email'],
      photo: data['photo'],
      location: Location.fromName(data['location'])
    );
  }
}