import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'src/controllers/initial_controller.dart';
import 'generated/l10n.dart';
import 'route_generator.dart';
import 'src/helpers/custom_trace.dart';
import 'src/models/setting.dart';
// ignore: library_prefixes
import 'src/repository/settings_repository.dart' as settingRepo;
// ignore: library_prefixes
import 'src/repository/user_repository.dart' as userRepo;
// ignore: library_prefixes
import 'src/repository/product_repository.dart' as proRepo;
import 'src/repository/home_repository.dart' as home;
// ignore: depend_on_referenced_packages
import "package:firebase_core/firebase_core.dart";
import 'package:flutter_localizations/flutter_localizations.dart';
















































class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
//final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GlobalConfiguration().loadFromAsset("configurations");

  //FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
 // await NotificationHelper.initialize(flutterLocalNotificationsPlugin);


  // ignore: deprecated_member_use
  if (kDebugMode) {
    print(CustomTrace(StackTrace.current, message: "base_url: ${GlobalConfiguration().getValue('base_url')}"));
  }
  // ignore: deprecated_member_use
  if (kDebugMode) {
    print(CustomTrace(StackTrace.current, message: "api_base_url: ${GlobalConfiguration().getValue('api_base_url')}"));
  }
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
//  /// Supply 'the Controller' for this application.
//  MyApp({Key key}) : super(con: Controller(), key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends StateMVC<MyApp> {
  InitialController  _con;
  MyAppState() : super(InitialController()) {
    _con = controller;
  }

  @override
  void initState() {
    settingRepo.initSettings();
    userRepo.getCurrentUser();
    proRepo.getCurrentCartItem();
    proRepo.getCurrentCheckout();
    home.getCatchLocationList();
    home.getRecentSearch();
    _con.listenForTips();
    _con.listenForLogisticsPricing();

    // homeCon.listenForTips();
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: settingRepo.setting,
        builder: (context, Setting setting, _) {
          return MaterialApp(
              navigatorKey: settingRepo.navigatorKey,
              title: setting.appName,
              initialRoute: '/Splash',
              onGenerateRoute: RouteGenerator.generateRoute,
              debugShowCheckedModeBanner: false,
              locale: setting.mobileLanguage.value,
              localizationsDelegates: const [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              supportedLocales: S.delegate.supportedLocales,
              theme: setting.brightness.value == Brightness.light
                  ? ThemeData(
                fontFamily: 'MotivaSansBold',
                primaryColor: Colors.white,
                disabledColor: Colors.grey,
                cardColor: Colors.lightBlue[50],
                secondaryHeaderColor: const Color(0xFF043832).withOpacity(1.0),
                iconTheme: const IconThemeData(
                  color: Colors.black
                ),
                floatingActionButtonTheme: FloatingActionButtonThemeData(elevation: 0, foregroundColor: Theme.of(context).primaryColor),
                brightness: Brightness.light,
                hintColor: const Color(0xFF919191),
                primaryColorLight: Colors.white,// button text color constant dark and light theme
                dividerColor: const Color(0xFF8c98a8).withOpacity(0.1), // divider color
                focusColor:const Color(0xFFfc8019).withOpacity(1.0), // input focused border color
                /*focusColor: Color(0xFF2abd03).withOpacity(1.0),*/ // input focused border color
                /*primaryColorDark:  Color(0xFF2abd03),*/
                primaryColorDark:const Color(0xFFfc8019), // main theme color light and dark theme
                colorScheme: ColorScheme.fromSwatch().copyWith(
                  /*secondary: Color(0xFF000000).withOpacity(1.0),*/
                    secondary: const Color(0xFFfc8019), // button color
                  primary: Colors.white, //  text color constant dark and light theme (white color)
                    background:Colors.black, // dynamic black color text in light theme,// icon color
                  /*background: const Color(0xFF000000),
                  onBackground: const Color(0xFF2e2e2e),
                  primary: const Color(0xFF00aa13).withOpacity(1),
                  onPrimary: const Color(0xFFeeeeee),*/
                  brightness: Brightness.light
                  // Your accent color
                ),

                textTheme: TextTheme(
                  /* headline1 */
                  headlineLarge: const TextStyle(fontSize: 24.0,fontWeight: FontWeight.w800, color: Colors.black, height: 1.3),
                  /* headline2 */
                  headlineMedium: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w800, color: Colors.black, height: 1.3),
                  /* headline3 */
                  headlineSmall: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.w800, color: Colors.black, height: 1.3),
                  /* title1 */
                  displayLarge: const TextStyle(fontSize: 19.0, fontWeight: FontWeight.w800, color: Colors.black, height: 1.4),
                  /* title2  */
                  displayMedium:const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w800, color: Colors.black, height: 1.4),
                  /* title3 */
                  displaySmall: const TextStyle(fontSize: 17.0, fontWeight: FontWeight.w800, color: Colors.black, height: 1.3),
                  /* subtitle1 */
                  titleLarge: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700, color: Colors.black, height: 1.3),
                  /* subtitle2 */
                  titleMedium:const TextStyle(fontSize: 15.0, fontWeight: FontWeight.w700, color: Colors.black, height: 1.3),
                  /* subtitle3 */
                  titleSmall: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600, color: Colors.black, height: 1.2),
                  /* lable1 */
                  labelLarge: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500,color: Colors.black, height: 1.2),
                  /* lable2 */
                  labelMedium: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500,color: Colors.black, height: 1.2),
                  /* lable3 */
                  labelSmall: const TextStyle(fontSize: 13.0, fontWeight: FontWeight.w500,color: Colors.black, height: 1.2),
                  /* bodytext1 */
                  bodyLarge: const TextStyle(fontSize: 13.0, fontWeight: FontWeight.w600, color: Colors.black, height: 1.3),
                  /* bodytext2 */
                  bodyMedium: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500, color: Colors.black, height: 1.2),
                  /* caption */
                  bodySmall: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500, color: const Color(0xFF8c98a8).withOpacity(1.0), height: 1.7),
                ),
              )
                  : ThemeData(
                fontFamily: 'MotivaSansBold',
                brightness: Brightness.dark,
                primaryColor: const Color(0xFF252525),
                scaffoldBackgroundColor: const Color(0xFF2C2C2C),
                disabledColor: Colors.grey,
                primaryColorLight: Colors.white, // button text color constant dark and light theme
                floatingActionButtonTheme: FloatingActionButtonThemeData(elevation: 0, foregroundColor: Theme.of(context).primaryColor),
                iconTheme: const IconThemeData(
                    color: Color(0xFF9999aa)
                ),
                dividerColor: const Color(0xFF9999aa).withOpacity(0.1), // divider color
                hintColor: const  Color(0xFFaeaeae),
                /*focusColor: Color(0xFF00aa13).withOpacity(1),*/ // input focused border color
                focusColor: const  Color(0xFFfc8019).withOpacity(1.0), // input focused border color
                primaryColorDark:const   Color(0xFFfc8019), // main theme color light and dark theme
                colorScheme: Theme.of(context).colorScheme.copyWith(
                  /*secondary: Color(0xFF000000),*/
                    secondary: const Color(0xFFfc8019),// button color
                  primary: Colors.white, //  text color constant dark and light theme (white color)
                  background: Colors.white,// dynamic white color text in dark theme, // icon color
                  /*background: const Color(0xFF000000),
                  onBackground: const Color(0xFF2e2e2e),
                  primary: const Color(0xFF00aa13).withOpacity(1),
                  onPrimary: const Color(0xFFeeeeee),*/
                  brightness: Brightness.dark,

                ),


                textTheme: TextTheme(
                  headlineLarge: TextStyle(fontSize: 24.0,fontWeight: FontWeight.w800, color: const Color(0xFF9999aa).withOpacity(1) , height: 1.3),
                  headlineMedium: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w800, color: const Color(0xFF9999aa).withOpacity(1), height: 1.3),
                  headlineSmall: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w800, color: const Color(0xFF9999aa).withOpacity(1), height: 1.3),
                  displayLarge: TextStyle(fontSize: 19.0, fontWeight: FontWeight.w800, color: const Color(0xFF9999aa).withOpacity(1.0), height: 1.4),
                  displayMedium: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w800, color: const Color(0xFF9999aa).withOpacity(1.0), height: 1.4),
                  displaySmall: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w800, color: const Color(0xFF9999aa).withOpacity(1), height: 1.3),
                  titleLarge: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700,color: const Color(0xFF9999aa).withOpacity(1.0), height: 1.3),
                  titleMedium: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w700, color: const Color(0xFF9999aa).withOpacity(1), height: 1.3),
                  titleSmall: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600, color: const Color(0xFF9999aa).withOpacity(1), height: 1.2),
                  labelLarge: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500, color: const Color(0xFF9999aa).withOpacity(0.6), height: 1.2),
                  labelMedium : TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500, color: const Color(0xFF9999aa).withOpacity(0.6), height: 1.2),
                  labelSmall: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w500, color: const Color(0xFF9999aa).withOpacity(0.6), height: 1.2),
                  bodyLarge: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w600, color: const Color(0xFF9999aa).withOpacity(1), height: 1.3),
                  bodyMedium: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500,color: const Color(0xFF9999aa).withOpacity(1), height: 1.2),
                  bodySmall: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500, color: const Color(0xFF9999aa).withOpacity(0.6), height: 1.7),

                ),
              ));
        });
  }
}

