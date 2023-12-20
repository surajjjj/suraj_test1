import 'package:flutter/material.dart';

class CategoryLoaderWidget extends StatelessWidget {
  const CategoryLoaderWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 100,
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: ListView.builder(
          itemCount: 4,
          itemBuilder: (context, index) {
            double marginLeft = 0;
            (index == 0) ? marginLeft = 20 : marginLeft = 0;
            return Container(
              margin: EdgeInsetsDirectional.only(start: marginLeft, end: 20),
              width: 100,
              height: 130,
              child: Image.asset('assets/img/loading_circle.png', fit: BoxFit.contain),
            );
          },
          scrollDirection: Axis.horizontal,
        ));
  }
}
