import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:page_indicator/page_indicator.dart';

import 'Bloc/CateBloc.dart';
import 'Bloc/bloc_provider.dart';
import 'Model/BaseCate.dart';
import 'Res/colors.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  CateBloc cateBloc;
  PageController controller;

  @override
  void initState() {
    super.initState();
    cateBloc = BlocProvider.of<CateBloc>(context);
    cateBloc.getCate();
    controller = new PageController(
      initialPage: 0,
      keepPage: false,
      viewportFraction: 0.94,
    );
  }

  @override
  void dispose() {
    super.dispose();
    cateBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: white,
        child: CustomScrollView(slivers: <Widget>[
          SliverAppBar(
            title: Text('Tất cả danh mục'),
            pinned: true,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xffA61A19), Color(0xffEE2624)]),
              ),
            ),
            centerTitle: true,
          ),
          StreamBuilder(
            stream: cateBloc.cateStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    if (index == 0) {
                      return banner(snapshot.data.data[index]);
                    } else {
                      return gridView(
                        snapshot.data.data
                            .getRange(1, snapshot.data.data.length)
                            .toList(),
                      );
                    }
                  }, childCount: 2),
                );
              }
              return SliverToBoxAdapter(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  color: white,
                  child: new Center(
                    child: new CircularProgressIndicator(),
                  ),
                ),
              );
            },
          ),
        ]),
      ),
    );
  }

  Widget banner(BaseCate baseCate) {
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
                      imageUrl: baseCate.bannerList[position].image,
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                );
              },
              controller: controller,
              itemCount: baseCate.bannerList.length,
            ),
            align: IndicatorAlign.bottom,
            length: baseCate.bannerList.length,
            indicatorSelectorColor: red,
            shape: IndicatorShape.circle(size: 8),
            indicatorSpace: 6),
      ),
    );
  }

  Widget gridView(List<BaseCate> data) {
    return GridView.builder(
      padding: EdgeInsets.all(16),
      itemCount: data.length,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: (MediaQuery.of(context).size.height) * 0.00153),
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
                  imageUrl: data[index].image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 4, left: 8),
              child: Text(
                data[index].title,
                style: TextStyle(color: black, fontSize: 14.0),
              ),
            ),
          ],
        );
      },
    );
  }
}
