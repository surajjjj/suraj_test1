import 'package:flutter/material.dart';
import 'src/elements/review_widget.dart';
import 'src/pages/rating.dart';
import 'src/elements/empty_cart.dart';
import 'src/pages/edit_profile.dart';
import 'src/pages/force_update.dart';
import 'src/pages/home.dart';
import 'src/pages/introscreen.dart';
import 'src/pages/location_detector.dart';
import 'src/pages/map3.dart';
import 'src/pages/mobile_login.dart';
import 'src/pages/order_details.dart';
import 'src/pages/otp.dart';
import 'src/pages/payment_page.dart';
import 'src/pages/privacy_policy.dart';
import 'src/pages/food_rating.dart';
import 'src/pages/rating_driver.dart';
import 'src/pages/recharge.dart';
import 'src/pages/set_location.dart';
import 'src/pages/shop_info.dart';
import 'src/pages/stores_favorite.dart';
import 'src/pages/topup.dart';
import 'src/pages/wallet.dart';
import 'src/pages/wallet_thankyou.dart';
import 'src/pages/wallet_transcation_history.dart';
import 'src/pages/takeaway_map.dart';
import 'src/pages/checkout_page.dart';
import 'src/pages/payment.dart';
import 'src/pages/profile_page.dart';
import 'src/pages/apply_coupon.dart';
import 'src/pages/orders.dart';
import 'src/pages/stores.dart';
import 'src/pages/thankyou.dart';
import 'src/pages/languages.dart';
import 'src/pages/pages.dart';
import 'src/pages/splash_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;
    switch (settings.name) {
      case '/Splash':
        return MaterialPageRoute(builder: (_) => const SplashScreen());


      case '/otp1':
        return MaterialPageRoute(builder: (_) => Otp());




      case '/shop_info':
        return MaterialPageRoute(builder: (_) => ShopInfo(shopDetails: args,));

      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeWidget());
      case '/shop_rating':
        return MaterialPageRoute(builder: (_) =>   Rating(invoiceDetailsData: args,));
      case '/food_rating':
        return MaterialPageRoute(builder: (_) => FoodRating(ratingData: args));

      case '/driver_rating':
        return MaterialPageRoute(builder: (_) => RatingDriver(invoiceDetailsData: args));

      case '/set_location':
        return MaterialPageRoute(builder: (_) =>  SetLocation(loadUser: args,));
      case '/payment_page':
        return MaterialPageRoute(builder: (_) => const PaymentPages());

      case '/Takeaway':
        return MaterialPageRoute(builder: (_) => TakeawayWidget(orderId: args,));
      case '/Login':
        return MaterialPageRoute(builder: (_) => const MobileLogin());
      case '/orderDetails':
        return MaterialPageRoute(builder: (_) => OrderDetails(orderId: args,));


      case '/Pages':
        return MaterialPageRoute(builder: (_) => PagesWidget(currentTab: args));
      case '/Profile':
        return MaterialPageRoute(builder: (_) => const ProfilePage());

      case '/Map':
        return MaterialPageRoute(builder: (_) => MapLiveTrack(orderId: args.toString(),));

      case '/Checkout':
        return MaterialPageRoute(builder: (_) => const CheckoutPage());

      case '/EmptyList':
        return MaterialPageRoute(builder: (_) =>  const EmptyList());

      case '/Orders':
        return MaterialPageRoute(builder: (_) => const OrdersWidget());
      case '/ApplyCoupon':
        return MaterialPageRoute(builder: (_) => const ApplyCoupon());

      case '/gift':
        return MaterialPageRoute(builder: (_) =>  ReviewBox1());

        return MaterialPageRoute(builder: (_) => Stores());

      case '/Languages':
        return MaterialPageRoute(builder: (_) => const LanguagesWidget());

      case '/WThankyou':
        return MaterialPageRoute(builder: (_) => const WThankyou());
      case '/Thankyou':
        return MaterialPageRoute(builder: (_) => Thankyou(orderId: args,));



      case '/location':
        return MaterialPageRoute(builder: (_) => const LocationDetector());


      case '/Payment':
        return MaterialPageRoute(builder: (_) => const PaymentPage());
      case '/introscreen':
        return MaterialPageRoute(builder: (_) => const IntroScreen());




      case '/wallet':
        return MaterialPageRoute(builder: (_) => const WalletPage());
      case '/Recharge':
        return MaterialPageRoute(builder: (_) => const RechargePage());
      case '/TransactionHistory':
        return MaterialPageRoute(builder: (_) => const WalletTransactionHistory());
      case '/My_FavoriteStore':
        return MaterialPageRoute(builder: (_) => const StoresFavorite());
      case '/topUp':
        return MaterialPageRoute(builder: (_) => const TopUpPage());

      case '/edit_profile':
        return MaterialPageRoute(builder: (_) => const EditProfile());
      case '/force_update':
        return MaterialPageRoute(builder: (_) => const ForceUpdate());

      case '/policy':
        return MaterialPageRoute(builder: (_) => PrivacyPolicy(policy: args,));
      default:
        // If there is no such named route in the switch statement, e.g. /third
        return MaterialPageRoute(builder: (_) => const Scaffold(body: SafeArea(child: Text('Route Error'))));
    }
  }
}
