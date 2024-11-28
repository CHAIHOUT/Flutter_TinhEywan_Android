// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AdminHeader extends StatefulWidget implements PreferredSizeWidget {
  const AdminHeader({super.key});

  @override
  State<AdminHeader> createState() => _AdminHeaderState();

  //add preferredsize and implement (ut to be used directly as the appBar property of a Scaffold)
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _AdminHeaderState extends State<AdminHeader> {
  var user_data;
  bool a = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Fun_getUser();
  }

  Future Fun_getUser() async {
    var myPref = await SharedPreferences.getInstance();
    var token = myPref.getString("TOKEN").toString();

    final res = await http.get(
      Uri.parse("https://tinheywan.com/api/getuser"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token"
      },
    );

    if (res.statusCode == 200) {
      var resbody = jsonDecode(res.body)['data'];
      setState(() {
        a = true;
        user_data = resbody;
      });
      // print(user_data);
    } else {
      // print("FAIL API");
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // backgroundColor: Colors.blue,
      automaticallyImplyLeading: false,
      title: Text(
        "Dashboard",
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        Container(
          margin: EdgeInsets.only(right: 15),
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: a
                  ? NetworkImage(user_data['image']) as ImageProvider
                  : AssetImage('assets/noimg.jpg'),
              fit: BoxFit.cover,
            ),
            color: Colors.amber,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Color.fromARGB(255, 173, 173, 173),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(255, 106, 106, 106)
                    .withOpacity(0.2), // Shadow color
                spreadRadius: 5, // Spread radius
                blurRadius: 7, // Blur radius
                offset: Offset(0, 3),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
