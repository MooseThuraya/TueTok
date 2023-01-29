import 'package:flutter/material.dart';
import 'package:flash_chat/widgets/grid_product3.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'editProfile.dart';

final _firestore = FirebaseFirestore.instance;
User loggedInUser;
final FirebaseAuth authGlobal = FirebaseAuth.instance;
String _username;

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
//
//  Profile({Key key, this.firstName, this.lastName, this.phoneNumber})
//      : super(key: key);
//  final String firstName;
//  final String lastName;
//  final String phoneNumber;
}

class _ProfileState extends State<Profile> {
  final _auth = FirebaseAuth.instance;
  String _firstName = "";
  String _lastName = "";
  String _email = "";
  String _phoneNumber = "";

  bool _isLoading = true;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  List<DocumentSnapshot> posts;
  List<DocumentSnapshot> posts2;

  int _current = 0;

  @override
  void initState() {
    _fetchPosts();
    super.initState();
    getCurrentUser();
  }

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }

    return result;
  }

  _fetchPosts() async {
    User user = _auth.currentUser;
    try {
      setState(() {
        _isLoading = true;
      });
      QuerySnapshot snap = await _db
          .collection("itemPosts")
          .orderBy("date", descending: true)
          .get();
      QuerySnapshot snap2 = await _db
          .collection("tutorPosts")
          .orderBy("date", descending: true)
          .get();
      setState(() {
        posts = snap.docs;
        posts2 = snap2.docs;
        _isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  // TODO: ADD THIS TO EVERY VIEW THAT DISPLAYS UNIQUE DATA FOR THE USER
  void getCurrentUser() {
    final user = _auth.currentUser;
    if (user != null) {
      loggedInUser = user;
      print(loggedInUser.email);
    }
  }

  Future<String> getUserInfo(String userInfo) async {
    //CollectionReference users = FirebaseFirestore.instance.collection('Users');
    FirebaseAuth auth = FirebaseAuth.instance;
    print(auth.currentUser.uid + ' USERID');

    //initializing the variable for the collection
    CollectionReference userCollection =
        FirebaseFirestore.instance.collection('Users');

    print(userCollection.doc(auth.currentUser.uid).get());
    return null;
  }

  @override
  Widget build(BuildContext context) {
    User user = _auth.currentUser;
    if (_isLoading) {
      return Scaffold(
        body: Container(
          child: SpinKitDualRing(
            color: Theme.of(context).accentColor,
            size: 60.0,
          ),
        ),
      );
    } else {
      List<DocumentSnapshot> filteredPosts = posts
          .where(
              (element) => element.data()['uploadedBy'] == user.uid.toString())
          .toList();
      List<DocumentSnapshot> filteredPosts2 = posts2
          .where(
              (element) => element.data()['uploadedBy'] == user.uid.toString())
          .toList();
      return Scaffold(
        body: Padding(
          padding: EdgeInsets.fromLTRB(10.0, 20, 10.0, 35),
          child: RefreshIndicator(
            onRefresh: () {
              _fetchPosts();
              return null;
            },
            child: ListView(
              children: <Widget>[
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding:
                          EdgeInsets.only(left: 5, top: 0, right: 0, bottom: 0),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('Users')
                                    .doc(authGlobal.currentUser.uid)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Center(
                                      child: CircularProgressIndicator(
                                        backgroundColor: Colors.lightBlueAccent,
                                      ),
                                    );
                                  }
                                  var userDocument = snapshot.data;
                                  _firstName = userDocument['First Name'];
                                  _lastName = userDocument['Last Name'];
                                  _email = userDocument['Email'];
                                  _phoneNumber = userDocument['Phone Number'];

                                  return Column(
                                    children: <Widget>[
                                      Text(
                                        //can use uid???
                                        userDocument['First Name'] +
                                            " " +
                                            userDocument['Last Name'],
                                        style: TextStyle(
                                          fontSize: 25.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 5.0),
                          StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('Users')
                                .doc(authGlobal.currentUser.uid)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                  child: CircularProgressIndicator(
                                    backgroundColor: Colors.lightBlueAccent,
                                  ),
                                );
                              }
                              var userDocument = snapshot.data;
                              _firstName = userDocument['First Name'];
                              _lastName = userDocument['Last Name'];
                              _email = userDocument['Email'];
                              _phoneNumber = userDocument['Phone Number'];

                              return Column(
                                children: <Widget>[
                                  Text(
                                    //can use uid???
                                    userDocument['Email'],
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          SizedBox(height: 20.0),
                        ],
                      ),
                      flex: 3,
                    ),
                  ],
                ),
                Divider(
                  thickness: 2,
                  color: Colors.grey[999],
                ),
                Container(height: 15.0),
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    "Account Information".toUpperCase(),
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListTile(
                  title: Text(
                    "First Name",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  subtitle: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('Users')
                        .doc(authGlobal.currentUser.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.lightBlueAccent,
                          ),
                        );
                      }
                      var userDocument = snapshot.data;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            userDocument['First Name'],
                            style: TextStyle(
                              fontSize: 15.0,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                ListTile(
                  title: Text(
                    "Last Name",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  subtitle: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('Users')
                        .doc(authGlobal.currentUser.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.lightBlueAccent,
                          ),
                        );
                      }
                      var userDocument = snapshot.data;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            userDocument['Last Name'],
                            style: TextStyle(
                              fontSize: 15.0,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                ListTile(
                  title: Text(
                    "Email",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  subtitle: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('Users')
                        .doc(authGlobal.currentUser.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.lightBlueAccent,
                          ),
                        );
                      }
                      var userDocument = snapshot.data;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            userDocument['Email'],
                            style: TextStyle(
                              fontSize: 15.0,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                ListTile(
                  title: Text(
                    "Phone Number",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  subtitle: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('Users')
                        .doc(authGlobal.currentUser.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.lightBlueAccent,
                          ),
                        );
                      }
                      var userDocument = snapshot.data;
                      _firstName = userDocument['First Name'];
                      _lastName = userDocument['Last Name'];
                      _email = userDocument['Email'];
                      _phoneNumber = userDocument['Phone Number'];

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            //can use uid???
                            userDocument['Phone Number'],
                            style: TextStyle(
                              fontSize: 15.0,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Divider(
                  thickness: 2,
                  color: Colors.grey[999],
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "My Item Posts".toUpperCase(),
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5.0),
                GridView.builder(
                    shrinkWrap: true,
                    primary: false,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: MediaQuery.of(context).size.width /
                          (MediaQuery.of(context).size.height / 1.25),
                    ),
                    itemCount: filteredPosts.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GridProduct3(
                        name: filteredPosts[index].data()['name'],
                        img: filteredPosts[index].data()['photoUrl'],
                        title: filteredPosts[index].data()['title'],
                        price: filteredPosts[index].data()['Price'],
                        description: filteredPosts[index].data()['description'],
                        phoneNo: filteredPosts[index].data()['phoneNo'],
                        uid: filteredPosts[index].id,
                      );
                    }),
                Divider(
                  thickness: 2,
                  color: Colors.grey[999],
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "My Tutor Posts".toUpperCase(),
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5.0),
                GridView.builder(
                    shrinkWrap: true,
                    primary: false,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: MediaQuery.of(context).size.width /
                          (MediaQuery.of(context).size.height / 1.25),
                    ),
                    itemCount: filteredPosts2.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GridProduct3(
                        name: filteredPosts2[index].data()['name'],
                        img: filteredPosts2[index].data()['photoUrl'],
                        title: filteredPosts2[index].data()['title'],
                        price: filteredPosts2[index].data()['Price'],
                        description:
                            filteredPosts2[index].data()['description'],
                        phoneNo: filteredPosts2[index].data()['phoneNo'],
                        uid: filteredPosts2[index].id,
                      );
                    }),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: "Edit Profile",
          mini: true,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return EditProfile(
                      firstName: _firstName,
                      lastName: _lastName,
                      phoneNumber: _phoneNumber);
                },
              ),
            );
          },
          child: Icon(
            Icons.create,
          ),
          heroTag: Object(),
        ),
      );
    }
  }
}
