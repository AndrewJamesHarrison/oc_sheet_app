import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EmptyStateContainer extends StatefulWidget {
  final void Function() addAction;
  final void Function() removeAction;

  const EmptyStateContainer({Key key, this.addAction, this.removeAction})
      : super(key: key);

  @override
  EmptyStateContainerState createState() => EmptyStateContainerState();
}

class EmptyStateContainerState extends State<EmptyStateContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.yellow,
        child: GestureDetector(
            child: Text('Tap to add widget, longpress to remove'),
            onTap: () => widget.addAction(),
            onLongPress: () => widget.removeAction()));
  }
}
