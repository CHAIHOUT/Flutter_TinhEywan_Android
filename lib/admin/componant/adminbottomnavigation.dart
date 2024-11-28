// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class AdminBottomNaviigation extends StatefulWidget {
  const AdminBottomNaviigation({super.key});

  @override
  State<AdminBottomNaviigation> createState() => _AdminBottomNaviigation();
}

class _AdminBottomNaviigation extends State<AdminBottomNaviigation> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: 70,
      // color: Colors.pink, // Uncomment this line if you want to set a specific color
      shape: CircularNotchedRectangle(),
      notchMargin: 10,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, 'displayadmin');
            },
            icon: Icon(Icons.home_outlined),
            iconSize: 30,
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, 'adminprofile');
            },
            icon: Icon(Icons.person_2_outlined),
            iconSize: 30,
          ),
        ],
      ),
    );
  }
}
