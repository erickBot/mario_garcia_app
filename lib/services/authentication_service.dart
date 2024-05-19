import 'package:firebase_auth/firebase_auth.dart';

class AuthFirebaseService {
  late FirebaseAuth _firebaseAuth;

  AuthFirebaseService() {
    _firebaseAuth = FirebaseAuth.instance;
  }

  User? getUser() {
    //obtiene los datos del usuario que inicio sesion
    return _firebaseAuth.currentUser;
  }

  bool isSignedIn() {
    final currentUser = _firebaseAuth.currentUser;

    if (currentUser == null) {
      return false;
    }

    return true;
  }

  Future<bool> login(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
    return true;
  }

  Future<bool> register(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }

    return true;
  }

  //cerrar sesion
  Future<void> signOut() async {
    return await FirebaseAuth.instance.signOut();
  }
}
