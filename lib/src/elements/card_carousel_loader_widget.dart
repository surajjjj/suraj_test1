
import 'package:flutter/material.dart';

class CardCarouselLoaderWidget extends StatelessWidget {
  const CardCarouselLoaderWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 210,
        color: Theme.of(context).primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: ListView.builder(
          itemCount: 3,
          itemBuilder: (context, index) {
            double marginLeft = 0;
            (index == 0) ? marginLeft = 20 : marginLeft = 0;
            return Container(
              margin: EdgeInsetsDirectional.only(start: marginLeft, end: 20),
              width: 180,
              height: 130,
              child: Image.asset('assets/img/loading_card.gif', fit: BoxFit.contain),
            );
          },
          scrollDirection: Axis.horizontal,
        ));
  }
}
