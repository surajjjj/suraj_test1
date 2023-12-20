import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import '../../generated/l10n.dart';
import 'no_shop_found_widget.dart';
import '../components/Shimmer/shop_list_shimmer_widget.dart';
import '../controllers/vendor_controller.dart';
import 'master_subcategory_widget.dart';
import 'shop_list_widget.dart';
// ignore: must_be_immutable
class ShopListBoxWidget extends StatefulWidget {
  VendorController con;
  String pageTitle;
  bool subcategoryStatus;
  int focusId;
  String previewImage;
  Function callback;
  bool notFound=false;
  ShopListBoxWidget({Key key,  this.con, this.pageTitle,this.focusId, this.previewImage, this.subcategoryStatus, this.callback, this.notFound}) : super(key: key);
  @override
  State<ShopListBoxWidget> createState() => _ShopListBoxWidgetState();
}

class _ShopListBoxWidgetState extends State<ShopListBoxWidget> with AfterLayoutMixin<ShopListBoxWidget> {
  bool ratingOne = false;




  @override
  Widget build(BuildContext context) {


    return SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          SizedBox(
            height:50,
            child:ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: superFilter.length,
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
                              color:filterData.selected?Colors.red[50]:Colors.white,
                              child: Center(
                                  child:  Wrap(
                                      children:[

                                        Container(
                                            padding: const EdgeInsets.only(right:5,left:5),
                                            child:Text(filterData.type,
                                                textAlign: TextAlign.center,
                                                style:TextStyle(fontFamily:'Touche W03 Regular',fontWeight: 1==2?FontWeight.bold:FontWeight.w500,color:1==2?Colors.white:Theme.of(context).colorScheme.background)
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

                                  widget.con.tempVendorList = widget.con.shopFilter(widget.con.vendorList,filterData.value);
                                });

                              },
                            ),)

                      )
                  );
                }
            ),
          ),
          widget.subcategoryStatus?MasterSubcategoryWidget(subCategoryList: widget.con.subcategoryList,con: widget.con,callback: widget.callback,):Container(),
          Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
              child: Text(widget.pageTitle, style: Theme.of(context).textTheme.titleLarge)),




          widget.notFound?Container():Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                widget.con.notFound? const Text(''): Expanded(
                  child: Text('${ widget.con.tempVendorList.length} ${S.of(context).stores_near_by}',
                      style: Theme.of(context).textTheme.bodySmall.merge(TextStyle(color: Theme.of(context).colorScheme.background))),
                ),

              ],
            ),
          ),




          widget.notFound?NoShopFoundWidget(value: 0.05,): widget.con.tempVendorList.isEmpty?Container(
              margin: const EdgeInsets.only(top:20,left:20,right:20),

              child:const ShopListShimmerWidget()):ListView.separated(
            scrollDirection: Axis.vertical,
            itemCount: widget.con.tempVendorList.length,
            shrinkWrap: true,
            primary: false,
            padding: const EdgeInsets.only(top: 16),
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, int index) {

              return  ShopList(choice: widget.con.tempVendorList[index], focusId: widget.focusId,previewImage: widget.previewImage,);
            },
            separatorBuilder: (context, index) {
              return const SizedBox(height: 20);
            },
          ),
          const SizedBox(height: 50)
        ]));
  }


  @override
  void afterFirstLayout(BuildContext context) {


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

