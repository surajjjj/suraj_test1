import 'package:flutter/material.dart';

class CardsCarouselLoaderWidget extends StatelessWidget {
  const CardsCarouselLoaderWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return SizedBox(
      height: 288,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, index) {
          return Container(
            width: size.width * 0.8,
            margin: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 20),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.1), blurRadius: 15, offset: const Offset(0, 5)),
              ],
            ),
            child: Image.asset(
              'assets/img/loading_card.gif',
              fit: BoxFit.fitWidth,
              width: size.width * 0.8,
            ),
          );
        },
      ),
    );
  }
}
