import 'package:flutter/material.dart';
import '../models/mastercategory_model.dart';
import '../pages/stores.dart';
import 'package:responsive_ui/responsive_ui.dart';
import '../components/constants.dart';



// ignore: must_be_immutable
class MyRecommendedTypeWidget extends StatefulWidget {
  List<MasterCategoryModel> categoryList;
  MyRecommendedTypeWidget({Key key, this.categoryList}) : super(key: key);
  @override
  State<MyRecommendedTypeWidget> createState() => _MyRecommendedTypeWidgetState();
}

class _MyRecommendedTypeWidgetState extends State<MyRecommendedTypeWidget>with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _animation;



  int intState = 8;
  bool openState =false;
  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(
          milliseconds: 700
      ),
      vsync: this,
    )..forward();
    _animation = Tween<Offset>(
      begin: const Offset(0.5, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInCubic,
    ));


       super.initState();
  }
  @override
  dispose() {
    _controller.dispose(); // you need this
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return  Wrap(
        children: List.generate(widget.categoryList.length, (index) {



            MasterCategoryModel categoryData = widget.categoryList.elementAt(index);

            return index<intState?Wrap(
              children: [
           Div(
            colL:3,
              colM:3,
              colS:3,
              child: Container(
                   /* padding: EdgeInsets.only(top:15,bottom:12,left:12,),*/
                  margin: const EdgeInsets.only(left:5,right:5,bottom:13),
                    child:SlideTransition(
                        position: _animation,
                        transformHitTests: true,
                        textDirection: TextDirection.ltr,
                        child:InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                              return Stores( pageTitle:  categoryData.title,
                                coverImage: categoryData.coverImage,previewImage: categoryData.previewImage,
                                pageType: 'category',
                                id: categoryData.id,
                                subcategoryStatus: categoryData.subCategoryView,
                              );
                            }));
                          },
                          child:Column(
                              children:[


                                Container(
                                      width: 70.0,
                                      height: 70.0,
                                      decoration:  BoxDecoration(
                                          shape: BoxShape.circle,
                                          image:  DecorationImage(
                                              fit: BoxFit.fill,
                                              image: NetworkImage(categoryData.previewImage)
                                          )
                                      )),

                                const SizedBox(height:5),
                                Text(
                                  categoryData.title,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: Theme.of(context).textTheme.bodyMedium.merge(TextStyle(color:greyColor1)),
                                ),
                              ]
                          ),




                        )
                    )


                )
            )
              ],
            ):Container();
          }
          )
      );



  }
}
