import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Model/WidgetHome.dart';
import 'package:flutter_app/Res/Utils.dart';
import 'package:flutter_app/Res/colors.dart';
import 'package:flutter_app/Res/dimen.dart';
import 'package:page_indicator/page_indicator.dart';

class WidgetBanner extends StatefulWidget {
  final WidgetHome widget;

  WidgetBanner({Key key, this.widget}) : super(key: key);

  @override
  _WidgetBannerState createState() => _WidgetBannerState();
}

class _WidgetBannerState extends State<WidgetBanner> {
  double index = 0;
  double indexController = 0;
  PageController controller = PageController();

  @override
  void initState() {
    controller.addListener(() {
      setState(() {
        if (controller.page >= index) {
          indexController = controller.page - index;
        } else {
          indexController = controller.page + 1 - index;
          index = index - 1;
        }

        if (indexController % 1 == 0) {
          index = controller.page;
        }
        if (indexController >= 1) {
          indexController = (indexController - index);
        }
        if (indexController >= 1) {
          indexController = 1;
        }
        if (indexController < 0) {
          indexController = 0;
        }
        indexController = indexController.abs();
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    var heightPageView = (mediaQueryData.size.width * 305 / 750 +
        mediaQueryData.padding.top +
        heightNavigation);

    return Container(
      height: heightPageView * 1.05,
      decoration: BoxDecoration(
          color: Utils.blendColors(
              Utils.getColorFromHex(widget
                  .widget.data.homeModelItems[index.toInt()].backgroundColor),
              Utils.getColorFromHex(widget.widget.data
                  .homeModelItems[index.toInt() + 1].backgroundColor),
              indexController)),
      child: Stack(
        children: <Widget>[
          Image.asset("assets/icons/ic_bg_home_banner.png",
              width: double.infinity,
              fit: BoxFit.fill,
              height: heightPageView * 0.85),
          Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset("assets/icons/ic_bg_banner_color.png",
                width: double.infinity,
                height: (mediaQueryData.size.width * 305 / 750) * 0.8,
                fit: BoxFit.fill),
          ),
          Container(
            child: Column(
              children: <Widget>[
                SizedBox(height: mediaQueryData.padding.top + heightNavigation),
                AspectRatio(
                  aspectRatio: 750 / 305,
                  child: Container(
                    margin: EdgeInsets.only(top: 8),
                    child: PageIndicatorContainer(
                        child: PageView.builder(
                          controller: controller,
                          itemBuilder: (context, position) {
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 12),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: widget.widget.data
                                      .homeModelItems[position].image,
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                              ),
                            );
                          },
                          itemCount: widget.widget.data.homeModelItems.length,
                        ),
                        align: IndicatorAlign.bottom,
                        length: widget.widget.data.homeModelItems.length,
                        indicatorSelectorColor: red,
                        shape: IndicatorShape.circle(size: 8),
                        indicatorSpace: 6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
