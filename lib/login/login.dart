// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables, unused_local_variable, non_constant_identifier_names, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email_con = TextEditingController();
  TextEditingController password_con = TextEditingController();

  Future Fun_Login() async {
    // LOADING SCREEN
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

    var email = email_con.text;
    var password = password_con.text;

    var data = json.encode({
      "email": email.toString(),
      "password": password.toString(),
    });

    final res = await http.post(Uri.parse("https://tinheywan.com/api/login"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"
        },
        body: data);

    if (res.statusCode == 200) {
      var resbody = json.decode(res.body)["user"];
      var status = json.decode(res.body)["status"];
      var token = json.decode(res.body)["Token"];
      // print(token);
      if (status.toString() == "1") {
        //END LOADING SCREEN
        Navigator.of(context).pop();
        //User
        var myPref = await SharedPreferences.getInstance();
        myPref.setString("TOKEN", token);
        myPref.setString("PASS", password.toString());
        // print(myPref.getString("TOKEN"));
        Navigator.pushNamed(context, 'display');
      } else if (status.toString() == "2") {
        //END LOADING SCREEN
        Navigator.of(context).pop();
        // Admin
        var myPref = await SharedPreferences.getInstance();
        myPref.setString("TOKEN", token);
        myPref.setString("PASS", password.toString());
        Navigator.pushNamed(context, 'displayadmin');
      } else {
        Navigator.of(context).pop();
        final snackBar = SnackBar(
          content: const Text(
            'Incorrect Account!',
            style:
                TextStyle(color: Colors.white), // Ensure text is visible on red
          ),
          backgroundColor: Colors.red, // Set background color to red
          action: SnackBarAction(
            label: 'Retry',
            onPressed: () {
              // Add retry logic here
            },
            textColor: Colors.white, // Optional: Set action text color to white
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      Navigator.of(context).pop();
      final snackBar = SnackBar(
        content: const Text(
          'Failed to API!',
          style:
              TextStyle(color: Colors.white), // Ensure text is visible on red
        ),
        backgroundColor: Colors.red, // Set background color to red
        action: SnackBarAction(
          label: 'Retry',
          onPressed: () {
            // Add retry logic here
          },
          textColor: Colors.white, // Optional: Set action text color to white
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // prevent input overflow border
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 80,
                        ),
                        SizedBox(
                          width: 250,
                          height: 100,
                          child: Image.asset(
                            "assets/tinheywan_icon2.png",
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                        Container(
                          width: 250,
                          height: 60,
                          child: Column(
                            children: [
                              Container(
                                // WELCOME BACK
                                alignment: Alignment.center,
                                width: double.infinity,
                                height: 35,

                                child: Text(
                                  "Welcome back!",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  //LOGIN
                                  width: double.infinity,
                                  alignment: Alignment.topCenter,
                                  child: Text(
                                    "Login to your exist Account",
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 158, 158, 158)),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: 350,
                          height: 400,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                // Email
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    TextField(
                                      //EMAIL
                                      controller: email_con,
                                      style: const TextStyle(
                                          height: 0.8,
                                          color: Color.fromARGB(
                                              255, 11, 101, 246)),
                                      decoration: const InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(30)),
                                            borderSide: BorderSide(
                                                color: Color.fromARGB(
                                                    255, 238, 2, 2),
                                                width: 3),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(30)),
                                            borderSide: BorderSide(
                                                color: Color.fromARGB(
                                                    255, 11, 101, 246),
                                                width: 2),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(30)),
                                            borderSide: BorderSide(
                                                color: Color.fromARGB(
                                                    255, 11, 101, 246),
                                                width: 2),
                                          ),
                                          prefixIcon: Visibility(
                                              child: Icon(
                                            Icons.person,
                                            color: Color.fromARGB(
                                                255, 11, 101, 246),
                                          )),
                                          hintText: "Email...",
                                          hintStyle: TextStyle(
                                            color: Color.fromARGB(
                                                255, 11, 101, 246),
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                // Password
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    TextField(
                                      controller: password_con,
                                      style: const TextStyle(
                                          height: 0.8,
                                          color: Color.fromARGB(
                                              255, 11, 101, 246)),
                                      decoration: const InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(30)),
                                            borderSide: BorderSide(
                                                color: Colors.redAccent,
                                                width: 3),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(30)),
                                            borderSide: BorderSide(
                                                color: Color.fromARGB(
                                                    255, 11, 101, 246),
                                                width: 2),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(30)),
                                            borderSide: BorderSide(
                                                color: Color.fromARGB(
                                                    255, 11, 101, 246),
                                                width: 2),
                                          ),
                                          prefixIcon: Visibility(
                                              child: Icon(
                                            Icons.lock,
                                            color: Color.fromARGB(
                                                255, 11, 101, 246),
                                          )),
                                          hintText: "Password...",
                                          hintStyle: TextStyle(
                                            color: Color.fromARGB(
                                                255, 11, 101, 246),
                                          )),
                                      obscureText: true,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                // BUTTON LOGIN
                                padding: const EdgeInsets.only(top: 25.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 100,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          if (email_con.text != "" &&
                                              password_con.text != "") {
                                            Fun_Login();
                                          } else {
                                            // print("NULL");
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(
                                              255, 6, 13, 222),
                                        ),
                                        child: const Text(
                                          "Login",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Don't have an Account?"),
                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context, 'register');
                                    },
                                    child: const Text(
                                      " Register",
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 5, 12, 207)),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
