import 'package:flutter/material.dart';
import 'light_color.dart';

class TitleText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  const TitleText(
      {Key key,
        this.text,
        this.fontSize = 18,
        this.color = LightColor.navyBlue2})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(text,
       style:TextStyle(
         color: color
       ),
        );
  }
}