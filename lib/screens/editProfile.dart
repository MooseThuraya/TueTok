import 'dart:io' as store;
import 'package:flash_chat/screens/profile.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:string_validator/string_validator.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();

  final String firstName;
  final String lastName;
  final String phoneNumber;

  EditProfile({Key key, this.firstName, this.lastName, this.phoneNumber})
      : super(key: key);
}

class _EditProfileState extends State<EditProfile> {
  store.File _image;
  TextEditingController _captionInputController = TextEditingController();
  TextEditingController _descriptionInputController = TextEditingController();
  String _priceInput;
  double _lowerValue;
  double _upperValue;
  String name;

  bool _isUploading = false;
  bool _isUploadCompleted = false;
  double _uploadProgress = 0;
  RangeValues values = RangeValues(1, 100);
  RangeLabels labels = RangeLabels('1', '100');

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth authGlobal = FirebaseAuth.instance;

  String firstName;
  String lastName;
  String phoneNumber;
  String incorrectInput;

  editUserData(String firstName, String lastName, String phoneNumber) async {
//    if (firstName == "" || lastName == "" || phoneNumber == "") {
//      //showOkAlertDialog(context: this.context, )
//      print('YOU HAVE AN EMPTY FIELD!');
//    } else {
//
//    }
    CollectionReference userCollection =
        FirebaseFirestore.instance.collection('Users');

    await userCollection.doc(_auth.currentUser.uid).update({
      'First Name': firstName,
      'Last Name': lastName,
      'Phone Number': phoneNumber
    });
  }

  alert(String error) {
    showDialog(
        context: this.context,
        builder: (ctx) {
          return AlertDialog(
            content: Text(
              "Please enter a valid: " +
                  error +
                  ".\n\nCheck for correctness of all fields.",
              style: TextStyle(
                color: Colors.red,
              ),
            ),
            title: Text(
              "Alert",
              style: TextStyle(fontSize: 25),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Text("OK"),
              ),
            ],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          );
        });
  }

  bool checkForFirstNameValidity(String firstName) {
    print(firstName + " I am in checkForFirstNameValidity()");
    if (firstName.length <= 15 && isAlpha(firstName)) {
      return true;
    } else {
      alert("First Name");
      print("Re-enter a correct First Name!");
      return false;
    }
  }

  bool checkForLastNameValidity(String lastName) {
    print(lastName + " I am in checkForLastNameValidity()");
    if (lastName.length <= 15 && isAlpha(lastName)) {
      return true;
    } else {
      alert("Last Name");
      print("Re-enter a correct Last Name!");
      return false;
    }
  }

  bool checkForPhoneNumberValidity(String phoneNumber) {
    print(phoneNumber + " I am in checkForPhoneNumberValidity()");
    if (phoneNumber.length == 10) {
      try {
        print(int.parse(phoneNumber));
      } catch (e) {
        print(e);

        alert("Phone Number");
        print("Re-enter a correct Phone Number!");
        return false;
      }
      if (phoneNumber.substring(0, 2) == "05") {
        return true;
      }
    }
    alert("Phone Number");
    print("Re-enter a correct Phone Number!");
    return false;
  }

  void checkForNull() {
    if (firstName == null || firstName == "") {
      firstName = widget.firstName;
    }
    if (lastName == null || lastName == "") {
      lastName = widget.lastName;
    }
    if (phoneNumber == null || phoneNumber == "") {
      phoneNumber = widget.phoneNumber;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
        actions: <Widget>[
//          Text(
//            "Edit Photo",
//            style: TextStyle(
//              fontSize: 14.0,
//              //fontWeight: FontWeight.bold,
//              height: 3,
//            ),
//          ),
//          IconButton(
//            tooltip: "Select Image",
//            icon: Icon(Icons.add_photo_alternate),
//            color: Theme.of(context).accentColor,
//            onPressed: () {
//              //pickFromPhone();
//            },
//          ),
        ],
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 15,
              ),
              ListTile(
                title: Text(
                  "First Name:",
                  style: TextStyle(
//                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(left: 10, top: 0, bottom: 0, right: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white54,
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                  ),
                  child: TextField(
                    onChanged: (value) {
                      firstName = value;
                    },
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                          left: 10, top: 0, bottom: 0, right: 10),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey[200],
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      hintText: widget.firstName,
                      hintStyle: TextStyle(
                        fontSize: 15.0,
                        color: Colors.grey,
                      ),
                    ),
                    maxLines: 1,
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              ListTile(
                title: Text(
                  "Last Name:",
                  style: TextStyle(
//                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(left: 10, top: 0, bottom: 0, right: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white54,
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                  ),
                  child: TextField(
                    onChanged: (value) {
                      lastName = value;
                    },
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10.0),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey[200],
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      hintText: widget.lastName,
                      hintStyle: TextStyle(
                        fontSize: 15.0,
                        color: Colors.grey,
                      ),
                    ),
                    maxLines: 1,
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              ListTile(
                title: Text(
                  "Phone Number:",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(left: 10, top: 0, bottom: 0, right: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white54,
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                  ),
                  child: TextField(
                    onChanged: (value) {
                      phoneNumber = value;
                    },
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10.0),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey[200],
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      hintText: widget.phoneNumber,
                      hintStyle: TextStyle(
                        fontSize: 15.0,
                        color: Colors.grey,
                      ),
                    ),
                    maxLines: 1,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 50,
                width: 200,
                child: RaisedButton(
                  child: Text(
                    "EDIT".toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () async {
                    //check for null, if there is null, set default values
                    checkForNull();
                    if (checkForFirstNameValidity(firstName.trim()) &&
                        checkForLastNameValidity(lastName.trim()) &&
                        checkForPhoneNumberValidity(phoneNumber.trim())) {
                      //if valid input, proceed
                      editUserData(firstName.trim(), lastName.trim(),
                          phoneNumber.trim());
                      Navigator.pop(context);
                    } else {
                      print("Re-enter correct info");
                    }
                  },
                  color: Theme.of(context).accentColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
