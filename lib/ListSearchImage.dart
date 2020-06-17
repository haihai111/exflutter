import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'Bloc/HomeBloc.dart';
import 'Bloc/bloc_provider.dart';
import 'Res/colors.dart';

class ListSearchImage extends StatefulWidget {
  final List productId;

  ListSearchImage({Key key, @required this.productId}) : super(key: key);

  @override
  _ListSearchImageState createState() => _ListSearchImageState();
}

class _ListSearchImageState extends State<ListSearchImage> {
  HomeBloc homeBloc;

  @override
  void dispose() {
    homeBloc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    homeBloc = BlocProvider.of<HomeBloc>(context);
    homeBloc.getListImageSearch(widget.productId.join(','));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("SearchImage")),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Stack(
      children: <Widget>[
        StreamBuilder(
          stream: homeBloc.imageSearchStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Container(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: snapshot.data.data.length,
                  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                      childAspectRatio:
                          (MediaQuery.of(context).size.height) * 0.00073),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      margin: EdgeInsets.all(0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      child: Column(
                        children: <Widget>[
                          AspectRatio(
                            aspectRatio: 1,
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              child: CachedNetworkImage(
                                imageUrl: snapshot.data.data[index].imageUrl,
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 6, left: 8, right: 8),
                            child: Text(
                              snapshot.data.data[index].name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: black, fontSize: 16.0),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            margin: EdgeInsets.only(top: 6, left: 8, right: 8),
                            child: Text(
                              snapshot.data.data[index].finalPrice,
                              style: TextStyle(
                                  color: black,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            margin: EdgeInsets.only(top: 6, left: 8, right: 8),
                            child: Text(
                              snapshot.data.data[index].price,
                              style: TextStyle(
                                  color: gray,
                                  fontSize: 11.0,
                                  decoration: TextDecoration.lineThrough),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            } else {
              return Container(
                height: MediaQuery.of(context).size.height,
                color: white,
                child: new Center(
                  child: new CircularProgressIndicator(),
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
