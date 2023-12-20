import 'package:flutter/material.dart';
import '../Widget/custom_divider_view.dart';
class DeliveryInstruction extends StatefulWidget {
  const DeliveryInstruction({Key key}) : super(key: key);

  @override
  State<DeliveryInstruction> createState() => _DeliveryInstructionState();
}

class _DeliveryInstructionState extends State<DeliveryInstruction> {
  bool isSwitchOn = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar:AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        title:  Container(
            height: 40,
            width: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
            ),
            child:Material(  //Wrap with Material
                shape: RoundedRectangleBorder(side: BorderSide(
                    color: Colors.grey[300],
                    width: 1,
                    style: BorderStyle.solid
                ),
                    borderRadius: BorderRadius.circular(22)
                ),
              color: Theme.of(context).dividerColor,
              clipBehavior: Clip.antiAlias, // Add This
              child: MaterialButton(
                child: Center(
                  child:Container(
                      padding: const EdgeInsets.only(top:1,left:10,right:5),
                      child:const Text('Save & Close',
                          textAlign: TextAlign.center,
                      )
                  ),
                ),
                onPressed: () {


                },
              ),)
        ),
      ),
        body: Column(

      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(top:20,left:20,right:20),
          child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
        children:[
          Text('Delivery Instructions',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Container(
            padding: const EdgeInsets.only(top:5,bottom:20),
            child: Text('Add instructions to get faster delivery and receive fewer calls from your delivery partner',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          CustomDividerView(
            dividerHeight: 2,
            color: Theme.of(context).dividerColor,
          ),
          const SizedBox(height: 5,),
          ListTile(
            contentPadding: EdgeInsets.zero,
            minLeadingWidth: 10,
            leading: const Icon(Icons.directions),
            title: Text('Add directions to reach',
            style: Theme.of(context).textTheme.titleMedium,
            ),
            trailing: const Icon(Icons.keyboard_arrow_right_sharp),
          ),
          const SizedBox(height: 10,),
          CustomDividerView(
            dividerHeight: 2,
            color: Theme.of(context).dividerColor,
          ),
          const SizedBox(height: 10,),
          ListTile(
            contentPadding: EdgeInsets.zero,
            minLeadingWidth: 10,
            leading: const Icon(Icons.notifications_active_outlined),
            title: Container(
              padding: const EdgeInsets.only(top:10),
              child:Text('Avoid ringing bell',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            subtitle: Container(
              padding: const EdgeInsets.only(top:10),
              child:Text('Delivery partner will avoid ringing the bell unless absolutely necessary',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
           /* trailing:FlutterSwitch(
              height: 25.0,
              width: 50.0,
              padding: 4.0,
              toggleSize: 15.0,
              borderRadius: 20.0,
              activeColor: Colors.red,
              value: isSwitchOn,
              onToggle: (value) {
                setState(() {
                  isSwitchOn = value;
                });
              },
            ), */

          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            minLeadingWidth: 10,
            leading: const Icon(Icons.delivery_dining),
            title: Container(
              padding: const EdgeInsets.only(top:10),
              child:Text('Leave at the door',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            subtitle: Container(
              padding: const EdgeInsets.only(top:10),
              child:Text('Delivery partner will leave the order at your doorstep and may call you',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
           /* trailing:FlutterSwitch(
              height: 25.0,
              width: 50.0,
              padding: 4.0,
              toggleSize: 15.0,
              borderRadius: 20.0,
              activeColor: Colors.red,
              value: isSwitchOn,
              onToggle: (value) {
                setState(() {
                  isSwitchOn = value;
                });
              },
            ), */

          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            minLeadingWidth: 10,
            leading: const Icon(Icons.call,),
            title: Container(
              padding: const EdgeInsets.only(top:10),
              child:Text('Avoid calling',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            subtitle: Container(
              padding: const EdgeInsets.only(top:10),
              child:Text('Delivery partner will avoid calling unless they need some help',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
           /* trailing:FlutterSwitch(
              height: 25.0,
              width: 50.0,
              padding: 4.0,
              toggleSize: 15.0,
              borderRadius: 20.0,
              activeColor: Colors.red,
              value: isSwitchOn,
              onToggle: (value) {
                setState(() {
                  isSwitchOn = value;
                });
              },
            ), */
          ),

          ListTile(
            contentPadding: EdgeInsets.zero,
            minLeadingWidth: 10,
            leading: const Icon(Icons.security,color:Colors.red),
            title: Container(
              padding: const EdgeInsets.only(top:10),
              child:Text('Leave the security',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            subtitle: Container(
              padding: const EdgeInsets.only(top:10),
              child:Text('Delivery partner will leave the order with security and may call you',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          /*  trailing:FlutterSwitch(
              height: 25.0,
              width: 50.0,
              padding: 4.0,
              toggleSize: 15.0,
              borderRadius: 20.0,
              activeColor: Colors.red,
              value: isSwitchOn,
              onToggle: (value) {
                setState(() {
                  isSwitchOn = value;
                });
              },
            ), */
          ),
        ]
          )
        )
      ],
    ));
  }
}
