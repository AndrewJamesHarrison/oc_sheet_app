import 'package:flutter/material.dart';
import 'package:oc_sheet_app/Models.dart';
import 'package:oc_sheet_app/PropertyWidget.dart';

class ViewPortWidget extends StatefulWidget {
  final List<ViewPort> viewPorts;
  final int position;
  ViewPortWidget({Key key, @required this.viewPorts, this.position}) : super(key: key);

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

    if((widget.position+1) < widget.viewPorts.length) {
      nextPosition = currentPosition + 1;
    }else{
      nextPosition = 0;
    }


  }

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
    new Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget> [
          new FlatButton.icon(onPressed: () => Navigator.of(context).pop(), icon: new Icon(Icons.arrow_back_ios), label: new Text("")),
          new FlatButton.icon(onPressed: () => Navigator.of(context).push(new MaterialPageRoute(builder: (context) => new ViewPortWidget(viewPorts: _viewPorts, position: nextPosition,))), icon: new Icon(Icons.arrow_forward_ios), label: new Text("")),
        ]),
    getViewWidget(_viewPortState)
    ],
    );
  }
}


  Widget getViewWidget(ViewPort v)
    {
      return new Row(
        mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: v.groups.map((item) => getGroupWidget(item)).toList()
      );
    }

    Widget getGroupWidget(Group g)
    {
      return new Column(children: g.properties.map((item) => new PropertyWidget(initialState: item,)).toList());
    }