import 'package:firebase_auth/firebase_auth.dart';

class FireBase {
  static FirebaseAuth _auth = FirebaseAuth.instance;
  static FirebaseUser currentUser;

  static Future<bool> initialize() async {
    currentUser = await _auth.currentUser();
    if (currentUser == null) {
      return false;
    } else {
      return true;
    }
  }
}
