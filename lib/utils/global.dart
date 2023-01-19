import 'package:flutter/material.dart';

import 'package:kwetter/utils/colours.dart';

class Global {
  // api
  // static String tweetApiUrl = "http://10.0.2.2:5000/";
  // static String userApiUrl = "http://10.0.2.2:5198/";
  static String tweetApiUrl = "https://dev-kwetter-tweet.azurewebsites.net/";
  static String userApiUrl = "https://dev-kwetter.azurewebsites.net/";

  // url
  static String firebaseStorage = "gs://kwetter-f8b5a.appspot.com";

  // colors
  static Color backgroundColor = Colour.white;
  static Color primaryColor = Colour.blue;
  static Color tertiaryColor = Colour.greyLight;

  // shared preferences
  static String spUserId = "userId";
  static String spUserEmail = "userEmail";
  static String spUserUsername = "userUsername";
  static String spUserName = "userName";
  static String spUserBio = "userBio";
  static String spUserLocation = "userLocation";
  static String spUserUserPic = "userUserPic";
  static String spUserCreatedAt = "userCreatedAt";
  static String spUserAccessToken = "userAccessToken";
  static String spSearch = "search";
}
