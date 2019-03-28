import 'package:flutter/material.dart';
import 'pages/englishWords.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Touch Stone',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(title: 'Flutter Touch Stone Home Page'),
    );
  }
}

var _pageList = <String, Widget>{'english_words': new RandomWords()};

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _biggerFont = const TextStyle(fontSize: 18.0);

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
