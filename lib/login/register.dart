// ignore_for_file: non_constant_identifier_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, sized_box_for_whitespace

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController name_con = TextEditingController();
  TextEditingController email_con = TextEditingController();
  TextEditingController password_con = TextEditingController();
  TextEditingController passwordconfirm_con = TextEditingController();

  Future Fun_Register() async {
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

    var name = name_con.text;
    var email = email_con.text;
    var pass = password_con.text;
    var conpass = passwordconfirm_con.text;

    if (pass == conpass) {
      var data = json.encode({
        "name": name.toString(),
        "email": email.toString(),
        "password": pass.toString(),
      });

      final res = await http.post(
          Uri.parse("https://tinheywan.com/api/register"),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json"
          },
          body: data);

      if (res.statusCode == 201) {
        //END LOADING SCREEN
        Navigator.of(context).pop();

        final snackBar = SnackBar(
          content: const Text('Register Successful !'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              // Implement code to undo the action.
            },
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        // print(res.body);
        Navigator.pushNamed(context, '/');
      } else {
        //END LOADING SCREEN
        Navigator.of(context).pop();
        final snackBar = SnackBar(
          content: const Text('Failed API !'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              // Implement code to undo the action.
            },
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      final snackBar = SnackBar(
        content: const Text('Password and Confirm Password are incorrect !'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // Implement code to undo the action.
          },
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SizedBox(
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 40,
                      ),
                      Container(
                        //Top head
                        width: double.infinity,
                        height: 180,

                        margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              width: double.infinity,
                              height: 50,
                              child: IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(Icons.arrow_back)),
                            ),
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                child: Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.only(top: 30),
                                      width: double.infinity,
                                      height: 50,
                                      child: Text(
                                        "Let's Get Started!",
                                        style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      width: double.infinity,
                                      height: 30,
                                      child: Text(
                                        "Create an account for an amazing outside",
                                        style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 158, 158, 158),
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
                      Container(
                        margin: EdgeInsets.only(left: 20, right: 20),
                        width: double.infinity,
                        height: 500,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              // Name
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextField(
                                    // Name
                                    controller: name_con,
                                    style: TextStyle(
                                        height: 1.1,
                                        color:
                                            Color.fromARGB(255, 11, 101, 246)),
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30)),
                                        borderSide: BorderSide(
                                            color:
                                                Color.fromARGB(255, 238, 2, 2),
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
                                        color:
                                            Color.fromARGB(255, 11, 101, 246),
                                        size: 20,
                                      )),
                                      hintText: "Username",
                                      hintStyle: TextStyle(
                                        color:
                                            Color.fromARGB(255, 11, 101, 246),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              // Email
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextField(
                                    //Email
                                    controller: email_con,
                                    style: TextStyle(
                                        height: 1.1,
                                        color:
                                            Color.fromARGB(255, 11, 101, 246)),
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30)),
                                        borderSide: BorderSide(
                                            color:
                                                Color.fromARGB(255, 238, 2, 2),
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
                                        Icons.email,
                                        color:
                                            Color.fromARGB(255, 11, 101, 246),
                                        size: 20,
                                      )),
                                      hintText: "Email",
                                      hintStyle: TextStyle(
                                        color:
                                            Color.fromARGB(255, 11, 101, 246),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              // Password
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextField(
                                    // Password
                                    controller: password_con,
                                    style: TextStyle(
                                        height: 1.1,
                                        color:
                                            Color.fromARGB(255, 11, 101, 246)),
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30)),
                                        borderSide: BorderSide(
                                            color:
                                                Color.fromARGB(255, 238, 2, 2),
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
                                        color:
                                            Color.fromARGB(255, 11, 101, 246),
                                        size: 20,
                                      )),
                                      hintText: "Password",
                                      hintStyle: TextStyle(
                                        color:
                                            Color.fromARGB(255, 11, 101, 246),
                                      ),
                                    ),
                                    obscureText: true,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              // Confirm Password
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextField(
                                    // Confirm Password
                                    controller: passwordconfirm_con,
                                    style: TextStyle(
                                        height: 1.1,
                                        color:
                                            Color.fromARGB(255, 11, 101, 246)),
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30)),
                                        borderSide: BorderSide(
                                            color: Colors.redAccent, width: 3),
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
                                        color:
                                            Color.fromARGB(255, 11, 101, 246),
                                        size: 20,
                                      )),
                                      hintText: "Confirm Password",
                                      hintStyle: TextStyle(
                                        color:
                                            Color.fromARGB(255, 11, 101, 246),
                                      ),
                                    ),
                                    obscureText: true,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              // BUTTON LOGIN
                              padding: const EdgeInsets.only(top: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 120,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (name_con.text != "" &&
                                            email_con.text != "" &&
                                            password_con.text != "" &&
                                            password_con.text != "") {
                                          Fun_Register();
                                        } else {
                                          final snackBar = SnackBar(
                                            content: const Text(
                                                'Please fill all in the box !'),
                                            action: SnackBarAction(
                                              label: 'Undo',
                                              onPressed: () {
                                                // Implement code to undo the action.
                                              },
                                            ),
                                          );
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            255, 6, 13, 222),
                                      ),
                                      child: const Text(
                                        "Register",
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
                                const Text("You have an Account?"),
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    " Login",
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 5, 12, 207)),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
