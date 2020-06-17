import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Bloc/HomeBloc.dart';
import 'package:flutter_app/Bloc/bloc_provider.dart';
import 'package:flutter_app/Res/Utils.dart';
import 'package:flutter_app/Res/colors.dart';

class WidgetDailySale extends StatefulWidget {
  @override
  _WidgetDailySaleState createState() => _WidgetDailySaleState();
}

class _WidgetDailySaleState extends State<WidgetDailySale>
    with AutomaticKeepAliveClientMixin {
  HomeBloc homeBloc;

  @override
  void dispose() {
    homeBloc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    homeBloc = BlocProvider.of<HomeBloc>(context);
    homeBloc.getDaily();
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder(
        stream: homeBloc.dailyStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              margin: EdgeInsets.only(top: 16),
              height:
                  (MediaQuery.of(context).size.width / 3.8) + 16 * 2 + 6 * 2,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data.data.products.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(left: 8),
                      width: MediaQuery.of(context).size.width / 3.8,
                      child: Column(
                        children: <Widget>[
                          Card(
                            margin: EdgeInsets.all(0),
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                child: CachedNetworkImage(
                                  imageUrl: snapshot.data.data.products[index].image,
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 6),
                            height: 16,
                            child: Text(
                              Utils.formatNumber(100000),
                              style: TextStyle(color: red, fontSize: 12.0),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 6),
                            height: 16,
                            child: Text(
                              Utils.formatNumber(100000),
                              style: TextStyle(color: red, fontSize: 12.0),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            );
          } else {
            return Container();
          }
        });
  }


}
