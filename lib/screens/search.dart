import 'package:flutter/material.dart';
import 'package:flash_chat/util/const.dart';
import 'package:flash_chat/util/items.dart';
import 'package:flash_chat/widgets/smooth_star_rating.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with AutomaticKeepAliveClientMixin<SearchScreen> {
  final TextEditingController _searchControl = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
      child: ListView(
        children: <Widget>[
          SizedBox(height: 10.0),
          Card(
            elevation: 6.0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
              ),
              child: TextField(
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
                  hintText: "Search..",
                  suffixIcon: Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  hintStyle: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                  ),
                ),
                maxLines: 1,
                controller: _searchControl,
              ),
            ),
          ),
          SizedBox(height: 5.0),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              "History",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            primary: false,
            physics: NeverScrollableScrollPhysics(),
            itemCount: items == null ? 0 : items.length,
            itemBuilder: (BuildContext context, int index) {
              Map item = items[index];
              return ListTile(
                title: Text(
                  "${item['name']}",
                  style: TextStyle(
//                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                leading: CircleAvatar(
                  radius: 25.0,
                  backgroundImage: AssetImage(
                    "${item['img']}",
                  ),
                ),
                trailing: Text(r"$10"),
                subtitle: Row(
                  children: <Widget>[
                    SmoothStarRating(
                      starCount: 1,
                      color: Constants.ratingBG,
                      allowHalfRating: true,
                      rating: 5.0,
                      size: 12.0,
                    ),
                    SizedBox(width: 6.0),
                    Text(
                      "5.0 (23 Reviews)",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
                onTap: () {},
              );
            },
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
