import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Bloc/CateBloc.dart';
import 'package:flutter_app/Model/WidgetHome.dart';
import 'package:flutter_app/Res/SlideRightRoute.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../CategoryScreen.dart';

class WidgetShortcut extends StatefulWidget {
  final WidgetHome widget;

  WidgetShortcut({Key key, this.widget}) : super(key: key);

  @override
  _WidgetShortcutState createState() => _WidgetShortcutState();
}

class _WidgetShortcutState extends State<WidgetShortcut> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.all(0.0),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MyCustomRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => CateBloc(),
                      child: CategoryScreen(),
                    ),
                  ),
                );
              },
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 12, right: 12),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: widget.widget.data.homeModelItems[index].image,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 12, right: 12),
                    child: Text(
                      widget.widget.data.homeModelItems[index].title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 8,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          itemCount: widget.widget.data.homeModelItems.length,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5)),
    );
  }
}
