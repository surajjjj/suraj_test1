

import 'package:flutter/material.dart';
import '../pages/wallet_transcation.dart';


class TransactionCard extends StatefulWidget {
  final String title;
  final String subTitle;
  final String price;
  final String letter;
  final Color color;
  final String transactionId;
  final String date;
  const TransactionCard({Key key,
    this.color,
    this.letter,
    this.price,
    this.subTitle,
    this.title,
    this.transactionId,
    this.date
  }) : super(key: key);
  @override
  State<TransactionCard> createState() => _TransactionCardState();
}

class _TransactionCardState extends State<TransactionCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 8),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TransactionPage(

              ),
            ),
          );
        },
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
                        color:widget.color,
                        borderRadius: BorderRadius.circular(22.0),
                      ),
                      child:  Center(
                          child:Text( widget.letter,
                          )
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       Container(
                         padding: const EdgeInsets.only(bottom: 4),
                         child: Text( widget.title,
                           style: Theme.of(context).textTheme.titleSmall.merge(const TextStyle(fontWeight: FontWeight.w700)),
                         ),
                       ),
                        Text(widget.subTitle,
                            style: TextStyle(color:Theme.of(context).disabledColor.withOpacity(0.9),fontWeight: FontWeight.w500)
                            ),
                      ],
                    )
                  ],
                ),
                Row(
                  children: [
                    Text(widget.price,
                        style: Theme.of(context).textTheme.titleMedium
                    ),

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
