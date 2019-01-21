import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
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

  _MyHomePageState() {
    reloadViewPort(); //.then((response) => viewPorts = response);
  }

  Future<void> reloadViewPort() async {
    List<ViewPort> response = new List<ViewPort>();
    String result = await readText();
    response = deSerializeJSON(result);
    setState(() {
      viewPorts = response;
    });
  }

  Future<void> callGetViewPortsAPI() async {
    Response response;
    await http
        .get('https://ocsheetserver.appspot.com/api/values/getviewports')
        .then((p) => response = p);
    return response;
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    // String contents = '[{"id":0,"name":"Background","groups":[{"name":"Basic Info","properties":[{"name":"Name","value":"Test Name","display":"String","editable":true},{"name":"Alias","value":"Test Alias","display":"String","editable":true},{"name":"Look","value":"Test Look","display":"String","editable":true},{"name":"Heritage","value":"Test Heritage","display":"String","editable":true},{"name":"Background","value":"Test Background","display":"String","editable":true},{"name":"Vice","value":"Test Vice","display":"String","editable":true}]}]},{"id":1,"name":"Status","groups":[{"name":"Damage","properties":[{"name":"Stress","value":"0","display":"Number","editable":true},{"name":"Trauma","value":"0","display":"Number","editable":true},{"name":"Harm","value":"0","display":"Number","editable":true}]}]},{"id":2,"name":"Gear","groups":[{"name":"Equipped","properties":[{"name":"Armor","value":"0","display":"Number","editable":true},{"name":"Heavy","value":"0","display":"Number","editable":true},{"name":"Special","value":"0","display":"Number","editable":true}]},{"name":"Money","properties":[{"name":"Cred","value":"0","display":"Number","editable":true},{"name":"Stash","value":"0","display":"Number","editable":true},{"name":"Recovery","value":"0","display":"Number","editable":true}]}]},{"id":3,"name":"Skills","groups":[{"name":"Insight","properties":[{"name":"Doctor","value":"0","display":"Number","editable":true},{"name":"Hack","value":"0","display":"Number","editable":true},{"name":"Rig","value":"0","display":"Number","editable":true},{"name":"Study","value":"0","display":"Number","editable":true}]},{"name":"Prowess","properties":[{"name":"Helm","value":"0","display":"Number","editable":true},{"name":"Scramble","value":"0","display":"Number","editable":true},{"name":"Scrap","value":"0","display":"Number","editable":true},{"name":"Skulk","value":"0","display":"Number","editable":true}]},{"name":"Resolve","properties":[{"name":"Attune","value":"0","display":"Number","editable":true},{"name":"Command","value":"0","display":"Number","editable":true},{"name":"Consort","value":"0","display":"Number","editable":true},{"name":"Sway","value":"0","display":"Number","editable":true}]}]}]';
    final path = await _localPath;
    File defaultFile = File('$path/default.json');
    // bool exists = await defaultFile.exists();
    // if(exists) {
    //   defaultFile.writeAsString(contents);
    // }
    return defaultFile;
  }

  Future<String> readText() async {
  try {
    final file = await _localFile;

    // Read the file
    String contents = await file.readAsString();

    return contents;
  } catch (e) {
    // If we encounter an error, return it.
    return e.toString();
  }
}


  List<ViewPort> deSerializeJSON(String jsonBody) {
    List<ViewPort> result = new List<ViewPort>();
    var y = json.decode(jsonBody) as List<dynamic>;
    for (var i = 0; i < y.length; i++) {
      var view = ViewPort.fromJson(y[i]);
      result.add(view);
    }
    return result;
  }

  Widget getPage(BuildContext context) {
    if (viewPorts.length > 0) {
      return new Container(
          padding: EdgeInsets.all(7.5),
        child: new Navigator(
          onGenerateRoute: (RouteSettings settings) {
            WidgetBuilder builder;
            builder = (context) =>
                new ViewPortWidget(viewPorts: viewPorts, position: _counter);

            return new MaterialPageRoute(builder: builder, settings: settings);
          },
        ),
      );
    } else {
      return new Text("No data found");
    }
  }

  Widget getViewWidget(ViewPort v) {
    return new Row(
      mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: v.groups.map((item) => getGroupWidget(item)).toList());
    //return new Column(children:  <Widget>[new Row(children: <Widget>[new TextFormField()])]);
  }

  Widget getGroupWidget(Group g) {
    return new Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: g.properties
            .map((item) => new PropertyWidget(
                  initialState: item,
                ))
            .toList());
  }

  Widget getOldGroupWidget(Group g) {
    return new Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: g.properties.map((item) => getPropertyWidget(item)).toList());
  }

  Widget getPropertyWidget(Property p) {
    Widget value;
    if (p.editable) {
      var propertyController = new TextEditingController();
      value = new Container(
          child: new TextField(
        decoration: new InputDecoration(),
        controller: propertyController,
      ));
    } else {
      value = new Text(
        p.value,
        textScaleFactor: 2.0,
      );
    }
    return new Row(mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
      new Text(
        p.name,
        textScaleFactor: 2.0,
      ),
      value
    ]);
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
          child: getPage(context)),
    ); // This trailing comma makes auto-formatting nicer for build methods.
  }
}
