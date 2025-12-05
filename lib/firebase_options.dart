// Placeholder Firebase config. Replace values by running `flutterfire configure`
// and regenerating this file, or fill with your project's settings.
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

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
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        return linux;
      case TargetPlatform.fuchsia:
        throw UnsupportedError(
          'Fuchsia platform is not supported by this configuration.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDulUmVLM4sbDFJLqctDbG1V0e8oOq4E-I',
    appId: '1:945231253344:web:73ba147ae53f8870975805',
    messagingSenderId: '945231253344',
    projectId: 'uas-flutter-2022110061',
    authDomain: 'uas-flutter-2022110061.firebaseapp.com',
    storageBucket: 'uas-flutter-2022110061.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB5nzYCu0s3oDtUWCiJ2izhgrbX9UgZQgU',
    appId: '1:945231253344:android:26b904d73c0e2070975805',
    messagingSenderId: '945231253344',
    projectId: 'uas-flutter-2022110061',
    storageBucket: 'uas-flutter-2022110061.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBEcHM3fIv-lnO5pZIK1hi74FvO51oxOTA',
    appId: '1:945231253344:ios:cea6eb2a524086fe975805',
    messagingSenderId: '945231253344',
    projectId: 'uas-flutter-2022110061',
    storageBucket: 'uas-flutter-2022110061.firebasestorage.app',
    iosBundleId: 'com.example.doitnow',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBEcHM3fIv-lnO5pZIK1hi74FvO51oxOTA',
    appId: '1:945231253344:ios:cea6eb2a524086fe975805',
    messagingSenderId: '945231253344',
    projectId: 'uas-flutter-2022110061',
    storageBucket: 'uas-flutter-2022110061.firebasestorage.app',
    iosBundleId: 'com.example.doitnow',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDulUmVLM4sbDFJLqctDbG1V0e8oOq4E-I',
    appId: '1:945231253344:web:23270fc59d70210d975805',
    messagingSenderId: '945231253344',
    projectId: 'uas-flutter-2022110061',
    authDomain: 'uas-flutter-2022110061.firebaseapp.com',
    storageBucket: 'uas-flutter-2022110061.firebasestorage.app',
  );

  static const FirebaseOptions linux = FirebaseOptions(
    apiKey: 'REPLACE_ME',
    appId: 'REPLACE_ME',
    messagingSenderId: 'REPLACE_ME',
    projectId: 'REPLACE_ME',
  );
}
