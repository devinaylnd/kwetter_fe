import 'package:crypt/crypt.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:kwetter/utils/global.dart';
import 'package:kwetter/utils/colours.dart';
import 'package:kwetter/api/apiUser.dart';
import 'package:kwetter/screen/base/botnav_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  login() async {
    try {
      final UserCredential user = await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passController.text,
      );
      
      if (user.user != null) {
        getUserByEmail();
      }
    } catch (error){
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(
        content: Text(error.toString().split("] ")[1]),
      ));
    }
  }

  getUserByEmail() async {
    var getData = await Provider.of<ApiUserService>(context, listen: false)
        .userGetByEmail({"email": emailController.text});

    if (getData.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(Global.spUserId, getData.body["id"]);
      await prefs.setString(Global.spUserEmail,
          getData.body.containsKey("email") ? getData.body["email"] : "");
      await prefs.setString(Global.spUserUsername,
          getData.body.containsKey("username") ? getData.body["username"] : "");
      await prefs.setString(Global.spUserName,
          getData.body.containsKey("name") ? getData.body["name"] : "");
      await prefs.setString(Global.spUserBio,
          getData.body.containsKey("bio") ? getData.body["bio"] : "");
      await prefs.setString(Global.spUserLocation,
          getData.body.containsKey("location") ? getData.body["location"] : "");
      await prefs.setString(Global.spUserUserPic,
          getData.body.containsKey("userPic") ? getData.body["userPic"] : "");
      await prefs.setString(
          Global.spUserCreatedAt,
          getData.body.containsKey("createdAt")
              ? getData.body["createdAt"]
              : "");

      // ignore: use_build_context_synchronously
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const BottomNavBar(),
        ),
        (Route<dynamic> route) => false,
      );
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Something went wrong. Please try again later :("),
      ));
    }
  }

  @override
  void dispose(){
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Global.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        backgroundColor: Global.backgroundColor,
        leading: BackButton(
          color: Colour.black,
        ),
        centerTitle: true,
        title: Image.asset(
          "assets/logo.png",
          height: 25,
        ),
      ),
      body: InkWell(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 32, right: 32, top: 20),
              child: Text(
                "Log In",
                style: TextStyle(
                  color: Colour.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 32, right: 32, top: 20),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 10,
                  ),
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                    borderSide: BorderSide(
                      width: 1,
                      color: Global.primaryColor,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                    borderSide: BorderSide(
                      width: 1,
                      color: Global.tertiaryColor,
                    ),
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    borderSide: BorderSide(
                      width: 1,
                    ),
                  ),
                  labelText: 'Email',
                  fillColor: Global.backgroundColor,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 32, right: 32, top: 10),
              child: TextField(
                controller: passController,
                obscureText: true,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 10,
                  ),
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                    borderSide: BorderSide(
                      width: 1,
                      color: Global.primaryColor,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                    borderSide: BorderSide(
                      width: 1,
                      color: Global.tertiaryColor,
                    ),
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    borderSide: BorderSide(
                      width: 1,
                    ),
                  ),
                  labelText: "Password",
                  fillColor: Global.backgroundColor,
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: FractionalOffset.bottomRight,
                child: MaterialButton(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    height: 40,
                    alignment: Alignment.center,
                    width: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Global.primaryColor,
                    ),
                    child: Text(
                      "Sign In",
                      style: TextStyle(
                        color: Colour.white,
                      ),
                    ),
                  ),
                  onPressed: () {
                    if (emailController.text.isNotEmpty &&
                        passController.text.isNotEmpty) {
                      login();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Email / Password is empty"),
                      ));
                    }
                  },
                ),
              ),
            ),
          ],
        ),
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      ),
    );
  }
}
