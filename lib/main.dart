import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/Home.dart';
import 'package:flutter_app/Res/colors.dart';

import 'Bloc/HomeBloc.dart';
import 'Bloc/bloc_provider.dart';
import 'NavigationToolBar.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  ScrollController scrollController;
  List<Widget> _widgetOptions;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  @override
  void initState() {
    scrollController = ScrollController();
    _widgetOptions = <Widget>[
      BlocProvider<HomeBloc>(
        bloc: HomeBloc(),
        child: Home(
          scrollController: scrollController,
        ),
      ),
      Text(
        'Index 1: Business',
        style: optionStyle,
      ),
      Text(
        'Index 2: School',
        style: optionStyle,
      ),
      Text(
        'Index 3: School',
        style: optionStyle,
      ),
      Text(
        'Index 4: School',
        style: optionStyle,
      ),
    ];
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: background,
      body: Stack(
        children: <Widget>[
          _widgetOptions.elementAt(_selectedIndex),
          NavigationToolBar(scrollController: scrollController,),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Trang chủ'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_mall),
            title: Text('Senmall'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            title: Text('Chat'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            title: Text('Thông báo'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            title: Text('Tài khoản'),
          ),
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        fixedColor: red,
        unselectedFontSize: 12,
        selectedFontSize: 12,
        onTap: _onItemTapped,
      ),
    );
  }
}
