import 'package:flutter/material.dart';

import '../controllers/vendor_controller.dart';
import '../models/mastersubcategory_model.dart';



// ignore: must_be_immutable
class MasterSubcategoryWidget extends StatefulWidget {
  VendorController con;
  List<MasterSubCategoryModel> subCategoryList;
  Function callback;
  MasterSubcategoryWidget({Key key, this.subCategoryList, this.con, this.callback}) : super(key: key);
  @override
  State<MasterSubcategoryWidget> createState() => _MasterSubcategoryWidgetState();
}

class _MasterSubcategoryWidgetState extends State<MasterSubcategoryWidget> {



@override
void initState() {

  super.initState();
}

  @override
  Widget build(BuildContext context) {
   return  SizedBox(
     height:130,
     child:ListView.builder(
         scrollDirection: Axis.horizontal,
         itemCount: widget.subCategoryList.length,
         physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
         padding: const EdgeInsets.only(right:10),
         itemBuilder: (context, index) {
           MasterSubCategoryModel shopTypeData = widget.subCategoryList.elementAt(index);

           return Container(
               padding: const EdgeInsets.only(top:15,bottom:12,left:12,),
               child:InkWell(
                 onTap: (){},
                 child:Container(
                   padding: const EdgeInsets.only(left:5,right:5),
                   child:Column(
                       children:[
                         GestureDetector(
                           onTap: () {
                             for (var l in widget.subCategoryList) {
                               setState(() {
                                 l.subCategoryView = false;
                               });
                             }
                             shopTypeData.subCategoryView = true;
                             if(shopTypeData.id=='all'){
                                widget.callback();
                             }else {
                               widget.con.listenForVendorList('subcategory_wise_vendor',shopTypeData.id , 'all');
                             }


                           },
                           child: Column(
                             children: [
                               Container(
                                   width: 70.0,
                                   height: 70.0,
                                   decoration: BoxDecoration(
                                       shape: BoxShape.circle,
                                       image: DecorationImage(
                                           fit: BoxFit.fill,
                                           image: NetworkImage(shopTypeData.previewImage)
                                       )
                                   )),
                               const SizedBox(height:5),
                               Text(
                                 shopTypeData.title,
                                 textAlign: TextAlign.center,
                                 overflow: TextOverflow.ellipsis,
                                 maxLines: 2,
                                 style: Theme.of(context).textTheme.bodyMedium,
                               ),
                               shopTypeData.subCategoryView ?Container(
                                 margin: const EdgeInsets.only(top: 8),
                                 height: 4,
                                 width: 90,
                                 decoration: const BoxDecoration(
                                     border: Border(
                                         bottom: BorderSide(
                                             color: Colors.red,width: 3
                                         )
                                     )
                                 ),
                               ):Container()
                             ],
                           )
                         ),

                       ]
                   ),
                 ),
               )


           );
         }
     ),
   );



  }
}
