import 'package:flutter/material.dart';
import 'pages/AppStateContainer.dart';
import 'pages/english_words.dart';
import 'pages/frameworkoverview/overview1.dart';
import 'pages/frameworkoverview/overview2.dart';
import 'pages/frameworkoverview/overview3.dart';
import 'pages/http_futurebuilder.dart';
import 'pages/websocket_streambuilder.dart';




void main() => runApp(App());

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    print("======app initState");
  }

  @override
  void deactivate() {
    print("======app deactivate");
    super.deactivate();
  }
  @override
  void dispose() {
    print("======app dispose");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("======app.build");
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
  '购物车': new ShoppingList(),
  "网络请求http": new HttpFutureBuilder(),
  "网络请求websocket": new WebSocketStreamBuilder(),
  "InheritedWidget": MyInheritedApp(),
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
    print("======home.initState");
    super.initState();
  }

  @override
  void deactivate() {
    print("======home.deactivate");
    super.deactivate();
  }

  @override
  void dispose() {
    print("======home.dispose");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("======home.build");
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
          _navigateRoute(context, key);
        },
      );
    });

    final dividers = ListTile.divideTiles(
      context: context,
      tiles: tiles
    ).toList();

    return new ListView(children: dividers,);
  }

  _navigateRoute(BuildContext context, String key) async{
    final result = await Navigator.of(context).push(
        new MaterialPageRoute(
            builder: (context) {
              return _pageList[key];
            }
        )
    );
  }
}
