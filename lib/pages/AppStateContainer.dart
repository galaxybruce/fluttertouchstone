

/// date: 2019-07-23 14:28
/// author: bruce.zhang
/// description: (亲，我是做什么的)
///
/// https://cloud.tencent.com/developer/article/1198733
///
/// modification history:

import 'package:flutter/material.dart';

class AppState {
  bool isLoading;

  ValueNotifier<bool> canListenLoading = ValueNotifier(false);

  AppState({this.isLoading = true});

  factory AppState.loading() => AppState(isLoading: true);

  @override
  String toString() {
    return 'AppState{isLoading: $isLoading}';
  }
}


//1. 模仿MediaQuery。简单的让这个持有我们想要保存的data
class _InheritedStateContainer extends InheritedWidget {
  final AppState data;

  //我们知道InheritedWidget总是包裹的一层，所以它必有child
  _InheritedStateContainer(
      {Key key, @required this.data, @required Widget child})
      : super(key: key, child: child);

  //参考MediaQuery,这个方法通常都是这样实现的。如果新的值和旧的值不相等，就需要notify
  @override
  bool updateShouldNotify(_InheritedStateContainer oldWidget) {
    print("=======updateShouldNotify: ${data != oldWidget.data}");

    return data != oldWidget.data;
  }
}

/*
1. 从MediaQuery模仿的套路，我们知道，我们需要一个StatefulWidget作为外层的组件，
将我们的继承于InheritateWidget的组件build出去
*/
class AppStateContainer extends StatefulWidget {
  //这个state是我们需要的状态
  final AppState state;

  //这个child的是必须的，来显示我们正常的控件
  final Widget child;

  AppStateContainer({this.state, @required this.child});

  //4.模仿MediaQuery,提供一个of方法，来得到我们的State.
  static AppState of(BuildContext context) {
    //这个方法内，调用 context.inheritFromWidgetOfExactType
    return (context.inheritFromWidgetOfExactType(_InheritedStateContainer)
    as _InheritedStateContainer)
        .data;
  }

  @override
  _AppStateContainerState createState() => _AppStateContainerState();
}

class _AppStateContainerState extends State<AppStateContainer> {

  //2. 在build方法内返回我们的InheritedWidget
  //这样App的层级就是 AppStateContainer->_InheritedStateContainer-> real app
  @override
  Widget build(BuildContext context) {
    print("=======_AppStateContainerState.build");

    return _InheritedStateContainer(
      data: widget.state,
      child: widget.child,
    );
  }
}

class MyInheritedApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    print("=======MyInheritedApp.build");
    //因为是AppState，所以他的范围是全生命周期的，所以可以直接包裹在最外层
    return AppStateContainer(
      //初始化一个loading
      state: AppState.loading(),
      child: new MaterialApp(
        title: 'Flutter Demo',
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: new MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget{

  final String title;

  MyHomePage({this.title});

  @override
  State<StatefulWidget> createState() {
    return _MyHomePageState();
  }
}


class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState();

  AppState appState;

  //添加成员变量。 result参数和 listener回调
  String result = "";
  VoidCallback listener;

  @override
  void dispose() {
    print('dispose');
    if (appState != null) {
      //在这里移除监听事件
      appState.canListenLoading.removeListener(listener);
    }
    super.dispose();
  }

  @override
  void initState() {
    print('initState');
    //初始化监听的回调。回调用作的就是延迟5s后，将result修改成 "From delay"
    listener = () {
      print("=======call listener");
      Future.delayed(Duration(seconds: 5)).then((value) {
        result = "From delay";
        setState(() {});
      });
    };
    super.initState();
  }

  //在didChangeDependencies方法中，就可以查到对应的state了
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('didChangeDependencies');
    if(appState==null){
      appState= AppStateContainer.of(context);
    }

    //在这里添加监听事件
    appState.canListenLoading.addListener(listener);
  }

  @override
  Widget build(BuildContext context) {
    print("=======_MyHomePageState.build");

    return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
        ),
        body: new Center(
          //根据isLoading来判断，显示一个loading，或者是正常的图
          child: appState.isLoading
              ? CircularProgressIndicator()
              : new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text(
                'appState.isLoading = ${appState.isLoading}',
              ),//新增，result的显示在屏幕上
              new Text(
                '$result',
              ),
            ],
          ),
        ),
        floatingActionButton: new Builder(builder: (context) {
          return new FloatingActionButton(
            onPressed: () {
              //点击按钮进行切换
              //因为是全局的状态，在其他页面改变，也会导致这里发生变化
//              appState.isLoading = !appState.isLoading;
//              //setState触发页面刷新
//              setState(() {});


              //push出一个先的页面
              Navigator.of(context).push(
                  new MaterialPageRoute<Null>(builder: (BuildContext context) {
                    return SecondPage(
                        title: 'Second State Change Page');
                  }));
            },
            tooltip: 'Increment',
            child: new Icon(Icons.swap_horiz),
          );
        }));
  }
}


class SecondPage extends StatefulWidget {
  SecondPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  SecondPageState createState() => new SecondPageState();
}

class SecondPageState extends State<SecondPage> {

  void _changeState() {
    setState(() {
      state.isLoading = !state.isLoading;
      state.canListenLoading.value = true;
    });
  }

  AppState state;

  @override
  void didChangeDependencies() {
    print('SecondPageState.didChangeDependencies');
    super.didChangeDependencies();
    if(state ==null){
      state = AppStateContainer.of(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    print("=======SecondPageState.build");

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              'appState.isLoading = ${state.isLoading}',
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _changeState,
        tooltip: 'ChangeState',
        child: new Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}