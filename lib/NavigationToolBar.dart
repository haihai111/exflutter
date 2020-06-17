import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/SearchImage.dart';
import 'package:image_picker/image_picker.dart';

import 'CameraScreen.dart';
import 'Res/colors.dart';
import 'Res/dimen.dart';

class NavigationToolBar extends StatefulWidget {
  final ScrollController scrollController;

  NavigationToolBar({Key key, this.scrollController}) : super(key: key);

  @override
  _NavigationToolBarState createState() => _NavigationToolBarState();
}

class _NavigationToolBarState extends State<NavigationToolBar> {
  double alpha = 0;
  ScrollController scrollController;

  @override
  void initState() {
    scrollController = widget.scrollController;

    widget.scrollController.addListener(() {
      if ((scrollController.offset / 200) <= 1) {
        setState(() {
          alpha = (scrollController.offset / 200);
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData media = MediaQuery.of(context);
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: statusBarHeight),
      width: double.infinity,
      height: heightNavigation + statusBarHeight,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Color(0xffA61A19).withOpacity(alpha),
          Color(0xffEE2624).withOpacity(alpha)
        ]),
      ),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(4))),
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 8),
              child: Icon(Icons.search, color: Colors.grey),
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  Text(
                    "Tìm Kiếm Trên Sendo",
                    style: TextStyle(color: Colors.grey),
                  ),
                  Spacer(),
                  IconButton(
                      icon: Icon(Icons.camera_alt),
                      color: Colors.grey,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CameraScreen()),
                        );
                      })
                ],
              ),
            ),
            Container(
              width: 1,
              margin: EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(color: Colors.grey),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Icon(
                Icons.shopping_cart,
                color: red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
