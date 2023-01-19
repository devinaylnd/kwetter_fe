import 'package:flutter/material.dart';

import 'package:kwetter/utils/global.dart';
import 'package:kwetter/utils/colours.dart';

class Tweet extends StatelessWidget {
  final String? tweet;
  final String? username;
  final String? name;
  final String? pic;
  final int like;
  final int retweet;
  final int reply;
  final DateTime? datetime;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Widget? userPic;

  const Tweet({
    super.key,
    this.tweet,
    this.username,
    this.name,
    this.pic,
    this.like = 0,
    this.retweet = 0,
    this.reply = 0,
    this.datetime,
    this.onTap,
    this.onLongPress,
    this.userPic,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
        decoration: BoxDecoration(
          color: Global.backgroundColor,
          border: Border(
            bottom: BorderSide(
              color: Global.tertiaryColor,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            userPic ?? Container(),
            const Padding(padding: EdgeInsets.only(left: 10)),
            SizedBox(
              width: MediaQuery.of(context).size.width - 92,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(padding: EdgeInsets.only(top: 5)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 113,
                        child: RichText(
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '@${username!}  ',
                                style: TextStyle(
                                  color: Colour.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: name!,
                                style: TextStyle(
                                  color: Colour.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Text(
                        "1m",
                        style: TextStyle(
                          color: Colour.grey,
                        ),
                      ),
                    ],
                  ),
                  const Padding(padding: EdgeInsets.only(top: 3)),
                  Text(
                    tweet!,
                    style: TextStyle(
                      color: Colour.black,
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 10)),
                  Row(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        width: (MediaQuery.of(context).size.width - 92) / 3,
                        child: Icon(
                          Icons.mode_comment_outlined,
                          size: 18,
                          color: Colour.grey.withOpacity(0.8),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        width: (MediaQuery.of(context).size.width - 92) / 3,
                        child: Icon(
                          Icons.repeat_outlined,
                          size: 18,
                          color: Colour.grey.withOpacity(0.8),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        width: (MediaQuery.of(context).size.width - 92) / 3,
                        child: Icon(
                          Icons.favorite,
                          size: 18,
                          color: Global.tertiaryColor,
                        ),
                      ),
                    ],
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
