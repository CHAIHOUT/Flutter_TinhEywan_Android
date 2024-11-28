// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, use_build_context_synchronously, non_constant_identifier_names, prefer_typing_uninitialized_variables, unused_local_variable, unused_import, avoid_function_literals_in_foreach_calls, deprecated_member_use, prefer_interpolation_to_compose_strings, no_leading_underscores_for_local_identifiers
import 'dart:convert';

import 'package:ecommerce/user/bottomNavi/bottomNavi.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';

//UPLOAD IMG
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var user_data;
  String datetime = "";
  String password = "";
  bool a = false;

  //Upload Image
  final ImagePicker imagePicker = ImagePicker();
  XFile? imageFileList;

  final List<String> arrImageUrl = <String>[];
  final FirebaseStorage storageRef = FirebaseStorage.instance;
  bool loading = false;

  //SIGLE UPLOAD
  Future selectImage() async {
    if (imageFileList == null) {
      final XFile? selectedImages =
          await imagePicker.pickImage(source: ImageSource.gallery);
      if (selectedImages != null) {
        imageFileList = selectedImages;
        setState(() {
          a = false;
        });
      } else {
        setState(() {
          a = true;
        });
      }
    } else {
      final XFile? selectedImages =
          await imagePicker.pickImage(source: ImageSource.gallery);
      if (selectedImages != null) {
        imageFileList = null;
        imageFileList = selectedImages;
      }
      setState(() {});
    }
  }

  // FIREBASE
  Future uploadFunction() async {
    var frontSelectImages = await selectImage();
    arrImageUrl.clear();
    dynamic imageUrl = await uploadFile(imageFileList!);
    arrImageUrl.add(imageUrl.toString());

    var updateImage = await Fun_updateImage();

    // stop Loading progress
    setState(() {
      a = true;
    });
  }

  Future uploadFile(XFile _image) async {
    TaskSnapshot snapshot = await storageRef
        .ref("images/${_image.name}")
        .putFile(File(_image.path));

    return await snapshot.ref.getDownloadURL();
  }

  Future Fun_updateImage() async {
    if (arrImageUrl.isNotEmpty) {
      var myPref = await SharedPreferences.getInstance();
      var token = myPref.getString("TOKEN").toString();
      var id = user_data['id'];
      var photo_address = arrImageUrl[0];

      // print("ID = $id");
      // print("PHOTO = $photo_address");

      var data = json.encode({
        "image": photo_address,
      });

      final res = await http.put(
          Uri.parse("https://tinheywan.com/api/getuser/" + id.toString()),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer $token"
          },
          body: data);
      if (res.statusCode == 200) {
        final snackBar = SnackBar(
          content: const Text('Successful Update !'),
          backgroundColor: Colors.green,
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {},
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        setState(() {
          // Refresh get data user
          Fun_getUser();
        });
      } else {
        // print("FAIL API");
      }
    } else {
      // print("Please Select Image");
    }
  }

  // LOG OUT
  Future Fun_logout() async {
    var myPref = await SharedPreferences.getInstance();
    myPref.remove("TOKEN");

    Navigator.pushNamed(context, '/');
  }

  Future Fun_getDateTime(created_date) async {
    var dateTime = DateTime.parse(created_date);
    datetime = dateTime.toString();
  }

  Future Fun_getStar() async {
    var myPref = await SharedPreferences.getInstance();
    String pass = myPref.getString("PASS").toString();

    pass.runes.forEach((element) {
      password += "*";
    });
  }

  Future Fun_getUser() async {
    var myPref = await SharedPreferences.getInstance();
    var token = myPref.getString("TOKEN").toString();
    password = "";

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
      Fun_getDateTime(user_data['created_at']);
      Fun_getStar();
      // print(user_data);
    } else {
      // print("FAIL API");
    }
  }

  @override
  void initState() {
    super.initState();
    Fun_getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Container(
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30)),
                    gradient: LinearGradient(
                        colors: [Colors.blue, Color.fromARGB(255, 5, 23, 188)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter)),
                width: double.infinity,
                height: 320,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 40, bottom: 20),
                      child: Text(
                        "Profile",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    // IMAGE
                    InkWell(
                      onTap: () {
                        uploadFunction();
                      },
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white, // Border color
                              width: 5.0, // Border width
                            ),
                            shape: BoxShape.circle),
                        child: ClipOval(
                          child: a
                              ? Image.network(
                                  user_data['image'],
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    // Fallback to asset image if network image fails to load
                                    return Image.asset(
                                      'assets/pic.png',
                                      fit: BoxFit.contain,
                                    );
                                  },
                                )
                              : Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3.5,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.orange),
                                  ),
                                ),
                        ),
                      ),
                    ),
                    Text(
                      a ? user_data['name'] : "",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                )),
            Expanded(
              child: Container(
                width: double.infinity,
                color: Colors.white,
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  children: [
                    //EMAIL
                    Container(
                      width: double.infinity,
                      height: 80,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            // color: Color.grey[300],
                            width: 1.5,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.email),
                          Container(
                              padding: EdgeInsets.only(left: 5),
                              child: Text("Email :")),
                          Container(
                              margin: EdgeInsets.only(left: 10),
                              child: a ? Text(user_data['email']) : Text("")),
                        ],
                      ),
                    ),
                    //PASSWORD
                    Container(
                      width: double.infinity,
                      height: 80,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            // color: Color.grey[300],
                            width: 1.5,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.lock),
                          Container(
                              padding: EdgeInsets.only(left: 5),
                              child: Text("Password :")),
                          Container(
                              margin: EdgeInsets.only(left: 10),
                              child: a ? Text(password) : Text("***")),
                        ],
                      ),
                    ),
                    // CREATED
                    Container(
                      width: double.infinity,
                      height: 80,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            // color: Color.grey[300],
                            width: 1.5,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.date_range),
                          Container(
                              padding: EdgeInsets.only(left: 5),
                              child: Text("Date of created :")),
                          Container(
                              margin: EdgeInsets.only(left: 10),
                              child: a ? Text(datetime) : Text("")),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        child: Container(
                          width: 120,
                          height: 40,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Color.fromARGB(255, 56, 61, 65),
                              ),
                              onPressed: () {
                                Fun_logout();
                              },
                              child: Text("Logout",
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.red))),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNaviigation(),
    );
  }
}
