// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBLxS17XBVyatOuy9X9Nahc4_ijg1ktTTI',
    appId: '1:1046776824301:web:ecb318a874193fea5b67e4',
    messagingSenderId: '1046776824301',
    projectId: 'reddit-clone-c8cbe',
    authDomain: 'reddit-clone-c8cbe.firebaseapp.com',
    storageBucket: 'reddit-clone-c8cbe.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDtl0kJhqBdXq34SQvbTEjP4kBwyL_2LhA',
    appId: '1:1046776824301:android:31369018157410285b67e4',
    messagingSenderId: '1046776824301',
    projectId: 'reddit-clone-c8cbe',
    storageBucket: 'reddit-clone-c8cbe.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCqBkbCrK1hFQsSM-1Oa3ydwmD24esaSgQ',
    appId: '1:1046776824301:ios:3c7f4dec45b411b85b67e4',
    messagingSenderId: '1046776824301',
    projectId: 'reddit-clone-c8cbe',
    storageBucket: 'reddit-clone-c8cbe.appspot.com',
    iosClientId: '1046776824301-6ed6gc1pflaktl2250d7tbrmo0grmmub.apps.googleusercontent.com',
    iosBundleId: 'com.example.redditClone',
  );
}
