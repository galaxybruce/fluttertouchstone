import 'package:flutter/material.dart';
import 'pages/english_words.dart';
import 'pages/frameworkoverview/overview1.dart';
import 'pages/frameworkoverview/overview2.dart';
import 'pages/frameworkoverview/overview3.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Touch Stone',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.blue[500]
      ),
      home: HomePage(title: 'Flutter Touch Stone Home Page'),
    );
  }
}

var _pageList = <String, Widget> {
  'english_words': new RandomWords(),
  'framework_overview1': new FrameworkOverview1(),
  'framework_overview2': new FrameworkOverview2(),
  '购物车': new ShoppingList()
  };

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: _buildPageListView());
  }

  // 构建ListView
  Widget _buildPageListView() {
    final tiles = _pageList.keys.map((key) {
      return new ListTile(
        title: new Text(
          key,
          style: _biggerFont,
        ),
        onTap: () {
          Navigator.of(context).push(
            new MaterialPageRoute(
              builder: (context) {
                return _pageList[key];
              }
            )
          );
        },
      );
    });

    final dividers = ListTile.divideTiles(
      context: context,
      tiles: tiles
    ).toList();

    return new ListView(children: dividers,);
  }
}
