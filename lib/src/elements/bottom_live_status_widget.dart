import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/platform/platform.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:page_indicator/page_indicator.dart';
import '../components/constants.dart';
import '../controllers/order_controller.dart';
import '../helpers/helper.dart';
import '../repository/user_repository.dart';
import 'lottie_animation_widget.dart';



class BottomLiveStatusWidget extends StatefulWidget {
  const BottomLiveStatusWidget({Key key}) : super(key: key);

  @override
  BottomLiveStatusWidgetState createState() => BottomLiveStatusWidgetState();
}

class BottomLiveStatusWidgetState extends StateMVC<BottomLiveStatusWidget> {
  GlobalKey<PageContainerState> key = GlobalKey();
  PageController controller1;
  int _currentPage = 0;
  Timer _timer;
  OrderController _con;
  final PageController _pageController = PageController(
    initialPage: 0,
  );

  BottomLiveStatusWidgetState() : super(OrderController()) {
    _con = controller;
  }

  @override
  void initState() {
    super.initState();
    controller1 = PageController();

    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return  currentUser.value.id!=null? StreamBuilder(
        stream: FirebaseFirestore.instance.collection("orderDetails").where(
            "grandState", isEqualTo: false)
            .where("userId", isEqualTo: currentUser.value.id).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError || snapshot.data == null) {
            return Container();
          } else {
            return  snapshot.data.docs.length>0?Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [

                Container(
                    height: Helper.mediaSize(context, 'height', 0.1),
                    width: Helper.mediaSize(context, 'width', 0.87),
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20)
                        ),
                        color: Theme
                            .of(context)
                            .primaryColor,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 1.0,
                            spreadRadius: 0.5,
                          ),
                        ]
                    ),
                    child: PageIndicatorContainer(
                        key: key,
                        align: IndicatorAlign.bottom,
                        length: snapshot.data.docs.length,
                        indicatorSpace: 15.0,
                        indicatorColor: greyColor1,
                        shape: IndicatorShape.defaultOval,
                        indicatorSelectorColor: Colors.black,
                        child: PageView.builder(
                          itemCount: snapshot.data.docs.length,
                          scrollDirection: Axis.horizontal,
                          controller: _pageController,
                          reverse: false,
                          itemBuilder: (context, index) {
                            DocumentSnapshot course = snapshot.data.docs[index];
                            return SizedBox(

                                width: double.infinity,
                                height: Helper.mediaSize(
                                    context, 'height', 0.07),
                                child: Container(
                                    padding: const EdgeInsets.only(top: 10,
                                        bottom: 10,
                                        left: 10,
                                        right: 10),

                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .start,
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: [
                                        InkWell(
                                          onTap: (){
                                            Navigator.of(context).pushNamed('/orderDetails', arguments: course['orderId']);
                                          },
                                          child: SizedBox(
                                              width: 50,
                                              height:50,
                                              child: course['status']=='Shipped'?LottieAnimationWidget(jsonData:'assets/img/delivery-boy.json'):
                                              LottieAnimationWidget(jsonData:'assets/img/cooking3.json'),
                                          ),
                                        ),
                                   Expanded(
                                      child: InkWell(
                                           onTap: (){
                                             Navigator.of(context).pushNamed('/orderDetails', arguments: course['orderId']);
                                           },
                                              child: Container(
                                                  padding: const EdgeInsets.only(
                                                      left: 10,
                                                      right: 9,
                                                      bottom: 10),
                                                  child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        Text(
                                                          'Food is being ${course['status']}',
                                                          style: Theme
                                                              .of(context)
                                                              .textTheme
                                                              .titleLarge,
                                                        ),
                                                        Text(
                                                          'Your order is ${course['status']} success',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                          style: Theme
                                                              .of(context)
                                                              .textTheme
                                                              .bodySmall,
                                                        ),


                                                      ]
                                                  )
                                              )
                                          ),
                                        ),
                                        // ignore: deprecated_member_use

                                        Container(

                                            padding: const EdgeInsets.only(
                                                top: 5),
                                            child: InkWell(
                                              onTap: () {

                                                _con.updateOrderStatus(course['orderId'], true);
                                              },

                                              child: Icon(Icons
                                                  .clear,
                                                size: 18,
                                                color: greyColor1,
                                              ),
                                            )

                                        ),


                                      ],
                                    ))
                            );
                          },
                        ))
                ),
                Container(
                  height: Helper.mediaSize(context, 'height',   GetPlatform.isIOS?0.04:0.08),
                )
              ],
            ):Container();
          }
        }):Container();
  }
}