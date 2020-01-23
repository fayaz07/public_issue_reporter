import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:random_string/random_string.dart';

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

  static FirebaseStorage storage = FirebaseStorage.instance;
  static StorageReference issuesDocuments =
      storage.ref().child("assets/issues/");

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

  static Future<String> uploadImageAndReturnURL(
      {@required File image, @required StorageReference ref}) async {
    //  Creating a random id
    var uuid = randomAlphaNumeric(5);
    StorageUploadTask uploadTask = ref.child(uuid + ".png").putFile(image);
    StorageTaskSnapshot snapshot = await uploadTask.onComplete;

    debugPrint(
        "Uploading asset ${uuid}.png, to path ${ref.toString()}: ${snapshot.bytesTransferred / snapshot.totalByteCount}");
    if (snapshot.bytesTransferred == snapshot.totalByteCount) {
      var result = await snapshot.ref.getDownloadURL();
      return result.toString();
    } else {
      return null;
    }
  }
}
