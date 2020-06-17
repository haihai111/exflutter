import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Model/HomeModelItem.dart';
import 'package:flutter_app/Model/WidgetHome.dart';
import 'package:flutter_app/Res/Utils.dart';
import 'package:flutter_app/Res/colors.dart';

class WidgetFlashSale extends StatefulWidget {
  final WidgetHome widget;

  WidgetFlashSale({Key key, this.widget}) : super(key: key);

  @override
  _WidgetFlashSaleState createState() => _WidgetFlashSaleState();
}

class _WidgetFlashSaleState extends State<WidgetFlashSale> {
  List<HomeModelItem> homeModelItems;
  double height = 16;
  double heightSizeBox = 8;
  double margin = 16;
  double padding = 16;
  double heightHeader = 48;

  Timer _timer;
  int _start = 0;
  int hour = 0;
  int minute = 0;
  int second = 0;

  @override
  void initState() {
    homeModelItems = widget.widget.data.homeModelItems;
    var date =
    DateTime.fromMillisecondsSinceEpoch(widget.widget.data.endTime * 1000);
    Duration duration = date.difference(DateTime.now());

    _start =
        duration.inHours * 3600 + duration.inMinutes * 60 + duration.inSeconds;

    _timer = new Timer.periodic(
      Duration(seconds: 1),
          (Timer timer) =>
          setState(() {
            if (_start < 1) {
              timer.cancel();
            } else {
              _start = _start - 1;
              var date = DateTime.fromMillisecondsSinceEpoch(
                  widget.widget.data.endTime * 1000);
              Duration duration =
              date.difference(DateTime.now().subtract(Duration(seconds: 2)));
              setState(() {
                hour = (duration.inHours.abs() % 24);
                minute = (duration.inMinutes.abs() % 60);
                second = (duration.inSeconds.abs() % 60);
              });
            }
          }),
    );
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery
        .of(context)
        .size
        .width;
    return Column(
      children: <Widget>[
        headerTitle(),
        Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 8, right: 8),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  )),
              width: double.infinity,
              height: (width / (3.8) + height * 2) * 2 +
                  heightSizeBox +
                  margin +
                  padding * 2,
            ),
            Container(
              height: (width / (3.8) + height * 2) * 2 +
                  heightSizeBox +
                  margin +
                  padding * 2,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: (homeModelItems.length / 2).round(),
                  itemBuilder: (context, index) {
                    if (index + 1 * index + 1 < homeModelItems.length) {
                      return a(index);
                    } else {
                      return b(index);
                    }
                  }),
            ),
          ],
        ),
      ],
    );
  }

  Widget headerTitle() {
    return Container(
      margin: EdgeInsets.only(left: 8, right: 8, top: 16),
      height: heightHeader,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              end: Alignment.topLeft,
              begin: Alignment.bottomRight,
              colors: [Color(0xfff5a36b), Color(0xffee2926)]),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          )),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 6,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/icons/ic_fs_banner.png"),
                          fit: BoxFit.fill)),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 8, right: 4),
                      child: Image.asset(
                        "assets/icons/icon_flash.png",
                        height: 16,
                      ),
                    ),
                    Text(
                      "Flash Sale",
                      style: TextStyle(
                          fontSize: 16,
                          color: white,
                          fontWeight: FontWeight.bold),
                    ),
                    timerCountDown()
                  ],
                )
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              margin: EdgeInsets.only(right: 8),
              alignment: Alignment.centerRight,
              child: Text(
                "Xem tất cả",
                style: TextStyle(color: white, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget timerCountDown() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Row(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.all(Radius.circular(2)),
            ),
            child: Padding(
              padding: EdgeInsets.all(4),
              child: Text(
                "${hour > 9 ? hour : "0$hour"}",
                style: TextStyle(color: white, fontSize: 10),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2),
            child: Text(":", style: TextStyle(color: Colors.black)),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.all(Radius.circular(2)),
            ),
            child: Padding(
              padding: EdgeInsets.all(4),
              child: Text(
                "${minute > 9 ? minute : "0$minute"}",
                style: TextStyle(color: white, fontSize: 10),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Text(":", style: TextStyle(color: Colors.black)),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.all(Radius.circular(2)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Text(
                "${second > 9 ? second : "0$second"}",
                style: TextStyle(color: white, fontSize: 10),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget a(int index) {
    return Column(
      children: <Widget>[
        SizedBox(height: heightSizeBox),
        itemFlashSale(index + 1 * index),
        itemFlashSale(index + 1 * index + 1)
      ],
    );
  }

  Widget b(index) {
    return itemFlashSale(index + 1 * index);
  }

  Widget itemFlashSale(int index) {
    double marginLeft = (index == 0 || index == 1) ? 16 : 8;
    double marginRight = (index == homeModelItems.length - 2 ||
        index == homeModelItems.length - 1)
        ? 16
        : 0;
    return Container(
      margin: EdgeInsets.only(left: marginLeft, right: marginRight),
      width: MediaQuery
          .of(context)
          .size
          .width / (3.8),
      child: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(0),
            child: AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                child: CachedNetworkImage(
                  imageUrl: homeModelItems[index].imgUrlMob,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 6),
            height: height,
            child: Text(
              Utils.formatNumber(homeModelItems[index].finalPrice),
              style: TextStyle(color: red, fontSize: 12.0),
            ),
          ),
          progressItem(index)
        ],
      ),
    );
  }

  Widget progressItem(int index) {
    return Padding(
      padding: EdgeInsets.only(top: 6, bottom: 16),
      child: LayoutBuilder(builder: (context, constraints) {
        var maxWidth = constraints.maxWidth - 24;
        return Stack(
          children: <Widget>[
            Container(
              height: 10,
              margin: EdgeInsets.symmetric(horizontal: 12),
              width: maxWidth,
              decoration: BoxDecoration(
                color: Color(0xfff5c9a6),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
            ),
            Container(
              height: 10,
              margin: EdgeInsets.symmetric(horizontal: 12),
              width: maxWidth * (homeModelItems[index].stockPercent / 100),
              decoration: BoxDecoration(
                color: Color(0xffff6a42),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
            ),
            Align(
              child: Text(
                "Đã bán ${homeModelItems[index].buyBumber.toString()}",
                style: TextStyle(color: Colors.white, fontSize: 8.0),
              ),
              alignment: Alignment.center,
            ),
          ],
        );
      }),
    );
  }
}
