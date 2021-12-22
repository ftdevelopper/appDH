import 'package:firebase_auth/firebase_auth.dart';

class UserRepository{

  late FirebaseAuth firebaseAuth;

  UserRepository(){
    this.firebaseAuth = FirebaseAuth.instance;
  }

  Future<User?> createUser(String email, String password) async {
    try {
      final result = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return result.user;
    } catch(e) {
      throw Exception(e.toString());
    }
  }

  Future<User?> signInUser(String email, String password) async {
    final result = await firebaseAuth.signInWithEmailAndPassword(
      email: email, password: password
    );
    return result.user;
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  Future<bool> isSignedIn() async {
    bool isSigned = false;

    firebaseAuth.authStateChanges()
    .listen((User? user){
      if (user == null){
        isSigned = false;
      } else {
        isSigned = true;
      }
    });

    return isSigned;
  }

  Future<User?> getCurrentUser() async {
    return firebaseAuth.currentUser;
  }

}