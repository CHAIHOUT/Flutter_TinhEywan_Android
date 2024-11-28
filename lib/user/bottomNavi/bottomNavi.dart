// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, unnecessary_string_interpolations, file_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class BottomNaviigation extends StatefulWidget {
  const BottomNaviigation({super.key});

  @override
  State<BottomNaviigation> createState() => BottomNaviigationState();
}

class BottomNaviigationState extends State<BottomNaviigation> {
  var countCart = 0;

  @override
  void initState() {
    super.initState();
    Fun_getCountCart();
  }

  Future Fun_getCountCart() async {
    var myPref = await SharedPreferences.getInstance();
    var token = myPref.getString("TOKEN").toString();

    final res = await http.get(
      Uri.parse("https://tinheywan.com/api/getcart"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token"
      },
    );
    if (res.statusCode == 200) {
      var resbody = jsonDecode(res.body)['data'];
      setState(() {
        countCart = resbody.length;
      });
      // print("TOTAL COUNT = ${resbody.length}");
    } else {
      // print("FAIL API");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: MediaQuery.of(context).size.height * 0.08,
      // color: Colors.pink, // Uncomment this line if you want to set a specific color
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, 'display');
              },
              icon: Icon(Icons.home)),
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, 'search');
              },
              icon: Icon(Icons.search)),
          Stack(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, 'cart');
                },
                child: Stack(
                  children: [
                    Positioned(
                      child: IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, 'cart');
                        },
                        icon: Icon(Icons.shopping_cart_outlined),
                      ),
                    ),
                    Positioned(
                      top: 5,
                      right: 3,
                      child: Container(
                        width: 20,
                        height: 20,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            border: Border.all(
                              color: Colors.white, // Border color
                              width: 1.0, // Border width
                            ),
                            shape: BoxShape.circle),
                        child: ClipOval(
                          child: Text(
                            "${countCart.toString()}",
                            style: TextStyle(fontSize: 10, color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, 'profile');
              },
              icon: Icon(Icons.person)),
        ],
      ),
    );
  }
}
