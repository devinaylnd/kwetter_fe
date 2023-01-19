import 'package:flutter/material.dart';
import 'package:kwetter/screen/profile/profile_screen.dart';
import 'package:provider/provider.dart';

import 'package:kwetter/api/apiTweet.dart';
import 'package:kwetter/utils/global.dart';
import 'package:kwetter/model/mTweet.dart';
import 'package:kwetter/widget/tweet.dart';
import 'package:kwetter/utils/colours.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;
  List<TweetModel> tweets = [];
  TextEditingController tweetController = TextEditingController();
  // ignore: prefer_typing_uninitialized_variables
  var prefs;

  @override
  void initState() {
    super.initState();
    getAllTweets();
  }

  getAllTweets() async {
    prefs = await SharedPreferences.getInstance();

    tweets.clear();
    // ignore: use_build_context_synchronously
    var getData = await Provider.of<ApiTweetService>(context, listen: false)
        .tweetGetBySearch({"description": ""});
    if (getData.body != null) {
      getData.body.map((item) {
        tweets.add(TweetModel()
          ..id = item["id"]
          ..description = item["description"]
          ..idUser = item["idUser"]
          ..username = item["username"]
          ..name = item["name"]
          ..totalLike = item["totalLike"]
          ..dateTime = item["dateTime"]
          ..userPic = item["userPic"]);
      }).toList();
    }

    setState(() {
      isLoading = false;
      tweets = tweets.reversed.toList();
      tweetController.clear;
      tweetController.text = "";
    });
  }

  sendTweet(context) async {
    var getData =
        await Provider.of<ApiTweetService>(context, listen: false).tweetCreate({
      "description": tweetController.text,
      "idUser": prefs.getInt(Global.spUserId),
      "username": prefs.getString(Global.spUserUsername),
      "name": prefs.getString(Global.spUserName),
      "totalLike": "0",
      "dateTime": DateTime.now().toString(),
      "userPic": prefs.getString(Global.spUserUserPic),
    });

    if (getData.statusCode == 200) {
      getAllTweets();
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Failed to send message. Try again later"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Global.backgroundColor,
      appBar: AppBar(
        backgroundColor: Global.backgroundColor,
        elevation: 1,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            isLoading || prefs.getString(Global.spUserUserPic) == null?
            CircleAvatar(
              backgroundColor: Global.backgroundColor,
              radius: 15,
              backgroundImage: const AssetImage("assets/white.png"),
            )
            :
            CircleAvatar(
              backgroundColor: Global.backgroundColor,
              radius: 15,
              backgroundImage: NetworkImage(prefs.getString(Global.spUserUserPic)),
            ),
            Image.asset(
              "assets/logo.png",
              height: 25,
            ),
            const SizedBox(
              width: 30,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 2,
        backgroundColor: Global.primaryColor,
        child: const Icon(Icons.add),
        onPressed: () => showCustomBottomSheet(),
      ),
      body: isLoading
          ? Container(
              padding: const EdgeInsets.only(top: 20),
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.topCenter,
              child: CircularProgressIndicator(
                color: Global.primaryColor,
              ),
            )
          : 
          tweets.isEmpty?
          Container(
            padding: const EdgeInsets.only(top: 16),
            alignment: Alignment.topCenter,
            child: const Text(
              "Tweet or follow someone\nto get latest tweets.",
              textAlign: TextAlign.center,
            ),
          )
          :
          ListView(
              children: tweets.map<Widget>((item) {
                return Tweet(
                  username: item.username,
                  name: item.name,
                  tweet: item.description,
                  datetime: DateTime.now(),
                  userPic: isLoading?
                  CircleAvatar(
                    backgroundColor: Global.backgroundColor,
                    radius: 15,
                    backgroundImage: const AssetImage("assets/white.png"),
                  )
                  :
                  CircleAvatar(
                    backgroundColor: Global.backgroundColor,
                    radius: 15,
                    backgroundImage: NetworkImage(prefs.getString(Global.spUserUserPic)),
                  ),
                  onTap: () {
                    if (item.idUser == prefs.getInt(Global.spUserId)) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const ProfileScreen(),
                        ),
                      );
                    } else {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) => ProfileScreen(
                            myProfile: false,
                            userId: item.idUser,
                          ),
                        ),
                      );
                    }
                  },
                );
              }).toList(),
            ),
    );
  }

  showCustomBottomSheet() {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      isDismissible: false,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 1,
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 32, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      child: const Icon(Icons.close),
                      onTap: () => Navigator.pop(context),
                    ),
                    InkWell(
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(13, 8, 13, 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Global.primaryColor,
                        ),
                        child: Text(
                          "Tweet",
                          style: TextStyle(
                            color: Colour.white,
                          ),
                        ),
                      ),
                      onTap: () {
                        if (tweetController.text != "") sendTweet(context);
                      },
                    ),
                  ],
                ),
                const Padding(padding: EdgeInsets.only(top: 16)),
                TextField(
                  controller: tweetController,
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                  maxLength: 160,
                  decoration: const InputDecoration.collapsed(
                    hintText: "What's happening?",
                    border: InputBorder.none,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
