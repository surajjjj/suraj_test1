import 'package:flutter/material.dart';
import '../../generated/l10n.dart';

class Appbar extends StatefulWidget {
  const Appbar({Key key}) : super(key: key);

  @override
  State<Appbar> createState() => _AppbarState();
}

class _AppbarState extends State<Appbar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top:5, left: 7.0, right: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios),

            onPressed: () {
              Navigator.pop(context);
            },
          ),
          const SizedBox(width: 5.0),
          Text(
              S.of(context).wallet,
            style:Theme.of(context).textTheme.displayMedium
          ),

        ],
      ),
    );
  }
}
