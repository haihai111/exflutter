import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_app/Event/CateItemEvent.dart';
import 'package:flutter_app/Res/dimen.dart';
import 'package:flutter_app/State/CateItemState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:provider/provider.dart';
import 'Model/CateItemModel.dart';
import 'Bloc/CateBloc.dart';
import 'Model/BaseCate.dart';
import 'Res/colors.dart';

class Category1Screen extends StatefulWidget {
  final List<BaseCate> cateItem;
  final index;
  final List<BaseCate> bannerList;

  Category1Screen({this.cateItem, this.bannerList, this.index});

  @override
  _Category1ScreenState createState() => _Category1ScreenState();
}

class _Category1ScreenState extends State<Category1Screen>
    with SingleTickerProviderStateMixin {
  BaseCate cateItemLv1;
  PageController pageController;
  List<BaseCate> allCate = [];
  AnimationController controller;
  Animation<double> offset;
  ScrollController scrollController = ScrollController();
  ScrollController scrollControllerHoz = ScrollController();
  ScrollDirection scrollDirection = ScrollDirection.reverse;

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

    controller = new AnimationController(
        duration: Duration(milliseconds: 200), vsync: this)
      ..addListener(() => {});
    offset = Tween(begin: 0.0, end: 116.0).animate(controller);

    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
              ScrollDirection.reverse &&
          scrollDirection == ScrollDirection.reverse) {
        scrollDirection = ScrollDirection.forward;
        controller.forward();
      } else if (scrollController.position.userScrollDirection ==
              ScrollDirection.forward &&
          scrollDirection == ScrollDirection.forward) {
        scrollDirection = ScrollDirection.reverse;
        controller.reverse();
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
            Consumer<CateItemModel>(builder: (context, myModel, child) {
              return NotificationListener<ScrollNotification>(
                onNotification: (scrollNotification) {
                  if (scrollNotification is ScrollStartNotification) {
                    Provider.of<CateGuidance>(context, listen: false)
                        .changeIsGuidance(false);
                  }
                  return true;
                },
                child: CustomScrollView(
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
                              myModel.cateItemLv1.child[index - 1]);
                        }
                      }, childCount: myModel.cateItemLv1.child.length + 2),
                    ),
                  ],
                ),
              );
            }),
            Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                "assets/icons/guide_background.png",
                fit: BoxFit.fill,
                height: MediaQuery.of(context).size.height * 0.75,
              ),
            ),
            guidanceAllCate(),
            allCateWidget(),
          ],
        ),
      ),
    );
  }

  Widget guidanceAllCate() {
    return Consumer<CateGuidance>(builder: (context, myModel, child) {
      return AnimatedOpacity(
        opacity: myModel.isGuidance ? 1 : 0,
        duration: Duration(seconds: 1),
        child: Padding(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + heightNavigation - 16,
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
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: Text(
                    "Bấm để xem tất cả sản phẩm \ncủa danh mục này.",
                    style: TextStyle(color: white, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
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
                  decoration: BoxDecoration(boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.black38,
                        blurRadius: 10.0,
                        offset: Offset(0.0, 0.75))
                  ], color: white),
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

  Widget gridView(String title, BaseCate data) {
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
