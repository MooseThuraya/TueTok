import 'dart:io' as store;
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'main_screen.dart';

class Checkout extends StatefulWidget {
  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  store.File _image;
  TextEditingController _captionInputController = TextEditingController();
  TextEditingController _descriptionInputController = TextEditingController();
  String _priceInput;
  int _lowerValue;
  int _upperValue;
  String firstName = "Default";
  String lastName = "Default";
  String fullName = "Default";
  String phoneNo = "Default";
  bool _isUploading = false;
  bool isLoaded = false;
  bool _isUploadCompleted = false;
  double _uploadProgress = 0;
  RangeValues values = RangeValues(1, 100);
  RangeLabels labels = RangeLabels('1', '100');
  List<DocumentSnapshot> posts;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  pickFromPhone() async {
    var image = await ImagePicker().getImage(source: ImageSource.gallery);
    _image = store.File(image.path);
  }

  void getProfileData() async {
    try {
      User user = _auth.currentUser;

      DocumentSnapshot doc = await _db.collection("Users").doc(user.uid).get();
      firstName = doc.data()["First Name"];
      lastName = doc.data()["Last Name"];
      fullName = firstName + " " + lastName;
      phoneNo = doc.data()["Phone Number"];
    } catch (e) {
      print(e);
    }
  }

  Future<void> userPost() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString() +
        basename(_image.path);
    User user = _auth.currentUser;

    final Reference storageReference =
        _storage.ref().child("itemPosts").child(user.uid).child(fileName);

    final UploadTask uploadTask = storageReference.putFile(_image);
    TaskSnapshot onComplete = await uploadTask.whenComplete(() => null);

    String photoUrl = await onComplete.ref.getDownloadURL();
    String uid = _auth.currentUser.uid.toString();

    _db.collection("itemPosts").add({
      "photoUrl": photoUrl,
      "name": fullName,
      "phoneNo": phoneNo,
      "title": _captionInputController.text,
      "description": _descriptionInputController.text,
      "Price": _priceInput,
      "date": DateTime.now(),
      "uploadedBy": uid
    });
  }

  alert() {
    showDialog(
        context: this.context,
        builder: (ctx) {
          return AlertDialog(
            content: Text("Please fill the required fields!"),
            title: Text("Alert"),
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

  uploadImage() async {
    try {
      if (_image != null) {
        setState(() {
          _isUploading = true;
          _uploadProgress = 0;
        });

        User user = _auth.currentUser;

        String fileName = DateTime.now().millisecondsSinceEpoch.toString() +
            basename(_image.path);

        final Reference storageReference =
            _storage.ref().child("itemPosts").child(user.uid).child(fileName);

        final UploadTask uploadTask = storageReference.putFile(_image);

        final StreamSubscription<FirebaseStorage> streamSubscription =
            // ignore: deprecated_member_use
            uploadTask.events.listen((event) {
          var totalBytes = event.snapshot.totalByteCount;
          var transferred = event.snapshot.bytesTransferred;

          double progress = ((transferred * 100) / totalBytes) / 100;
          setState(() {
            _uploadProgress = progress;
          });
        });

        // when completed
        setState(() {
          _isUploading = false;
          _isUploadCompleted = true;
        });

        streamSubscription.cancel();
        Navigator.pop(this.context);
      } else {
        showDialog(
            context: this.context,
            builder: (ctx) {
              return AlertDialog(
                content: Text("Please select image!"),
                title: Text("Alert"),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Text("OK"),
                  ),
                ],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              );
            });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    AssetImage("assets/placeholder.jpeg");
    return Scaffold(
      appBar: AppBar(
        title: Text("Product Info"),
        actions: <Widget>[
          Text(
            "Choose a photo",
            style: TextStyle(
              fontSize: 14.0,
              //fontWeight: FontWeight.bold,
              height: 3,
            ),
          ),
          IconButton(
            tooltip: "Select Image",
            icon: Icon(Icons.add_photo_alternate),
            color: Theme.of(context).accentColor,
            onPressed: () async {
              await pickFromPhone();
              await uploadImage();
            },
          ),
        ],
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _image != null
                  ? Image.file(_image)
                  : Image(
                      image: AssetImage("assets/placeholder.jpeg"),
                    ),
              _isUploading
                  ? LinearProgressIndicator(
                      value: _uploadProgress,
                      backgroundColor: Theme.of(context).accentColor,
                    )
                  : Container(),
              SizedBox(
                height: 20,
              ),

              ListTile(
                visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                title: Text(
                  "Post title:",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white54,
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                  ),
                  child: TextField(
                    controller: _captionInputController,
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).accentColor,
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey[200],
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      hintText: "Title of your post",
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

              ListTile(
                visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                title: Text(
                  "Post description:",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white54,
                    borderRadius: BorderRadius.all(
                      Radius.circular(15.0),
                    ),
                  ),
                  child: TextField(
                    controller: _descriptionInputController,
                    keyboardType: TextInputType.multiline,
                    maxLines: 15,
                    maxLength: 500,
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.black,
                    ),
                    //
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(20.0),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).accentColor,
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey[200],
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      hintText: "Enter your description",
                      hintStyle: TextStyle(
                        fontSize: 15.0,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ListTile(
                visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                title: Text(
                  "Price range:",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // SizedBox(height: 10.0),,
              RangeSlider(
                inactiveColor: Colors.grey,
                min: 1,
                max: 1000,
                values: values,
                divisions: 50,
                labels: labels,
                onChanged: (value) {
                  print('START: ${value.start}, END: ${value.end}');
                  setState(() {
                    values = value;
                    labels = RangeLabels(
                        '${value.start.toInt()..toString()}\ SR',
                        '${value.end.toInt().toString()}\ SR');
                    _lowerValue = value.start.toInt();
                    _upperValue = value.end.toInt();
                    _priceInput = "" +
                        _lowerValue.toString() +
                        " - " +
                        _upperValue.toString();
                  });
                },
              ),
              Container(
                height: 50.0,
                width: 200.0,
                child: RaisedButton(
                  child: Text(
                    "POST".toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () async {
                    if (_priceInput != null &&
                        _captionInputController.text != "" &&
                        _descriptionInputController.text != "") {
                      await uploadImage();
                      await userPost();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return MainScreen();
                          },
                        ),
                      );
                    } else {
                      alert();
                    }
                  },
                  color: Theme.of(context).accentColor,
                ),
              ),
              SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getProfileData();
  }
}
