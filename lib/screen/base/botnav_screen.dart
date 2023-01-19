import 'package:flutter/material.dart';

import 'package:kwetter/utils/global.dart';
import 'package:kwetter/screen/home/home_screen.dart';
import 'package:kwetter/screen/search/search_screen.dart';
import 'package:kwetter/screen/profile/profile_screen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int currentIndex = 0;
  var pages = const [
    HomeScreen(),
    SearchScreen(),
    EmptyScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Global.backgroundColor,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Global.tertiaryColor),
            label: "",
            activeIcon: Icon(Icons.home, color: Global.primaryColor),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, color: Global.tertiaryColor),
            label: "",
            activeIcon: Icon(Icons.search, color: Global.primaryColor),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Global.tertiaryColor),
            label: "",
            activeIcon: Icon(Icons.person, color: Global.primaryColor),
          ),
        ],
        currentIndex: currentIndex,
        onTap: (index) {
          if (index == 2) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => const ProfileScreen(),
              ),
            );
          } else {
            setState(() {
              currentIndex = index;
            });
          }
        },
      ),
    );
  }
}

class EmptyScreen extends StatelessWidget {
  const EmptyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
