import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EmptyStateContainer extends StatefulWidget {
  const EmptyStateContainer({Key key}) : super(key: key);

  @override
  EmptyStateContainerState createState() => EmptyStateContainerState();
}

class EmptyStateContainerState extends State<EmptyStateContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.yellow,
        child: Text('Swipe to add widget, longpress to remove'));
  }
}
