import 'package:flutter/material.dart';
import 'package:flutter_app/Home/WidgetBanner.dart';
import 'package:flutter_app/Home/WidgetDailySale.dart';

import 'Bloc/HomeBloc.dart';
import 'Bloc/bloc_provider.dart';
import 'Home/WidgetBannerEvent.dart';
import 'Home/WidgetFlashsale.dart';
import 'Home/WidgetShortcut.dart';

class Home extends StatefulWidget {
  final ScrollController scrollController;

  Home({Key key, this.scrollController}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  HomeBloc homeBloc;

  @override
  void dispose() {
    homeBloc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    homeBloc = BlocProvider.of<HomeBloc>(context);
    homeBloc.getHome();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: widget.scrollController,
      slivers: <Widget>[
        StreamBuilder(
            stream: homeBloc.homeStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    switch (snapshot.data[index].type) {
                      case "SlideWidget":
                        {
                          return WidgetBanner(
                            widget: snapshot.data[index],
                          );
                        }
                      case "ShortcutWidget":
                        {
                          return WidgetShortcut(
                            widget: snapshot.data[index],
                          );
                        }
                      case "BannerEventWidget":
                        {
                          return WidgetBannetEvent(
                            widget: snapshot.data[index],
                          );
                        }
                      case "FlashDealWidget":
                        {
                          return WidgetFlashSale(
                            widget: snapshot.data[index],
                          );
                        }
                      case "DailyDealsWidget":
                        {
                          return WidgetDailySale();
                        }
                      default:
                        {
                          return Container(height: 200);
                        }
                    }
                  }, childCount: snapshot.data.length),
                );
              }
              return SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Stack(children: <Widget>[
                      Center(child: CircularProgressIndicator())
                    ],)
                  ],
                ),
              );
            }),
      ],
    );
  }
}
