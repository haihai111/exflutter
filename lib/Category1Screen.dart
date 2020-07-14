import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_app/Event/CateItemEvent.dart';
import 'package:flutter_app/Res/dimen.dart';
import 'package:flutter_app/State/CateItemState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'Model/CateItemModel.dart';
import 'Bloc/CateBloc.dart';
import 'Model/BaseCate.dart';
import 'Res/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Category1Screen extends StatefulWidget {
  final List<BaseCate> cateItem;
  final index;
  final List<BaseCate> bannerList;

  Category1Screen({this.cateItem, this.bannerList, this.index});

  @override
  _Category1ScreenState createState() => _Category1ScreenState();
}

class _Category1ScreenState extends State<Category1Screen>
    with TickerProviderStateMixin {
  BaseCate cateItemLv1;
  PageController pageController;
  List<BaseCate> allCate = [];
  AnimationController controller;
  AnimationController allController;
  AnimationController bgController;
  Animation<double> offset;
  Animation<double> allOffset;
  Animation<double> bgOffset;
  ScrollController scrollController = ScrollController();
  ScrollController scrollControllerHoz = ScrollController();
  ScrollDirection scrollDirection = ScrollDirection.reverse;
  bool isFirstBgCate = false;
  Future<bool> isFirstTextCate;
  bool _isFirstTextCate = false;

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
    cateItemLv1 = widget.cateItem[widget.index];
    widget.cateItem.asMap().forEach((index, cate) =>
        {cate.isSelected = index == widget.index, allCate.add(cate)});
    pageController = new PageController(
      initialPage: 0,
      keepPage: false,
      viewportFraction: 0.94,
    );

    isFirstTextCate = _prefs.then((SharedPreferences prefs) {
      return (prefs.getBool('isFirstTextCate') ?? true);
    });

    controller = new AnimationController(
        duration: Duration(milliseconds: 200), vsync: this)
      ..addListener(() => {});
    offset = Tween(begin: 0.0, end: 116.0).animate(controller);

    allController = new AnimationController(
        duration: Duration(milliseconds: 100), vsync: this)
      ..addListener(() => {});
    allOffset = Tween(begin: 1.0, end: 0.0).animate(allController);

    bgController = new AnimationController(
        duration: Duration(milliseconds: 500), vsync: this)
      ..addListener(() => {});
    bgOffset = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: bgController, curve: Curves.easeInOutBack));

    scrollController.addListener(() async {
      if (scrollController.position.userScrollDirection ==
              ScrollDirection.reverse &&
          scrollDirection == ScrollDirection.reverse) {
        scrollDirection = ScrollDirection.forward;
        controller.forward();
        if (_isFirstTextCate == false) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          _isFirstTextCate = prefs.getBool("isFirstTextCate") ?? true;
          if (_isFirstTextCate == true) {
            allController.forward();
            prefs.setBool("isFirstTextCate", false);
          }
        }
      } else if (scrollController.position.userScrollDirection ==
              ScrollDirection.forward &&
          scrollDirection == ScrollDirection.forward) {
        scrollDirection = ScrollDirection.reverse;
        controller.reverse();
        if (isFirstBgCate == false) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          isFirstBgCate = prefs.getBool("isFirstBgCate") ?? true;
          if (isFirstBgCate == true) {
            prefs.setBool("isFirstBgCate", false);
            bgController.forward();
          }
        }
      }
    });
    scrollAllCate();
  }

  void scrollAllCate() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollControllerHoz.animateTo(widget.index * 104.0,
          duration: const Duration(milliseconds: 10), curve: Curves.easeOut);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider<AllCateItemModel>(
              create: (context) => AllCateItemModel(allCate: allCate)),
          ChangeNotifierProvider<CateItemModel>(
              create: (context) => CateItemModel(cateItemLv1: cateItemLv1)),
          ChangeNotifierProvider<CateGuidance>(
              create: (context) => CateGuidance())
        ],
        child: Stack(
          children: <Widget>[
            Consumer<CateItemModel>(
              builder: (context, myModel, child) {
                return CustomScrollView(
                  controller: scrollController,
                  slivers: <Widget>[
                    SliverAppBar(
                      title: Text(
                        myModel.cateItemLv1.title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      pinned: true,
                      flexibleSpace: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Color(0xffA61A19), Color(0xffEE2624)]),
                        ),
                      ),
                      centerTitle: true,
                      actions: <Widget>[
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: Text(
                              "Tất cả",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ),
                        )
                      ],
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        if (index == 0) {
                          return banner(widget.bannerList);
                        } else if (index ==
                            myModel.cateItemLv1.child.length + 1) {
                          return Container(height: 60);
                        } else {
                          return gridView(
                              myModel.cateItemLv1.child[index - 1].title,
                              myModel.cateItemLv1.child[index - 1],
                              context);
                        }
                      }, childCount: myModel.cateItemLv1.child.length + 2),
                    ),
                  ],
                );
              },
            ),
            guidanceAllCate(context),
            guidanceTextAllCate(),
            allCateWidget(),
          ],
        ),
      ),
    );
  }

  Widget guidanceAllCate(BuildContext context) {
    print(bgOffset.value);
    return Stack(
      children: <Widget>[
        AnimatedBuilder(
          animation: bgController,
          builder: (BuildContext context, Widget child) {
            return bgOffset.value >= 1
                ? InkWell(
                    onTap: () {
                      bgController.reverse();
                    },
                    child: Container(
                      decoration: new BoxDecoration(
                        color: gray900.withOpacity(0.5),
                      ),
                    ),
                  )
                : Container();
          },
        ),
        guidanceBg(context),
        AnimatedBuilder(
          animation: bgController,
          builder: (BuildContext context, Widget child) {
            return bgOffset.value >= 1
                ? Positioned(
                    left: 16,
                    right: 16,
                    bottom: 200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(
                            "Xem các danh mục khác",
                            style: TextStyle(color: white, fontSize: 16),
                          ),
                        ),
                        Container(
                          child: Text(
                            "Cuộn ngang và bấm vào ảnh để xem danh mục bạn muốn.",
                            style: TextStyle(color: white, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  )
                : Container();
          },
        ),
      ],
    );
  }

  Widget guidanceBg(BuildContext context) {
    return Positioned(
      bottom: -(MediaQuery.of(context).size.height * 0.5),
      right: -160,
      child: AnimatedBuilder(
        animation: bgController,
        builder: (BuildContext context, Widget child) {
          return isFirstBgCate == false
              ? Container()
              : Transform.scale(
                  scale: bgOffset.value,
                  child: Container(
                    width: MediaQuery.of(context).size.height * (1.2),
                    height: MediaQuery.of(context).size.height * (1.2),
                    decoration: new BoxDecoration(
                      color: gray800,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
        },
      ),
    );
  }

  Widget guidanceTextAllCate() {
    return AnimatedBuilder(
      animation: allController,
      builder: (BuildContext context, Widget child) {
        return AnimatedOpacity(
          opacity: allOffset.value,
          duration: Duration(seconds: 1),
          child: FutureBuilder<bool>(
            future: isFirstTextCate,
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              return snapshot.data == false
                  ? Container()
                  : Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top +
                              heightNavigation -
                              16,
                          right: 6),
                      child: Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              margin: EdgeInsets.only(right: 16),
                              child: CustomPaint(
                                size: Size(24, 10),
                                painter: DrawTriangle(),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: gray900,
                                  border: Border.all(color: gray900, width: 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              child: Text(
                                "Bấm để xem tất cả sản phẩm \ncủa danh mục này.",
                                style: TextStyle(color: white, fontSize: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
            },
          ),
        );
      },
    );
  }

  Widget allCateWidget() {
    return Consumer<AllCateItemModel>(
      builder: (context, myModel, child) {
        return AnimatedBuilder(
          animation: controller,
          builder: (BuildContext context, Widget child) {
            return Align(
              alignment: Alignment.bottomCenter,
              child: Transform.translate(
                offset: Offset(0.0, offset.value),
                child: Container(
                  height: 176,
                  decoration: BoxDecoration(
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Colors.black38,
                            blurRadius: 10.0,
                            offset: Offset(0.0, 0.75)),
                      ],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                      color: white),
                  child: Column(
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          switch (controller.status) {
                            case AnimationStatus.completed:
                              controller.reverse();
                              break;
                            case AnimationStatus.dismissed:
                              controller.forward();
                              break;
                            default:
                          }
                        },
                        child: Container(
                          height: 60,
                          alignment: Alignment.center,
                          child: Text(
                            "Toàn bộ danh mục",
                            style: TextStyle(
                                color: black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Container(
                        color: white,
                        height: 116,
                        child: ListView.builder(
                          controller: scrollControllerHoz,
                          scrollDirection: Axis.horizontal,
                          itemCount: myModel.allCate.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                myModel.changeAllCate(index);
                                Provider.of<CateItemModel>(context,
                                        listen: false)
                                    .changeAllCate(widget.cateItem[index]);
                              },
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    height: 100,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: myModel
                                                    .allCate[index].isSelected
                                                ? red
                                                : transparent,
                                            width: 2),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    margin: EdgeInsets.only(
                                        left: 4, right: 4, bottom: 16),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        imageUrl: myModel.allCate[index].image,
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 12,
                                    right: 8,
                                    bottom: 24,
                                    child: Container(
                                      width: 100,
                                      child: Text(
                                        myModel.allCate[index].title,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  myModel.allCate[index].isSelected
                                      ? Padding(
                                          padding: const EdgeInsets.only(
                                              top: 4, left: 8),
                                          child: Image.asset(
                                            "assets/icons/icon24_circle_checked_solid_default.png",
                                            height: 24,
                                            color: red,
                                          ),
                                        )
                                      : Container(),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget banner(List<BaseCate> bannerList) {
    return AspectRatio(
      aspectRatio: 750 / 422,
      child: Container(
        margin: EdgeInsets.only(top: 8),
        child: PageIndicatorContainer(
            child: PageView.builder(
              itemBuilder: (context, position) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: bannerList[position].image,
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                );
              },
              controller: pageController,
              itemCount: bannerList.length,
            ),
            align: IndicatorAlign.bottom,
            length: bannerList.length,
            indicatorSelectorColor: red,
            shape: IndicatorShape.circle(size: 8),
            indicatorSpace: 6),
      ),
    );
  }

  Widget gridView(String title, BaseCate data, BuildContext context) {
    return Container(
      color: white,
      child: Column(
        children: <Widget>[
          Container(
            height: 8,
            color: gray50,
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  title,
                  style: TextStyle(
                      color: black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Image.asset(
                  "assets/icons/icon24_chevron_right.png",
                  height: 24,
                ),
              ),
            ],
          ),
          GridView.builder(
            padding: EdgeInsets.all(16),
            itemCount: data.child.length,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio:
                    (MediaQuery.of(context).size.height) * 0.00068),
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(
                    height: 100,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      child: CachedNetworkImage(
                        imageUrl: data.child[index].image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 4, left: 8),
                    child: Text(
                      data.child[index].title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: black,
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              );
            },
          )
        ],
      ),
    );
  }
}

class DrawTriangle extends CustomPainter {
  Paint _paint;

  DrawTriangle() {
    _paint = Paint()
      ..color = gray900
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.close();
    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class DrawCircle extends CustomPainter {
  Paint _paint;
  var widthScreen;

  DrawCircle(widthScreen) {
    this.widthScreen = widthScreen;
    _paint = Paint()
      ..color = gray900
      ..strokeWidth = 1
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(Offset(0, widthScreen * 2), 300.0, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
