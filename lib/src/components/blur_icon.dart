import 'dart:ui';

import 'package:flutter/material.dart';


class BlurIcon extends StatelessWidget {
  final double width;
  final double height;
  final EdgeInsets padding;
  final Icon icon;

  const BlurIcon({Key key, this.width = 32, this.height = 32, this.icon, this.padding}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(0),
          child: Container(
            width: width,
            height: height,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0x19000000),
            ),
            child: Center(child: icon),
          ),
        ),
      ),
    );
  }
}
