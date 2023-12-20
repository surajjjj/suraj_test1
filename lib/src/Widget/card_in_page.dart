import 'package:flutter/material.dart';
class CardInPage extends StatefulWidget {
  const CardInPage({Key key}) : super(key: key);


  @override
  State<CardInPage> createState() => _CardInPageState();
}

class _CardInPageState extends State<CardInPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: SizedBox(
        height: 57.0,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      height: 44.0,
                      width: 44.0,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(22.0),
                      ),
                      child: const Center(
                        child: Text(
                          '2',
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('rerer',
                            style: Theme.of(context).textTheme.titleSmall
                            ),
                        Text('sdg',
                            style: TextStyle(color:Theme.of(context).disabledColor.withOpacity(0.9),fontWeight: FontWeight.w500)
                            ),
                      ],
                    )
                  ],
                ),
                Row(
                  children: [
                    Text('12',
                        style: Theme.of(context).textTheme.titleSmall.merge(const TextStyle(color:Colors.red,fontWeight: FontWeight.w400))
                    ),
                    const SizedBox(width: 4.0),
                    const Icon(Icons.keyboard_arrow_right),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
