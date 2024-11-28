// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, prefer_interpolation_to_compose_strings, non_constant_identifier_names
import 'dart:convert';

import 'package:ecommerce/user/bottomNavi/bottomNavi.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController search = TextEditingController();
  bool a = false;

  Future Fun_getEywan() async {
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
      var resbody = jsonDecode(res.body)['data'];
      return resbody;
    } else {
      // print("FAIL API");
      return "";
    }
  }

  Future Fun_filter() async {
    var myPref = await SharedPreferences.getInstance();
    var token = myPref.getString("TOKEN").toString();

    var search_text = search.text;
    var data = json.encode({
      "text": search_text.toString(),
    });

    final res = await http.post(Uri.parse("https://tinheywan.com/api/filter"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token"
        },
        body: data);

    if (res.statusCode == 200) {
      var resbody = jsonDecode(res.body)['data'];
      return resbody;
    } else {
      // print("FAIL API");
      return "";
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
        actions: [
          IconButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
              },
              icon: Icon(Icons.fact_check_outlined))
        ],
      ),
      // prevent input overflow border
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              // Search
              Container(
                padding: EdgeInsets.all(10),
                width: double.infinity,
                height: 80,
                child: TextField(
                  controller: search,
                  style: const TextStyle(height: 1),
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color.fromARGB(255, 236, 245, 253),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide: BorderSide(color: Colors.white, width: 3),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          borderSide:
                              BorderSide(color: Colors.white, width: 3)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide: BorderSide(color: Colors.white, width: 2),
                      ),
                      prefixIcon: Visibility(
                          child: Icon(
                        Icons.search,
                        color: Color.fromARGB(255, 176, 177, 178),
                      )),
                      hintText: "Search..."),
                  onChanged: (text) {
                    // print(search.text);
                    setState(() {
                      a = true;
                    });
                  },
                ),
              ),

              // List Eywan
              Expanded(
                child: Container(
                  width: double.infinity,
                  height: 180,
                  child: FutureBuilder(
                      future: a ? Fun_filter() : null,
                      builder: ((context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        return ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: a ? snapshot.data.length : 0,
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
                                  onTap: () {
                                    var id =
                                        snapshot.data[index]['id'].toString();
                                    Navigator.pushNamed(context, 'detail',
                                        arguments: id);
                                  },
                                  child: Container(
                                    width: 380,
                                    height: 180,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Color.fromARGB(255, 236, 245, 253),
                                    ),
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
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
                                                    color: Color.fromARGB(
                                                        255, 56, 61, 65),
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
                                                      color: Color.fromARGB(
                                                          255, 56, 61, 65),
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ),
                                              Container(
                                                alignment: Alignment.topLeft,
                                                height: 30,
                                                child: Text(
                                                  "\$" +
                                                      snapshot.data[index]
                                                          ['price'],
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 56, 61, 65),
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                    alignment: Alignment.center,
                                                    height: 30,
                                                    child: ElevatedButton(
                                                        onPressed: () {},
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                                backgroundColor:
                                                                    Color.fromARGB(
                                                                        255,
                                                                        56,
                                                                        61,
                                                                        65)),
                                                        child: Text(
                                                            "ADD TO CART",
                                                            style: TextStyle(
                                                                fontSize: 10,
                                                                color: Colors
                                                                    .white)))),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                      })),
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNaviigation(),
    );
  }
}
