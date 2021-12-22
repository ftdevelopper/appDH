import 'dart:async';
import 'package:app_dos_hermanos/blocs/authBloc/authbloc_bloc.dart';
import 'package:app_dos_hermanos/classes/user.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';

//Cuando ocurre error al registrarse
class SignUpFailure implements Exception {}

//Cuando ocurre error en el login
class LogInWithEmailAndPasswordFailure implements Exception {}

//Cuando ocurre error en el login de google
class LogInWithGoogleFailure implements Exception {}

//Cuando ocurre error al cerrar sesion
class LogOutFailure implements Exception {}

class AuthenticationRepository {
  
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthenticationRepository({
    firebase_auth.FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn
  }) : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
      _googleSignIn = googleSignIn ?? GoogleSignIn.standard();

  // Stream User -> actual usuario cuando el estado de autanticacion cambia

  Stream<User> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      return firebaseUser == null ? User.empty : firebaseUser.toUser;
    });
  }

  Future<void> signUp({
    required String email,
    required String password
  }) async {
    assert(email !=null && password != null);
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
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
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
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
    } on Exception {
    }
  }

}

extension on firebase_auth.User {
  User get toUser {
    return User(id: uid, email: email ?? '', name: displayName ?? '', photo: photoURL ?? '');
  }
}