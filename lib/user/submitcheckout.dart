// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings, sized_box_for_whitespace, unused_import, non_constant_identifier_names, prefer_typing_uninitialized_variables, use_build_context_synchronously

// Stream builder
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter_hooks/flutter_hooks.dart';
//STRIPE
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;

class SubmitCheckout extends StatefulWidget {
  const SubmitCheckout({super.key});

  @override
  State<SubmitCheckout> createState() => _SubmitCheckoutState();
}

class _SubmitCheckoutState extends State<SubmitCheckout> {
  // var total = 0.0;
  bool a = false;
  var t = 0.0;
  double t2 = 0.0;
  bool doubleReload = false;

  // Address
  var v_street = "";
  var v_khan = "";
  var v_province = "";
  var v_country = "";

  var v_detail;
  var v_tel;
  var v_contact;
  var v_photo = "";

  //STRIPE
  Map<String, dynamic>? paymentIntent;

  //Stream build (No need setState)
  final StreamController<double> _sumController = StreamController();

  // = UseEffect
  @override
  void initState() {
    super.initState();
    Fun_getMarkAddress();
  }

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
      //END LOADING SCREEN
      Navigator.of(context).pop();

      doubleReload = true; // prevent double reload => do to no see reload icon
      setState(() {}); // reload
    } else {
      // print("FAIL API");
    }
  }

  Future Fun_getMarkAddress() async {
    var myPref = await SharedPreferences.getInstance();
    var token = myPref.getString("TOKEN").toString();
    final res = await http.get(
      Uri.parse("https://tinheywan.com/api/f_getmarkaddress"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token"
      },
    );
    if (res.statusCode == 200) {
      var resbody = jsonDecode(res.body)['data'];
      if (resbody != null) {
        setState(() {
          v_street = resbody['street'];
          v_khan = resbody['khan'];
          v_province = resbody['province'];
          v_country = resbody['country'];

          v_detail = resbody['detail'];
          v_tel = resbody['telephone'];
          v_contact = resbody['contact'];
          v_photo = resbody['photo_address'];
        });
      } else {
        setState(() {
          v_street = "NULL";
          v_khan = "NULL";
          v_province = "NULL";
          v_country = "NULL";
          v_detail = "NULL";
          v_tel = "NULL";
          v_contact = "NULL";
          v_photo = "NULL";
        });
      }
      // reload
    } else {
      // print("FAIL API");
    }
  }

  //STRIPE

  createPaymentIntent() async {
    try {
      Map<String, dynamic> body = {
        "amount": "${t2.toStringAsFixed(0)}00",
        "currency": "USD",
      };

      http.Response response = await http.post(
          Uri.parse("https://api.stripe.com/v1/payment_intents"),
          body: body,
          headers: {
            "Authorization":
                "Bearer sk_test_51PBeKwRoHvdg46Tc5iSMTD6Ncp5qBICNHOqmIw5N1K6LGX8a2xTfGDeiLToZP5LU1XCb9ezRaturq2CtGvf1ut3O00pKnhPLpt",
            "Content-Type": "application/x-www-form-urlencoded",
          });
      return json.decode(response.body);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  void displayPaymentSheet() async {
    try {
      await stripe.Stripe.instance.presentPaymentSheet();
      // print("DONE");
    } catch (e) {
      // print("FAILED");
    }
  }

  void makePayment() async {
    try {
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
      paymentIntent = await createPaymentIntent();

      var gpay = const stripe.PaymentSheetGooglePay(
        merchantCountryCode: "US",
        currencyCode: "USD",
        testEnv: true,
      );

      await stripe.Stripe.instance.initPaymentSheet(
          paymentSheetParameters: stripe.SetupPaymentSheetParameters(
        paymentIntentClientSecret: paymentIntent!["client_secret"],
        style: ThemeMode.dark,
        merchantDisplayName: "Sabir",
        googlePay: gpay,
      ));

      displayPaymentSheet();
      Navigator.of(context).pop();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: IconButton(
          // Custom icon button on the left side
          icon: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.payment_rounded,
                color: Colors.green,
              ), // Use an icon like "post"
              Text('CHECKOUT'), // Add a label "EYWAN"
            ],
          ),
          onPressed: () {
            // Define action for the icon button
          },
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left_rounded),
          onPressed: () {
            Navigator.pushNamed(context, 'cart');
          },
        ),

        // to make title in center
        actions: [
          SizedBox(
            width: 40,
            height: 10,
          )
        ],
        //bottom border
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(4.0), // Height of the bottom container
          child: Container(
            decoration: BoxDecoration(
              // color: Colors.blue, // Background color (optional)
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(66, 177, 177, 177), // Shadow color
                  offset: Offset(0, 4), // Offset in x and y directions
                  blurRadius: 1.0, // Shadow blur radius
                ),
              ],
            ),
            height: 4.0, // Optional height for visual separation
          ),
        ),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          //ADDRESS
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, 'pickaddress');
            },
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.2,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      color: Color.fromARGB(255, 157, 157, 157), width: 2.0),
                ),
              ),
              child: Row(
                children: [
                  //IMAGE ADDRESS
                  Container(
                    width: 130,

                    height: double.infinity,
                    // use align to make inside container resize
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: v_photo != "NULL"
                            ? Image.network(
                                v_photo, // photo here
                                fit: BoxFit.cover,
                                // prevent not yet load image data => use this default
                                errorBuilder: (context, error, stackTrace) {
                                  // Fallback to asset image if network image fails to load
                                  return Image.asset(
                                    'assets/noimg.jpg',
                                    fit: BoxFit.cover,
                                  );
                                },
                              )
                            : Image.asset(
                                "assets/noimg.jpg",
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                  // DETAIL ADDRESS
                  Container(
                    width: 230,
                    height: double.infinity,
                    child: Column(
                      children: [
                        Container(
                            width: double.infinity,
                            height: 80,
                            alignment: Alignment.centerLeft,
                            child: v_country != "NULL"
                                ? Text(
                                    "$v_street $v_khan $v_province $v_country",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.clip,
                                  )
                                : Text("Address: ..................")),
                        Container(
                          width: double.infinity,
                          height: 30,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            v_detail != "NULL"
                                ? "Detail : $v_detail"
                                : "Detail : .....",
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            child: Row(
                              children: [
                                Container(
                                  width: 120,
                                  height: double.infinity,
                                  alignment: Alignment.centerLeft,
                                  child: v_tel != "NULL"
                                      ? Text("Tel: $v_tel")
                                      : Text("Tel:....."),
                                ),
                                Expanded(
                                  child: Container(
                                    height: double.infinity,
                                    alignment: Alignment.centerLeft,
                                    child: v_contact != "NULL"
                                        ? Text(
                                            "Name: $v_contact",
                                            overflow: TextOverflow.ellipsis,
                                          )
                                        : Text("Name: ...."),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //Tap
                  Expanded(
                    child: Container(
                      height: double.infinity,
                      child: Icon(Icons.arrow_forward_ios_outlined),
                    ),
                  ),
                ],
              ),
            ),
          ),
          //||ADDRESS
          Container(
            width: double.infinity,
            // color: Colors.amber,
            height: 40,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                    color: Color.fromARGB(255, 157, 157, 157), width: 2.0),
              ),
            ),
            child: Text(
              "LIST PRODUCS PAYMENT",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          //
          // CART LIST
          Container(
            width: double.infinity,
            // height: 400,
            height: MediaQuery.of(context).size.height * 0.45,

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
                            return Center(child: CircularProgressIndicator());
                          }
                        }

                        // Calculate the total sum
                        double newTotal = snapshot.data!.fold(0.0, (sum, item) {
                          return sum + double.parse(item['price'].toString());
                        });

                        // Autoreload after end listview builder
                        // Use addPostFrameCallback to update the total after the frame is rendered
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (newTotal != t2) {
                            // Only update if the total has changed
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

                              if (snapshot.data[index]['type'] == "ACCESSORY") {
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
                                    var id = snapshot.data[index]['eywan_id']
                                        .toString();
                                    Navigator.pushNamed(context, 'detail',
                                        arguments: id);
                                  },
                                  child: Container(
                                    width: 380,
                                    height: 150,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Color.fromARGB(255, 236, 245, 253),
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
                                            padding: EdgeInsets.only(left: 10),
                                            // width: 155,
                                            child: Row(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.only(
                                                      top: 10, bottom: 10),
                                                  // width: 100,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.3,
                                                  height: MediaQuery.of(context)
                                                      .size
                                                      .height,
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        width: double.infinity,
                                                        height: 50,
                                                        child: Text(
                                                          snapshot.data[index]
                                                              ['title'],
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    56,
                                                                    61,
                                                                    65),
                                                            fontWeight:
                                                                FontWeight.w800,
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        alignment:
                                                            Alignment.topLeft,
                                                        height: 30,
                                                        child: Text(
                                                          snapshot.data[index]
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
                                                        alignment:
                                                            Alignment.topLeft,
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
                                                    height:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .height,
                                                    child: CircleAvatar(
                                                      radius: 20,
                                                      backgroundColor:
                                                          Color.fromARGB(
                                                              255, 56, 61, 65),
                                                      child: IconButton(
                                                          onPressed: () {
                                                            var id = snapshot
                                                                .data[index]
                                                                    ['id']
                                                                .toString();
                                                            Fun_removeCart(id);
                                                          },
                                                          icon: Icon(
                                                            Icons.remove,
                                                            color: Colors.white,
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
            ),
          ),
          //
          //TOTAL
          Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.15,
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
                                    height: MediaQuery.of(context).size.height,
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
                              }),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(10),
                      child: ElevatedButton(
                          onPressed: () {
                            makePayment();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 255, 17, 0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  15), // Set the border radius
                            ),
                          ),
                          child: Text("PAY NOW",
                              style: TextStyle(
                                  fontSize: 15, color: Colors.white))),
                    ),
                  )
                ],
              ))
        ],
      ),
    );
  }
}
