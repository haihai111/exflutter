import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:page_indicator/page_indicator.dart';

import 'Bloc/CateBloc.dart';
import 'Bloc/bloc_provider.dart';
import 'Res/colors.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  CateBloc cateBloc;

  @override
  void initState() {
    super.initState();
    cateBloc = BlocProvider.of<CateBloc>(context);
    cateBloc.getCate();
  }

  @override
  void dispose() {
    super.dispose();
    cateBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: white,
      child: CustomScrollView(slivers: <Widget>[
        SliverAppBar(
          title: Text('SliverAppBar'),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Color(0xffA61A19),
                Color(0xffEE2624)
              ]),
            ),
          ),
          centerTitle: true,
        ),
        StreamBuilder(
          stream: cateBloc.cateStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var cateItem = snapshot.data.data[0];
              return SliverToBoxAdapter(
                child: AspectRatio(
                  aspectRatio: 750 / 422,
                  child: Container(
                    margin: EdgeInsets.only(top: 8),
                    child: PageIndicatorContainer(
                        child: PageView.builder(
                          itemBuilder: (context, position) {
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 12),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: cateItem.bannerList[position].image,
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                              ),
                            );
                          },
                          itemCount: cateItem.bannerList.length,
                        ),
                        align: IndicatorAlign.bottom,
                        length: cateItem.bannerList.length,
                        indicatorSelectorColor: red,
                        shape: IndicatorShape.circle(size: 8),
                        indicatorSpace: 6),
                  ),
                ),
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
    );
  }
}
