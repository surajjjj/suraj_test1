import 'package:carousel_slider/carousel_slider.dart';

import 'package:flutter/material.dart';


import '../helpers/helper.dart';
import '../models/slide.dart';
import '../pages/shop_all_list.dart';
import '../pages/store_detail.dart';
import '../components/Shimmer/home_slider_loader_widget.dart';
import 'search_results_widget.dart';


class HomeSliderWidget extends StatefulWidget {
  final List<Slide> slides;
  const HomeSliderWidget({Key key, this.slides}) : super(key: key);
  @override
  State<HomeSliderWidget> createState() => _HomeSliderWidgetState();


}

class _HomeSliderWidgetState extends State<HomeSliderWidget> {
  AlignmentDirectional _alignmentDirectional;
  final _currentPageNotifier = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return widget.slides == null || widget.slides.isEmpty
        ? const HomeSliderLoaderWidget()
        : Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Stack(
          alignment: _alignmentDirectional ?? Helper.getAlignmentDirectional('bottom_start'),
          fit: StackFit.passthrough,
          children: <Widget>[
            CarouselSlider(
              options: CarouselOptions(
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
                height: 170,
                viewportFraction: 0.85,
                onPageChanged: (index, reason) {
                  _currentPageNotifier.value = index;
                  setState(() {

                    _alignmentDirectional = Helper.getAlignmentDirectional('bottom_start');
                  });
                },
              ),
              items: widget.slides.map((Slide slide) {
         return Container(
                margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                height: 170,

                child: InkWell(
                  onTap: (){
                    if(slide.redirect_type=='discount_upto') {
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                        return  ShopAllList(pageTitle: 'Discount Upto', type: 'discount_upto',coverImage: 'assets/img/cover1.jpg',para: slide.para,);
                      }));
                    }

                    if(slide.redirect_type=='link_to_shop'){

                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                StoreViewDetails(shopDetails: slide.vendorDetails,
                                    shopTypeID: 2,
                                    )));

                    }

                    if(slide.redirect_type=='link_to_item'){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchResultWidget(searchTxt: slide.para,)));
                    }
                  },
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(15)),
                        child: Image.network(
                          slide.image,
                          fit: BoxFit.fill,
                          height: 170,
                          width: double.infinity,),
                      ),

                    ],
                  ),
                ));
              }).toList(),
            ),

          ],
        ),


      ],
    );

  }
}
