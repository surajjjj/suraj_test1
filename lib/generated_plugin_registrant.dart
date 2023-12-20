
// ignore: depend_on_referenced_packages
import 'package:audio_session/audio_session_web.dart';
// ignore: depend_on_referenced_packages
import "package:cloud_firestore_web/cloud_firestore_web.dart";
// ignore: depend_on_referenced_packages
import 'package:firebase_auth_web/firebase_auth_web.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_core_web/firebase_core_web.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_messaging_web/firebase_messaging_web.dart';
// ignore: depend_on_referenced_packages
import 'package:geolocator_web/geolocator_web.dart';
// ignore: depend_on_referenced_packages
import 'package:google_sign_in_web/google_sign_in_web.dart';
// ignore: depend_on_referenced_packages
import 'package:image_picker_for_web/image_picker_for_web.dart';
// ignore: depend_on_referenced_packages
import 'package:just_audio_web/just_audio_web.dart';
// ignore: depend_on_referenced_packages
import 'package:libphonenumber_web/libphonenumber_web.dart';
// ignore: depend_on_referenced_packages
import 'package:location_web/location_web.dart';
// ignore: depend_on_referenced_packages
import 'package:shared_preferences_web/shared_preferences_web.dart';
// ignore: depend_on_referenced_packages
import 'package:speech_to_text/speech_to_text_web.dart';
// ignore: depend_on_referenced_packages
import 'package:url_launcher_web/url_launcher_web.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

// ignore: public_member_api_docs
void registerPlugins(Registrar registrar) {
  AudioSessionWeb.registerWith(registrar);
  FirebaseFirestoreWeb.registerWith(registrar);
  FirebaseAuthWeb.registerWith(registrar);
  FirebaseCoreWeb.registerWith(registrar);
  FirebaseMessagingWeb.registerWith(registrar);
  GeolocatorPlugin.registerWith(registrar);
  GoogleSignInPlugin.registerWith(registrar);
  ImagePickerPlugin.registerWith(registrar);
  JustAudioPlugin.registerWith(registrar);
  LibPhoneNumberPlugin.registerWith(registrar);
  LocationWebPlugin.registerWith(registrar);
  SharedPreferencesPlugin.registerWith(registrar);
  SpeechToTextPlugin.registerWith(registrar);
  UrlLauncherPlugin.registerWith(registrar);
  registrar.registerMessageHandler();
}
