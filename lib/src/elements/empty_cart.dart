import 'package:flutter/material.dart';
import '../../generated/l10n.dart';
import 'lottie_animation_widget.dart';

class EmptyList extends StatefulWidget {
  const EmptyList({Key key}) : super(key: key);

  @override
  State<EmptyList> createState() => _EmptyListState();
}

class _EmptyListState extends State<EmptyList> {
  int dropDownValue = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading:  Container(
            margin: const EdgeInsets.only(left: 10),
            height: 35,
            width: 35,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black.withOpacity(0.7),
            ),
            child: Container(
                padding: const EdgeInsets.only(left: 4),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(Icons.arrow_back_ios,
                      color:
                      Theme.of(context).colorScheme.primary,
                      size: 18),
                ))),
      ),
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child:SizedBox(
        height:150,width:200,
        child:LottieAnimationWidget(jsonData: 'assets/img/cooking.json')
          )
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: Text(
        S.of(context).no_items_in_your_cart,
        style: Theme.of(context).textTheme.titleSmall.merge(const TextStyle(fontWeight: FontWeight.w600)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15, left: 30, right: 30),
          child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        child: Text(
          S.of(context).your_favourite_items_are_just_a_click_away,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall,
        ),
          ),
        ),
        const SizedBox(height: 30),

      ],
    ));
  }
}



