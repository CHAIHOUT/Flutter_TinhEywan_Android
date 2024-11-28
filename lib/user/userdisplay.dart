// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, avoid_unnecessary_containers, sized_box_for_whitespace, prefer_interpolation_to_compose_strings, unused_local_variable, use_build_context_synchronously

import 'dart:convert';

import 'package:ecommerce/user/bottomNavi/bottomNavi.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

class Userdisplay extends StatefulWidget {
  const Userdisplay({super.key});

  @override
  State<Userdisplay> createState() => _UserdisplayState();
}

class _UserdisplayState extends State<Userdisplay> {
  var a = false;
  var b = false;
  var c = false;
  var d = false;

  // Glabalkey for call fun form another class to interact
  final GlobalKey<BottomNaviigationState> bottomNavKey =
      GlobalKey<BottomNaviigationState>();

  Future Fun_getVip() async {
    var myPref = await SharedPreferences.getInstance();
    var token = myPref.getString("TOKEN").toString();
    final res = await http.get(
      Uri.parse("https://tinheywan.com/api/getallvip"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token"
      },
    );

    if (res.statusCode == 200) {
      // var resbody = json.decode(res.body);
      // print(resbody[0]['id']);
      // return resbody; // return ($data);
      var resbody = jsonDecode(res.body)['data'];
      return resbody;
    } else {
      // print("FAIL API");
      return "";
    }
  }

  Future Fun_getEywanImage() async {
    var myPref = await SharedPreferences.getInstance();
    var token = myPref.getString("TOKEN").toString();
    final res = await http.get(Uri.parse(""));
  }

  Future Fun_getMedium() async {
    var myPref = await SharedPreferences.getInstance();
    var token = myPref.getString("TOKEN").toString();
    final res = await http.get(
      Uri.parse("https://tinheywan.com/api/getallmedium"),
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

  Future Fun_getStandard() async {
    var myPref = await SharedPreferences.getInstance();
    var token = myPref.getString("TOKEN").toString();
    final res = await http.get(
      Uri.parse("https://tinheywan.com/api/getallstandard"),
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

  // GET TYPE VIP
  Future Fun_getTypeVIP() async {
    var myPref = await SharedPreferences.getInstance();
    var token = myPref.getString("TOKEN").toString();

    // VIP ACCESSORY
    if (a == true) {
      // VIP MATERIAL
      if (b == true) {
        // VIP CLOTHES
        if (c == true) {
          // VIP OTHER
          if (d == true) {
            final res = await http.get(
              Uri.parse("https://tinheywan.com/api/f_getallother"),
              headers: {
                "Content-Type": "application/json",
                "Accept": "application/json",
                "Authorization": "Bearer $token"
              },
            );
            if (res.statusCode == 200) {
              var resbody = jsonDecode(res.body)[
                  'Vip_other']; //Vip_other : name data del kdob Ex: "Vip_other":
              return resbody;
            } else {
              // print("FAIL API");
              return "";
            }
          }
          final res = await http.get(
            Uri.parse("https://tinheywan.com/api/f_getallclothes"),
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
              "Authorization": "Bearer $token"
            },
          );
          if (res.statusCode == 200) {
            var resbody = jsonDecode(res.body)['Vip_clothes'];
            return resbody;
          } else {
            // print("FAIL API");
            return "";
          }
        }
        final res = await http.get(
          Uri.parse("https://tinheywan.com/api/f_getallmaterial"),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer $token"
          },
        );
        if (res.statusCode == 200) {
          var resbody = jsonDecode(res.body)['Vip_material'];
          return resbody;
        } else {
          // print("FAIL API");
          return "";
        }
      }
      final res = await http.get(
        Uri.parse("https://tinheywan.com/api/f_getallaccessory"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token"
        },
      );
      if (res.statusCode == 200) {
        var resbody = jsonDecode(res.body)['Vip_accessory'];
        return resbody;
      } else {
        // print("FAIL API");
        return "";
      }
    }
  }

  // GET TYPE MEDIUM
  Future Fun_getTypeMEDIUM() async {
    var myPref = await SharedPreferences.getInstance();
    var token = myPref.getString("TOKEN").toString();

    // MEDIUM ACCESSORY
    if (a == true) {
      // MEDIUM MATERIAL
      if (b == true) {
        // MEDIUM CLOTHES
        if (c == true) {
          // MEDIUM OTHER
          if (d == true) {
            final res = await http.get(
              Uri.parse("https://tinheywan.com/api/f_getallother"),
              headers: {
                "Content-Type": "application/json",
                "Accept": "application/json",
                "Authorization": "Bearer $token"
              },
            );
            if (res.statusCode == 200) {
              var resbody = jsonDecode(res.body)['Medium_other'];
              return resbody;
            } else {
              // print("FAIL API");
              return "";
            }
          }
          final res = await http.get(
            Uri.parse("https://tinheywan.com/api/f_getallclothes"),
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
              "Authorization": "Bearer $token"
            },
          );
          if (res.statusCode == 200) {
            var resbody = jsonDecode(res.body)['Medium_clothes'];
            return resbody;
          } else {
            // print("FAIL API");
            return "";
          }
        }
        final res = await http.get(
          Uri.parse("https://tinheywan.com/api/f_getallmaterial"),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer $token"
          },
        );
        if (res.statusCode == 200) {
          var resbody = jsonDecode(res.body)['Medium_material'];
          return resbody;
        } else {
          // print("FAIL API");
          return "";
        }
      }
      final res = await http.get(
        Uri.parse("https://tinheywan.com/api/f_getallaccessory"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token"
        },
      );
      if (res.statusCode == 200) {
        var resbody = jsonDecode(res.body)['Medium_accessory'];
        return resbody;
      } else {
        // print("FAIL API");
        return "";
      }
    }
  }

  // GET TYPE STANDARD
  Future Fun_getTypeSTANDARD() async {
    var myPref = await SharedPreferences.getInstance();
    var token = myPref.getString("TOKEN").toString();

    // STANDARD ACCESSORY
    if (a == true) {
      // STANDARD MATERIAL
      if (b == true) {
        // STANDARD CLOTHES
        if (c == true) {
          // STANDARD OTHER
          if (d == true) {
            final res = await http.get(
              Uri.parse("https://tinheywan.com/api/f_getallother"),
              headers: {
                "Content-Type": "application/json",
                "Accept": "application/json",
                "Authorization": "Bearer $token"
              },
            );
            if (res.statusCode == 200) {
              var resbody = jsonDecode(res.body)['Standard_other'];
              return resbody;
            } else {
              // print("FAIL API");
              return "";
            }
          }
          final res = await http.get(
            Uri.parse("https://tinheywan.com/api/f_getallclothes"),
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
              "Authorization": "Bearer $token"
            },
          );
          if (res.statusCode == 200) {
            var resbody = jsonDecode(res.body)['Standard_clothes'];
            return resbody;
          } else {
            // print("FAIL API");
            return "";
          }
        }
        final res = await http.get(
          Uri.parse("https://tinheywan.com/api/f_getallmaterial"),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer $token"
          },
        );
        if (res.statusCode == 200) {
          var resbody = jsonDecode(res.body)['Standard_material'];
          return resbody;
        } else {
          // print("FAIL API");
          return "";
        }
      }

      final res = await http.get(
        Uri.parse("https://tinheywan.com/api/f_getallaccessory"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token"
        },
      );
      if (res.statusCode == 200) {
        var resbody = jsonDecode(res.body)['Standard_accessory'];
        return resbody;
      } else {
        // print("FAIL API");
        return "";
      }
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
        // backgroundColor: Colors.blue,
        title: Container(
          // color: Colors.amber,
          width: 300,
          height: 65,
          child: Image.asset(
            "assets/tinheywan_icon2.png",
            fit: BoxFit.fill,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, 'test');
              },
              icon: Icon(Icons.shopping_cart_outlined))
        ],
      ),
      body: ListView(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 50,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      TextButton(
                          onPressed: () {
                            setState(() {
                              a = false;
                            });
                          },
                          child: Text(
                            "ALL",
                            style: TextStyle(
                                color: Color.fromARGB(255, 133, 133, 133)),
                          )),
                      TextButton(
                          onPressed: () {
                            setState(() {
                              a = true;
                              b = false;
                            });
                          },
                          child: Text(
                            "ACCESSORY",
                            style: TextStyle(
                                color: Color.fromARGB(255, 133, 133, 133)),
                          )),
                      TextButton(
                          onPressed: () {
                            setState(() {
                              a = true;
                              b = true;
                              c = false;
                            });
                          },
                          child: Text(
                            "MATERIAL",
                            style: TextStyle(
                                color: Color.fromARGB(255, 133, 133, 133)),
                          )),
                      TextButton(
                          onPressed: () {
                            setState(() {
                              a = true;
                              b = true;
                              c = true;
                              d = false;
                            });
                          },
                          child: Text(
                            "CLOTHES",
                            style: TextStyle(
                                color: Color.fromARGB(255, 133, 133, 133)),
                          )),
                      TextButton(
                          onPressed: () {
                            setState(() {
                              a = true;
                              b = true;
                              c = true;
                              d = true;
                            });
                          },
                          child: Text(
                            "OTHER",
                            style: TextStyle(
                                color: Color.fromARGB(255, 133, 133, 133)),
                          )),
                    ],
                  ),
                ),
              )
            ],
          ),
          // VIP
          Container(
              width: double.infinity,
              height: 180,
              child: FutureBuilder(
                  future: a
                      ? b
                          ? c
                              ? d
                                  ? Fun_getTypeVIP()
                                  : Fun_getTypeVIP()
                              : Fun_getTypeVIP()
                          : Fun_getTypeVIP()
                      : Fun_getVip(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        // print(snapshot.data[index]['id'].toString());
                        String img;
                        // snapshot.data[index]['type'] return {$data}
                        if (snapshot.data[index]['type'] == "ACCESSORY") {
                          img = 'assets/accessory5.webp';
                        } else if (snapshot.data[index]['type'] == "MATERIAL") {
                          img = 'assets/material.jpg';
                        } else if (snapshot.data[index]['type'] == "CLOTHES") {
                          img = 'assets/cloth.jpg';
                        } else {
                          img = 'assets/other.jpg';
                        }

                        return Card(
                          child: InkWell(
                            onTap: () {
                              var id = snapshot.data[index]['id'].toString();
                              Navigator.pushNamed(context, 'detail',
                                  arguments: id);
                            },
                            child: Container(
                              width: 380,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color.fromARGB(255, 56, 61, 65),
                              ),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(
                                      img,
                                      width: 200,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(left: 10),
                                    width: 155,
                                    child: Column(
                                      children: [
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          width: double.infinity,
                                          height: 50,
                                          child: Text(
                                            snapshot.data[index]['title'],
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          alignment: Alignment.topLeft,
                                          height: 30,
                                          child: Text(
                                            snapshot.data[index]['type'],
                                            style: TextStyle(
                                                color: Colors.white
                                                    .withOpacity(0.8),
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                        Container(
                                          alignment: Alignment.topLeft,
                                          height: 30,
                                          child: Text(
                                            "\$" +
                                                snapshot.data[index]['price'],
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                        // BUTTON ADD TO CART
                                        Expanded(
                                          child: Container(
                                              alignment: Alignment.center,
                                              height: 30,
                                              child: ElevatedButton(
                                                  onPressed: () {
                                                    var title = snapshot
                                                        .data[index]['title'];
                                                    var description =
                                                        snapshot.data[index]
                                                            ['description'];
                                                    var type = snapshot
                                                        .data[index]['type'];
                                                    var price = snapshot
                                                        .data[index]['price'];
                                                    var status = snapshot
                                                        .data[index]['status'];
                                                    int eywan_id = snapshot
                                                        .data[index]['id'];
                                                    Fun_addToCart(
                                                        title,
                                                        description,
                                                        type,
                                                        price,
                                                        status,
                                                        eywan_id);
                                                  },
                                                  child: Text("ADD TO CART",
                                                      style: TextStyle(
                                                          fontSize: 10)))),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  })),
          // Our Products
          Container(
            width: double.infinity,
            height: 50,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 10),
            child: Text(
              "Our Products",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
          ),
          // MEDIUM
          Container(
              width: double.infinity,
              height: 250,
              child: FutureBuilder(
                  future: a
                      ? b
                          ? c
                              ? d
                                  ? Fun_getTypeMEDIUM()
                                  : Fun_getTypeMEDIUM()
                              : Fun_getTypeMEDIUM()
                          : Fun_getTypeMEDIUM()
                      : Fun_getMedium(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          String img;
                          // snapshot.data[index]['type'] return {$data}
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
                              onTap: () {
                                var id = snapshot.data[index]['id'].toString();
                                Navigator.pushNamed(context, 'detail',
                                    arguments: id);
                              },
                              child: Container(
                                padding: EdgeInsets.all(5),
                                width: 180,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color.fromARGB(255, 236, 245, 253)),
                                child: Column(
                                  children: [
                                    // IMAGE
                                    Container(
                                      width: double.infinity,
                                      height: 120,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.asset(
                                          img,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    // TITLE
                                    Container(
                                      height: 35,
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        snapshot.data[index]['title'],
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: const Color.fromARGB(
                                              255, 56, 61, 65),
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                    // TYPE
                                    Container(
                                      height: 30,
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        snapshot.data[index]['type'],
                                        style: TextStyle(
                                            color: const Color.fromARGB(
                                                255, 56, 61, 65),
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    // Price & Button
                                    Expanded(
                                      child: Container(
                                          alignment: Alignment.centerLeft,
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 100,
                                                height: MediaQuery.of(context)
                                                    .size
                                                    .height,
                                                child: Text(
                                                    "\$" +
                                                        snapshot
                                                                .data[index]
                                                            ['price'],
                                                    style: TextStyle(
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 56, 61, 65),
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                              ),
                                              // BUTTON ADD TO CART
                                              Container(
                                                  width: 70,
                                                  child: ElevatedButton(
                                                      onPressed: () {
                                                        var title =
                                                            snapshot.data[index]
                                                                ['title'];
                                                        var description =
                                                            snapshot.data[index]
                                                                ['description'];
                                                        var type =
                                                            snapshot.data[index]
                                                                ['type'];
                                                        var price =
                                                            snapshot.data[index]
                                                                ['price'];
                                                        var status =
                                                            snapshot.data[index]
                                                                ['status'];
                                                        int eywan_id = snapshot
                                                            .data[index]['id'];
                                                        Fun_addToCart(
                                                            title,
                                                            description,
                                                            type,
                                                            price,
                                                            status,
                                                            eywan_id);
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              foregroundColor:
                                                                  Colors.white,
                                                              backgroundColor:
                                                                  const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      56,
                                                                      61,
                                                                      65),
                                                              shape:
                                                                  CircleBorder()),
                                                      child: Container(
                                                        child: Icon(Icons.add),
                                                      )))
                                            ],
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  })),
          // New Arrival
          Container(
            width: double.infinity,
            height: 50,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 10),
            child: Text(
              "New Arrival",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
          ),

          // STANDARD
          Container(
            width: double.infinity,
            height: 350,
            child: FutureBuilder(
                future: a
                    ? b
                        ? c
                            ? d
                                ? Fun_getTypeSTANDARD()
                                : Fun_getTypeSTANDARD()
                            : Fun_getTypeSTANDARD()
                        : Fun_getTypeSTANDARD()
                    : Fun_getStandard(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return GridView.builder(
                      itemCount: snapshot.data.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, childAspectRatio: 0.75),
                      itemBuilder: (context, index) {
                        String img;
                        // snapshot.data[index]['type'] return {$data}
                        if (snapshot.data[index]['type'] == "ACCESSORY") {
                          img = 'assets/accessory5.webp';
                        } else if (snapshot.data[index]['type'] == "MATERIAL") {
                          img = 'assets/material.jpg';
                        } else if (snapshot.data[index]['type'] == "CLOTHES") {
                          img = 'assets/cloth.jpg';
                        } else {
                          img = 'assets/other.jpg';
                        }

                        return Card(
                          child: InkWell(
                            onTap: () {
                              var id = snapshot.data[index]['id'].toString();
                              Navigator.pushNamed(context, 'detail',
                                  arguments: id);
                            },
                            child: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color.fromARGB(255, 236, 245, 253)),
                              child: Column(
                                children: [
                                  // IMAGE
                                  Container(
                                    width: double.infinity,
                                    height: 120,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset(
                                        img,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  // TITLE
                                  Container(
                                    height: 35,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      snapshot.data[index]['title'],
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: const Color.fromARGB(
                                            255, 56, 61, 65),
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                  // TYPE
                                  Container(
                                    height: 30,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      snapshot.data[index]['type'],
                                      style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 56, 61, 65),
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  // Price & Button
                                  Expanded(
                                    child: Container(
                                        alignment: Alignment.centerLeft,
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 100,
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .height,
                                              child: Text(
                                                  "\$" +
                                                      snapshot.data[index]
                                                          ['price'],
                                                  style: TextStyle(
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 56, 61, 65),
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                            ),
                                            // BUTTON ADD TO CART
                                            Container(
                                                width: 70,
                                                child: ElevatedButton(
                                                    onPressed: () {
                                                      var title = snapshot
                                                          .data[index]['title'];
                                                      var description =
                                                          snapshot.data[index]
                                                              ['description'];
                                                      var type = snapshot
                                                          .data[index]['type'];
                                                      var price = snapshot
                                                          .data[index]['price'];
                                                      var status =
                                                          snapshot.data[index]
                                                              ['status'];
                                                      int eywan_id = snapshot
                                                          .data[index]['id'];
                                                      Fun_addToCart(
                                                          title,
                                                          description,
                                                          type,
                                                          price,
                                                          status,
                                                          eywan_id);
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            foregroundColor:
                                                                Colors.white,
                                                            backgroundColor:
                                                                const Color
                                                                    .fromARGB(
                                                                    255,
                                                                    56,
                                                                    61,
                                                                    65),
                                                            shape:
                                                                CircleBorder()),
                                                    child: Container(
                                                      child: Icon(Icons.add),
                                                    )))
                                          ],
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                }),
          )
        ],
      ),
      bottomNavigationBar: BottomNaviigation(
        // pass key
        key: bottomNavKey,
      ),
    );
  }
}
