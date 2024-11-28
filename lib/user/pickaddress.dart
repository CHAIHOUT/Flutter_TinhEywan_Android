// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings, unused_import, unnecessary_import, non_constant_identifier_names, use_build_context_synchronously, sized_box_for_whitespace

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PickAddress extends StatefulWidget {
  const PickAddress({super.key});

  @override
  State<PickAddress> createState() => _PickAddressState();
}

List<String> options = ['A']; // Goble variable
List<int> pickRadio = [];

class _PickAddressState extends State<PickAddress> {
  int currentOption = 0;

  Future Fun_getAddress() async {
    var myPref = await SharedPreferences.getInstance();
    var token = myPref.getString("TOKEN").toString();
    final res = await http.get(
      Uri.parse("https://tinheywan.com/api/f_address"),
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

  Future Fun_updateaddress(id) async {
    var myPref = await SharedPreferences.getInstance();
    var token = myPref.getString("TOKEN").toString();

    var setTrue = "TRUE";
    var data = json.encode({
      "pick": setTrue,
    });

    final res = await http.put(
        Uri.parse("https://tinheywan.com/api/f_address/" + id.toString()),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token"
        },
        body: data);
    if (res.statusCode == 200) {
      setState(() {});
      final snackBar = SnackBar(
        content: const Text('Successful Update !'),
        backgroundColor: Colors.green,
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {},
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      // print("FAIL API");
      final snackBar = SnackBar(
        content: const Text('FAIL API!'),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {},
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future Fun_deleteAddress(id) async {
    var myPref = await SharedPreferences.getInstance();
    var token = myPref.getString("TOKEN").toString();
    // id is string
    final res = await http.delete(
      Uri.parse("https://tinheywan.com/api/f_address/" + id),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token"
      },
    );
    if (res.statusCode == 200) {
      return true;
    } else {
      // print("FAIL API");
      return false;
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
                Icons.location_on_outlined,
                color: Colors.blue,
              ), // Use an icon like "post"
              Text('PICK ADDRESS'), // Add a label "EYWAN"
            ],
          ),
          onPressed: () {
            // Define action for the icon button
            // print(options);
          },
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left_rounded),
          onPressed: () {
            Navigator.pushNamed(context, 'submitcheckout');
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
      body: Column(
        children: [
          //ADD ADDRESS
          Container(
            width: double.infinity,
            height: 70,
            // color: Colors.amber,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                    color: Color.fromARGB(255, 224, 224, 224), width: 2.0),
              ),
            ),
            child: IconButton(
              // Custom icon button on the left side
              icon: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.add_circle_outline_outlined,
                    color: Colors.black,
                  ), // Use an icon like "post"
                  Text('  Add Address'), // Add a label "EYWAN"
                ],
              ),
              onPressed: () {
                // Define action for the icon button
                Navigator.pushNamed(context, 'addaddress');
              },
            ),
          ),

          //LIST ADDRESS
          Expanded(
            //BODY
            child: Container(
              width: double.infinity,
              child: FutureBuilder(
                  future: Fun_getAddress(),
                  builder: (context, snapshot) {
                    // Reload
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          // Fetch 'id' and ensure it’s an integer
                          var idValue = snapshot.data[index]['id'];
                          int idAsInt;

                          // Convert 'id' to int if it's a string
                          if (idValue is String) {
                            idAsInt = int.parse(idValue);
                          } else if (idValue is int) {
                            idAsInt = idValue;
                          } else {
                            // Handle unexpected data type
                            // print("Unexpected type for 'id': $idValue");
                            return SizedBox(); // Skip rendering this item if the id is invalid
                          }

                          // Add the id to pickRadio if it's change lenght
                          if (pickRadio.length <= index) {
                            pickRadio.add(idAsInt);
                          } else {
                            pickRadio[index] = idAsInt;
                          }

                          if (snapshot.data[index]['pick'] == "TRUE") {
                            // print("CURRENT ID =${snapshot.data[index]['id']}");
                            // print("PCIK =${snapshot.data[index]['pick']}");
                            currentOption = pickRadio[index];
                          }

                          return Dismissible(
                            key: Key(snapshot.data[index]['id'].toString()),
                            direction: DismissDirection
                                .endToStart, // Allow swipe left only
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              color: Colors.red,
                              child: Icon(Icons.delete, color: Colors.white),
                            ),
                            confirmDismiss: (direction) async {
                              // Show confirmation dialog
                              return await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Delete Confirmation"),
                                    content: Text(
                                        "Are you sure you want to delete  this Address : ${snapshot.data[index]['street']} ${snapshot.data[index]['khan']} ${snapshot.data[index]['province']} ${snapshot.data[index]['country']}"),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.of(context)
                                            .pop(false), // Cancel
                                        child: Text("Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.of(context)
                                            .pop(true), // Confirm
                                        child: Text("Delete"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            onDismissed: (direction) async {
                              // Remove the item from your data source
                              // API
                              bool deleteFormAddress = await Fun_deleteAddress(
                                  snapshot.data[index]['id'].toString());

                              if (deleteFormAddress) {
                                setState(() {});
                              }

                              // Show a confirmation message
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Item deleted')),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                    bottom: BorderSide(
                                        color: Colors.grey.shade300)),
                              ),
                              child: Container(
                                width: double.infinity,
                                height: 150,
                                child: Row(
                                  children: [
                                    //IMAGE ADDRESS
                                    Container(
                                      width: 50,
                                      height: double.infinity,

                                      // use align to make inside container resize
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Row(
                                          //RADIO
                                          children: [
                                            Radio<int>(
                                                value: pickRadio[index],
                                                groupValue: currentOption,
                                                activeColor: Colors.orange,
                                                onChanged: (int? value) {
                                                  // setState(() {
                                                  currentOption = value!;
                                                  // print(
                                                  //     "click = $currentOption");
                                                  Fun_updateaddress(
                                                    currentOption,
                                                  );
                                                  // });
                                                }),
                                          ],
                                        ),
                                      ),
                                    ),
                                    // DETAIL ADDRESS
                                    Expanded(
                                      child: Container(
                                        height: double.infinity,
                                        child: Column(
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              height: 80,
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "${snapshot.data[index]['street']} ${snapshot.data[index]['khan']} ${snapshot.data[index]['province']} ${snapshot.data[index]['country']}",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                                overflow: TextOverflow.clip,
                                              ),
                                            ),
                                            //Detail
                                            Container(
                                              width: double.infinity,
                                              height: 30,
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                snapshot.data[index]
                                                            ['detail'] !=
                                                        "NULL"
                                                    ? "Detail : ${snapshot.data[index]['detail']}"
                                                    : "Detail : ...",
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            //Tel & Name
                                            Expanded(
                                              child: Container(
                                                width: double.infinity,
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: 120,
                                                      height: double.infinity,
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                          "Tel: ${snapshot.data[index]['telephone']}"),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        height: double.infinity,
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          "Name: ${snapshot.data[index]['contact']}",
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
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
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
