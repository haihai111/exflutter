import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Model/WidgetHome.dart';

class WidgetBannetEvent extends StatelessWidget {
  final WidgetHome widget;

  WidgetBannetEvent({Key key, this.widget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: widget.data.homeModelItems[0].ratioImage,
      child: CachedNetworkImage(
        fit: BoxFit.cover,
        imageUrl: widget.data.homeModelItems[0].image,
      ),
    );
  }
}
