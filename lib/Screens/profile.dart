import 'dart:convert';
import 'dart:io';

import 'package:abir_sabil/Providers/auth.dart';
import 'package:abir_sabil/Screens/Auth/UserType.dart';
import 'package:abir_sabil/Screens/Map.dart';
import 'package:abir_sabil/main.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import 'package:location/location.dart';
import 'package:provider/provider.dart';
// import 'package:geocoder/geocoder.dart';

class profile extends StatefulWidget {
  const profile({Key? key}) : super(key: key);

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  double? lat;
  double? long;
  File? filex;
  Future selectFile(XFile? file) async {
    // final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (file == null) {
      return;
    }
    final path = file.path;

    setState(() {
      filex = File(path);
    });
  }

  getAddressFromLatLng(context, double lat, double lng) async {
    String _host = 'https://maps.google.com/maps/api/geocode/json';
    final url =
        '$_host?key=AIzaSyDr4ElWM1yVRYWE6ldvD3mhGokioUb4-SA&language=en&latlng=$lat,$lng';
    if (lat != null && lng != null) {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        String _formattedAddress = data["results"][0]["formatted_address"];
        print("response ==== $_formattedAddress");
        return _formattedAddress;
      } else
        return null;
    } else
      return null;
  }

  Future uploadFile() async {
    if (filex == null) return;
    final num = math.Random();
    final filename = 'test.png';
    final destination = 'files/$filename';

    final x = FirebaseApi.uploadFile(destination, filex!);
  }

  Future<void> getLoc() async {
    setState(() {
      _isLoading = true;
    });
    var location = Location();

    var locationEnabled = await location.serviceEnabled();

    if (!locationEnabled) {
      locationEnabled = await location.requestService();
      if (!locationEnabled) {
        return;
      }
    }

    var _permission = await location.hasPermission();
    if (_permission == PermissionStatus.denied) {
      _permission = await location.requestPermission();
      if (_permission != PermissionStatus.granted) {
        return;
      }
    }

    var currentLocation = await location.getLocation();

    lat = currentLocation.latitude;
    long = currentLocation.longitude;
    // getAddressFromLatLng(context, lat!, long!);

    // final coordinates = Coordinates(lat, long);
    // var addresses =
    //     await Geocoder.local.findAddressesFromCoordinates(coordinates);

    // print(addresses);

    setState(() {
      _isLoading = false;
    });
  }

  bool _isLoading = false;

  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;

  Future<void> getInfos() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<AuthService>(context, listen: false).getUserInfos();
    } catch (e) {
      print(e.toString());
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getInfos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final WidthSize = MediaQuery.of(context).size.width;
    final HeightSize = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top +
            MediaQuery.of(context).padding.bottom);
    final prov = Provider.of<AuthService>(context, listen: false);
    final sizee = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Color(0xffe5e5e5),
        appBar: AppBar(
          title: Center(child: Text("الملف الشخصي")),
          automaticallyImplyLeading: false,
          backgroundColor: Color(0xffFAC358),
          actions: [
            Transform.rotate(
              angle: 180 * math.pi / 180,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_outlined,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            )
            // InkWell(
            //     child:
            //         // child: Transform.rotate(
            //         //   angle: 180 * math.pi / 180,
            //         //   child:
            //         Padding(
            //       padding: const EdgeInsets.all(3.0),
            //       child: Icon(
            //         Icons.logout,
            //         color: Colors.white,
            //         size: WidthSize * (40.0 / 540),
            //       ),
            //     ),
            //     // ),
            //     onTap: () {
            //       FirebaseAuth.instance.signOut();
            //
            //     }),
            // ),
          ],
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Container(
                  // height: HeightSize,
                  height: MediaQuery.of(context).size.height,
                  child: Stack(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height,
                        color: Colors.white,
                      ),
                      Container(
                        child: Column(
                          children: [
                            SizedBox(
                              height: HeightSize * 0.32,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: HeightSize * 0.04),
                        child: Container(
                          alignment: Alignment.topCenter,
                          child: Column(
                            children: [
                              Container(
                                width: sizee.width * (65 / 540) * 2,
                                height: sizee.width * (65 / 540) * 2,
                                margin: EdgeInsets.only(
                                    top: sizee.height * (15 / 912),
                                    bottom: sizee.height * 0.01),
                                alignment: Alignment.center,
                                child: Stack(
                                  children: [
                                    CircleAvatar(
                                        backgroundColor: Colors.grey,
                                        radius: WidthSize * (65 / 540),
                                        child:
                                            //  filex == null
                                            //     ?
                                            Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(80)),
                                              image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: nu
                                                    ? AssetImage(
                                                        "assets/muslim.png")
                                                    : AssetImage(
                                                        "assets/restaurant.jpg"),
                                              )),
                                        )
                                        // : Image(image: FileImage(filex!)),
                                        ),
                                    (!nu)
                                        ? Align(
                                            alignment: Alignment.bottomRight,
                                            child: CircleAvatar(
                                              backgroundColor: Colors.grey[300],
                                              radius: sizee.width * (18 / 540),
                                              child: IconButton(
                                                padding: EdgeInsets.zero,
                                                icon: Icon(
                                                  Icons.photo_camera,
                                                  color:
                                                      const Color(0xffFAC358),
                                                  size:
                                                      sizee.width * (30 / 540),
                                                ),
                                                color: Colors.white,
                                                onPressed: () {
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          'ليست في الخدمة الآن');
                                                  // final imagefile =
                                                  //     await ImagePicker.platform
                                                  //         .getImage(
                                                  //             source:
                                                  //                 ImageSource
                                                  //                     .gallery);
                                                  // await selectFile(imagefile);
                                                },
                                              ),
                                            ),
                                          )
                                        : Container(),
                                  ],
                                ),
                              ),
                              // if (filex != null)
                              //   TextButton(
                              //       onPressed: () async {
                              //         uploadFile();
                              //       },
                              //       child: Text('upload')),
                              Text(
                                prov.userInfo[nu ? 'name' : 'restaurantName'],
                                style: TextStyle(
                                    fontSize: WidthSize * (25 / 540),
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff3E4958),
                                    fontFamily: 'Gothic'),
                              ),
                              Text(
                                nu ? 'صائم' : 'مطعم',
                                style: TextStyle(
                                    fontSize: WidthSize * (20 / 540),
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xffB1B0B0),
                                    fontFamily: 'Gothic'),
                              ),

                              //   Image(
                              //       fit: BoxFit.contain,
                              //       filterQuality: FilterQuality.low,
                              //       image: nu
                              //           ? AssetImage('assets/restaurant.jpg')
                              //           : AssetImage('assets/restaurant.jpg')),
                              // ),

                              Padding(
                                padding:
                                    EdgeInsets.only(top: HeightSize * 0.05),
                                child: Column(
                                  children: [
                                    Container(
                                      height: HeightSize * 0.47,
                                      child: Column(
                                        children: [
                                          (!nu)
                                              ? Center(
                                                  child: Card(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              bottomLeft: Radius
                                                                  .circular(5),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          5)),
                                                    ),
                                                    elevation: 1,
                                                    child: Container(
                                                      width: WidthSize * 0.75,
                                                      height: HeightSize * 0.06,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5))),
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            margin: EdgeInsets.only(
                                                                right:
                                                                    WidthSize *
                                                                        0.05),
                                                            width:
                                                                WidthSize * 0.6,
                                                            alignment: Alignment
                                                                .centerRight,
                                                            child: Text(
                                                              prov.userInfo[
                                                                  'restaurantName'],
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      WidthSize *
                                                                          (30 /
                                                                              540),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Color(
                                                                      0xffB1B0B0),
                                                                  fontFamily:
                                                                      'Gothic'),
                                                            ),
                                                          ),
                                                          Icon(
                                                            Icons
                                                                .storefront_outlined,
                                                            color: Color(
                                                                0xffB1B0B0),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : Container(),
                                          Center(
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(5),
                                                    bottomRight:
                                                        Radius.circular(5)),
                                              ),
                                              elevation: 1,
                                              child: Container(
                                                width: WidthSize * 0.75,
                                                height: HeightSize * 0.06,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                5))),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          right:
                                                              WidthSize * 0.05),
                                                      width: WidthSize * 0.6,
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: Text(
                                                        prov.userInfo['name'],
                                                        style: TextStyle(
                                                            fontSize:
                                                                WidthSize *
                                                                    (30 / 540),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Color(
                                                                0xffB1B0B0),
                                                            fontFamily:
                                                                'Gothic'),
                                                      ),
                                                    ),
                                                    Icon(
                                                      Icons.person,
                                                      color: Color(0xffB1B0B0),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Center(
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(5),
                                                    bottomRight:
                                                        Radius.circular(5)),
                                              ),
                                              elevation: 1,
                                              child: Container(
                                                width: WidthSize * 0.75,
                                                height: HeightSize * 0.06,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                5))),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          right:
                                                              WidthSize * 0.05),
                                                      width: WidthSize * 0.6,
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: Text(
                                                        prov.userInfo['email'],
                                                        style: TextStyle(
                                                            fontSize:
                                                                WidthSize *
                                                                    (30 / 540),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Color(
                                                                0xffB1B0B0),
                                                            fontFamily:
                                                                'Gothic'),
                                                      ),
                                                    ),
                                                    Icon(
                                                      Icons.email,
                                                      color: Color(0xffB1B0B0),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Center(
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(5),
                                                    bottomRight:
                                                        Radius.circular(5)),
                                              ),
                                              elevation: 1,
                                              child: Container(
                                                width: WidthSize * 0.75,
                                                height: HeightSize * 0.06,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                5))),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          right:
                                                              WidthSize * 0.05),
                                                      width: WidthSize * 0.6,
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: Text(
                                                        prov.userInfo['phone'],
                                                        style: TextStyle(
                                                            fontSize:
                                                                WidthSize *
                                                                    (30 / 540),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Color(
                                                                0xffB1B0B0),
                                                            fontFamily:
                                                                'Gothic'),
                                                      ),
                                                    ),
                                                    Icon(
                                                      Icons.call,
                                                      color: Color(0xffB1B0B0),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          if (!nu)
                                            TextButton(
                                              onPressed: () async {
                                                await getLoc().then((value) =>
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (_) =>
                                                                MapScreen(
                                                                    latitude:
                                                                        lat!,
                                                                    longitude:
                                                                        long!))));
                                              },
                                              child: Center(
                                                child: Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            bottomLeft: Radius
                                                                .circular(5),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    5)),
                                                  ),
                                                  elevation: 1,
                                                  child: Container(
                                                    width: WidthSize * 0.75,
                                                    height: HeightSize * 0.06,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5))),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left:
                                                                      WidthSize *
                                                                          0.02),
                                                          child: SvgPicture.asset(
                                                              "assets/localisation.svg",
                                                              color: Color(
                                                                  0xffFAC358),
                                                              semanticsLabel:
                                                                  'A red up arrow'),
                                                        ),
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  right:
                                                                      WidthSize *
                                                                          0.05),
                                                          width:
                                                              WidthSize * 0.5,
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child: Text(
                                                            'الموقع',
                                                            style: TextStyle(
                                                                fontSize:
                                                                    WidthSize *
                                                                        (30 /
                                                                            540),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Color(
                                                                    0xffB1B0B0),
                                                                fontFamily:
                                                                    'Gothic'),
                                                          ),
                                                        ),
                                                        Icon(
                                                          Icons.place,
                                                          color:
                                                              Color(0xffB1B0B0),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          SizedBox(
                                            height: HeightSize * 0.08,
                                          ),
                                        ],
                                      ),
                                    ),
                                    RaisedButton(
                                      onPressed: () {
                                        FirebaseAuth.instance
                                            .signOut()
                                            .then((value) {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) => UserType()));
                                        });
                                      },
                                      padding: const EdgeInsets.all(0.0),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0)),
                                      child: Container(
                                        width: WidthSize * 0.8,
                                        height: HeightSize * 0.08,
                                        decoration: const BoxDecoration(
                                            color: Color(0xffFAC358),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0))),
                                        child: Center(
                                          child: Text(
                                            "تسجيل الخروج",
                                            style: TextStyle(
                                              fontFamily: "Gothic",
                                              fontSize: WidthSize * (25 / 540),
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
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

class FirebaseApi {
  static UploadTask? uploadFile(String dest, File file) {
    try {
      final ref = FirebaseStorage.instance.ref(dest);

      return ref.putFile(file);
    } catch (e) {
      print(e.toString());
    }
  }
}
