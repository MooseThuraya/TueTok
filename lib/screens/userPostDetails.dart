import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/screens/cart.dart';
import 'main_screen.dart';

class UserPostDetails extends StatefulWidget {
  final String name;
  final String title;
  final String img;
  final String price;
  final String description;
  final String phoneNo;
  final String uid;

  UserPostDetails({
    Key key,
    @required this.name,
    @required this.title,
    @required this.img,
    @required this.price,
    @required this.description,
    @required this.phoneNo,
    @required this.uid,
  }) : super(key: key);

  @override
  _UserPostDetailsState createState() => _UserPostDetailsState();
}

class _UserPostDetailsState extends State<UserPostDetails> {
  final _db = FirebaseFirestore.instance.collection('itemPosts');
  final _db2 = FirebaseFirestore.instance.collection('tutorPosts');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_backspace,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          "Item Details",
        ),
        elevation: 0.0,
        actions: <Widget>[
          // IconButton(
          //   icon: IconBadge(
          //     icon: Icons.notifications,
          //     size: 22.0,
          //   ),
          //   onPressed: () {
          //     Navigator.of(context).push(
          //       MaterialPageRoute(
          //         builder: (BuildContext context) {
          //           return Notifications();
          //         },
          //       ),
          //     );
          //   },
          // ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 10.0),
            Stack(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height / 3.2,
                  width: MediaQuery.of(context).size.width,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      widget.img,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Padding(
              padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Icon(
                  Icons.title,
                  color: Theme.of(context).accentColor,
                  size: 22,
                ),
                SizedBox(width: 10.0),
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 2,
                  textAlign: TextAlign.left,
                ),
              ]),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(36, 0, 36, 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.name,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w900,
                    ),
                    maxLines: 1,
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    widget.price + " SR",
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).accentColor,
                    ),
                    maxLines: 1,
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            Divider(
              thickness: 2,
              color: Colors.grey[999],
            ),
            SizedBox(height: 20.0),
            Padding(
              padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.description,
                    color: Theme.of(context).accentColor,
                    size: 22,
                  ),
                  SizedBox(width: 10.0),
                  Text(
                    "Item Description",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.0),
            Padding(
              padding: EdgeInsets.fromLTRB(36, 0, 36, 2),
              child: Text(
                widget.description,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Divider(
              thickness: 2,
              color: Colors.grey[999],
            ),
            SizedBox(height: 20.0),
            Padding(
              padding: EdgeInsets.fromLTRB(4, 0, 4, 2),
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Icon(
                  Icons.phone,
                  color: Theme.of(context).accentColor,
                  size: 22,
                ),
                SizedBox(width: 10.0),
                Text(
                  widget.phoneNo,
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 2,
                  textAlign: TextAlign.left,
                ),
              ]),
            ),
            SizedBox(height: 20.0),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 50.0,
        child: RaisedButton(
          child: Text(
            "Delete Post",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          color: Colors.red,
          onPressed: () {
            _db.doc(widget.uid).delete();
            _db2.doc(widget.uid).delete();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return MainScreen();
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
