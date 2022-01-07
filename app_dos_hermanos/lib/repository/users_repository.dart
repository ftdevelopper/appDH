import 'package:app_dos_hermanos/classes/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepository {
  final String uid;

  UserRepository({required this.uid});

  final CollectionReference userReference = FirebaseFirestore.instance.collection('users');

  Future updateUserData(User user) async {
    return await userReference.doc(user.id).set(
      _mapUser(user)
    );
  }

  Map<String, String> _mapUser(User user){
    Map<String, String> _map ={
      'hol':user.id
    };
    return _map;
  }
}