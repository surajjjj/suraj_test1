
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class GiftPage extends StatefulWidget{
  const GiftPage({Key key}) : super(key: key);


  @override
  State<GiftPage> createState() => _GiftPageState();
}

class _GiftPageState extends State<GiftPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*backgroundColor: Theme.of(context).primaryColorDark,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColorLight, //change your color here
        ),
        elevation: 0,
        title: Text('Profile',style: Theme.of(context).textTheme.headline3.merge(TextStyle(color:Theme.of(context).primaryColorLight)),),
        backgroundColor:  Theme.of(context).primaryColorDark,
      ),*/
      body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[
                Color(0xFFff4c7b),
                Color(0xFFff4c7b),



              ],
            ),
          ),
          child: SafeArea(child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.only( left: 10.0),
                child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      color:Theme.of(context).primaryColorLight,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),


              ),
              Container(
                padding: const EdgeInsets.only( left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          clipBehavior: Clip.none, alignment: Alignment.bottomCenter,
                          children: [
                            Container(
                              height:120,
                              width:120,
                              margin: const EdgeInsets.only(top:10,),
                              alignment: Alignment.bottomRight,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color:Theme.of(context).primaryColor,
                              ),
                              child:ClipRRect(
                                  borderRadius: BorderRadius.circular(60),
                                  child:Image.asset('assets/img/resturentdefaultbg.jpg', height: 120,width:120,
                                    fit: BoxFit.cover,
                                  )
                              ),
                            ),
                            Positioned(
                              bottom: -10,
                                child: Container(
                                  height:30,
                                  width:30,
                                  margin: const EdgeInsets.only(top:10,),
                                  alignment: Alignment.bottomRight,
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:Theme.of(context).primaryColor,
                                  ),
                                  child:const Icon(Icons.favorite,color: Colors.red,)

                                ),
                            )
                          ],
                        )

                      ],
                    ),
                Container(
                              padding: const EdgeInsets.only(top:25,left:20,right:20),
                              child: Text('Naga you really love Barbequeen',textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.headlineMedium.merge(TextStyle(fontWeight:FontWeight.w700,color:Theme.of(context).primaryColorLight.withOpacity(0.97))),
                                  ),

                          ),
                    Container(
                        padding: const EdgeInsets.only(top:10,left:20,right:20,bottom:15),
                        child: Text('and they love you back! So they\'ve chhosen to make you their ambassadar',textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleSmall.merge(TextStyle(color:Theme.of(context).primaryColorLight.withOpacity(0.85))),
                            ),

                    ),

                  ],
                ),
              ),


              const SizedBox(height: 20),
              Expanded(
                child: Container(
                  width:double.infinity,
                  padding: const EdgeInsets.only(top:10),
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30))),
                  child: SingleChildScrollView(

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.center,
                            padding: const EdgeInsets.only(left:20,right:20,top:20),
                            child:Text('Gift your friends ₹50 OFF',
                                textAlign: TextAlign.center,
                                style:Theme.of(context).textTheme.displayMedium
                            )
                        ),
                        Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(left:10,right:10,top:10),
                            child:Text('on their first order from barbequeen',
                                textAlign: TextAlign.center,
                                style:Theme.of(context).textTheme.titleSmall
                            )
                        ),
                        Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(left:15,right:15,top:20,bottom:20),
                            child:Row(
                              children: [
                                const Expanded(

                                  child: DottedLine(
                                    direction: Axis.horizontal,
                                    dashColor: Colors.grey,
                                  ),
                                ),
                               Container(
                                 padding: const EdgeInsets.only(left:2,right:2),
                                 child:Text('WHAT THEY WILL SEE',style: Theme.of(context).textTheme.bodySmall.merge(const TextStyle(height: 1.2)),),
                               ),

                                const Expanded(
                                  child: DottedLine(
                                    direction: Axis.horizontal,
                                    dashColor: Colors.grey,
                                  ),
                                ),
                              ],
                            )
                        ),
                        Container(
                            padding: const EdgeInsets.only(left:10,right:20,top:10),
                        child:Row(
                        children:[
                        Stack(
                          clipBehavior: Clip.none, alignment: Alignment.bottomCenter,
                          children: [

                            Container(
                              width:120,
                              height: 120,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                    'assets/img/gift_voucher.png'
                                  )
                                )
                              ),
                              child:Container(
                                height:70,
                                width:70,
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child:ClipRRect(
                                    borderRadius: BorderRadius.circular(60),
                                    child:Image.asset('assets/img/resturentdefaultbg.jpg', height: 70,width:70,
                                      fit: BoxFit.cover,
                                    )
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: -10,
                              child: Container(

                                  width:90,
                                  margin: const EdgeInsets.only(top:10,),
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color:Theme.of(context).primaryColor,
                                    border: Border.all(
                                      color: Colors.grey[300],
                                      width: 1
                                    )
                                  ),
                                  child:const Text('5 Gift left',style: TextStyle(color: Colors.orange,fontWeight: FontWeight.w700),)

                              ),
                            )

                          ],
                        ),
                          Expanded(
                            child: Container(
                              height: 111,
                              padding: const EdgeInsets.only(top:10,left:9,right: 5),
                              decoration: BoxDecoration(
                                color:Colors.orangeAccent.withOpacity(0.1),
                               border: Border.all(
                                 color: Colors.orangeAccent.withOpacity(0.2),
                                 width: 1
                               ),
                                  borderRadius: const BorderRadius.only(
                                  bottomRight: Radius.circular(8),
                                  topRight: Radius.circular(8),
                                  topLeft: Radius.circular(0),
                                  bottomLeft: Radius.circular(0)
                                )
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Naga gifted you a coupon',
                                  style: Theme.of(context).textTheme.titleSmall.merge(const TextStyle(fontWeight: FontWeight.w700)),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(top:10),
                                    child: Text('Try barbequeen with my ₹50 OFF gift coupon. this apply over and above other amazing offer,',
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ]
                        )
                ),


                      ],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                  child:Container(
                    color: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Column(
                      children:[
                       /* Container(
                          padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                          width: double.infinity,
                          // ignore: deprecated_member_use
                          child: FlatButton(
                              onPressed: () {},
                              padding: EdgeInsets.all(15),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              color: Theme.of(context).colorScheme.secondary.withOpacity(1),
                              child: Text(
                                'Gift Now',
                                style: Theme.of(context).textTheme.bodyText1.merge(TextStyle(color: Theme.of(context).primaryColorLight)),
                              )
                          ),
                        ), */
                        Text(
                          'Expires in 5 days',
                          style: Theme.of(context).textTheme.titleSmall,
                        )
                      ]
                    )
                  ),


              ),

            ],
          ),
          )
      ),
    );
  }
}