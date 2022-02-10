import 'dart:async';
import 'package:app_dos_hermanos/classes/user.dart';
import 'package:app_dos_hermanos/repository/users_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';

//Cuando ocurre error al registrarse
class SignUpFailure implements Exception {}

//Cuando ocurre error en el login
class LogInWithEmailAndPasswordFailure implements Exception {}

//Cuando ocurre error en el login de google
class LogInWithGoogleFailure implements Exception {}

//Cuando ocurre error al cerrar sesion
class LogOutFailure implements Exception {}

class AuthenticationRepository {
  
  User user;
  UserRepository userRepository = UserRepository();

  final firebase_auth.FirebaseAuth _firebaseAuth;
  //final GoogleSignIn _googleSignIn;

  AuthenticationRepository({
    required this.user,
    firebase_auth.FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn
  }) : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance;
      //_googleSignIn = googleSignIn ?? GoogleSignIn.standard();

  bool isLoggedIn(){
    if(_firebaseAuth.currentUser == null){
      return false;
    }
    return true;
  }

  Future<String> get getUserID async{
    if (isLoggedIn()){
      return _firebaseAuth.currentUser!.uid;
    }
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      return firebaseUser == null ? '' : firebaseUser.uid;
    }).first;
  }

  Future<User> get getUser async {
    String _id = await getUserID;
    user = await userRepository.getUserData(_id);
    if (user.id == ''){
      user.id = _firebaseAuth.currentUser!.uid;
      user.email = _firebaseAuth.currentUser!.email!;
      user.name = _firebaseAuth.currentUser!.uid;
    }
    return user;
  }

  /*Future<User> signUp({
    required String password,
    required File? photoFile
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: user.email, password: password).then((value) => user.id = value.user!.uid);
      print('User Registered with the following ID: ${user.id}');

      if(photoFile != null){
        user.photoURL = await userRepository.putProfileImage(image: photoFile, name: user.name);
        print('User Photo updated with the following URL: ${user.photoURL}');
      } else {
        user.photoURL = 'https://firebasestorage.googleapis.com/v0/b/dos-hermanos.appspot.com/o/Profile%20Images%2Fdefault_profile_pic.jpg?alt=media&token=33961555-a0d8-48aa-9a48-124c1e397aeb';
      }
      
      await userRepository.updateUserData(user);
      print('''User Data Updated: User{
        id: ${user.id},
        name: ${user.name},
        email: ${user.email}
        location: ${user.location},
        photoURL: ${user.photoURL},
      }''');
      return user;
    } on Exception {
      throw SignUpFailure();
    }
  }

  Future<void> logInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser!.authentication;
      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken
      );
      await _firebaseAuth.signInWithCredential(credential);
    } on Exception {
      throw LogInWithGoogleFailure();
    }
  }*/

  // Login con email y password
  Future<void> logInWithEmailAndPassword({
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: user.email, password: password);
      user = await this.getUser;
    } on Exception {
      throw LogInWithEmailAndPasswordFailure();
    }
  }

  // Cerrar sesion
  Future<void> logOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        //_googleSignIn.signOut()
      ]);
      user = User.empty();
    } on Exception {
    }
  }

}