import 'dart:io';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/ListSearchImage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

import 'Bloc/HomeBloc.dart';
import 'Bloc/bloc_provider.dart';
import 'CornerBBoxSearch.dart';
import 'Res/colors.dart';
import 'package:image/image.dart' as Img;

enum Drag {
  LEFT,
  RIGHT,
  TOP,
  BOTTOM,
  LEFT_TOP,
  RIGHT_TOP,
  LEFT_BOTTOM,
  RIGHT_BOTTOM,
  DRAG,
}

class SearchImage extends StatefulWidget {
  final File image;
  final double widthImg;
  final double heightImg;
  final double width;
  final double height;
  final bool isGallery;

  SearchImage(
      {Key key,
      this.image,
      this.widthImg,
      this.heightImg,
      this.width,
      this.height,
      this.isGallery = false})
      : super(key: key);

  @override
  _SearchImageState createState() => _SearchImageState();
}

class _SearchImageState extends State<SearchImage> {
  File _image;
  double widthImg = 0;
  double heightImg = 0;
  double width = 0;
  double height = 0;
  GlobalKey _key = GlobalKey();
  List bbox;
  bool isBbox = false;
  Drag enumDrag;

  _getSizes() {
    final RenderBox renderBoxRed = _key.currentContext.findRenderObject();
    final sizeRed = renderBoxRed.size;
    print("SIZE of Red: $sizeRed");
  }

  _getPositions() {
    final RenderBox renderBoxRed = _key.currentContext.findRenderObject();
    final positionRed = renderBoxRed.localToGlobal(Offset.zero);
    print("POSITION of Red: $positionRed ");
  }

  _afterLayout() {
    _getSizes();
  }

  @override
  void initState() {
    super.initState();
    _image = widget.image;
    widthImg = widget.widthImg;
    heightImg = widget.heightImg;
    width = widget.width;
    height = widget.height;
    if (widget.isGallery == false) {
      var imageTemp = Img.decodeImage(_image.readAsBytesSync());
      var resizedImg = Img.copyResize(imageTemp,
          height: (heightImg * (height / heightImg)).toInt(),
          width: (widthImg * (width / widthImg)).toInt());
      heightImg = (heightImg * (height / heightImg));
    }
    _upload(_image, null);
  }

  void _upload(File file, Img.Image image) async {
    String fileName = file.path.split('/').last;
    FormData data;
    if (image != null)
      data = FormData.fromMap({
        "query_img": await MultipartFile.fromBytes(
          Img.encodeJpg(image),
          filename: fileName,
        ),
      });
    else
      data = FormData.fromMap({
        "query_img": await MultipartFile.fromFile(
          file.path,
          filename: fileName,
        ),
      });
    Dio dio = new Dio();

    dio.post("http://0.0.0.0:5000", data: data).then(
      (response) {
        setState(() {
          var _b = response.data['bbox'];
          bbox = [
            double.parse(_b[0]),
            double.parse(_b[1]),
            double.parse(_b[2]),
            double.parse(_b[3])
          ];
          isBbox = true;
        });
      },
    ).catchError((error) => print(error));
  }

  void _uploadImage(File file) async {
    String fileName = file.path.split('/').last;

    FormData data = FormData.fromMap({
      "bbox": bbox.join(','),
      "query_img": await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      ),
    });

    Dio dio = new Dio();

    dio.post("http://0.0.0.0:5000/images", data: data).then(
      (response) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return BlocProvider<HomeBloc>(
                bloc: HomeBloc(),
                child: ListSearchImage(
                  productId: response.data['productid'],
                ),
              );
            },
          ),
        );
      },
    ).catchError((error) => print(error));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GestureDetector(
          onPanDown: (DragDownDetails details) {
            onTapDown(details);
          },
          onPanUpdate: (DragUpdateDetails details) {
            onPanUpdate(details);
          },
          child: Center(
            child: Container(
              key: _key,
              child: _image == null
                  ? Container()
                  : Image(
                      height: getHeighImg(),
                      width: width,
                      image: FileImage(_image),
                      fit: BoxFit.fill,
                    ),
            ),
          ),
        ),
        IgnorePointer(
          child: ClipPath(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: black.withOpacity(0.6),
            ),
            clipper: _RectangleModePhoto(
                bbox, width, height, widthImg, getHeighImg()),
          ),
        ),
        bbox != null
            ? GestureDetector(
                onPanDown: (DragDownDetails details) {
                  onTapDown(details);
                },
                onPanUpdate: (DragUpdateDetails details) {
                  onPanUpdate(details);
                },
                child: CornerBBoxSearch(
                  bbox: bbox,
                  heightImg: getHeighImg(),
                ),
              )
            : Container(),
        Align(
          alignment: Alignment.bottomCenter,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 22),
              child: FloatingActionButton(
                onPressed: () {
                  _uploadImage(_image);
                },
                child: isBbox == false
                    ? Icon(Icons.close, size: 32)
                    : Icon(Icons.done, size: 32),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: _image != null && isBbox == false
              ? new SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 22),
                    child: SizedBox(
                      height: 58,
                      width: 58,
                      child: new CircularProgressIndicator(
                        strokeWidth: 6,
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ),
                )
              : Container(),
        ),
      ],
    );
  }

  void onTapDown(DragDownDetails details) {
    if (isDraggable(details.localPosition, bbox)) {
      if (isDragLeft(details.localPosition) &&
          isDragTop(details.localPosition)) {
        enumDrag = Drag.LEFT_TOP;
      } else if (isDragRight(details.localPosition) &&
          isDragTop(details.localPosition)) {
        enumDrag = Drag.RIGHT_TOP;
      } else if (isDragRight(details.localPosition) &&
          isDragBottom(details.localPosition)) {
        enumDrag = Drag.RIGHT_BOTTOM;
      } else if (isDragLeft(details.localPosition) &&
          isDragBottom(details.localPosition)) {
        enumDrag = Drag.LEFT_BOTTOM;
      } else if (isDragLeft(details.localPosition)) {
        enumDrag = Drag.LEFT;
      } else if (isDragRight(details.localPosition)) {
        enumDrag = Drag.RIGHT;
      } else if (isDragTop(details.localPosition)) {
        enumDrag = Drag.TOP;
      } else if (isDragBottom(details.localPosition)) {
        enumDrag = Drag.BOTTOM;
      } else {
        enumDrag = Drag.DRAG;
      }
    } else {
      enumDrag = null;
    }
  }

  void onPanUpdate(DragUpdateDetails details) {
    List _bbox = []..addAll(bbox);
    switch (enumDrag) {
      case Drag.LEFT:
        _bbox[0] += details.delta.dx / width;
        break;
      case Drag.RIGHT:
        _bbox[2] += details.delta.dx / width;
        break;
      case Drag.TOP:
        _bbox[1] += details.delta.dy / getHeighImg();
        break;
      case Drag.BOTTOM:
        _bbox[3] += details.delta.dy / getHeighImg();
        break;
      case Drag.LEFT_TOP:
        _bbox[0] += details.delta.dx / width;
        _bbox[1] += details.delta.dy / getHeighImg();
        break;
      case Drag.RIGHT_TOP:
        _bbox[2] += details.delta.dx / width;
        _bbox[1] += details.delta.dy / getHeighImg();
        break;
      case Drag.LEFT_BOTTOM:
        _bbox[0] += details.delta.dx / width;
        _bbox[3] += details.delta.dy / getHeighImg();
        break;
      case Drag.RIGHT_BOTTOM:
        _bbox[2] += details.delta.dx / width;
        _bbox[3] += details.delta.dy / getHeighImg();
        break;
      case Drag.DRAG:
        _bbox[0] += details.delta.dx / width;
        _bbox[2] += details.delta.dx / width;
        _bbox[1] += details.delta.dy / getHeighImg();
        _bbox[3] += details.delta.dy / getHeighImg();
        break;
    }
    if (isDragInImage(_bbox)) {
      setState(() {
        bbox = _bbox;
      });
    }
  }

  bool isDraggable(Offset details, List bbox) {
    var l = convertWidth(bbox[0]);
    var r = convertWidth(bbox[2]);
    var t = convertHeight(bbox[1]) + (height - getHeighImg()) / 2 + 5;
    var b = convertHeight(bbox[3]) + (height - getHeighImg()) / 2 + 5;
    return details.dx >= l &&
        details.dx <= r &&
        details.dy >= t &&
        details.dy <= b;
  }

  bool isDragInImage(bbox) {
    return convertWidth(bbox[0]) >= 5 &&
        convertWidth(bbox[2]) <= width - 5 &&
        convertHeight(bbox[1]) >= 5 &&
        convertHeight(bbox[3]) <= getHeighImg() - 5 &&
        convertHeight(bbox[3]) - convertHeight(bbox[1]) >= 70 &&
        convertWidth(bbox[2]) - convertWidth(bbox[0]) >= 70;
  }

  bool isDragLeft(Offset details) {
    return details.dx >= convertWidth(bbox[0]) &&
        details.dx <= convertWidth(bbox[0]) + 20;
  }

  bool isDragRight(Offset details) {
    return details.dx <= convertWidth(bbox[2]) &&
        details.dx >= convertWidth(bbox[2]) - 20;
  }

  bool isDragTop(Offset details) {
    return details.dy >= convertHeight(bbox[1]) + extraHeight() &&
        details.dy <= convertHeight(bbox[1]) + 20 + extraHeight();
  }

  bool isDragBottom(Offset details) {
    return details.dy <= convertHeight(bbox[3]) + extraHeight() &&
        details.dy >= convertHeight(bbox[3]) - 20 + extraHeight();
  }

  double getHeighImg() {
    if (widget.isGallery == true) {
      if ((heightImg == widthImg) && (widthImg > width || widthImg < width)) {
        return width;
      } else if (widthImg > width) {
        return heightImg * (width / widthImg);
      }
      return 0;
    }
    return heightImg;
  }

  double convertWidth(double a) {
    return a * width;
  }

  double convertHeight(double a) {
    return a * getHeighImg();
  }

  double extraHeight() {
    return (height - getHeighImg()) / 2;
  }
}

class _RectangleModePhoto extends CustomClipper<Path> {
  final List bbox;
  final double width;
  final double height;
  final double widthImg;
  final double heightImg;

  _RectangleModePhoto(
      this.bbox, this.width, this.height, this.widthImg, this.heightImg);

  @override
  Path getClip(Size size) {
    if (bbox != null) {
      var path = Path();
      var reactPath = Path();
      reactPath.moveTo(
          convertWidth(bbox[0]), convertHeight(bbox[1]) + extraHeight());
      reactPath.lineTo(
          convertWidth(bbox[0]), convertHeight(bbox[3]) + extraHeight());
      reactPath.lineTo(
          convertWidth(bbox[2]), convertHeight(bbox[3]) + extraHeight());
      reactPath.lineTo(
          convertWidth(bbox[2]), convertHeight(bbox[1]) + extraHeight());

      path.addPath(reactPath, Offset.zero);
      path.addRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height));
      path.fillType = PathFillType.evenOdd;
      path.close();
      return path;
    }
    return Path();
  }

  double extraHeight() {
    return (height - heightImg) / 2;
  }

  double convertWidth(double a) {
    return a * width;
  }

  double convertHeight(double a) {
    return a * heightImg;
  }

  @override
  bool shouldReclip(_RectangleModePhoto oldClipper) {
    return true;
  }
}
