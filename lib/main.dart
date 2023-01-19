// import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:kwetter/api/apiTweet.dart';
import 'package:kwetter/api/apiUser.dart';
import 'package:kwetter/screen/base/splash_screen.dart';
import 'package:universal_io/io.dart';

void main() async {
  // HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  if(!Platform.environment.containsKey('FLUTTER_TEST')){
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiTweetService>(
          create: (_) => ApiTweetService.create(),
        ),
        Provider<ApiUserService>(
          create: (_) => ApiUserService.create(),
        ),
      ],
      child: MaterialApp(
        home: const SplashScreen(),
        theme: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
        ),
      ),
    );
  }
}

// class MyHttpOverrides extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext? context) {
//     return super.createHttpClient(context)
//       ..badCertificateCallback =
//           (X509Certificate cert, String host, int port) => true;
//   }
// }
