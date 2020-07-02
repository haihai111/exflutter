import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Event/CateItemEvent.dart';
import 'package:flutter_app/State/CateItemState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_indicator/page_indicator.dart';

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

  @override
  void initState() {
    super.initState();
    cateItemLv1 = widget.cateItem[widget.index];
    widget.cateItem.forEach((cate) => {allCate.add(cate)});
    pageController = new PageController(
      initialPage: 0,
      keepPage: false,
      viewportFraction: 0.94,
    );

    controller = new AnimationController(
        duration: Duration(milliseconds: 250), vsync: this)
      ..addListener(() => {});
    offset = Tween(begin: 0.0, end: 116.0).animate(controller);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            color: white,
            child: CustomScrollView(slivers: <Widget>[
              SliverAppBar(
                title: Text(cateItemLv1.title),
                pinned: true,
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Color(0xffA61A19), Color(0xffEE2624)]),
                  ),
                ),
                centerTitle: true,
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  if (index == 0) {
                    return banner(widget.bannerList);
                  } else {
                    return gridView(cateItemLv1.child[index - 1].title,
                        cateItemLv1.child[index - 1]);
                  }
                }, childCount: cateItemLv1.child.length + 1),
              ),
            ]),
          ),
          AnimatedBuilder(
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
                            scrollDirection: Axis.horizontal,
                            itemCount: allCate.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Container(
                                height: 100,
                                margin: EdgeInsets.only(
                                    left: 4, right: 4, bottom: 16),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: allCate[index].image,
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
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
          )
        ],
      ),
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
    return Column(
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
                    color: black, fontSize: 16.0, fontWeight: FontWeight.bold),
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
              childAspectRatio: (MediaQuery.of(context).size.height) * 0.00068),
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
    );
  }
}
