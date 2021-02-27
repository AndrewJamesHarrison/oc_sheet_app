import 'package:flutter/widgets.dart';
import 'package:test_app/widgets/layoutContainerWidget/emptyStateContainer.dart';

class LayoutContainer extends StatefulWidget {
  LayoutContainer({Key key}) : super(key: key);

  @override
  LayoutContainerState createState() => LayoutContainerState();
}

class LayoutContainerState extends State<LayoutContainer> {
  addElement() {
    setState(() {
      if (childContainers.length < 2)
        childContainers.insert(
            0, Expanded(flex: 1, child: new LayoutContainer()));
    });
  }

  removeElement() {
    setState(() {
      childContainers.clear();
      initChildContainers();
    });
  }

  initChildContainers() {
    childContainers.add(Expanded(
        flex: 1,
        child: EmptyStateContainer(
          addAction: addElement,
          removeAction: removeElement,
        )));
  }

  List<Widget> childContainers = [];

  @override
  Widget build(BuildContext context) {
    if (childContainers.isEmpty) {
      initChildContainers();
    }
    return Column(
      children: childContainers,
    );
  }
}
