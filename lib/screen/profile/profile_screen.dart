import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:kwetter/api/apiTweet.dart';
import 'package:kwetter/model/mTweet.dart';
import 'package:kwetter/utils/colours.dart';
import 'package:kwetter/utils/global.dart';
import 'package:kwetter/screen/base/welcome_screen.dart';
import 'package:kwetter/api/apiUser.dart';
import 'package:kwetter/widget/tweet.dart';

class ProfileScreen extends StatefulWidget {
  final bool myProfile;
  final int userId;
  const ProfileScreen({this.myProfile = true, this.userId = 0, super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLoading = true;
  String username = "",
      name = "",
      userPic =
          "https://cdn.icon-icons.com/icons2/1143/PNG/512/twitterlogooutline_80724.png",
      bio = "",
      location = "",
      createdAt = "";
  List<TweetModel> tweets = [];
  List<String> months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];
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

    if (widget.myProfile) {
      setProfile();
      // ignore: use_build_context_synchronously
      var getData = await Provider.of<ApiTweetService>(context, listen: false)
          .tweetGetByUserId(prefs.getInt(Global.spUserId));
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
    } else {
      getUser();
      // ignore: use_build_context_synchronously
      var getData = await Provider.of<ApiTweetService>(context, listen: false)
          .tweetGetByUserId(widget.userId);
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
    }

    setState(() {
      isLoading = false;
      tweets = tweets.reversed.toList();
    });
  }

  getUser() async {
    var getData = await Provider.of<ApiUserService>(context, listen: false)
        .userGet(widget.userId);

    if (getData.statusCode == 200) {
      username = getData.body["username"];
      name = getData.body["name"];
      bio = getData.body["bio"];
      location = getData.body["location"];
      createdAt = getData.body["createdAt"];
      userPic = getData.body["userPic"];
    }

    setState(() {});
  }

  setProfile() {
    username = "@${prefs.getString(Global.spUserUsername)}";
    name = prefs.getString(Global.spUserName);
    bio = prefs.getString(Global.spUserBio);
    location = prefs.getString(Global.spUserLocation);
    createdAt = prefs.getString(Global.spUserCreatedAt);
    userPic = prefs.getString(Global.spUserUserPic);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Container(
              padding: const EdgeInsets.only(top: 20),
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.topCenter,
              child: CircularProgressIndicator(
                color: Global.primaryColor,
              ),
            )
          : CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: Global.backgroundColor,
                  floating: false,
                  pinned: true,
                  expandedHeight: 235,
                  leading: BackButton(
                    color: Colour.black,
                  ),
                  elevation: 1,
                  actions: [
                    PopupMenuButton<int>(
                      icon: Icon(
                        Icons.adaptive.more,
                        color: Colour.black,
                      ),
                      onSelected: (item) => handleClick(item),
                      itemBuilder: (context) => [
                        const PopupMenuItem<int>(
                            value: 0, child: Text('Edit Profile')),
                        const PopupMenuItem<int>(
                            value: 1, child: Text('Logout')),
                      ],
                    ),
                  ],
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          color: Colour.black,
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 1.5)),
                      Text(
                        username,
                        style: TextStyle(
                          color: Global.tertiaryColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 80,
                                left: 16,
                                right: 16,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  isLoading?
                                  CircleAvatar(
                                    backgroundColor: Global.backgroundColor,
                                    radius: 30,
                                    backgroundImage: const AssetImage("assets/white.png"),
                                  )
                                  :
                                  CircleAvatar(
                                    backgroundColor: Global.backgroundColor,
                                    radius: 30,
                                    backgroundImage: NetworkImage(userPic),
                                  ),
                                  widget.myProfile
                                      ? Container()
                                      : MaterialButton(
                                          child: Container(
                                            height: 40,
                                            alignment: Alignment.center,
                                            width: 100,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: Global.backgroundColor,
                                              border: Border.all(
                                                color: Global.primaryColor,
                                                width: 1,
                                              ),
                                            ),
                                            child: Text(
                                              "Follow",
                                              style: TextStyle(
                                                color: Global.primaryColor,
                                              ),
                                            ),
                                          ),
                                          onPressed: () {},
                                        ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 15, 16, 0),
                                  child: Text(
                                    bio,
                                    style: TextStyle(
                                      color: Colour.black,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 8, 16, 0),
                                  child: Row(
                                    children: [
                                      if (location != "") ...[
                                        Icon(
                                          Icons.location_on,
                                          color: Colour.grey,
                                          size: 18,
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(left: 3),
                                        ),
                                        Text(
                                          location,
                                          style: TextStyle(
                                            color: Colour.grey,
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(left: 10),
                                        ),
                                      ],
                                      if (createdAt != "") ...[
                                        Icon(
                                          Icons.calendar_month_outlined,
                                          color: Colour.grey,
                                          size: 18,
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(left: 3),
                                        ),
                                        Text(
                                          "Joined ${months[int.parse(createdAt.split("-")[1]) - 1]} ${createdAt.split("-")[0]}",
                                          style: TextStyle(
                                            color: Colour.grey,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 10, 16, 0),
                                  child: Row(
                                    children: [
                                      Text(
                                        "10",
                                        style: TextStyle(
                                          color: Colour.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(left: 3),
                                      ),
                                      Text(
                                        "Following",
                                        style: TextStyle(
                                          color: Colour.grey,
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(left: 15),
                                      ),
                                      Text(
                                        "1",
                                        style: TextStyle(
                                          color: Colour.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(left: 3),
                                      ),
                                      Text(
                                        "Followers",
                                        style: TextStyle(
                                          color: Colour.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (tweets.isNotEmpty) {
                        return Tweet(
                          username: tweets[index].username ?? "",
                          name: tweets[index].name ?? "",
                          tweet: tweets[index].description ?? "",
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
                            backgroundImage: NetworkImage(userPic),
                          ),
                          onLongPress: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Warning"),
                                  content: const Text(
                                      "Would you like to delete this tweet?"),
                                  actions: [
                                    TextButton(
                                      child: const Text("Cancel"),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                    TextButton(
                                      child: const Text("Delete"),
                                      onPressed: () async {
                                        var getData =
                                            await Provider.of<ApiTweetService>(
                                                    context,
                                                    listen: false)
                                                .tweetDelete(tweets[index].id);
                                        if (getData.statusCode == 200) {
                                          setState(() {
                                            isLoading = true;
                                          });
                                          getAllTweets();
                                          // ignore: use_build_context_synchronously
                                          Navigator.pop(context);
                                        }
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      } else {
                        return Container(
                          padding: const EdgeInsets.only(
                              top: 16, left: 16, right: 16),
                          alignment: Alignment.topCenter,
                          child: Text(
                            "You haven't tweet yet",
                            style: TextStyle(
                              color: Colour.black,
                            ),
                          ),
                        );
                      }
                    },
                    childCount: tweets.isNotEmpty ? tweets.length : 1,
                  ),
                ),
              ],
            ),
    );
  }

  void handleClick(int item) async {
    switch (item) {
      case 0:
        break;
      case 1:
        await prefs.remove(Global.spUserId);
        await prefs.remove(Global.spUserEmail);
        await prefs.remove(Global.spUserUsername);
        await prefs.remove(Global.spUserName);
        await prefs.remove(Global.spUserBio);
        await prefs.remove(Global.spUserLocation);
        await prefs.remove(Global.spUserUserPic);
        await prefs.remove(Global.spUserCreatedAt);
        await prefs.remove(Global.spUserAccessToken);
        await prefs.remove(Global.spSearch);

        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => const WelcomeScreen(),
          ),
        );
        break;
    }
  }
}
