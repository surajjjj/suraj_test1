import 'package:flutter/material.dart';
import '../helpers/helper.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class ReviewsController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKeyRating;
  OverlayEntry loader;
  ReviewsController() {
    loader = Helper.overlayLoader(context);
    scaffoldKeyRating = GlobalKey<ScaffoldState>();
  }




}
