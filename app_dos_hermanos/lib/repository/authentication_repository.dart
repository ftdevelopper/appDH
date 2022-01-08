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
  final GoogleSignIn _googleSignIn;

  AuthenticationRepository({
    required this.user,
    firebase_auth.FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn
  }) : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
      _googleSignIn = googleSignIn ?? GoogleSignIn.standard();

  // Stream User -> actual usuario cuando el estado de autanticacion cambia

  Stream<String> get getUserID {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      return firebaseUser == null ? '' : firebaseUser.uid;
    });
  }

  Future<User> get getUser async {
    String _id;
    _id = await getUserID.first;
    if (_id != ''){
      user = await userRepository.getUserData(_id);
    }
    return user;
  }

  Future<void> signUp({
    required String password
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: user.email, password: password).then((value) => user.id = value.user!.uid);
      user = await UserRepository().updateUserData(user);
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
  }

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
        _googleSignIn.signOut()
      ]);
      user = User.empty();
    } on Exception {
    }
  }

}