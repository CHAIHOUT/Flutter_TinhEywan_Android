// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';

class NotchBtn extends StatefulWidget {
  const NotchBtn({super.key});

  @override
  State<NotchBtn> createState() => _NotchBtnState();
}

class _NotchBtnState extends State<NotchBtn> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70.0,
      height: 70.0,
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
        ),
      ),
    );
  }
}
