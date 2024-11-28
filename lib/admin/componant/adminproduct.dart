// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, prefer_interpolation_to_compose_strings, use_build_context_synchronously, no_leading_underscores_for_local_identifiers, unused_local_variable, sized_box_for_whitespace, non_constant_identifier_names, deprecated_member_use

import 'dart:convert';

import 'package:ecommerce/admin/componant/adminbottomnavigation.dart';
import 'package:ecommerce/admin/componant/adminnotch.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AdminProduct extends StatefulWidget {
  const AdminProduct({super.key});

  @override
  State<AdminProduct> createState() => _AdminProductState();
}

class _AdminProductState extends State<AdminProduct> {
  //drop down menu
  String? _selectedValue;
  List<String> _dropdownItems = ['ACCESSORY', 'MATERIAL', 'CLOTHES', 'OTHER'];

  String? _selectedValue2;
  List<String> _dropdownItems2 = ['VIP', 'MEDIUM', 'STANDARD'];

  //Upload Image
  final ImagePicker imagePicker = ImagePicker();
  List<XFile> imageFileList = [];

  final List<String> arrImageUrl = <String>[];
  final FirebaseStorage storageRef = FirebaseStorage.instance;
  bool loading = false;

  //Controller
  TextEditingController c_title = TextEditingController();
  TextEditingController c_description = TextEditingController();
  TextEditingController c_price = TextEditingController();
  // for stop focus
  FocusNode _focusNode = FocusNode();

  Future selectImage() async {
    // print("LEN =" + imageFileList.length.toString());
    if (imageFileList.length < 5) {
      final List<XFile> selectedImages = await imagePicker.pickMultiImage();
      if (selectedImages.isNotEmpty) {
        var sumIMG = (imageFileList.length +
            selectedImages.length); // EX: 1.UP 4 , 2.UP 2
        if (selectedImages.length <= 5 && sumIMG <= 5) {
          imageFileList.addAll(selectedImages);
        } else {
          final snackBar = SnackBar(
            content: const Text("CAN'T SELECT MORE THAN 5 !"),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {},
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }
      setState(() {});
    } else {
      final snackBar = SnackBar(
        content: const Text("ALLOW UPLOAD ONLY 5!"),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {},
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  // FIREBASE
  Future uploadFunction() async {
    var frontSelectImages = await selectImage();
    // print(imageFileList.length);
    setState(() {
      loading = false;
    });
    arrImageUrl.clear();
    for (var i = 0; i < imageFileList.length; i++) {
      dynamic imageUrl = await uploadFile(imageFileList[i]);
      arrImageUrl.add(imageUrl.toString());
    }
    // stop Loading progress
    setState(() {
      loading = true;
    });
    // print(arrImageUrl);
  }

  Future uploadFile(XFile _image) async {
    TaskSnapshot snapshot = await storageRef
        .ref("images/${_image.name}")
        .putFile(File(_image.path));

    return await snapshot.ref.getDownloadURL();
  }

  // POST
  Future Fun_post() async {
    //POP UP LOADING SCREEN
    // STOP FOCUS
    _focusNode.unfocus();
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
    if (c_title.text != "" &&
        c_price.text != "" &&
        _selectedValue != "" &&
        _selectedValue2 != "" &&
        c_description.text != "" &&
        arrImageUrl.isNotEmpty) {
      var title = c_title.text;
      var price = c_price.text;
      var description = c_description.text;
      var type = _selectedValue;
      var status = _selectedValue2;
      var data = json.encode({
        "title": title.toString(),
        "price": price.toString(),
        "description": description.toString(),
        "type": type.toString(),
        "status": status.toString(),
      });

      //post eywan
      var myPref = await SharedPreferences.getInstance();
      var token = myPref.getString("TOKEN").toString();
      final res = await http.post(Uri.parse("https://tinheywan.com/api/eywan"),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer $token"
          },
          body: data);
      if (res.statusCode == 200) {
        var resbody = jsonDecode(res.body)['data'];
        var eywan_id = resbody['id'];

        //post eywan images
        for (var i = 0; i < arrImageUrl.length; i++) {
          var data2 = json.encode({
            "eywan_id": eywan_id.toString(),
            "image": arrImageUrl[i],
          });
          final res2 = await http.post(
              Uri.parse("https://tinheywan.com/api/eywan_image"),
              headers: {
                "Content-Type": "application/json",
                "Accept": "application/json",
                "Authorization": "Bearer $token"
              },
              body: data2);
          if (res2.statusCode == 500) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('FAIL POST IMAGE!'), // The message to display
                duration: Duration(
                    seconds: 2), // How long the SnackBar should be visible
                backgroundColor: Colors.green, // Customize the background color
              ),
            );
          }
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Post successful!'), // The message to display
            duration:
                Duration(seconds: 2), // How long the SnackBar should be visible
            backgroundColor: Colors.green, // Customize the background color
          ),
        );
        //END LOADING SCREEN
        Navigator.of(context).pop();
        //
        setState(() {
          c_title.clear();
          c_price.clear();
          c_description.clear();
          arrImageUrl.clear();
          imageFileList.clear();
          _selectedValue = null;
          _selectedValue2 = null;
          // arrImageUrl = <String>[];
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('FAIL API POST!'), // The message to display
            duration:
                Duration(seconds: 2), // How long the SnackBar should be visible
            backgroundColor: Colors.red, // Customize the background color
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('PLEASE FILL ALL!'), // The message to display
          duration:
              Duration(seconds: 2), // How long the SnackBar should be visible
          backgroundColor: Color.fromARGB(
              255, 236, 215, 31), // Customize the background color
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          false, // prevent notch btn move up when inout keyboard
      appBar: AppBar(
        //remove left arrow
        automaticallyImplyLeading: false,
        title: IconButton(
          // Custom icon button on the left side
          icon: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.production_quantity_limits), // Use an icon like "post"
              Text('POST EYWAN'), // Add a label "EYWAN"
            ],
          ),
          onPressed: () {
            // Define action for the icon button
            FocusScope.of(context).unfocus();
          },
        ),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: ListView(
          scrollDirection: Axis.vertical,
          // padding: EdgeInsets.all(10),
          children: [
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    // TITLE
                    controller: c_title,
                    style: TextStyle(
                        height: 1.0, color: Color.fromARGB(255, 11, 101, 246)),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color.fromARGB(255, 236, 245, 253),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 11, 101, 246), width: 3),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 11, 101, 246), width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 11, 101, 246), width: 2),
                      ),
                      prefixIcon: Visibility(
                          child: Icon(
                        Icons.person,
                        color: Color.fromARGB(255, 11, 101, 246),
                        size: 20,
                      )),
                      hintText: "Title",
                      hintStyle: TextStyle(
                        color: Color.fromARGB(255, 11, 101, 246),
                      ),
                    ),
                  ),
                ),
                //
                //
                //Price
                Padding(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    // Name
                    controller: c_price,
                    style: TextStyle(
                        height: 1.0, color: Color.fromARGB(255, 11, 101, 246)),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color.fromARGB(255, 236, 245, 253),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 238, 2, 2), width: 3),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 11, 101, 246), width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 11, 101, 246), width: 2),
                      ),
                      prefixIcon: Visibility(
                          child: Icon(
                        Icons.monetization_on_outlined,
                        color: Color.fromARGB(255, 11, 101, 246),
                        size: 20,
                      )),
                      hintText: "Price",
                      hintStyle: TextStyle(
                        color: Color.fromARGB(255, 11, 101, 246),
                      ),
                    ),
                  ),
                ),
                //
                //Drop down menu
                // TYPE
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    width: 370,
                    height: 55,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 236, 245, 253),
                        borderRadius:
                            BorderRadius.circular(15), // Set border radius
                        border: Border.all(
                            color: Color.fromARGB(255, 11, 101, 246),
                            width: 2) // Border color and width
                        ),
                    padding: EdgeInsets.all(10),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedValue, // The current selected value
                      hint: Text(
                        'SELECT TYPE ',
                        style: TextStyle(
                            fontSize: 15,
                            color: Color.fromARGB(255, 11, 101, 246)),
                      ), // The hint shown when no value is selected
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedValue =
                              newValue; // Update the selected value
                        });
                      },
                      items: _dropdownItems.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Container(
                            height:
                                60, // Set the height of the individual items
                            alignment: Alignment.centerLeft,
                            child: Text(
                              value,
                              style: TextStyle(
                                  color: Color.fromARGB(255, 11, 101, 246)),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                // STATUS
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    width: 370,
                    height: 55,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 236, 245, 253),
                        borderRadius:
                            BorderRadius.circular(15), // Set border radius
                        border: Border.all(
                            color: Color.fromARGB(255, 11, 101, 246),
                            width: 2) // Border color and width
                        ),
                    padding: EdgeInsets.all(10),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedValue2, // The current selected value
                      hint: Text(
                        'SELECT STATUS ',
                        style: TextStyle(
                            fontSize: 15,
                            color: Color.fromARGB(255, 11, 101, 246)),
                      ), // The hint shown when no value is selected
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedValue2 =
                              newValue; // Update the selected value
                        });
                      },
                      items: _dropdownItems2.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Container(
                            height:
                                60, // Set the height of the individual items
                            alignment: Alignment.centerLeft,
                            child: Text(
                              value,
                              style: TextStyle(
                                  color: Color.fromARGB(255, 11, 101, 246)),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                //
                //Upload Image
                Container(
                  width: double.infinity,
                  height: 240,
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 35,
                        padding: EdgeInsets.only(left: 10, bottom: 5),
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Text(
                              "Upload Image (only 5 image) :",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 157, 157, 157)),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Color.fromARGB(255, 11, 101, 246),
                                ),
                                onPressed: () {
                                  // selectImage();
                                  uploadFunction();
                                },
                                child: Text("Upload",
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.white)),
                              ),
                            )
                          ],
                        ),
                      ),
                      //BODY IMAGE
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 236, 245, 253),
                            border: Border.all(
                                width: 2,
                                color: Color.fromARGB(255, 11, 101, 246)),
                          ),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: imageFileList.length,
                            itemBuilder: (context, index) {
                              return loading
                                  ? Container(
                                      width: 170,
                                      padding: EdgeInsets.all(10),
                                      child: Image.file(
                                        File(imageFileList[index].path),
                                        fit: BoxFit.fill,
                                      ),
                                    )
                                  : Container(
                                      width: 170,
                                      child: Center(
                                          child: Transform.scale(
                                              scale: 1.25,
                                              child:
                                                  CupertinoActivityIndicator())),
                                    );
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                //||Upload Image
                //
                //Description
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      border: Border.all(
                          width: 2, color: Color.fromARGB(255, 11, 101, 246)),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextField(
                      controller: c_description,
                      focusNode: _focusNode,
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top, // start
                      textAlign: TextAlign.start,
                      decoration: InputDecoration(
                          alignLabelWithHint: true, // Hint start
                          filled: true,
                          // labelText:
                          //     v_description,
                          fillColor: Color.fromARGB(255, 236, 245, 253),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide:
                                BorderSide(color: Colors.white, width: 3),
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 3)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide:
                                BorderSide(color: Colors.white, width: 2),
                          ),
                          hintText: "Description..."),
                    ),
                  ),
                ),
                //||Description
                //
                //POST
                Container(
                  width: double.infinity,
                  height: 80,
                  // color: Colors.amber,
                  child: Container(
                    alignment: Alignment.topCenter,
                    width: 50,
                    height: 30,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 11, 101, 246),
                      ),
                      onPressed: () {
                        Fun_post();
                      },
                      child: Text("POST",
                          style: TextStyle(fontSize: 15, color: Colors.white)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: AdminBottomNaviigation(),
      floatingActionButton: NotchBtn(),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
    );
  }
}
