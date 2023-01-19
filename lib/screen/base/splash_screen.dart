import 'dart:async';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:kwetter/screen/base/welcome_screen.dart';
import 'package:kwetter/screen/base/botnav_screen.dart';
import 'package:kwetter/utils/global.dart';
import 'package:universal_io/io.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    
    if(!Platform.environment.containsKey('FLUTTER_TEST')){
      checkPermission();
    }
  }

  checkPermission() async {
    var status = await Permission.storage.request();
    if (status.isDenied) {
      checkPermission();
    } else {
      var prefs = await SharedPreferences.getInstance();
      Timer(const Duration(milliseconds: 1500), () {
        if (prefs.getString(Global.spUserEmail) != "" &&
            prefs.getString(Global.spUserEmail) != null) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (BuildContext context) => const BottomNavBar(),
            ),
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (BuildContext context) => const WelcomeScreen(),
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Global.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 100,
            ),
            Image.asset(
              "assets/logo.png",
              width: MediaQuery.of(context).size.width / 3,
            ),
            const SizedBox(
              height: 100,
              child: Text("v1.0"),
            ),
          ],
        ),
      ),
    );
  }
}
