import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:app_dos_hermanos/classes/locations.dart';
import 'package:app_dos_hermanos/features/login_feature/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class UserRepository {

  final CollectionReference usersReference = FirebaseFirestore.instance.collection('users');

  Future<void> updateUserData(User user) async {
    await usersReference.doc(user.id).set(
      _mapUser(user)
    );
  }

  Future<User> getUserData(String uid) async {
    DocumentSnapshot snapshot = await usersReference.doc(uid).get();
    if (snapshot.exists){
      return fromSnapshot(snapshot);
    } else {
      return User(
        email: '',
        id: '',
        location: Location (name: "SELECCIONAR"),
        name: '',
        photoURL: 'https://firebasestorage.googleapis.com/v0/b/dos-hermanos.appspot.com/o/Profile%20Images%2Fdefault_profile_pic.jpg?alt=media&token=33961555-a0d8-48aa-9a48-124c1e397aeb',
        profilePhoto: Image.asset('assets/default_profile_pic.jpg'),
      );
    }
    
  }

  Future<String> putProfileImage({required File image, required String name}) async {
    final firebase_storage.Reference profileImage = firebase_storage.FirebaseStorage.instance.ref()
    .child('Profile Images');

    final firebase_storage.UploadTask uploadTask = profileImage.child(name + ".jpg").putFile(image);
    firebase_storage.TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
    String imageURL = await snapshot.ref.getDownloadURL();
    print('Image Uploaded, download URL: $imageURL');
    return imageURL;
  }

  Future<Image> getProfileImage(String photoURL) async {

    Image image;
    photoURL == ''
    ? image = Image.asset('assets/default_profile_pic.jpg')
    : image = Image.network(photoURL);

    return image;
  }

  Map<String, String> _mapUser(User user){
    Map<String, String> _map = {
      'email':user.email,
      'uid':user.id,
      'name':user.name,
      'photoURL':user.photoURL,
      'location':user.location.name
    };
    return _map;
  }

  Future<User> fromSnapshot(DocumentSnapshot snapshot) async {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return User(
      id: data['uid'] ?? '', 
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      photoURL: data['photoURL'] ?? 'https://firebasestorage.googleapis.com/v0/b/dos-hermanos.appspot.com/o/Profile%20Images%2Fdefault_profile_pic.jpg?alt=media&token=33961555-a0d8-48aa-9a48-124c1e397aeb',
      location: Location.fromName(data['location'] ?? 'SELECCIONAR'),
      profilePhoto: await getProfileImage(data['photoURL'] ?? Image.asset('assets/default_profile_pic.jpg'))
    );
  }
}