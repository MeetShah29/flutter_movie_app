import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> userSetup(String email) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  String uid = auth.currentUser.uid.toString();
  return await FirebaseFirestore.instance
      .collection("Users")
      .doc(uid)
      .set({'email': email, 'uid': uid});
}

Future<void> updateWishlist(String movieName) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  String uid = auth.currentUser.uid.toString();
  return await FirebaseFirestore.instance.collection("Users").doc(uid).update({
    "movieName": FieldValue.arrayUnion([movieName])
  }).then((_) {
    print("success!");
  });
}

// Future<void> getUserData(String movieName) async {
//   FirebaseAuth auth = FirebaseAuth.instance;
//   String uid = auth.currentUser.uid.toString();
//   try {
//    await  FirebaseFirestore.instance.collection("Users").doc(uid).get();
//   } catch (e) {
//     print(e.toString());
//     return null;
//   }
// }
