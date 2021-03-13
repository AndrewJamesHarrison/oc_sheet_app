import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:test_app/models/LayoutDirection.dart';
import 'package:test_app/widgets/layoutContainerWidget/emptyStateContainer.dart';

class LayoutContainer extends StatefulWidget {
  LayoutContainer({Key key}) : super(key: key);

  @override
  LayoutContainerState createState() => LayoutContainerState();
}

class LayoutContainerState extends State<LayoutContainer> {
  LayoutDirection layoutDirection;
  addElement(LayoutDirection direction) {
    setState(() {
      layoutDirection = direction;
    });
  }

  removeElement() {
    log('removing element with children: ', error: childContainers);
    setState(() {
      layoutDirection = LayoutDirection.none;
    });
  }

  List<Widget> childContainers = [
    Expanded(flex: 1, child: new LayoutContainer()),
    Expanded(flex: 1, child: new LayoutContainer())
  ];

  @override
  Widget build(BuildContext context) {
    // if (layoutDirection == LayoutDirection.vertical) {
    //   return Row(
    //     children: childContainers,
    //   );
    // } else if (layoutDirection == LayoutDirection.horizontal)
    //   return Column(
    //     children: childContainers,
    //   );
    // else {
    return gestureDetector(getChildWidget());
  }

  Widget gestureDetector(Widget childWidget) {
    return Expanded(
        flex: 1,
        child: GestureDetector(
            child: childWidget,
            behavior: HitTestBehavior.opaque,
            onHorizontalDragEnd: (val) =>
                addElement(LayoutDirection.horizontal),
            onVerticalDragEnd: (val) => addElement(LayoutDirection.vertical),
            onLongPress: () => removeElement()));
  }

  Widget getChildWidget() {
    switch (layoutDirection) {
      case LayoutDirection.vertical:
        return Row(
          children: childContainers,
        );
        break;
      case LayoutDirection.horizontal:
        return Column(
          children: childContainers,
        );
        break;
      case LayoutDirection.none:
        return Expanded(
            flex: 1,
            child: GestureDetector(
                child: EmptyStateContainer(),
                behavior: HitTestBehavior.opaque,
                onHorizontalDragEnd: (val) =>
                    addElement(LayoutDirection.horizontal),
                onVerticalDragEnd: (val) =>
                    addElement(LayoutDirection.vertical)));
        break;
    }
    return gestureDetector(EmptyStateContainer());
  }
}
