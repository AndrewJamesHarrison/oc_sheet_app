import 'package:flutter/material.dart';
import 'package:oc_sheet_app/Models.dart';
import 'package:oc_sheet_app/PropertyWidget.dart';

class ViewPortWidget extends StatefulWidget {
  final List<ViewPort> viewPorts;
  final int position;
  ViewPortWidget({Key key, @required this.viewPorts, this.position})
      : super(key: key);

  @override
  _ViewPortWidgetState createState() => new _ViewPortWidgetState();
}

class _ViewPortWidgetState extends State<ViewPortWidget> {
  ViewPort _viewPortState;

  List<ViewPort> _viewPorts;
  int currentPosition;
  int nextPosition;

  @override
  void initState() {
    super.initState();
    currentPosition = widget.position;
    _viewPorts = widget.viewPorts;

    _viewPortState = widget.viewPorts[widget.position];

    if ((widget.position + 1) < widget.viewPorts.length) {
      nextPosition = currentPosition + 1;
    } else {
      nextPosition = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              new FlatButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: new Icon(Icons.arrow_back_ios),
                  label: new Text("")),
              new FlatButton.icon(
                  onPressed: () =>
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (context) => new ViewPortWidget(
                                viewPorts: _viewPorts,
                                position: nextPosition,
                              ))),
                  icon: new Icon(Icons.arrow_forward_ios),
                  label: new Text("")),
            ]),
        getViewWidget(_viewPortState)
      ],
    );
  }
}

Widget getViewWidget(ViewPort v) {
  return new Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: v.groups.map((item) => getGroupWidget(item)).toList());
}

Widget getGroupWidget(Group g) {
  List<Widget> test = new List<Widget>();
  if (g.properties != null) {
    test.addAll(g.properties
        .map((item) => new PropertyWidget(
              initialState: item,
            ))
        .toList());
  }
  if (g.subGroups != null) {
    test.addAll(g.subGroups.map((item) => getGroupWidgetTest(item)).toList());
  }
  return Expanded(
      child: new Container(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(width: 1.0, color: Color(0xFFFF000000)),
              left: BorderSide(width: 1.0, color: Color(0xFFFF000000)),
              right: BorderSide(width: 1.0, color: Color(0xFFFF000000)),
              bottom: BorderSide(width: 1.0, color: Color(0xFFFF000000)),
            ),
          ),
          child: getGroupWidgetTest(g)));
  // return Expanded(
  //     flex: 1,
  //     child: new Container(
  //         decoration: const BoxDecoration(
  //           border: Border(
  //             top: BorderSide(width: 1.0, color: Color(0xFFFF000000)),
  //             left: BorderSide(width: 1.0, color: Color(0xFFFF000000)),
  //             right: BorderSide(width: 1.0, color: Color(0xFFFF000000)),
  //             bottom: BorderSide(width: 1.0, color: Color(0xFFFF000000)),
  //           ),
  //         ),
  //         child: new Column(
  //             crossAxisAlignment: CrossAxisAlignment.start, children: test)));
}

Widget getGroupWidgetTest(Group g) {
  List<Widget> test = new List<Widget>();
  if (g.properties != null) {
    test.addAll(g.properties
        .map((item) => new PropertyWidget(
              initialState: item,
            ))
        .toList());
  }
  if (g.subGroups != null) {
    test.addAll(g.subGroups.map((item) => getGroupWidget(item)).toList());
  }
  return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(width: 1.0, color: Color(0xFFFF000000)),
          left: BorderSide(width: 1.0, color: Color(0xFFFF000000)),
          right: BorderSide(width: 1.0, color: Color(0xFFFF000000)),
          bottom: BorderSide(width: 1.0, color: Color(0xFFFF000000)),
        ),
      ),
      child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: test));
}
