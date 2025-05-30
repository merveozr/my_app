import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.windows:
        return windows;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions sadece Android, Web ve Windows için ayarlanmıştır.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBw6LY0of0vQyYcxP3205FzkW9-0eeEGO8',
    appId: '1:247768195864:android:632c4403a648929b4f346d',
    messagingSenderId: '247768195864',
    projectId: 'mobil-uygulama-ce7df',
    storageBucket: 'mobil-uygulama-ce7df.appspot.com',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBw6LY0of0vQyYcxP3205FzkW9-0eeEGO8',
    appId: '1:247768195864:web:3f05ad1561c50e01e97a14',
    messagingSenderId: '247768195864',
    projectId: 'mobil-uygulama-ce7df',
    authDomain: 'mobil-uygulama-ce7df.firebaseapp.com',
    storageBucket: 'mobil-uygulama-ce7df.appspot.com',
    measurementId: 'G-VMZ7NKY5V3',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBw6LY0of0vQyYcxP3205FzkW9-0eeEGO8',
    appId: '1:247768195864:web:d52d54e5fe773033e97a14',
    messagingSenderId: '247768195864',
    projectId: 'mobil-uygulama-ce7df',
    authDomain: 'mobil-uygulama-ce7df.firebaseapp.com',
    storageBucket: 'mobil-uygulama-ce7df.appspot.com',
    measurementId: 'G-5695VRQTVR',
  );
}
