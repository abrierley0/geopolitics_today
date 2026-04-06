import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.android:
        return android;
      case TargetPlatform.linux:
        return web;
      default:
        throw UnsupportedError('Unsupported platform');
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyD8w-2rRp22GA8k4BBHTDducsgZg37MAaQ',
    appId: '1:20687711358:ios:495a0cf5092569a8f3fc2f',
    messagingSenderId: '20687711358',
    projectId: 'news-app-a01ea',
    storageBucket: 'news-app-a01ea.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD8w-2rRp22GA8k4BBHTDducsgZg37MAaQ',
    appId: '1:20687711358:ios:495a0cf5092569a8f3fc2f',
    messagingSenderId: '20687711358',
    projectId: 'news-app-a01ea',
    storageBucket: 'news-app-a01ea.appspot.com',
    iosClientId: 'YOUR_IOS_CLIENT_ID',
    iosBundleId: 'com.geopoliticstoday.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD8w-2rRp22GA8k4BBHTDducsgZg37MAaQ',
    appId: '1:20687711358:ios:495a0cf5092569a8f3fc2f',
    messagingSenderId: '20687711358',
    projectId: 'news-app-a01ea',
    storageBucket: 'news-app-a01ea.appspot.com',
  );
}