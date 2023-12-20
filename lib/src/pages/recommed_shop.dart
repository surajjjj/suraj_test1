
import 'package:flutter/material.dart';

import '../controllers/vendor_controller.dart';

import 'package:mvc_pattern/mvc_pattern.dart';



import '../elements/no_shop_found_widget.dart';

import '../elements/shop_list_widget.dart';

import '../models/vendor.dart';
//ignore: must_be_immutable
class RecommendShop extends StatefulWidget {
  List<Vendor> vendorList;
  RecommendShop({Key key, this.vendorList}) : super(key: key);



  @override
  RecommendShopState createState() => RecommendShopState();
}

class RecommendShopState extends StateMVC<RecommendShop> {

  VendorController _con;

  RecommendShopState() : super(VendorController()) {
    _con = controller;

  }

  @override
  void initState() {
    super.initState();
    _con.tempVendorList = widget.vendorList;

  }
  final bool visible= false;
  @override
  void dispose() {

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return  widget.vendorList.isNotEmpty?Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
       SizedBox(
        height:50,
        child:ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount:  superFilter.length,
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            padding: const EdgeInsets.only(right:10),
            itemBuilder: (context, index) {
              ShopFilter filterData = superFilter.elementAt(index);
              return  Container(
                  margin:const EdgeInsets.only(left:5),
                  child:Container(
                      margin:const EdgeInsets.only(left:3),
                      padding: const EdgeInsets.only(top:10,bottom:5,left:4,),
                      child:Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Colors.grey[300],
                                  width: 1,
                                  style: BorderStyle.solid
                              ),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          height: 40,
                          elevation: 0,
                          color: filterData.selected?Colors.red[50]:Theme.of(context).primaryColor,
                          child: Center(
                              child:  Wrap(
                                  children:[
                                    Container(
                                        margin:const EdgeInsets.only(top:2),
                                        child:const Icon(Icons.sort,size:18)
                                    ),
                                    Container(
                                        padding: const EdgeInsets.only(right:5,left:5),
                                        child:Text(filterData.type,
                                            textAlign: TextAlign.center,
                                            style:TextStyle(fontFamily:'Touche W03 Regular',fontWeight: 1==2?FontWeight.bold:FontWeight.w500,color:1==2?Theme.of(context).colorScheme.primary:Theme.of(context).colorScheme.background)
                                        )
                                    ),
                                  ]
                              )
                          ),
                          onPressed: () {
                            for (var l in superFilter) {
                              setState(() {
                                l.selected = false;
                              });
                            }
                            filterData.selected = true;

                            setState(() {

                              _con.tempVendorList = _con.shopFilter(widget.vendorList,filterData.value);
                            });



                          },
                        ),)

                  )
              );
            }
        ),
      ),
        ListView.separated(
          scrollDirection: Axis.vertical,
          itemCount:   _con.tempVendorList.length,
          shrinkWrap: true,
          primary: false,
          padding: const EdgeInsets.only(top: 16),
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, int index) {

            return   _con.tempVendorList[index].shopId=='no_data'?NoShopFoundWidget():ShopList(choice:  _con.tempVendorList[index], focusId: 2,previewImage:   _con.tempVendorList[index].cover,);
          },
          separatorBuilder: (context, index) {
            return const SizedBox(height: 20);
          },
        ),
   ]
    ):Container();
  }



  List<ShopFilter> superFilter = <ShopFilter>[
    ShopFilter( type: 'All', selected: true, value: 'All'),
    ShopFilter( type: 'Opened Shop', selected: false, value: 'Opened Shop'),
    ShopFilter( type: 'Rating', selected: false, value:'Rating'),
    ShopFilter( type: 'Takeaway', selected: false, value: 'Takeaway'),
    ShopFilter( type: 'Distance', selected: false, value: 'Distance'),
    ShopFilter( type: 'Delivery Time', selected: false, value: 'Delivery Time'),
  ];
}


class ShopFilter  {
  ShopFilter({this.type, this.selected, this.value});
  String type;
  bool selected;
  String value;
}

