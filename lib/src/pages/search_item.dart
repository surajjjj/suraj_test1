import 'package:flutter/material.dart';
import '../elements/add_cart_slider_widget.dart';
import '../elements/no_shop_found_widget.dart';
import '../helpers/helper.dart';
import '../models/searchisresult.dart';
import 'store_detail.dart';
import '../repository/vendor_repository.dart';





class SearchItem extends StatefulWidget {
  final List<ItemSearchDetails> itemDetails;
  const SearchItem({Key key, this.itemDetails}) : super(key: key);

  @override
  State<SearchItem> createState() => _SearchItemState();
}

class _SearchItemState extends State<SearchItem> {

  @override
  void initState() {


    // TODO: implement initState
    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    return widget.itemDetails.isNotEmpty?SingleChildScrollView(
        child:Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.builder(
            shrinkWrap: true,
            itemCount: widget.itemDetails.length,
            scrollDirection: Axis.vertical,
            primary: false,
            itemBuilder: (context, index) {
              ItemSearchDetails itemData = widget.itemDetails.elementAt(index);

              return itemData.vendor.shopId==null?NoShopFoundWidget():Column(
                  children:[
                    Container(
                      margin:const EdgeInsets.only(top:5),
                      padding:const EdgeInsets.only(top:15,bottom:15),
                      decoration:BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12.withOpacity(0.1),
                            blurRadius: 8,
                            spreadRadius:1,
                          ),
                        ],
                      ),
                      child:Column(
                        children: [
                          Container(
                              padding: const EdgeInsets.only(left:20,right:20),
                              child:Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:[


                                    Expanded(
                                        child:Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children:[
                                              Text(itemData.vendor.shopName,
                                                style:Theme.of(context).textTheme.titleMedium,
                                              ),
                                              Container(
                                                  padding: const EdgeInsets.only(top:5,),
                                                  child:Wrap(
                                                      children:[
                                                        Container(
                                                            height: 18,
                                                            width: 18,
                                                            alignment: Alignment.center,
                                                            padding: const EdgeInsets.all(2),
                                                            decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).primaryColorDark,),
                                                            child: InkWell(
                                                              onTap: (){},
                                                              child: Icon(Icons.star,color:Theme.of(context).colorScheme.primary,size:13),
                                                            )
                                                        ),
                                                        Container(
                                                            padding:const EdgeInsets.only(left:5,right:10),
                                                            child:Text('${itemData.vendor.ratingNum }-${Helper.priceDistance(itemData.vendor.distance)}| ${Helper.calculateTime(double.parse(itemData.vendor.distance.replaceAll(',','')),int.parse(itemData.vendor.handoverTime),false)}',
                                                                style: Theme.of(context).textTheme.titleSmall
                                                            )
                                                        ),
                                                      ]
                                                  )
                                              ),
                                              Container(
                                                  padding: const EdgeInsets.only(top:5,bottom:5),
                                                  child:Wrap(
                                                      children:[

                                                        const SizedBox(width:3),
                                                        Text(itemData.vendor.locationMark,maxLines:1,style:Theme.of(context).textTheme.bodySmall),

                                                      ]
                                                  )
                                              )
                                            ]
                                        )
                                    ),
                                    Align(
                                        child:Container(
                                            padding: const EdgeInsets.only(left:10),
                                            child:IconButton(
                                                onPressed: (){
                                                  currentVendor.value = itemData.vendor;

                                                  Navigator.of(context).push(MaterialPageRoute(
                                                      builder: (context) =>
                                                          StoreViewDetails(shopDetails: itemData.vendor,
                                                            shopTypeID: 2,
                                                          )));

                                                },
                                                icon:const Icon(Icons.arrow_forward_outlined)
                                            )
                                        )
                                    )
                                  ]
                              )
                          ),
                          //_itemData.vendor.shopType=='2'?AddRestaurantSliderWidget(itemData: _itemData,):
                          AddCartSliderWidget(productList: itemData.productAarList, focusId: 2,searchType: 'search', vendor: itemData.vendor,),


                        ],
                      )
                    ),



                   
                  ]
              );

            }
        ),
      ],
    )):Container();
  }
}
