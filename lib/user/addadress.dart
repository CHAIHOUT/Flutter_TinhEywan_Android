// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, sort_child_properties_last, prefer_interpolation_to_compose_strings, unused_local_variable, non_constant_identifier_names, prefer_final_fields, no_leading_underscores_for_local_identifiers, unused_element, use_build_context_synchronously, prefer_collection_literals, deprecated_member_use
// import 'dart:ffi';

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

//MAP
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher_string.dart';
//GOOGLE MAP
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddAddress extends StatefulWidget {
  const AddAddress({super.key});

  @override
  State<AddAddress> createState() => _AddAddressState();
}

List<String> options = ['MALE', 'FEMALE'];

class _AddAddressState extends State<AddAddress> {
  //Controller
  TextEditingController c_contact = TextEditingController();
  TextEditingController c_tel = TextEditingController();
  TextEditingController c_detail = TextEditingController();

  //Radio
  String currentOption = options[0];

  //Upload Image
  final ImagePicker imagePicker = ImagePicker();
  XFile? imageFileList;

  final List<String> arrImageUrl = <String>[];
  final FirebaseStorage storageRef = FirebaseStorage.instance;
  bool loading = false;

  //MAP
  late String lat;
  late String long;
  bool loadingAddress = false;

  //GOOGLE MAP BY AI
  late GoogleMapController mapController;
  final Set<Marker> _markers = {};
  LatLng _initialPosition = LatLng(11.5564, 104.9282); // PP

  late GoogleMapController mapController2;
  final Set<Marker> _markers2 = {};
  LatLng _initialPosition2 = LatLng(11.5564, 104.9282); // PP

  //CONVERT LOT& LOG -> ADDRESS
  String placeM = '';

  String country = '';
  String province = '';
  String street = '';
  String khan = '';

  Future<String> getAddressFromLatLng(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);

      // Check if any placemarks are returned
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0]; // Get the first placemark
        // Format the address as needed
        return '${placemark.street ?? ''}, ${placemark.locality ?? ''}, ${placemark.postalCode ?? ''}, ${placemark.country ?? ''}';
      } else {
        return 'No address found';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }

  //SIGLE UPLOAD
  Future selectImage() async {
    if (imageFileList == null) {
      final XFile? selectedImages =
          await imagePicker.pickImage(source: ImageSource.gallery);
      if (selectedImages != null) {
        imageFileList = selectedImages;
        setState(() {
          loading = true;
        });
      } else {
        setState(() {
          false;
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
    // stop Loading progress
    setState(() {
      loading = false;
    });
    // print(arrImageUrl);
  }

  Future uploadFile(XFile _image) async {
    TaskSnapshot snapshot = await storageRef
        .ref("images/${_image.name}")
        .putFile(File(_image.path));

    return await snapshot.ref.getDownloadURL();
  }

  //MAP
  Future<Position> _getCurrentLocation() async {
    //LOADING SCREEN
    setState(() {
      loadingAddress = true;
    });
    // ON SERVICE
    _markers.clear();
    bool serviceEnable = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnable) {
      return Future.error('Location service are disabled.');
    }
    // CHECK PERMISSION
    LocationPermission permission = await Geolocator.checkPermission();
    // POP UP MODAL TO ALLOW LOCATION
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    // DENIED FOREVER PERMISSION
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permission');
    }

    return await Geolocator.getCurrentPosition();
  }

  void _liveLocation() {
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100, // 100 METER CATCH
    );
    // HELP TO GET POSTION
    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
      //PARA
      lat = position.latitude.toString();
      long = position.longitude.toString();
      //UPDATE CURRENT POSITION
      setState(() {
        // print('Latitude: $lat , Longitude: $long');
      });
    });
  }

  Future<void> _openMap(String lat, String long) async {
    // GOOGLE URL
    String googleURL =
        'https://www.google.com/maps/search/?api=1&query=$lat,$long';
    await canLaunchUrlString(googleURL)
        ? await launchUrlString(googleURL)
        : throw 'Could not launch $googleURL';
  }

  Future f_postAddress() async {
    if (c_contact.text != "" &&
        currentOption != "" &&
        c_tel.text != "" &&
        lat != "" &&
        long != "") {
      // Screen Reload
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

      // CHECK BLANK 1 BY 1
      var detail = "";
      var photo_address = "";
      if (arrImageUrl.isEmpty) {
        photo_address = "NULL";
      }

      if (c_detail.text == "") {
        detail = "NULL";
      }

      // CHECK IF NOT NULL
      if (arrImageUrl.isNotEmpty) {
        photo_address = arrImageUrl[0];
      }

      if (c_detail.text != "") {
        detail = c_detail.text;
      }
      //|| CHECK IF NOT NULL

      //SOME LOCATION DON'T HAVE KHAN
      if (khan == "") {
        khan = "NULL";
      }
      if (street == "") {
        street = "NULL";
      }
      if (province == "") {
        province = "NULL";
      }
      if (country == "") {
        country = "NULL";
      }

      var contact = c_contact.text;
      var gender = currentOption;
      var telephone = c_tel.text;
      var latitude = lat;
      var longitude = long;

      var data = json.encode({
        "contact": contact,
        "gender": gender,
        "telephone": telephone,
        "detail": detail,
        "latitude": latitude,
        "longitude": longitude,
        "photo_address": photo_address,
        "khan": khan,
        "street": street,
        "province": province,
        "country": country,
      });

      var myPref = await SharedPreferences.getInstance();
      var token = myPref.getString("TOKEN").toString();
      final res =
          await http.post(Uri.parse("https://tinheywan.com/api/f_address"),
              headers: {
                "Content-Type": "application/json",
                "Accept": "application/json",
                "Authorization": "Bearer $token"
              },
              body: data);
      if (res.statusCode == 200) {
        //END LOADING SCREEN
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Save successful!'), // The message to display
            duration:
                Duration(seconds: 2), // How long the SnackBar should be visible
            backgroundColor: Colors.green, // Customize the background color
          ),
        );
        Navigator.pushNamed(context, 'pickaddress');
      } else {
        var resbody = jsonDecode(res.body);
        var errorMessage = resbody.containsKey('message')
            ? resbody['message']
            : 'Request failed with status: ${res.statusCode}';

        // print("FAIL API: $errorMessage");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'FAIL API',
              style: TextStyle(color: Colors.white),
            ),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating, // Make the SnackBar floating
            margin: EdgeInsets.only(
                bottom: 30, right: 50, left: 50), // Adjust the position
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'PLEASE FILL ALL IN ( * )',
            style: TextStyle(color: Colors.white),
          ),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating, // Make the SnackBar floating
          margin: EdgeInsets.only(
              bottom: 30, right: 50, left: 50), // Adjust the position
        ),
      );
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
                Icons.map_outlined,
                color: Colors.orange,
              ), // Use an icon like "post"
              Text(' ADD ADDRESS'), // Add a label "EYWAN"
            ],
          ),
          onPressed: () {
            // Define action for the icon button

            FocusScope.of(context).unfocus();
          },
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left_rounded),
          onPressed: () {
            Navigator.pushNamed(context, 'pickaddress');
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
      //
      //
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            //MAP
            Container(
              width: double.infinity,
              height: 290,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      color: Color.fromARGB(255, 157, 157, 157), width: 2.0),
                ),
              ),
              child: Column(
                children: [
                  //HEAD MAP
                  Container(
                    width: double.infinity,
                    height: 190,
                    child: GoogleMap(
                      onMapCreated: (GoogleMapController controller) {
                        mapController = controller;
                      },
                      initialCameraPosition: CameraPosition(
                        target: _initialPosition,
                        zoom: 10,
                      ),
                      markers: _markers,
                      // onTap: _handleTap,
                      mapType: MapType.normal,
                    ),
                  ),
                  //BODY MAP
                  Container(
                    width: double.infinity,
                    height: 60,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: loadingAddress
                        ? Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 3.5,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.orange),
                            ),
                          )
                        : Text(
                            "$street $khan $province $country",
                            style: TextStyle(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.clip,
                          ),
                  ),
                  //FOOTER MAP
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                              color: Color.fromARGB(255, 157, 157, 157),
                              width: 2.0),
                        ),
                      ),
                      child: Row(
                        children: [
                          //MAP BTN LEFT
                          Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: IconButton(
                              // Custom icon button on the left side
                              icon: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.track_changes,
                                    color: Color.fromARGB(255, 227, 145, 21),
                                    size: 18,
                                  ), // Use an icon like "post"
                                  Text(
                                    ' Use Current Location',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromARGB(255, 227, 145, 21)),
                                  ), // Add a label "EYWAN"
                                ],
                              ),
                              onPressed: () async {
                                _getCurrentLocation().then((value) async {
                                  lat = '${value.latitude}';
                                  long = '${value.longitude}';

                                  // print('Latitude: $lat , Longitude: $long');

                                  //CONVERT LOG & LOT -> ADDRESS
                                  List<Placemark> placemark =
                                      await placemarkFromCoordinates(
                                          double.parse(lat),
                                          double.parse(long));

                                  setState(() {
                                    //CONVERT LOG & LOT -> ADDRESS
                                    placeM =
                                        'Country = ${placemark.reversed.last.country}'
                                        'Province = ${placemark.reversed.last.locality}'
                                        'Street = ${placemark.reversed.last.street}'
                                        'KHAN = ${placemark.reversed.last.subLocality}';
                                    // print("ADDRESS =" + placeM);
                                    country = placemark.reversed.last.country
                                        .toString();
                                    province = placemark.reversed.last.locality
                                        .toString();
                                    street = placemark.reversed.last.street
                                        .toString();
                                    khan = placemark.reversed.last.subLocality
                                        .toString();

                                    // locationMessage = 'Latitude: $lat , Longitude: $long';
                                    // print('Latitude: $lat , Longitude: $long');
                                    _initialPosition = LatLng(
                                      double.parse(lat),
                                      double.parse(long),
                                    );
                                    //Move Camera to current location
                                    mapController.animateCamera(
                                      CameraUpdate.newLatLngZoom(
                                          _initialPosition, 14.0),
                                    );
                                    // MARK CURRENT LOCATION
                                    _markers.add(
                                      Marker(
                                        markerId: MarkerId(LatLng(
                                          double.parse(lat),
                                          double.parse(long),
                                        ).toString()),
                                        position: LatLng(
                                          double.parse(lat),
                                          double.parse(long),
                                        ),
                                      ),
                                    );
                                    //END LOADING
                                    loadingAddress = false;
                                  });
                                  //GET CURRENT LOCATION WHEN U MOVE
                                  _liveLocation();
                                });
                              },
                            ),
                          ),
                          //MAP BTN RIGHT
                          Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            decoration: BoxDecoration(
                              border: Border(
                                left: BorderSide(
                                    color: Color.fromARGB(255, 157, 157, 157),
                                    width: 2.0),
                              ),
                            ),
                            child: IconButton(
                              // Custom icon button on the left side
                              icon: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    color: Color.fromARGB(255, 227, 145, 21),
                                    size: 18,
                                  ), // Use an icon like "post"
                                  Text(
                                    ' Set Location',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromARGB(255, 227, 145, 21)),
                                  ), // Add a label "EYWAN"
                                ],
                              ),
                              onPressed: () {
                                // MODAL : SET LOCATION
                                showGeneralDialog(
                                  context: context,
                                  pageBuilder:
                                      (context, animation, secondaryAnimation) {
                                    return Center(
                                      child: StatefulBuilder(
                                        builder: (context, setDialogState) =>
                                            Container(
                                          width: double.infinity,
                                          height: 600,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                width: double.infinity,
                                                height: 30,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10),
                                                    topRight:
                                                        Radius.circular(10),
                                                  ),
                                                ),
                                                child: Text(
                                                  'SET LOCATION',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.orange,
                                                    decoration:
                                                        TextDecoration.none,
                                                  ),
                                                ),
                                              ),
                                              // MAP SET LOCATION
                                              Container(
                                                width: double.infinity,
                                                height: 450,
                                                child: GoogleMap(
                                                  onMapCreated:
                                                      (GoogleMapController
                                                          controller) {
                                                    mapController2 = controller;
                                                  },
                                                  initialCameraPosition:
                                                      CameraPosition(
                                                    target: _initialPosition2,
                                                    zoom: 10,
                                                  ),
                                                  markers: _markers2,
                                                  onTap: (LatLng tappedPoint) {
                                                    setDialogState(() {
                                                      _handleTap2(
                                                          tappedPoint); // Call to update the marker
                                                    });
                                                  },
                                                  mapType: MapType.normal,
                                                  // Double tap for zoom in
                                                  gestureRecognizers: Set()
                                                    ..add(Factory<
                                                            PanGestureRecognizer>(
                                                        () =>
                                                            PanGestureRecognizer()))
                                                    ..add(Factory<
                                                            ScaleGestureRecognizer>(
                                                        () =>
                                                            ScaleGestureRecognizer()))
                                                    ..add(Factory<
                                                            TapGestureRecognizer>(
                                                        () =>
                                                            TapGestureRecognizer())), // Allow tap gestures
                                                ),
                                              ),
                                              Container(
                                                width: double.infinity,
                                                height: 70,
                                                alignment: Alignment.center,
                                                padding: EdgeInsets.all(5),
                                                child: Text(
                                                  "$street $khan $province $country",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                    color: Colors.black,
                                                    decoration:
                                                        TextDecoration.none,
                                                  ),
                                                  overflow: TextOverflow.clip,
                                                ),
                                              ),
                                              Expanded(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        _markers2.clear();
                                                        Navigator.of(context)
                                                            .pop(); // Close the modal
                                                      },
                                                      child: Text('Close'),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    //SAVE MODAL
                                                    ElevatedButton(
                                                      onPressed: () async {
                                                        // Screen Reload
                                                        showDialog(
                                                          context: context,
                                                          barrierDismissible:
                                                              false, // Prevent closing the dialog by tapping outside
                                                          builder: (BuildContext
                                                              context) {
                                                            return Center(
                                                              child:
                                                                  CircularProgressIndicator(), // The loading spinner
                                                            );
                                                          },
                                                        );

                                                        Marker marker =
                                                            _markers2.first;
                                                        LatLng markerPostion =
                                                            marker.position;

                                                        double latitude =
                                                            markerPostion
                                                                .latitude;
                                                        double longitude =
                                                            markerPostion
                                                                .longitude;

                                                        // print(
                                                        //     'Latitude: $latitude, Longitude: $longitude');

                                                        //Convert Lat - log to Address
                                                        List<Placemark>
                                                            placemark =
                                                            await placemarkFromCoordinates(
                                                          latitude,
                                                          longitude,
                                                        );

                                                        Navigator.of(context)
                                                            .pop();

                                                        setState(() {
                                                          //SET VAR = VALUE
                                                          lat = latitude
                                                              .toString();
                                                          long = longitude
                                                              .toString();

                                                          // GET THE LOCATION
                                                          LatLng setlocation =
                                                              LatLng(latitude,
                                                                  longitude);

                                                          _markers.clear();
                                                          _markers.add(
                                                            Marker(
                                                              markerId: MarkerId(
                                                                  setlocation
                                                                      .toString()),
                                                              position:
                                                                  setlocation,
                                                              infoWindow:
                                                                  InfoWindow(
                                                                title:
                                                                    'Selected Location',
                                                              ),
                                                              icon: BitmapDescriptor
                                                                  .defaultMarkerWithHue(
                                                                      BitmapDescriptor
                                                                          .hueRed),
                                                            ),
                                                          );

                                                          placeM =
                                                              'Country = ${placemark.reversed.last.country}'
                                                              'Province = ${placemark.reversed.last.locality}'
                                                              'Street = ${placemark.reversed.last.street}'
                                                              'KHAN = ${placemark.reversed.last.subLocality}';
                                                          // print("ADDRESS =" +
                                                          //     placeM);
                                                          country = placemark
                                                              .reversed
                                                              .last
                                                              .country
                                                              .toString();
                                                          province = placemark
                                                              .reversed
                                                              .last
                                                              .locality
                                                              .toString();
                                                          street = placemark
                                                              .reversed
                                                              .last
                                                              .street
                                                              .toString();
                                                          khan = placemark
                                                              .reversed
                                                              .last
                                                              .subLocality
                                                              .toString();

                                                          //END LOADING SCREEN
                                                          Navigator.of(context)
                                                              .pop();

                                                          //MOVE CAMERA
                                                          mapController
                                                              .animateCamera(
                                                            CameraUpdate
                                                                .newLatLngZoom(
                                                                    setlocation,
                                                                    10.0),
                                                          );
                                                        });
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        primary: Colors.orange,
                                                      ),
                                                      child: Text(
                                                        'Save',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
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
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //
            //Insert Detail address
            Container(
              width: double.infinity,
              height: 240,
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 236, 240, 241),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Row(
                children: [
                  //LEFT
                  Container(
                    width: 100,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                    ),
                    child: Column(
                      children: [
                        //Contact
                        Container(
                          width: double.infinity,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Contact",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                Text(
                                  " *",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.red),
                                ),
                                Text(
                                  " :",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              ]),
                        ),
                        //Gender Radio
                        Container(
                          width: double.infinity,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Gender",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                Text(
                                  " *",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.red),
                                ),
                                Text(
                                  " :",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              ]),
                        ),
                        //Tel
                        Container(
                          width: double.infinity,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Tel",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                Text(
                                  " *",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.red),
                                ),
                                Text(
                                  " :",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              ]),
                        ),
                        //Detail
                        Container(
                          width: double.infinity,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Detail :",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        )
                      ],
                    ),
                  ),
                  //RIGHT
                  Expanded(
                    child: Container(
                      height: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                      ),
                      child: Column(
                        children: [
                          //Contact
                          Container(
                            width: double.infinity,
                            height: 60,
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                              ),
                            ),
                            child: TextField(
                              controller: c_contact,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Name",
                                hintStyle: TextStyle(
                                  color: Color.fromARGB(255, 79, 79, 79)
                                      .withOpacity(0.5),
                                ),
                              ),
                            ),
                          ),
                          //GENDER
                          Container(
                            width: double.infinity,
                            height: 60,
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Radio(
                                  value: options[0],
                                  groupValue: currentOption,
                                  activeColor: Colors.orange,
                                  onChanged: (value) {
                                    setState(() {
                                      currentOption = value.toString();
                                    });
                                  },
                                ),
                                Text("Mr."),
                                SizedBox(
                                  width: 10,
                                ),
                                Radio(
                                  value: options[1],
                                  groupValue: currentOption,
                                  activeColor: Colors.orange,
                                  onChanged: (value) {
                                    setState(() {
                                      currentOption = value.toString();
                                    });
                                  },
                                ),
                                Text("Ms.")
                              ],
                            ),
                          ),
                          //TEL
                          Container(
                            width: double.infinity,
                            height: 60,
                            alignment: Alignment.centerLeft,
                            child: TextField(
                              controller: c_tel,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Phone number",
                                hintStyle: TextStyle(
                                  color: Color.fromARGB(255, 79, 79, 79)
                                      .withOpacity(0.5),
                                ),
                              ),
                            ),
                          ),
                          //Detail
                          Container(
                            width: double.infinity,
                            height: 60,
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(10),
                              ),
                            ),
                            child: TextField(
                              controller: c_detail,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "House number, place, room ,etc",
                                hintStyle: TextStyle(
                                  color: Color.fromARGB(255, 79, 79, 79)
                                      .withOpacity(0.5),
                                ),
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
            //||Insert Detail address
            //
            //Add address photo'
            Container(
              width: double.infinity,
              height: 280,
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 236, 240, 241),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                children: [
                  //HEAD UPLOAD IMG
                  Container(
                    width: double.infinity,
                    height: 60,
                    padding: EdgeInsets.only(left: 10),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      border: Border(
                        bottom: BorderSide(
                            color: Color.fromARGB(255, 157, 157, 157),
                            width: 2.0),
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          "Address Photo :",
                          style: TextStyle(
                              color: Color.fromARGB(255, 79, 79, 79)
                                  .withOpacity(0.5),
                              fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.orange,
                            ),
                            onPressed: () {
                              uploadFunction();
                            },
                            child: Text("Upload",
                                style: TextStyle(
                                    fontSize: 15, color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //BODY UPLOAD IMG
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                      ),
                      child: loading
                          ? Container(
                              width: 200,
                              child: Center(
                                  child: Transform.scale(
                                      scale: 1.25,
                                      child: CupertinoActivityIndicator())),
                            )
                          : imageFileList != null
                              ? Container(
                                  margin: EdgeInsets.all(10),
                                  width: double.infinity,
                                  height: 200,
                                  color: Colors.blueGrey,
                                  child: Image.file(
                                    File(imageFileList!.path),
                                    fit: BoxFit.fill,
                                  ),
                                )
                              : Container(
                                  width: 200,
                                  child: Center(
                                    child: Text(
                                      "No Image Uploaded",
                                      style: TextStyle(
                                          color: Colors.orange, fontSize: 15),
                                    ),
                                  ),
                                ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      //||BODY
      // FLOAT
      floatingActionButton: Container(
        width: double.infinity,
        height: 40,
        padding: EdgeInsets.only(left: 10, right: 10),
        child: FloatingActionButton(
          onPressed: () {
            // print('Contact = ${c_contact.text}');
            // print('Gender = $currentOption');
            // print('Tel = ${c_tel.text}');
            // print('Detail = ${c_detail.text}');
            // // print('Photo = ${arrImageUrl[0]}');
            // print('Lat = $lat, log = $long');
            f_postAddress();
          },
          child: Text(
            "SAVE",
            style: TextStyle(color: Colors.white),
          ),

          backgroundColor: Colors.orange, // Change the background color
          shape: RoundedRectangleBorder(
            // Change the shape
            borderRadius: BorderRadius.circular(16), // Rounded corners
          ),
        ),
      ),
      //to make float btn in center
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      resizeToAvoidBottomInset: false,
    );
  }

  // Method Tap to add marker
  void _handleTap2(LatLng tappedPoint) {
    setState(() {
      _markers2.clear();
      _markers2.add(
        Marker(
          markerId: MarkerId(tappedPoint.toString()),
          position: tappedPoint,
          infoWindow: InfoWindow(
            title: 'Selected Location',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );

      // Get latitude and longitude from the tapped point
      var latitude = tappedPoint.latitude;
      var longitude = tappedPoint.longitude;

      // Print the latitude and longitude
      // print("Tapped Latitude: $latitude, Tapped Longitude: $longitude");
      // print("Markers: $_markers");
    });
  }
}
