import 'package:flutter/material.dart';
import 'package:kwetter/model/mTweet.dart';
import 'package:provider/provider.dart';

import 'package:kwetter/utils/colours.dart';
import 'package:kwetter/utils/global.dart';
import 'package:kwetter/widget/tweet.dart';
import 'package:kwetter/api/apiTweet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isLoading = true;
  // ignore: prefer_typing_uninitialized_variables
  var prefs;

  @override
  void initState() {
    super.initState();

    checkSharePref();
  }

  checkSharePref() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoading = false;
    });
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
            isLoading?
            CircleAvatar(
              backgroundColor: Global.backgroundColor,
              radius: 15,
              backgroundImage: const AssetImage("assets/white.png")
            )
            :
            CircleAvatar(
              backgroundColor: Global.backgroundColor,
              radius: 15,
              backgroundImage: NetworkImage(prefs.getString(Global.spUserUserPic)),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 8),
            ),
            Flexible(
              flex: 1,
              child: TextField(
                decoration: InputDecoration(
                  isDense: true,
                  filled: true,
                  fillColor: Global.tertiaryColor.withOpacity(0.15),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
                  hintText: 'Search',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(45.0),
                    borderSide: BorderSide(
                      width: 1.0,
                      color: Global.tertiaryColor,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(45.0),
                    borderSide: BorderSide(
                      width: 1.0,
                      color: Global.tertiaryColor,
                    ),
                  ),
                ),
                readOnly: true,
                onTap: () {
                  showSearch(
                    context: context,
                    delegate: CustomSearchDelegate(),
                  );
                },
              ),
            ),
            const SizedBox(
              width: 30,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                "Trending",
                style: TextStyle(
                  color: Colour.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
            ),
            InkWell(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  "#MAMAVOTE",
                  style: TextStyle(
                    color: Colour.black,
                  ),
                ),
              ),
              onTap: () {},
            ),
            InkWell(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  "#COFFEE",
                  style: TextStyle(
                    color: Colour.black,
                  ),
                ),
              ),
              onTap: () {},
            ),
            InkWell(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  "#BREAKINGNEWS",
                  style: TextStyle(
                    color: Colour.black,
                  ),
                ),
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  // ignore: prefer_typing_uninitialized_variables
  var prefs;

  Future<List<TweetModel>> searchTweet(context) async {
    prefs = await SharedPreferences.getInstance();
    List<String>? items = prefs.getStringList(Global.spSearch) ?? [];
    int check = 0;
    for (var item in items!) {
      if (item == query) {
        check = 1;
        break;
      }
    }

    if (check == 0) items.add(query);
    await prefs.setStringList(Global.spSearch, items);

    List<TweetModel> tweets = [];
    var getData = await Provider.of<ApiTweetService>(context, listen: false)
        .tweetGetBySearch({"description": query});
    if (getData.statusCode == 200) {
      for (int i = getData.body.length - 1; i >= 0; i--) {
        tweets.add(TweetModel()
          ..id = getData.body[i]["id"]
          ..description = getData.body[i]["description"]
          ..username = getData.body[i]["username"]
          ..idUser = getData.body[i]["idUser"]
          ..name = getData.body[i]["name"]
          ..dateTime = getData.body[i]["dateTime"]
          ..userPic = getData.body[i]["userPic"]);
      }
    }
    return tweets;
  }

  Future<List<String>> getHistory() async {
    prefs = await SharedPreferences.getInstance();
    List<String> items = prefs.getStringList(Global.spSearch) ?? [];
    return items;
  }

  @override
  TextStyle? get searchFieldStyle => const TextStyle(fontSize: 15);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [Container()];
    // return [
    //   IconButton(
    //     icon: const Icon(Icons.clear),
    //     onPressed: () {
    //       query = '';
    //     },
    //   ),
    // ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<TweetModel>>(
      future: searchTweet(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            padding: const EdgeInsets.only(top: 20),
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.topCenter,
            child: CircularProgressIndicator(
              color: Global.primaryColor,
            ),
          );
        } else {
          if (snapshot.hasError) {
            return Container();
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Tweet(
                  username: snapshot.data![index].username,
                  name: snapshot.data![index].name,
                  tweet: snapshot.data![index].description,
                  datetime: DateTime.now(),
                  userPic: CircleAvatar(
                    backgroundColor: Global.backgroundColor,
                    radius: 15,
                    backgroundImage: NetworkImage(snapshot.data![index].userPic ?? ""),
                  ),
                );
              },
            );
          }
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: getHistory(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Container();
        } else {
          if (snapshot.data!.isEmpty) {
            return Container(
              padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
              alignment: Alignment.topCenter,
              child: Text(
                "Try searching for keywords",
                style: TextStyle(
                  color: Colour.black,
                ),
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ListView.builder(
                itemCount: snapshot.data!.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 16),
                      child: Text(
                        "Recent",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colour.black,
                          fontSize: 17,
                        ),
                      ),
                    );
                  } else {
                    return InkWell(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        child: Text(
                          snapshot.data![index - 1],
                          style: TextStyle(
                            color: Colour.black,
                          ),
                        ),
                      ),
                      onTap: () {},
                    );
                  }
                },
              ),
            );
          }
        }
      },
    );
  }
}
