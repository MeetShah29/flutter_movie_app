import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class UserRepository {
  final FirebaseAuth _firebaseAuth;

  UserRepository({FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Future<void> signInWithCredentials(String email,String password){
    return _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signUp(String email,String password) async{
    return await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut() async{
    return Future.wait([_firebaseAuth.signOut()]);
  }

  Future<bool>isSignedIn()async{
    final currentUser=  _firebaseAuth.currentUser;  //Modifications are made
    return currentUser!=null;

  }

  Future<auth.User> getUser() async{
      return _firebaseAuth.currentUser;
  }


}
