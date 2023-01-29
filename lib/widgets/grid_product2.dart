import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/screens/detailsTutor.dart';
import 'package:flutter/rendering.dart';

class GridProduct2 extends StatelessWidget {
  final String name;
  final String title;
  final String img;
  final String price;
  final String description;
  final String phoneNo;

  GridProduct2({
    Key key,
    @required this.name,
    @required this.title,
    @required this.img,
    @required this.price,
    @required this.description,
    @required this.phoneNo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: ListView(
        shrinkWrap: true,
        primary: false,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(0, 2, 3.0, 8),
            child: Text(
              "$title",
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w900,
              ),
              maxLines: 1,
            ),
          ),
          Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height / 3.6,
                width: MediaQuery.of(context).size.width / 2.2,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    "$img",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0.0, 0, 10.0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "$name",
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w900,
                  ),
                  maxLines: 1,
                ),
                Text(
                  "$price SR",
                  style: TextStyle(
                    fontSize: 11.0,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),

        ],
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return DetailsTutor(
                name: name,
                img: img,
                title: title,
                price: price,
                description: description,
                phoneNo: phoneNo,);
            },
          ),
        );
      },
    );
  }
}
