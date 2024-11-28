// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, prefer_interpolation_to_compose_strings, non_constant_identifier_names, prefer_typing_uninitialized_variables, use_build_context_synchronously, unused_import

import 'dart:async';

import 'package:ecommerce/user/bottomNavi/bottomNavi.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter_hooks/flutter_hooks.dart';

class CartProduct extends StatefulWidget {
  const CartProduct({super.key});

  @override
  State<CartProduct> createState() => _CartProductState();
}

class _CartProductState extends State<CartProduct> {
  // var total = 0.0;
  bool a = false;
  var t = 0.0;
  double t2 = 0.00;
  // for stop loading when delete
  bool doubleReload = false;

  //Stream build (No need setState)
  final StreamController<double> _sumController = StreamController();

  // Glabalkey for call fun form another class to interact
  final GlobalKey<BottomNaviigationState> bottomNavKey =
      GlobalKey<BottomNaviigationState>();

  Future Fun_getCart() async {
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
      return resbody;
    } else {
      // print("FAIL API");
      return "";
    }
  }

  Future Fun_removeCart(id) async {
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

    final res = await http.delete(
      Uri.parse("https://tinheywan.com/api/getcartdelete/" + id),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token"
      },
    );

    if (res.statusCode == 200) {
      doubleReload = true; // prevent double reload => do to no see reload icon
      // call another function
      bottomNavKey.currentState?.Fun_getCountCart();
      setState(() {}); // reload
    } else {
      // print("FAIL API");
    }
    //END LOADING SCREEN
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            // CART PRODUCR
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.1,
              child: Text(
                "CART PRODUCT",
                style: TextStyle(fontSize: 18),
              ),
            ),

            // CART LIST
            Container(
                width: double.infinity,
                //530
                height: MediaQuery.of(context).size.height * 0.65,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height,
                        child: FutureBuilder(
                          future: Fun_getCart(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              if (doubleReload == false) {
                                // no see reload Icon when remove cart
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                            }

                            // Calculate the total sum
                            double newTotal =
                                snapshot.data!.fold(0.0, (sum, item) {
                              return sum +
                                  double.parse(item['price'].toString());
                            });

                            // Autoreload after end listview builder
                            // Use addPostFrameCallback to update the total after the frame is rendered
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (newTotal != t2) {
                                // Only update if the total has changed
                                // Double reload cuz sum and set total
                                // setState(() {
                                //   t2 = newTotal;
                                // });
                                _sumController.add(t2 = newTotal);
                              }
                            });

                            return ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index) {
                                  String img;

                                  if (snapshot.data[index]['type'] ==
                                      "ACCESSORY") {
                                    img = 'assets/accessory5.webp';
                                  } else if (snapshot.data[index]['type'] ==
                                      "MATERIAL") {
                                    img = 'assets/material.jpg';
                                  } else if (snapshot.data[index]['type'] ==
                                      "CLOTHES") {
                                    img = 'assets/cloth.jpg';
                                  } else {
                                    img = 'assets/other.jpg';
                                  }

                                  return Card(
                                    child: InkWell(
                                      // use InkWell for onTap()
                                      onTap: () {
                                        var id = snapshot.data[index]
                                                ['eywan_id']
                                            .toString();
                                        Navigator.pushNamed(context, 'detail',
                                            arguments: id);
                                      },
                                      child: Container(
                                        width: 380,
                                        height: 150,
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Color.fromARGB(
                                              255, 236, 245, 253),
                                        ),
                                        child: Row(
                                          children: [
                                            // IMAGE
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Image.asset(
                                                img,
                                                width: 200,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            //BODY
                                            Expanded(
                                              child: Container(
                                                padding:
                                                    EdgeInsets.only(left: 10),
                                                // width: 155,

                                                child: Row(
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          top: 10, bottom: 10),
                                                      // width: 100,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.3,
                                                      height:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .height,
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            width:
                                                                double.infinity,
                                                            height: 50,
                                                            child: Text(
                                                              snapshot.data[
                                                                      index]
                                                                  ['title'],
                                                              style: TextStyle(
                                                                fontSize: 20,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        56,
                                                                        61,
                                                                        65),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            height: 30,
                                                            child: Text(
                                                              snapshot.data[
                                                                      index]
                                                                  ['type'],
                                                              style: TextStyle(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          56,
                                                                          61,
                                                                          65),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                            ),
                                                          ),
                                                          Container(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            height: 30,
                                                            child: Text(
                                                              "\$" +
                                                                  snapshot.data[
                                                                          index]
                                                                      ['price'],
                                                              style: TextStyle(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          56,
                                                                          61,
                                                                          65),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),

                                                    // Remove
                                                    Expanded(
                                                      child: Container(
                                                        height: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .height,
                                                        child: CircleAvatar(
                                                          radius: 20,
                                                          backgroundColor:
                                                              Color.fromARGB(
                                                                  255,
                                                                  56,
                                                                  61,
                                                                  65),
                                                          child: IconButton(
                                                              onPressed: () {
                                                                var id = snapshot
                                                                    .data[index]
                                                                        ['id']
                                                                    .toString();
                                                                Fun_removeCart(
                                                                    id);
                                                              },
                                                              icon: Icon(
                                                                Icons.remove,
                                                                color: Colors
                                                                    .white,
                                                              )),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                });
                          },
                        ),
                      ),
                    )
                  ],
                )),

            //TOTAL
            Expanded(
              child: Container(
                  width: double.infinity,
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 50,
                        child: Row(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              width: 150,
                              height: MediaQuery.of(context)
                                  .size
                                  .height, //height : 100%
                              child: Text(
                                "Total Payment :",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 56, 61, 65)),
                              ),
                            ),
                            Expanded(
                                child: StreamBuilder<double>(
                                    stream: _sumController.stream,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Text("");
                                      } else {
                                        return Container(
                                          padding: EdgeInsets.only(right: 20),
                                          height: MediaQuery.of(context)
                                              .size
                                              .height,
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            // "\$${t2.toStringAsFixed(2)}",
                                            "\$${snapshot.data?.toStringAsFixed(2)}",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.amber[700]),
                                          ),
                                        );
                                      }
                                    }))
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(10),
                          child: ElevatedButton(
                              onPressed: () {
                                // makePayment();
                                Navigator.pushNamed(context, 'submitcheckout');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromARGB(255, 56, 61, 65),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      8), // Set the border radius
                                ),
                              ),
                              child: Text("Checkout Now",
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.white))),
                        ),
                      )
                    ],
                  )),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNaviigation(
        // pass key
        key: bottomNavKey,
      ),
    );
  }
}
