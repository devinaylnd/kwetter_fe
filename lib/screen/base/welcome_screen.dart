import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:kwetter/utils/global.dart';
import 'package:kwetter/utils/colours.dart';
import 'package:kwetter/screen/authentication/login_screen.dart';
import 'package:kwetter/screen/authentication/register_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Global.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Global.backgroundColor,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Image.asset(
          "assets/logo.png",
          height: 25,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 32, right: 32),
        child: Column(
          children: [
            Padding(
              padding:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
            ),
            Text(
              "See what's happening in the world right now.",
              style: TextStyle(
                color: Colour.black,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
            ),
            InkWell(
              key: const Key('createAccount'),
              child: Container(
                height: 40,
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Global.primaryColor,
                ),
                child: Text(
                  "Create Account",
                  style: TextStyle(
                    color: Colour.white,
                  ),
                ),
              ),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => const RegisterScreen(),
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 15)),
            Text.rich(
              TextSpan(
                text: 'Have an account already? ',
                style: TextStyle(
                  color: Colour.black,
                ),
                children: <InlineSpan>[
                  TextSpan(
                    text: 'Log In',
                    style: TextStyle(
                      color: Global.primaryColor,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const LoginScreen(),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
