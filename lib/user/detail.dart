// ignore_for_file: prefer_const_constructors, unused_element, unused_import, unused_local_variable, prefer_typing_uninitialized_variables, non_constant_identifier_names, prefer_interpolation_to_compose_strings, use_build_context_synchronously, sized_box_for_whitespace, deprecated_member_use

import 'package:ecommerce/user/bottomNavi/bottomNavi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Detail extends StatefulWidget {
  final String id;

  const Detail({super.key, required this.id});

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  int _activePage = 0;

  var eywan;
  var eywan_image;
  bool a = false;
  bool b = false;

  // Glabalkey for call fun form another class to interact
  final GlobalKey<BottomNaviigationState> bottomNavKey =
      GlobalKey<BottomNaviigationState>();

  @override
  void initState() {
    super.initState();
    Fun_getEywan();
    Fun_getEywanImage();
  }

  Future Fun_getEywanImage() async {
    var myPref = await SharedPreferences.getInstance();
    var token = myPref.getString("TOKEN").toString();

    final res = await http.get(
      Uri.parse("https://tinheywan.com/api/geteywanimagebyid/" + widget.id),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token"
      },
    );
    if (res.statusCode == 200) {
      var resbody = jsonDecode(res.body)['data'];
      setState(() {
        b = true;
        eywan_image = resbody;
      });
      // $eywan_image['image']
      // print(eywan_image);
    } else {
      // print("FAIL API");
      return "";
    }
  }

  Future Fun_getEywan() async {
    var myPref = await SharedPreferences.getInstance();
    var token = myPref.getString("TOKEN").toString();

    final res = await http.get(
      Uri.parse("https://tinheywan.com/api/f_getEywanbyid/" + widget.id),
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
        eywan = resbody;
      });
      // $eywan_image['image']
      // print(eywan);
    } else {
      // print("FAIL API");
      return "";
    }
  }

  // ADD TO CART
  Future Fun_addToCart(
      title, description, type, price, status, eywan_id) async {
    var myPref = await SharedPreferences.getInstance();
    var token = myPref.getString("TOKEN").toString();

    //LOADING SCREEN
    showDialog(
      context: context,
      barrierDismissible:
          false, // Prevent closing the dialog by tapping outside
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(), // The loading spinner
        );
      },
    );

    var data = json.encode({
      "title": title.toString(),
      "description": description.toString(),
      "type": type.toString(),
      "price": price.toString(),
      "status": status.toString(),
      "eywan_id": eywan_id,
    });

    final res = await http.post(Uri.parse("https://tinheywan.com/api/cart"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token"
        },
        body: data);

    if (res.statusCode == 200) {
      // call another function
      bottomNavKey.currentState?.Fun_getCountCart();
      //END LOADING SCREEN
      Navigator.of(context).pop();
      final snackBar = SnackBar(
        content: const Text('Add To Cart Successful !'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // Implement code to undo the action.
          },
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      // print("FAIL API");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      // prevent input overflow border
      resizeToAvoidBottomInset: false,
      body: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              // Carasul slider
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.3,
                    color: Color.fromARGB(255, 236, 245, 253),
                    child: PageView.builder(
                        itemCount: b ? eywan_image.length : 1,
                        pageSnapping: true,
                        onPageChanged: (value) => {
                              setState(() {
                                _activePage = value;
                              })
                            },
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.all(10),
                            child: b
                                ? Image.network(
                                    eywan_image[index]['image'],
                                    fit: BoxFit.fill,
                                  )
                                : Center(child: CircularProgressIndicator()),
                          );
                        }),
                  ),
                  // Indicator
                  Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: Colors.transparent,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List<Widget>.generate(
                              b ? eywan_image.length : 0,
                              (index) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: CircleAvatar(
                                      radius: 4,
                                      backgroundColor: _activePage == index
                                          ? Colors.yellow
                                          : Colors.grey,
                                    ),
                                  ))),
                    ),
                  ),
                ],
              ),
              //TITLE & PRICE
              Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 10, right: 10),
                  width: double.infinity,
                  height: 80,
                  child: Row(
                    children: [
                      Container(
                        width: 230,
                        alignment: Alignment.centerLeft,
                        height: MediaQuery.of(context).size.height,
                        child: Text(
                          a ? eywan['title'] : "",
                          style: TextStyle(
                              color: Color.fromARGB(255, 56, 61, 65),
                              fontSize: 20,
                              fontWeight: FontWeight.w800),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          height: MediaQuery.of(context).size.height,
                          child: Text(
                            a ? "\$" + eywan['price'] : "",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.amber[600]),
                          ),
                        ),
                      )
                    ],
                  )),
              // TYPE
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                width: double.infinity,
                height: 50,
                child: Text(
                  a ? eywan['type'] : "",
                  style: TextStyle(
                      color: Color.fromARGB(255, 56, 61, 65),
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              ),
              // Description
              SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.23,
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        alignment: Alignment.centerLeft,
                        width: double.infinity,
                        height: 30,
                        child: Text(
                          "Description :",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w900),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          height: 100,
                          width: double.infinity,
                          child: Text(
                            a ? eywan['description'] : "",
                            style:
                                TextStyle(color: Colors.black.withOpacity(0.5)),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              //Button
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  child: ElevatedButton(
                      onPressed: () {
                        var a = eywan['title'];
                        var title = eywan['title'];
                        var description = eywan['description'];
                        var type = eywan['type'];
                        var price = eywan['price'];
                        var status = eywan['status'];
                        int eywan_id = eywan['id'];
                        Fun_addToCart(
                            title, description, type, price, status, eywan_id);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 56, 61, 65),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(8), // Set the border radius
                        ),
                      ),
                      child: Text("ADD TO CART",
                          style: TextStyle(fontSize: 10, color: Colors.white))),
                ),
              )
            ],
          )),
      bottomNavigationBar: BottomNaviigation(
        // pass key
        key: bottomNavKey,
      ),
    );
  }
}
