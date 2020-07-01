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
  final BaseCate cateItemLv1;
  final List<BaseCate> bannerList;

  Category1Screen({this.cateItemLv1, this.bannerList});

  @override
  _Category1ScreenState createState() => _Category1ScreenState();
}

class _Category1ScreenState extends State<Category1Screen> {
//  CateBloc cateBloc;
  PageController controller;

  @override
  void initState() {
    super.initState();
//    cateBloc = BlocProvider.of<CateBloc>(context);
    controller = new PageController(
      initialPage: 0,
      keepPage: false,
      viewportFraction: 0.94,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: white,
        child: CustomScrollView(slivers: <Widget>[
          SliverAppBar(
            title: Text(widget.cateItemLv1.title),
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
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
              if (index == 0) {
                return banner(widget.bannerList);
              } else {
                return gridView(widget.cateItemLv1.child[index - 1].title,
                    widget.cateItemLv1.child[index - 1]);
              }
            }, childCount: widget.cateItemLv1.child.length + 1),
          ),
        ]),
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
              controller: controller,
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
                style: TextStyle(color: black, fontSize: 16.0,fontWeight: FontWeight.bold),
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
        )
      ],
    );
//    return GridView.builder(
//      padding: EdgeInsets.all(16),
//      itemCount: data.length,
//      physics: NeverScrollableScrollPhysics(),
//      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
//          crossAxisCount: 2,
//          crossAxisSpacing: 8.0,
//          mainAxisSpacing: 8.0,
//          childAspectRatio: (MediaQuery.of(context).size.height) * 0.00148),
//      shrinkWrap: true,
//      itemBuilder: (BuildContext context, int index) {
//        return Column(
//          crossAxisAlignment: CrossAxisAlignment.stretch,
//          children: <Widget>[
//            SizedBox(
//              height: 100,
//              child: ClipRRect(
//                borderRadius: BorderRadius.all(Radius.circular(4)),
//                child: CachedNetworkImage(
//                  imageUrl: data[index].image,
//                  fit: BoxFit.cover,
//                ),
//              ),
//            ),
//            Container(
//              margin: EdgeInsets.only(top: 4, left: 8),
//              child: Text(
//                data[index].title,
//                style: TextStyle(color: black, fontSize: 14.0),
//              ),
//            ),
//          ],
//        );
//      },
//    );
  }
}