import 'package:flutter/material.dart';


class DotContainer extends StatefulWidget {
  const DotContainer({Key key}) : super(key: key);

  @override
  State<DotContainer> createState() => _DotContainerState();
}

class _DotContainerState extends State<DotContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top:6),
      height:6,width: 6,
      decoration: BoxDecoration(
          color: Theme.of(context).disabledColor,
          shape: BoxShape.circle
      ),
    );
  }
}
