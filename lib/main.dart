import 'package:flutter/material.dart';
import 'package:oc_sheet_app/Models.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Open Character Sheet'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  List<ViewPort> viewPorts = new List<ViewPort>();
  String test = "false";

  _MyHomePageState(){
    reloadViewPort();//.then((response) => viewPorts = response);
  }

  Future<void> reloadViewPort() async {
    List<ViewPort> response = new List<ViewPort>();
    await http.get('https://ocsheetserver.appspot.com/api/values/getviewports').then((p) {
      var x = json.decode(p.body) as Map<String, dynamic>;
      var y = x["viewPorts"];
      for (var i = 0; i < y.length; i++) {
        var view = ViewPort.fromJson(y[i]);
        response.add(view);
      }
    });
    setState(() {
      viewPorts = response;
    });
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      if(viewPorts.length > (_counter+1))
        _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      if(_counter > 0)
        _counter--;
    });
  }

  Widget getPage(List<ViewPort> viewPorts, int counter){
    if(viewPorts.length > 0){
      return getViewWidget(viewPorts[counter]);
    }else{
      return new Text("No data found");
    }
  }

  Widget getViewWidget(ViewPort v)
  {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
        children: v.groups.map((item) => getGroupWidget(item)).toList()
    );
    //return new Column(children:  <Widget>[new Row(children: <Widget>[new TextFormField()])]);
  }

  Widget getGroupWidget(Group g)
  {
    return new Column(children: g.properties.map((item) => getPropertyWidget(item)).toList());
  }

  Widget getPropertyWidget(Property p)
  {
    Widget value;
    if(!p.editable) {
      value = new TextField(decoration: new InputDecoration(),  );
    }else{
      value =
          new Text(p.value, textScaleFactor: 2.0,);
    }
    return new Row(
        children:
        <Widget>[
          new Text(p.name,
            textScaleFactor: 2.0,
          ),
          value
        ]
    );
  }

  @override
  Widget build(BuildContext context) {

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text(widget.title),
      ),
      body: new Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: new Column(
          // Column is also layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug paint" (press "p" in the console where you ran
          // "flutter run", or select "Toggle Debug Paint" from the Flutter tool
          // window in IntelliJ) to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          crossAxisAlignment: CrossAxisAlignment.center,
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                new FlatButton.icon(onPressed: _decrementCounter, icon: new Icon(Icons.arrow_back_ios), label: new Text("")),
                new FlatButton.icon(onPressed: _incrementCounter, icon: new Icon(Icons.arrow_forward_ios), label: new Text("")),
              ],
            ),
            getPage(viewPorts, _counter)
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
