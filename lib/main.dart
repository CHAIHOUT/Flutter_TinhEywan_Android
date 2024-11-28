// ignore_for_file: unused_import

import 'dart:convert';

import 'package:ecommerce/admin/admindisplay.dart';
import 'package:ecommerce/admin/componant/adminproduct.dart';
import 'package:ecommerce/admin/componant/adminprofile.dart';
import 'package:ecommerce/login/login.dart';
import 'package:ecommerce/login/register.dart';
import 'package:ecommerce/user/addadress.dart';
import 'package:ecommerce/user/cart.dart';
import 'package:ecommerce/user/detail.dart';
import 'package:ecommerce/user/pickaddress.dart';
import 'package:ecommerce/user/profile.dart';
import 'package:ecommerce/user/search.dart';
import 'package:ecommerce/user/setlocation.dart';
import 'package:ecommerce/user/submitcheckout.dart';
import 'package:ecommerce/user/test.dart';
import 'package:ecommerce/user/userdisplay.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
//
import 'package:flutter_stripe/flutter_stripe.dart';

void main() async {
  //FIREBASE
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized
  await Firebase.initializeApp(); // Initialize Firebase

  //STRIPE PUBLIC KEY
  Stripe.publishableKey =
      "pk_test_51PBeKwRoHvdg46TcLlX83xtlQYZr0mJ4WBSD12S2lCw4FNkbMKT48ecp9c77WhMJY0D2k5DswBf8fmPYw9T1guso00i1aZasE0";

  runApp(MaterialApp(
    routes: {
      '/': (context) => const Login(),
      'register': (context) => const Register(),
      'display': (context) => const Userdisplay(),
      //dynamic route
      'detail': (context) {
        final id = ModalRoute.of(context)!.settings.arguments
            as String; // Extract the 'id' parameter
        return Detail(id: id);
      },
      'search': (context) => const Search(),
      'profile': (context) => const Profile(),
      'cart': (context) => const CartProduct(),
      'submitcheckout': (context) => const SubmitCheckout(),
      'pickaddress': (context) => const PickAddress(),
      'addaddress': (context) => const AddAddress(),
      'setlocation': (context) => const SetLocation(),
      'test': (context) => const Test(),

      //admin
      'displayadmin': (context) => const Admindisplay(),
      'adminprofile': (context) => const AdminProfile(),
      'adminproduct': (context) => const AdminProduct(),
    },
  ));
}
