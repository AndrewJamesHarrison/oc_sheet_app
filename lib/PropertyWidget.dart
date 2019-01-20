import 'package:flutter/material.dart';
import 'package:oc_sheet_app/Models.dart';

class PropertyWidget extends StatefulWidget {
  final Property initialState;
  PropertyWidget({Key key, @required this.initialState}) : super(key: key);

  @override
  _PropertyWidgetState createState() => new _PropertyWidgetState();
}

class _PropertyWidgetState extends State<PropertyWidget> {
  final propertyController = TextEditingController();
  Property _propertyState;
  TextInputType inputType;

  @override
  void initState() {
    super.initState();
    _propertyState = widget.initialState;
    // Start listening to changes
    propertyController.addListener(_setProperty);
    propertyController.text = _propertyState.value;
    print(_propertyState.display);
    switch (_propertyState.display) {
      case ("Number"):
        inputType = TextInputType.number;
        break;
      case ("String"):
        inputType = TextInputType.text;
        break;
    }
  }

  @override
  void dispose() {
    // Stop listening to text changes
    propertyController.removeListener(_setProperty);

    // Clean up the controller when the Widget is removed from the Widget tree
    propertyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget value;
    if (_propertyState.editable) {
      value = new Container(
          child: new TextField(
            decoration: new InputDecoration(),
            controller: propertyController,
            keyboardType: inputType,
            textDirection: TextDirection.ltr,
          ),
        width: 150,
          );
    } else {
      value = new Text(
        _propertyState.value,
        textScaleFactor: 2.0,
      );
    }
    return new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
            new Text(
              _propertyState.name,
              textScaleFactor: 1,
            ),
          value
        ]);
  }

  void _setProperty() {
    setState(() {
      _propertyState.value = propertyController.text;
    });
  }
}
