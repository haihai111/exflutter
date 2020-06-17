import 'package:flutter/cupertino.dart';

class CornerBBoxSearch extends StatefulWidget {
  final List bbox;
  final double heightImg;

  CornerBBoxSearch({Key key, @required this.bbox, @required this.heightImg})
      : super(key: key);

  @override
  _CornerBBoxSearchState createState() => _CornerBBoxSearchState();
}

class _CornerBBoxSearchState extends State<CornerBBoxSearch> {
  double width = 0;
  double height = 0;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Stack(
      children: <Widget>[
        Positioned(
          left: convertWidth(widget.bbox[0]) - 4,
          top: convertHeight(widget.bbox[1]) + extraHeight() - 4,
          child: Image(
            height: 35,
            width: 35,
            image: AssetImage('assets/icons/corner.png'),
          ),
        ),
        Positioned(
          left: convertWidth(widget.bbox[0]) - 4,
          top: convertHeight(widget.bbox[3]) + extraHeight() - (35 - 4),
          child: RotatedBox(
            quarterTurns: 3,
            child: Image(
              height: 35,
              width: 35,
              image: AssetImage('assets/icons/corner.png'),
            ),
          ),
        ),
        Positioned(
          right: width - convertWidth(widget.bbox[2]) - 4,
          top: convertHeight(widget.bbox[1]) + extraHeight() - 4,
          child: RotatedBox(
            quarterTurns: 1,
            child: Image(
              height: 35,
              width: 35,
              image: AssetImage('assets/icons/corner.png'),
            ),
          ),
        ),
        Positioned(
          right: width - convertWidth(widget.bbox[2]) - 4,
          top: convertHeight(widget.bbox[3]) + extraHeight() - (35 - 4),
          child: RotatedBox(
            quarterTurns: 2,
            child: Image(
              height: 35,
              width: 35,
              image: AssetImage('assets/icons/corner.png'),
            ),
          ),
        ),
      ],
    );
  }

  double convertWidth(double a) {
    return a * width;
  }

  double convertHeight(double a) {
    return a * widget.heightImg;
  }

  double extraHeight() {
    return (height - widget.heightImg) / 2;
  }
}
