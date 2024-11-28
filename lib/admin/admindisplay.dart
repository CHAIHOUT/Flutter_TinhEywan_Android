// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import, non_constant_identifier_names, unused_field, prefer_final_fields, unused_element, unused_local_variable, sized_box_for_whitespace, prefer_interpolation_to_compose_strings, dead_code, use_build_context_synchronously, sort_child_properties_last, deprecated_member_use

import 'dart:async';
import 'dart:convert';

import 'package:ecommerce/admin/componant/adminbottomnavigation.dart';
import 'package:ecommerce/admin/componant/admincycle.dart';
import 'package:ecommerce/admin/componant/admingraph.dart';
import 'package:ecommerce/admin/componant/adminheader.dart';
import 'package:ecommerce/admin/componant/admintotalsold.dart';
import 'package:ecommerce/user/bottomNavi/bottomNavi.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Admindisplay extends StatefulWidget {
  const Admindisplay({super.key});

  @override
  State<Admindisplay> createState() => _AdmindisplayState();
}

class _AdmindisplayState extends State<Admindisplay> {
  var total_user = 0;
  var total_eywanqty = 0;
  //total sold
  List<dynamic> datasolds = [];
  double totalsold_Sep = 0.0;

  //User & product
  bool a = false;

  // Auto Swipe
  late ScrollController _scrollController;
  late Timer _timer;
  int _currentIndex = 0;

  //Modal
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController type = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController status = TextEditingController();
  bool progress = false;

  @override
  void initState() {
    super.initState();
    // This code runs once when the widget is created

    // Auto Swipe
    _scrollController = ScrollController();

    //just getalluser
    Fun_getTotalUser();
    Fun_getCountTotalEywan(); //count all eywan
    Fun_getDataSold(); // get total sold

    // Set up a periodic timer to auto-scroll
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      //5
      _autoScroll();
    });
  }

  //Auto Swipe
  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is disposed
    _scrollController.dispose(); // Dispose the controller
    super.dispose();
  }

  void _autoScroll() {
    double maxScroll = _scrollController.position.maxScrollExtent;
    double minScroll = _scrollController.position.minScrollExtent;

    // Move to the next index or go back to the start
    if (_scrollController.offset < maxScroll) {
      _currentIndex++;
    } else {
      _currentIndex = 0;
    }

    // Scroll to the next index (smooth scrolling)
    _scrollController.animateTo(
      _currentIndex * 380.0, // Adjust the item width to control scroll distance
      duration: Duration(seconds: 2), //2
      curve: Curves.easeInOut,
    );
  }

  // Auto Swipe ^

  // Text Dialog
  void _showTextDialog(BuildContext context, id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete User : $id'),
          content: Text('Are you sure to delete this user?'),
          actions: <Widget>[
            ElevatedButton(
                onPressed: () async {
                  var processdelete = await Fun_deleteUser(id);
                  setState(() {
                    Navigator.of(context).pop();
                  });
                },
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 255, 0, 0),
                ),
                child: Text("YES",
                    style: TextStyle(fontSize: 11, color: Colors.white))),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 255, 255, 255),
                ),
                child: Text("NO",
                    style: TextStyle(fontSize: 11, color: Colors.black))),
          ],
        );
      },
    );
  }

  // Dialog delete user
  void _showTextDialogDelete(BuildContext context, id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Product : $id'),
          content: Text('Are you sure to delete this Product?'),
          actions: <Widget>[
            ElevatedButton(
                onPressed: () async {
                  var processdelete = await Fun_deleteProduct(id);
                  setState(() {
                    // double navi = back all 2 modal
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  });
                },
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 255, 0, 0),
                ),
                child: Text("YES",
                    style: TextStyle(fontSize: 11, color: Colors.white))),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 255, 255, 255),
                ),
                child: Text("NO",
                    style: TextStyle(fontSize: 11, color: Colors.black))),
          ],
        );
      },
    );
  }

  //GET ALL USER FOR COUNT
  Future Fun_getTotalUser() async {
    var myPref = await SharedPreferences.getInstance();
    var token = myPref.getString("TOKEN").toString();
    final res = await http.get(
      Uri.parse("https://tinheywan.com/api/getalluser"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token"
      },
    );
    if (res.statusCode == 200) {
      var resbody = jsonDecode(res.body)['data'];
      setState(() {
        total_user = resbody.length;
      });
    } else {
      // print("FAIL API");
    }
  }

  //GET COUNT ALL EYWAN
  Future Fun_getCountTotalEywan() async {
    var myPref = await SharedPreferences.getInstance();
    var token = myPref.getString("TOKEN").toString();
    final res = await http.get(
      Uri.parse("https://tinheywan.com/api/counteywan"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token"
      },
    );
    if (res.statusCode == 200) {
      var resbody = jsonDecode(res.body);
      setState(() {
        total_eywanqty = resbody;
      });
    } else {
      // print("FAIL API");
    }
  }

  //Get total sold month sep first
  Future Fun_getDataSold() async {
    var myPref = await SharedPreferences.getInstance();
    var token = myPref.getString("TOKEN").toString();
    final res = await http.get(
      Uri.parse("https://tinheywan.com/api/getdatasold"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token"
      },
    );
    if (res.statusCode == 200) {
      //Total Eywan
      var resbody = jsonDecode(res.body)['data'];
      datasolds = resbody;
      for (var datasold in datasolds) {
        DateTime createdAt = DateTime.parse(datasold['created_at']);
        int month = createdAt.month;

        if (month == 9) {
          //still need add logic another month sale
          setState(() {
            totalsold_Sep = totalsold_Sep + double.parse(datasold['price']);
          });
        }
      }
    } else {
      // print("FAIL API");
    }
  }

  //GET ALL USER
  Future Fun_getAllUser() async {
    var myPref = await SharedPreferences.getInstance();
    var token = myPref.getString("TOKEN").toString();
    final res = await http.get(
      Uri.parse("https://tinheywan.com/api/getalluser"),
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

  //Get all Eywan
  Future Fun_getAllEywan() async {
    var myPref = await SharedPreferences.getInstance();
    var token = myPref.getString("TOKEN").toString();
    final res = await http.get(
      Uri.parse("https://tinheywan.com/api/eywan"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token"
      },
    );
    if (res.statusCode == 200) {
      var resbody = jsonDecode(res.body);
      return resbody;
    } else {
      // print("FAIL API");
      return "";
    }
  }

  //Get Eywan by id
  Future Fun_getEywanByID(id) async {
    var myPref = await SharedPreferences.getInstance();
    var token = myPref.getString("TOKEN").toString();
    final res = await http.get(
      Uri.parse("https://tinheywan.com/api/f_getEywanbyid/" + id),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token"
      },
    );
    if (res.statusCode == 200) {
      var resbody = jsonDecode(res.body)['data'];
      setState(() {
        title.text = resbody['title'];
        description.text = resbody['description'];
        price.text = resbody['price'];
        status.text = resbody['status'];
        type.text = resbody['type'];
        progress = true;
      });
    } else {
      // print("FAIL API");
      return "";
    }
  }

  // Update Product
  Future Fun_updateProd(id, title, description, type, price, status) async {
    var myPref = await SharedPreferences.getInstance();
    var token = myPref.getString("TOKEN").toString();

    var data = json.encode({
      "title": title.toString(),
      "description": description.toString(),
      "type": type.toString(),
      "price": price.toString(),
      "status": status.toString(),
    });

    final res =
        await http.put(Uri.parse("https://tinheywan.com/api/eywan/" + id),
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
              "Authorization": "Bearer $token"
            },
            body: data);

    if (res.statusCode == 200) {
      final snackBar = SnackBar(
        content: const Text('Successful Update !'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {},
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.of(context).pop();
      setState(() {});
    } else {
      // print("FAIL API");
    }
  }

  //Delete user
  Future Fun_deleteUser(id) async {
    var myPref = await SharedPreferences.getInstance();
    var token = myPref.getString("TOKEN").toString();
    final res = await http.delete(
      Uri.parse("https://tinheywan.com/api/deleteuserbyid/" + id),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token"
      },
    );
    if (res.statusCode == 200) {
      final snackBar = SnackBar(
        content: const Text('Delete success!'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {},
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      // setState(() {});
    } else {
      // print("FAIL API");
    }
  }

  // delete Eywan
  Future Fun_deleteProduct(id) async {
    var myPref = await SharedPreferences.getInstance();
    var token = myPref.getString("TOKEN").toString();
    final res = await http.delete(
      Uri.parse("https://tinheywan.com/api/eywan/" + id),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token"
      },
    );
    if (res.statusCode == 200) {
      final res = await http.delete(
        Uri.parse("https://tinheywan.com/api/eywan_image/" + id),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token"
        },
      );
      if (res.statusCode == 200) {
        final snackBar = SnackBar(
          content: const Text('Delete Eywan success!'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {},
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        // print("FAIL API OR NO IMAGE TO DELETE");
      }
    } else {
      // print("FAIL API");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          false, // prevent notch btn move up when inout keyboard
      appBar: AdminHeader(),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          SizedBox(
            width: double.infinity,
            height: 20,
          ),
          //Total card
          Container(
            width: double.infinity,
            height: 255,
            child: ListView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              children: [
                // Total User
                Container(
                  margin: EdgeInsets.all(10),
                  //370
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 165,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(255, 106, 106, 106)
                            .withOpacity(0.4), // Shadow color
                        spreadRadius: 5, // Spread radius
                        blurRadius: 7, // Blur radius
                        offset: Offset(0, 3),
                      ),
                    ],
                    border: Border.all(
                      color: Color.fromARGB(255, 255, 255, 255),
                      width: 2,
                    ),
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 255, 162, 0),
                        Color.fromARGB(255, 241, 44, 0)
                      ], // Starting and ending colors
                      begin: Alignment.topLeft, // Gradient starts from top-left
                      end: Alignment
                          .bottomRight, // Gradient ends at bottom-right
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.only(left: 10, top: 15),
                        width: double.infinity,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                        ),
                        child: Text(
                          "Total Users: $total_user",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w400),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20)),
                          ),
                          child: AspectRatio(
                            aspectRatio: 1.6,
                            child: BarChart2(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  // Total Products
                  margin: EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 165,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(255, 106, 106, 106)
                            .withOpacity(0.4), // Shadow color
                        spreadRadius: 5, // Spread radius
                        blurRadius: 7, // Blur radius
                        offset: Offset(0, 3),
                      ),
                    ],
                    border: Border.all(
                      color: Color.fromARGB(255, 255, 255, 255),
                      width: 2,
                    ),
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 204, 0, 255),
                        Color.fromARGB(255, 129, 0, 241)
                      ], // Starting and ending colors
                      begin: Alignment.topLeft, // Gradient starts from top-left
                      end: Alignment
                          .bottomRight, // Gradient ends at bottom-right
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.only(left: 10, top: 15),
                        width: double.infinity,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                        ),
                        child: Text(
                          "Total Products: $total_eywanqty",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w400),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20)),
                          ),
                          child: PieChartSample2(),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  // Total Sold
                  margin: EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 165,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(255, 106, 106, 106)
                            .withOpacity(0.4), // Shadow color
                        spreadRadius: 5, // Spread radius
                        blurRadius: 7, // Blur radius
                        offset: Offset(0, 3),
                      ),
                    ],
                    border: Border.all(
                      color: Color.fromARGB(255, 255, 255, 255),
                      width: 2,
                    ),
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(205, 0, 255, 30),
                        Color.fromARGB(255, 0, 241, 157)
                      ], // Starting and ending colors
                      begin: Alignment.topLeft, // Gradient starts from top-left
                      end: Alignment
                          .bottomRight, // Gradient ends at bottom-right
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.only(left: 10, top: 15),
                        width: double.infinity,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                        ),
                        child: Text(
                          "Total Sold Products: $totalsold_Sep\$",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w400),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20)),
                          ),
                          child: AspectRatio(
                            aspectRatio: 1.6,
                            child: LineChartSample2(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          //link list
          Container(
            width: double.infinity,
            height: 50,
            child: Row(
              children: [
                //List Users
                Container(
                  width: 100,
                  height: double.infinity,
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        a = false;
                      });
                    },
                    child: Text(
                      "USERS",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 133, 133, 133)),
                    ),
                  ),
                ),
                Container(
                  width: 100,
                  height: double.infinity,
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        a = true;
                      });
                    },
                    child: Text(
                      "PRODUCTS",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 133, 133, 133)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          //LINK LIST//

          // LIST
          Container(
            width: double.infinity,
            height: 327,
            child: FutureBuilder(
                future: a ? Fun_getAllEywan() : Fun_getAllUser(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: a //default users
                              ? Text(snapshot.data[index]['id'].toString())
                              : Text(snapshot.data[index]['id'].toString()),
                          title: a
                              ? Text(snapshot.data[index]['title']) // EYWAN
                              : Text(snapshot.data[index]['name']
                                  .toString()), // USER
                          subtitle: a
                              ? Text("Status :" +
                                  snapshot.data[index]['status'] +
                                  ", Type :" +
                                  snapshot.data[index]['type'])
                              : Text(snapshot.data[index]['email'].toString()),
                          trailing: a
                              ? IconButton(
                                  // Modal CURD Eywan
                                  icon: Icon(Icons.edit),
                                  onPressed: () async {
                                    //Get Eywan by id
                                    var eywanData = await Fun_getEywanByID(
                                        snapshot.data[index]['id'].toString());

                                    //Modal
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return GestureDetector(
                                          onTap: () {
                                            FocusScope.of(context).unfocus();
                                          },
                                          child: AlertDialog(
                                            title: Text(
                                                "Edit Eywan : ${snapshot.data[index]['id'].toString()}"),
                                            content: SingleChildScrollView(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  //TITLE
                                                  TextField(
                                                    controller: title,
                                                    decoration: InputDecoration(
                                                        filled: true,
                                                        // labelText: v_title,
                                                        fillColor: Color
                                                            .fromARGB(255, 236,
                                                                245, 253),
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          15)),
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .white,
                                                                  width: 3),
                                                        ),
                                                        enabledBorder: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            15)),
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .white,
                                                                    width: 3)),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          15)),
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .white,
                                                                  width: 2),
                                                        ),
                                                        prefixIcon: Visibility(
                                                            child: Icon(
                                                          Icons.title,
                                                          color: Color.fromARGB(
                                                              255,
                                                              176,
                                                              177,
                                                              178),
                                                        )),
                                                        hintText: "Title..."),
                                                  ),

                                                  SizedBox(
                                                    width: double.infinity,
                                                    height: 20,
                                                  ),

                                                  // TYPE
                                                  TextField(
                                                    controller: type,
                                                    decoration: InputDecoration(
                                                        filled: true,
                                                        // labelText: v_type,
                                                        fillColor: Color
                                                            .fromARGB(255, 236,
                                                                245, 253),
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          15)),
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .white,
                                                                  width: 3),
                                                        ),
                                                        enabledBorder: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            15)),
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .white,
                                                                    width: 3)),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          15)),
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .white,
                                                                  width: 2),
                                                        ),
                                                        prefixIcon: Visibility(
                                                            child: Icon(
                                                          Icons
                                                              .production_quantity_limits,
                                                          color: Color.fromARGB(
                                                              255,
                                                              176,
                                                              177,
                                                              178),
                                                        )),
                                                        hintText: "Type..."),
                                                  ),

                                                  SizedBox(
                                                    width: double.infinity,
                                                    height: 20,
                                                  ),

                                                  // STATUS
                                                  TextField(
                                                    controller: status,
                                                    decoration: InputDecoration(
                                                        filled: true,
                                                        // labelText: v_status,
                                                        fillColor: Color
                                                            .fromARGB(255, 236,
                                                                245, 253),
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          15)),
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .white,
                                                                  width: 3),
                                                        ),
                                                        enabledBorder: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            15)),
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .white,
                                                                    width: 3)),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          15)),
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .white,
                                                                  width: 2),
                                                        ),
                                                        prefixIcon: Visibility(
                                                            child: Icon(
                                                          Icons
                                                              .star_outline_rounded,
                                                          color: Color.fromARGB(
                                                              255,
                                                              176,
                                                              177,
                                                              178),
                                                        )),
                                                        hintText: "Status..."),
                                                  ),

                                                  SizedBox(
                                                    width: double.infinity,
                                                    height: 20,
                                                  ),

                                                  // Price
                                                  TextField(
                                                    controller: price,
                                                    decoration: InputDecoration(
                                                        filled: true,
                                                        // labelText: v_price,
                                                        fillColor: Color
                                                            .fromARGB(255, 236,
                                                                245, 253),
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          15)),
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .white,
                                                                  width: 3),
                                                        ),
                                                        enabledBorder: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            15)),
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .white,
                                                                    width: 3)),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          15)),
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .white,
                                                                  width: 2),
                                                        ),
                                                        prefixIcon: Visibility(
                                                            child: Icon(
                                                          Icons
                                                              .monetization_on_outlined,
                                                          color: Color.fromARGB(
                                                              255,
                                                              176,
                                                              177,
                                                              178),
                                                        )),
                                                        hintText: "Price..."),
                                                  ),

                                                  SizedBox(
                                                    width: double.infinity,
                                                    height: 20,
                                                  ),

                                                  // DESCRIPTION
                                                  Container(
                                                    height: 150,
                                                    child: TextField(
                                                      controller: description,
                                                      maxLines: null,
                                                      expands: true,
                                                      textAlignVertical:
                                                          TextAlignVertical
                                                              .top, // start
                                                      textAlign:
                                                          TextAlign.start,
                                                      decoration:
                                                          InputDecoration(
                                                              alignLabelWithHint:
                                                                  true, // Hint start
                                                              filled: true,
                                                              // labelText:
                                                              //     v_description,
                                                              fillColor: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      236,
                                                                      245,
                                                                      253),
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            15)),
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .white,
                                                                    width: 3),
                                                              ),
                                                              enabledBorder: OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              15)),
                                                                  borderSide: BorderSide(
                                                                      color: Colors
                                                                          .white,
                                                                      width:
                                                                          3)),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            15)),
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .white,
                                                                    width: 2),
                                                              ),
                                                              hintText:
                                                                  "Description..."),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            actions: [
                                              ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(); // Close the dialog
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    primary: Color.fromARGB(
                                                        255, 255, 255, 255),
                                                  ),
                                                  child: Text("BACK",
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                        color: Color.fromARGB(
                                                            255, 8, 102, 216),
                                                      ))),
                                              //Delete Product
                                              ElevatedButton(
                                                onPressed: () {
                                                  _showTextDialogDelete(
                                                      context,
                                                      snapshot.data[index]['id']
                                                          .toString());
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  primary: Color.fromARGB(
                                                      255, 255, 0, 0),
                                                ),
                                                child: Text("DELETE",
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        color: Colors.white)),
                                              ),
                                              ElevatedButton(
                                                  onPressed: () {
                                                    //EDIT
                                                    Fun_updateProd(
                                                        snapshot.data[index]
                                                                ['id']
                                                            .toString(),
                                                        title.text,
                                                        description.text,
                                                        type.text,
                                                        price.text,
                                                        status.text);
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    primary: Color.fromARGB(
                                                        255, 255, 247, 0),
                                                  ),
                                                  child: Text("EDIT",
                                                      style: TextStyle(
                                                          fontSize: 11,
                                                          color:
                                                              Colors.white))),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                )
                              : IconButton(
                                  // Delete Users
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    _showTextDialog(context,
                                        snapshot.data[index]['id'].toString());
                                  },
                                ),
                        );
                      });
                }),
          ),
          // LIST //

          //default end
        ],
      ),
      bottomNavigationBar: AdminBottomNaviigation(),

      //notch button
      floatingActionButton: SizedBox(
        width: 70.0, // Increase the width
        height: 70.0, // Increase the height

        child: FloatingActionButton(
          onPressed: () {
            // Action to perform
            Navigator.pushNamed(context, 'adminproduct');
          },
          child: Icon(Icons.production_quantity_limits_rounded, size: 40),
          shape: RoundedRectangleBorder(
            // Add this to adjust the button shape
            borderRadius:
                BorderRadius.circular(30.0), // Adjust the radius as needed
          ), // You can also increase the icon size
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
    );
  }
}
