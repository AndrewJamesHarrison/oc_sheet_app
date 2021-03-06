import 'package:flutter/material.dart';
import 'package:oc_sheet_app/Models.dart';
import 'package:oc_sheet_app/PropertyWidget.dart';
import 'package:oc_sheet_app/ViewPortWidget.dart';
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
  ViewPort current;
  ViewPort next;

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
      if(viewPorts.length > 0){
        current = viewPorts[0];
      }
      if(viewPorts.length > 1){
        next = viewPorts[1];
      }
    });
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      if(viewPorts.length > (_counter+1)){
        _counter++;
        current = viewPorts[_counter];
        if(_counter < viewPorts.length-1){
          next = viewPorts[_counter+1];
        }
      }

    });
  }

  void _decrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      if(_counter > 0) {
        _counter--;
        current = viewPorts[_counter];
        if(_counter < viewPorts.length-1){
          next = viewPorts[_counter+1];
        }else{
          next = viewPorts[0];
        }
      }
    });
  }

  Widget getPage(BuildContext context){
    if(viewPorts.length > 0){
      return  new Container(width:600.00, height:800.0,child: new Navigator(
        onGenerateRoute: (RouteSettings settings) {
          WidgetBuilder builder;
          builder = (context) => new ViewPortWidget(viewPorts: viewPorts, position: _counter);

          return new MaterialPageRoute(builder: builder, settings: settings);
        },
      ),
      );

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
    return new Column(children: g.properties.map((item) => new PropertyWidget(initialState: item,)).toList());
  }

  Widget getOldGroupWidget(Group g)
  {
    return new Column(children: g.properties.map((item) => getPropertyWidget(item)).toList());
  }

  Widget getPropertyWidget(Property p)
  {
    Widget value;
    if(p.editable) {
      var propertyController = new TextEditingController();
      value = new Container(child : new TextField(decoration: new InputDecoration(), controller: propertyController, ));
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
        child:getPage(context)
        ),
        );// This trailing comma makes auto-formatting nicer for build methods.

  }
}
