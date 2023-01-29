import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:io' as store;

class DatabaseService {
  //This is a variable to use in the function updateUserData();
  final String uid;
  DatabaseService({this.uid});

  //We are creating a function that will be used during registration and later in settings
  Future updateUserData(String firstName, String lastName, String email,
      String phoneNumber) async {
    CollectionReference userCollection =
        FirebaseFirestore.instance.collection('Users');
    FirebaseAuth auth = FirebaseAuth.instance;

    return await userCollection.doc(uid).set({
      'First Name': firstName,
      'Last Name': lastName,
      "Email": email,
      'Phone Number': phoneNumber
    });

//    users.add({
//      'displayName': concatNames(),
//      'uid': uid,
//      'phoneNumber': _phoneNumber,
//    });
  }
}
