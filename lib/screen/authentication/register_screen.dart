import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:kwetter/utils/global.dart';
import 'package:kwetter/utils/colours.dart';
import 'package:kwetter/api/apiUser.dart';
import 'package:kwetter/screen/base/botnav_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  PageController pageController = PageController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  String accessToken = "";
  // ignore: prefer_typing_uninitialized_variables
  var _image;

  checkAuth() async {
    try {
      final UserCredential user = await 
        _auth.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passController.text,
      );

      if (user.user != null) {
        accessToken = await user.user!.getIdToken();
        pageController.nextPage(
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeIn,
        );
      }
    } catch (error){
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(
        content: Text(error.toString().split("] ")[1]),
      ));
    }
  }

  createAccount() async {
    String getImageUrl = await uploadToFirebase();
    var getData =
        // ignore: use_build_context_synchronously
        await Provider.of<ApiUserService>(context, listen: false).userCreate({
      "email": emailController.text,
      "username": usernameController.text,
      "name": nameController.text,
      "bio": bioController.text,
      "location": locationController.text,
      "userPic": getImageUrl,
      "createdAt": DateTime.now().toString(),
      "accessToken" : accessToken,
    });

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
      await prefs.setString(Global.spUserAccessToken,
          getData.body.containsKey("accessToken") ? getData.body["accessToken"] : "");

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
        content: Text("Failed to create a new account"),
      ));
    }
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
                "Create your account",
                style: TextStyle(
                  color: Colour.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height -
                  210 -
                  MediaQuery.of(context).viewInsets.bottom,
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: pageController,
                children: [
                  firstPage(),
                  secondPage(),
                ],
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
                      "Next",
                      style: TextStyle(
                        color: Colour.white,
                      ),
                    ),
                  ),
                  onPressed: () {
                    if (pageController.page == 0) {
                      if (emailController.text.isNotEmpty &&
                          passController.text.isNotEmpty) {
                          checkAuth();
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Email / Password is empty"),
                        ));
                      }
                    } else {
                      if (usernameController.text.isNotEmpty &&
                          nameController.text.isNotEmpty) {
                        createAccount();
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Username and name can not be empty"),
                        ));
                      }
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

  firstPage() {
    return ListView(
      padding: const EdgeInsets.only(left: 32, right: 32, top: 20),
      children: [
        TextField(
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
        Padding(
          padding: const EdgeInsets.only(top: 10),
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
      ],
    );
  }

  secondPage() {
    return ListView(
      children: [
        InkWell(
          onTap: () => checkPermission(),
          child: Center(
            child: _image == null?
            Container(
              margin: const EdgeInsets.only(top: 10),
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Global.primaryColor,
              ),
              child: Icon(
                Icons.add,
                color: Colour.white,
                size: 40,
              ),
            )
            :
            CircleAvatar(
              backgroundColor: Global.primaryColor,
              radius: 50,
              backgroundImage: FileImage(_image),
              ),
            ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 32, right: 32, top: 20),
          child: TextField(
            controller: usernameController,
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
              labelText: 'Username',
              fillColor: Global.backgroundColor,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 32, right: 32, top: 10),
          child: TextField(
            controller: nameController,
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
              labelText: "Name",
              fillColor: Global.backgroundColor,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 32, right: 32, top: 10),
          child: TextField(
            controller: bioController,
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
              labelText: "Bio",
              fillColor: Global.backgroundColor,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 32, right: 32, top: 10),
          child: TextField(
            controller: locationController,
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
              labelText: "Location",
              fillColor: Global.backgroundColor,
            ),
          ),
        ),
      ],
    );
  }

  checkPermission() async {
    var status = await Permission.camera.request();
    if (status.isDenied) {
      checkPermission();
    } else {
      getImage();
    }
  }

  getImage() async {
    ImagePicker picker = ImagePicker();
    XFile? pickedFile;
    pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  uploadToFirebase() async {
    final path = "images/${_auth.currentUser!.uid}";
    final ref = FirebaseStorage.instanceFor(bucket: Global.firebaseStorage).ref().child(path);
    UploadTask uploadTask = ref.putFile(_image);
    TaskSnapshot snapshot = await uploadTask;
    var imageUrl = await snapshot.ref.getDownloadURL();
    return imageUrl.toString();
  }
}
