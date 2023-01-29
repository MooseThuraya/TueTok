import 'package:flutter/material.dart';
import 'package:flash_chat/screens/detailsItem.dart';

class SliderItem extends StatelessWidget {
  final String name;
  final String img;
  final String price;
  final String title;
  final String description;
  final String phoneNo;

  SliderItem({
    Key key,
    @required this.name,
    @required this.img,
    @required this.title,
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
          Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height / 3.2,
                width: MediaQuery.of(context).size.width,
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
            padding: EdgeInsets.fromLTRB(5.0, 0, 5.0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "$title",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w900,
                  ),
                  maxLines: 1,
                ),
                Text(
                  "$price SR",
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(5.0, 2, 5.0, 8),
            child: Text(
              "$name",
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w900,
              ),
              maxLines: 2,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 5.0, top: 2.0),
            child: Row(),
          ),
        ],
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return ProductDetails(
                name: name,
                img: img,
                title: title,
                price: price,
                description: description,
                phoneNo: phoneNo,
              );
            },
          ),
        );
      },
    );
  }
}
