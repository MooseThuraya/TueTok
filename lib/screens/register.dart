import 'package:flash_chat/screens/database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flash_chat/screens/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'database.dart';
import 'package:string_validator/string_validator.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _firstNameController =
      new TextEditingController();
  final TextEditingController _lastNameController = new TextEditingController();
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _phoneNumberController =
      new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  final TextEditingController _passwordConfirmationController =
      new TextEditingController();

  final _auth = FirebaseAuth.instance;
  bool showSpinner = false; //so it doesn't spin right off the bat;
  String _firstName;
  String _lastName;
  String _email;
  String _password;
  String _confirmPassword;
  String _phoneNumber;

  String concatNames() {
    String _displayName = _firstName + " " + _lastName;
    return _displayName;
  }

  Future<void> userSetup(String displayName) async {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    FirebaseAuth auth = FirebaseAuth.instance;

    //String currentuser = FirebaseAuth.instance.currentUser.uid; just in case i wanna get back to it, moose
    String uid = auth.currentUser.uid.toString();
    users.add({
      'displayName': concatNames(),
      'uid': uid,
      'phoneNumber': _phoneNumber,
    });
    return;
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

  bool passwordConfirmation() {
    if (_password == _confirmPassword) {
      return true;
    } else {
      print("Password not the same, reconfirm");
      return false;
    }
  }

  bool emailVerification() {
    if (_email.length == 20 && _email.substring(9, 20) == "@psu.edu.sa") {
      return true;
    } else {
      alert("Email");
      print("incorrect email");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.0, 0, 20, 0),
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          SizedBox(height: 10.0),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(
              top: 15.0,
            ),
            child: Text(
              "Create an account",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).accentColor,
              ),
            ),
          ),

          SizedBox(height: 15.0),

          Card(
            elevation: 3.0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
              ),
              child: TextField(
                onChanged: (value) {
                  //Do something with the user input.
                  _firstName = value;
                },
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  hintText: "First Name",
                  prefixIcon: Icon(
                    Icons.perm_identity,
                    color: Colors.black,
                  ),
                  hintStyle: TextStyle(
                    fontSize: 15.0,
                    color: Colors.grey,
                  ),
                ),
                maxLines: 1,
                controller: _firstNameController,
              ),
            ),
          ),

          SizedBox(height: 10.0),
          Card(
            elevation: 3.0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
              ),
              child: TextField(
                onChanged: (value) {
                  //Do something with the user input.
                  _lastName = value;
                },
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  hintText: "Last Name",
                  prefixIcon: Icon(
                    Icons.perm_identity,
                    color: Colors.black,
                  ),
                  hintStyle: TextStyle(
                    fontSize: 15.0,
                    color: Colors.grey,
                  ),
                ),
                maxLines: 1,
                controller: _lastNameController,
              ),
            ),
          ),

          SizedBox(height: 10.0),
          Card(
            elevation: 3.0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
              ),
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  //Do something with the user input.
                  _email = value;
                },
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  hintText: "Email",
                  prefixIcon: Icon(
                    Icons.mail_outline,
                    color: Colors.black,
                  ),
                  hintStyle: TextStyle(
                    fontSize: 15.0,
                    color: Colors.grey,
                  ),
                ),
                maxLines: 1,
                controller: _emailController,
              ),
            ),
          ),
          SizedBox(height: 10.0),
          Card(
            elevation: 3.0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
              ),
              child: TextField(
                onChanged: (value) {
                  //Do something with the user input.
                  _phoneNumber = value;
                },
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  hintText: "05x-xxx-xxxx",
                  prefixIcon: Icon(
                    Icons.call,
                    color: Colors.black,
                  ),
                  hintStyle: TextStyle(
                    fontSize: 15.0,
                    color: Colors.grey,
                  ),
                ),
                maxLines: 1,
                controller: _phoneNumberController,
              ),
            ),
          ),
          SizedBox(height: 10.0),

          Card(
            elevation: 3.0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
              ),
              child: TextField(
                onChanged: (value) {
                  //Do something with the user input.
                  _password = value;
                },
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  hintText: "Password",
                  prefixIcon: Icon(
                    Icons.lock_outline,
                    color: Colors.black,
                  ),
                  hintStyle: TextStyle(
                    fontSize: 15.0,
                    color: Colors.grey,
                  ),
                ),
                obscureText: true,
                maxLines: 1,
                controller: _passwordController,
              ),
            ),
          ),

          SizedBox(height: 10.0),
          Card(
            elevation: 3.0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
              ),
              child: TextField(
                onChanged: (value) {
                  //Do something with the user input.
                  _confirmPassword = value;
                },
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  hintText: "Confirm Password",
                  prefixIcon: Icon(
                    Icons.lock_outline,
                    color: Colors.black,
                  ),
                  hintStyle: TextStyle(
                    fontSize: 15.0,
                    color: Colors.grey,
                  ),
                ),
                obscureText: true,
                maxLines: 1,
                controller: _passwordConfirmationController,
              ),
            ),
          ),

          SizedBox(height: 30.0),

          Container(
            height: 50.0,
            child: RaisedButton(
              child: Text(
                "Register".toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () async {
                if (passwordConfirmation() && emailVerification()) {
                  if (checkForFirstNameValidity(_firstName.trim()) &&
                      checkForLastNameValidity(_lastName.trim()) &&
                      checkForPhoneNumberValidity(_phoneNumber.trim())) {
                    setState(() {
                      showSpinner = true;
                    });
                    //MOOSE AUTH
                    try {
                      final newUser =
                          await _auth.createUserWithEmailAndPassword(
                              email: _email, password: _password);
                      FirebaseAuth auth = FirebaseAuth.instance;
                      String uid = auth.currentUser.uid.toString();
                      // Here we make a userCollection (record) in firebase firestore to later fetch from
                      await DatabaseService(uid: uid).updateUserData(
                          _firstName, _lastName, _email, _phoneNumber);
                      //await userSetup(concatNames());

//                  if (newUser != null) {
//                    Navigator.pushNamed(context, ChatScreen.id);
//                  }
                    } catch (e) {
                      print(e);
                    }
                    try {
                      final signedUser = await _auth.signInWithEmailAndPassword(
                          email: _email, password: _password);
                      if (signedUser != null) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return MainScreen();
                            },
                          ),
                        );
                      }
                    } catch (e) {
                      print(e);
                    }
                    setState(() {
                      showSpinner = false;
                    });

//                try {
//                  FirebaseUser user =
//                      (await FirebaseAuth.instance.signInWithEmailAndPassword(
//                    email: _emailController.text,
//                    password: _passwordController.text,
//                  ))
//                          .user;
//                } catch (e) {
//                  print(e);
//                  _emailController.text = "";
//                  _passwordController.text = "";
//                  // TODO: AlertDialog with error
//                }
                  } else {
                    print("Re-enter required fields");
                  }
                }
              },
              color: Theme.of(context).accentColor,
            ),
          ),
//
//          SizedBox(height: 10.0),
//          Divider(
//            color: Theme.of(context).accentColor,
//          ),
//          SizedBox(height: 10.0),

//          Center(
//            child: Container(
//              width: MediaQuery.of(context).size.width/2,
//              child: Row(
//                children: <Widget>[
//                  RawMaterialButton(
//                    onPressed: (){},
//                    fillColor: Colors.blue[800],
//                    shape: CircleBorder(),
//                    elevation: 4.0,
//                    child: Padding(
//                      padding: EdgeInsets.all(15),
//                      child: Icon(
//                        FontAwesomeIcons.facebookF,
//                        color: Colors.white,
////              size: 24.0,
//                      ),
//                    ),
//                  ),
//
//                  RawMaterialButton(
//                    onPressed: (){},
//                    fillColor: Colors.white,
//                    shape: CircleBorder(),
//                    elevation: 4.0,
//                    child: Padding(
//                      padding: EdgeInsets.all(15),
//                      child: Icon(
//                        FontAwesomeIcons.google,
//                        color: Colors.blue[800],
////              size: 24.0,
//                      ),
//                    ),
//                  ),
//                ],
//              ),
//            ),
//          ),

          SizedBox(height: 20.0),
        ],
      ),
    );
  }
}
