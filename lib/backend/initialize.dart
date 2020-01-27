import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireBase {
  //  Authentication
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseUser currentUser;

  //  Cloud firestore instances
  static Firestore firestore = Firestore.instance;
  static CollectionReference peopleCollection = firestore.collection("people");
  static CollectionReference adminCollection = firestore.collection("admin");
  static CollectionReference issuesCollection = firestore.collection("issues");
  static CollectionReference localityCollection =
      firestore.collection("localities");

  static Future<Map<String, dynamic>> initialize() async {
    currentUser = await auth.currentUser();
    if (currentUser == null) {
      return {'logged_in': false};
    } else {
      /// People loggedin
      if (currentUser.email == null) return {'logged_in': true, 'user_type': 1};
      /// Admin loggedin
      return {'logged_in': true, 'user_type': 2};
    }
  }
}
