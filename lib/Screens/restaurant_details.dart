import 'package:abir_sabil/Providers/restaurant.dart';
import 'package:abir_sabil/Screens/Map.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import 'package:url_launcher/url_launcher.dart';

class restaurant_details extends StatefulWidget {
  final String title;
  const restaurant_details({Key? key, required this.title}) : super(key: key);

  @override
  State<restaurant_details> createState() => _restaurant_detailsState();
}

class _restaurant_detailsState extends State<restaurant_details> {
  bool _isLoading = false;
  bool _isLoading2 = false;
  double? lat;
  double? long;
  Map<String, dynamic>? userInfo = {};
  Map<String, dynamic>? menu = {};
  Future<void> volunter(int m, bool abondone) async {
    setState(() {
      _isLoading2 = true;
    });

    try {
      final rest = Provider.of<Restaurants>(context, listen: false);
      final auth = FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance
          .collection('volounteers')
          .doc(auth!.uid)
          .update({
        'isVolounteer': abondone ? false : true,
        'whereVolunter': abondone ? '' : rest.chosenRestaurant!.id,
        'timeVolunteer': abondone ? null : DateTime.now()
      });

      final data = await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(rest.chosenRestaurant!.id)
          .get();
      final info = data.data();
      await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(rest.chosenRestaurant!.id)
          .update({
        'vols_number': info!['vols_number'] + m,
        'need_number_vol': info['need_number_vol'] - m,
      });
    } catch (e) {
      print(e.toString());
    }
    setState(() {
      _isLoading2 = false;
    });
  }

  Future<void> getInfos() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final auth = FirebaseAuth.instance.currentUser;
      final data = await FirebaseFirestore.instance
          .collection('volounteers')
          .doc(auth!.uid)
          .get();
      userInfo = data.data();
    } catch (e) {
      print(e.toString());
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> reserve(int m, bool reserved) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final auth = FirebaseAuth.instance.currentUser;
      final rest =
          Provider.of<Restaurants>(context, listen: false).chosenRestaurant;
      final data = await FirebaseFirestore.instance
          .collection('menus')
          .doc(rest!.id)
          .get();
      final prevValue = data.data();
      await FirebaseFirestore.instance
          .collection('menus')
          .doc(rest.id)
          .update({'repas_dispo': prevValue!['repas_dispo'] + m});
      await FirebaseFirestore.instance
          .collection('volounteers')
          .doc(auth!.uid)
          .update({
        'isReserved': reserved ? true : false,
        'whereReserved': reserved ? rest.id : '',
        'reserveTime': reserved ? DateTime.now() : null
      });
    } catch (e) {
      print(e.toString());
    }
    setState(() {
      _isLoading = false;
    });
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

  Future<void> getMenu() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final rest =
          Provider.of<Restaurants>(context, listen: false).chosenRestaurant;

      final data = await FirebaseFirestore.instance
          .collection('menus')
          .doc(rest!.id)
          .get();
      menu = data.data();
    } catch (e) {
      print(e.toString());
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    getInfos();
    getMenu();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final sizee = MediaQuery.of(context).size;
    final rest = Provider.of<Restaurants>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xffFAC358),
        title: Center(child: Text(widget.title)),
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
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              height: sizee.height,
              width: sizee.width,
              margin: EdgeInsets.only(
                  top: sizee.height * 0.04, bottom: sizee.height * 0.00),
              child: Stack(
                children: [
                  Container(
                    height: sizee.height,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: sizee.height * 0.6,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          fit: BoxFit.fitWidth,
                          opacity: 0.5,
                          image: AssetImage(
                            "assets/hilel3.png",
                          ),
                        )),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: sizee.height * 0.02),
                                height: sizee.height * 0.32,
                                width: sizee.width * 0.35,
                                child: Column(
                                  children: [
                                    Container(
                                        width: sizee.width * 0.35,
                                        height: sizee.height * 0.05,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Color(0xffFAC358),
                                          ),
                                          borderRadius: const BorderRadius.only(
                                              topRight: Radius.circular(5),
                                              bottomRight: Radius.circular(5)),
                                        ),
                                        child: Center(
                                            child: Text(
                                          '${rest.chosenRestaurant!.city}, ${rest.chosenRestaurant!.commune}',
                                          style: TextStyle(color: Colors.black),
                                        ))),
                                    Container(
                                        width: sizee.width * 0.35,
                                        height: sizee.height * 0.05,
                                        margin: EdgeInsets.symmetric(
                                            vertical: sizee.height * 0.012),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Color(0xffFAC358),
                                          ),
                                          borderRadius: const BorderRadius.only(
                                              topRight: Radius.circular(5),
                                              bottomRight: Radius.circular(5)),
                                        ),
                                        child: Center(
                                            child: Text(
                                          'متوفر ${menu!['repas_dispo']} مقعد ',
                                          style: TextStyle(color: Colors.black),
                                        ))),
                                    _isLoading
                                        ? CircularProgressIndicator()
                                        : Container(
                                            child: InkWell(
                                            onTap: () async {
                                              if (!userInfo!['isReserved']) {
                                                Fluttertoast.showToast(
                                                    msg: 'جاري الحجز');
                                                await reserve(-1, true).then((value) =>
                                                    Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (_) =>
                                                                restaurant_details(
                                                                    title: rest
                                                                        .chosenRestaurant!
                                                                        .restName!))));
                                              } else if (userInfo![
                                                      'isReserved'] &&
                                                  userInfo!['whereReserved'] ==
                                                      rest.chosenRestaurant!
                                                          .id) {
                                                Fluttertoast.showToast(
                                                    msg: 'جاري حذف الحجز');
                                                await reserve(1, false).then((value) =>
                                                    Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (_) =>
                                                                restaurant_details(
                                                                    title: rest
                                                                        .chosenRestaurant!
                                                                        .restName!))));
                                              }
                                            },
                                            child: _isLoading
                                                ? CircularProgressIndicator()
                                                : Container(
                                                    child: Center(
                                                      child: userInfo![
                                                                  'isReserved'] &&
                                                              userInfo![
                                                                      'whereReserved'] ==
                                                                  rest.chosenRestaurant!
                                                                      .id
                                                          ? const Text(
                                                              'إلغاء الحجز',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            )
                                                          : userInfo![
                                                                  'isReserved']
                                                              ? const Text(
                                                                  'تم الحجز مسبقا')
                                                              : const Text(
                                                                  'احجز مقعد',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                    ),
                                                    width: sizee.width * 0.24,
                                                    height: sizee.height * 0.05,
                                                    margin: EdgeInsets.only(
                                                        top: sizee.height *
                                                            0.01),
                                                    decoration: BoxDecoration(
                                                      color: Color(0xffFAC358),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey
                                                              .withOpacity(
                                                                  0.05),
                                                          spreadRadius: 5,
                                                          blurRadius: 10,
                                                          offset: const Offset(
                                                              0,
                                                              3), // changes position of shadow
                                                        ),
                                                      ],
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                        Radius.circular(5),
                                                      ),
                                                    ),
                                                  ),
                                          )),
                                    Container(
                                      width: sizee.width * 0.35,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                              width: sizee.width * 0.08,
                                              height: sizee.width * 0.08,
                                              margin: EdgeInsets.symmetric(
                                                  vertical:
                                                      sizee.height * 0.02),
                                              decoration: BoxDecoration(
                                                color: Color(0xffFAC358),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.05),
                                                    spreadRadius: 5,
                                                    blurRadius: 10,
                                                    offset: const Offset(0,
                                                        3), // changes position of shadow
                                                  ),
                                                ],
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(5),
                                                ),
                                              ),
                                              child: Center(
                                                child: IconButton(
                                                  icon: Icon(
                                                    Icons.call,
                                                    size: 18,
                                                    color: Colors.white,
                                                  ),
                                                  onPressed: () {
                                                    launch(
                                                        'tel:${rest.chosenRestaurant!.phone!}');
                                                  },
                                                ),
                                              )),
                                          Container(
                                              width: sizee.width * 0.08,
                                              height: sizee.width * 0.08,
                                              decoration: BoxDecoration(
                                                color: Color(0xffFAC358),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.05),
                                                    spreadRadius: 5,
                                                    blurRadius: 10,
                                                    offset: const Offset(0,
                                                        3), // changes position of shadow
                                                  ),
                                                ],
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(5),
                                                ),
                                              ),
                                              child: Center(
                                                child: IconButton(
                                                  icon: Icon(
                                                    Icons.place,
                                                    size: 18,
                                                    color: Colors.white,
                                                  ),
                                                  onPressed: () {
                                                    showDialog(
                                                        context: context,
                                                        builder:
                                                            (BuildContext ctx) {
                                                          return AlertDialog(
                                                            title: Text(
                                                                'هل تسمح للتطبيق بتحديد مكانك من أجل إرشادك الى المطعم ؟'),
                                                            actions: [
                                                              TextButton(
                                                                  onPressed:
                                                                      () async {
                                                                    Navigator
                                                                        .pop(
                                                                            ctx);
                                                                    await getLoc().then((value) => Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (_) => MapScreen(
                                                                                  latitude: lat!,
                                                                                  longitude: long!,
                                                                                  user: true,
                                                                                ))));
                                                                    Navigator
                                                                        .pop(
                                                                            ctx);
                                                                  },
                                                                  child: Text(
                                                                      'تأكيد')),
                                                              TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator
                                                                        .pop(
                                                                            ctx);
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (_) => MapScreen(
                                                                                  latitude: rest.chosenRestaurant!.latitude!,
                                                                                  longitude: rest.chosenRestaurant!.longitude!,
                                                                                  user: false,
                                                                                )));
                                                                  },
                                                                  child: Text(
                                                                      'رفض')),
                                                            ],
                                                          );
                                                        });

                                                    // launchMap();
                                                  },
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                  ],
                                )),
                            Container(
                              margin: EdgeInsets.only(right: sizee.width * 0.1),
                              height: sizee.height * 0.3,
                              width: sizee.width * 0.45,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage("assets/restaurant.jpg"),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.05),
                                    spreadRadius: 5,
                                    blurRadius: 10,
                                    offset: const Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(15)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: sizee.height * 0.05,
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(13),
                          ),
                        ),
                        elevation: 10,
                        child: Container(
                          width: sizee.width * 0.8,
                          padding: EdgeInsets.symmetric(
                              vertical: sizee.height * 0.02,
                              horizontal: sizee.width * 0.03),
                          margin: EdgeInsets.symmetric(),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color(0xffFAC358),
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                          height: sizee.height * 0.2,
                          child: Column(
                            children: [
                              Center(
                                  child: Text(
                                'قائمة اليوم',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                              Container(
                                width: sizee.width * 0.7,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: sizee.width * 0.45,
                                          child: Text(
                                            '${menu!['soupe']}',
                                            textDirection: TextDirection.rtl,
                                          ),
                                        ),
                                        Text(':الحساء ')
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: sizee.width * 0.45,
                                          child: Text(
                                            '${menu!['plat_principal']}',
                                            textDirection: TextDirection.rtl,
                                          ),
                                        ),
                                        Text(':الطبق الرئيسي ')
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: sizee.width * 0.45,
                                          child: Text(
                                            '${menu!['plat_sec']}',
                                            textDirection: TextDirection.rtl,
                                          ),
                                        ),
                                        Text(':الطبق الثانوي ')
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: sizee.width * 0.45,
                                          child: Text(
                                            '${menu!['entree']}',
                                            textDirection: TextDirection.rtl,
                                          ),
                                        ),
                                        Text(':المقبلة ')
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: sizee.width * 0.45,
                                          child: Text(
                                            '${menu!['dessert']}',
                                            textDirection: TextDirection.rtl,
                                          ),
                                        ),
                                        Text(':التحلية ')
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: sizee.width * 0.45,
                                          child: Text(
                                            '${menu!['autre']}',
                                            textDirection: TextDirection.rtl,
                                          ),
                                        ),
                                        Text(':أخرى ')
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: sizee.height * 0.05,
                      ),
                      if (rest.chosenRestaurant!.needVol! &&
                          rest.chosenRestaurant!.needNumberVols! >
                              rest.chosenRestaurant!.volsNumber!)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _isLoading2
                                ? CircularProgressIndicator()
                                : Container(
                                    child: InkWell(
                                    onTap: () async {
                                      if (!userInfo!['isVolounteer']) {
                                        await volunter(1, false).then((value) {
                                          rest.chosenRestaurant!
                                              .needNumberVols = rest
                                                  .chosenRestaurant!
                                                  .needNumberVols! -
                                              1;
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      restaurant_details(
                                                          title: rest
                                                              .chosenRestaurant!
                                                              .restName!)));
                                        });
                                      } else if (userInfo!['isVolounteer'] &&
                                          userInfo!['whereVolunter'] ==
                                              rest.chosenRestaurant!.id) {
                                        await volunter(-1, true).then((value) {
                                          rest.chosenRestaurant!
                                              .needNumberVols = rest
                                                  .chosenRestaurant!
                                                  .needNumberVols! +
                                              1;
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      restaurant_details(
                                                          title: rest
                                                              .chosenRestaurant!
                                                              .restName!)));
                                        });
                                      }
                                    },
                                    child: Container(
                                      child: Center(
                                        child: Text(
                                          userInfo!['isVolounteer'] &&
                                                  userInfo!['whereVolunter'] ==
                                                      rest.chosenRestaurant!.id
                                              ? 'إلغاء التطوع'
                                              : userInfo!['isVolounteer']
                                                  ? 'متطوع'
                                                  : 'تطوع الآن',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      width: sizee.width * 0.2,
                                      height: sizee.height * 0.05,
                                      margin: EdgeInsets.only(
                                          top: sizee.height * 0.01),
                                      decoration: BoxDecoration(
                                        color: Color(0xffFAC358),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.grey.withOpacity(0.05),
                                            spreadRadius: 5,
                                            blurRadius: 10,
                                            offset: const Offset(0,
                                                3), // changes position of shadow
                                          ),
                                        ],
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                      ),
                                    ),
                                  )),
                            Container(
                              width: sizee.width * 0.3,
                              height: sizee.height * 0.05,
                              margin: EdgeInsets.only(top: sizee.height * 0.01),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white,
                                    spreadRadius: 5,
                                    blurRadius: 10,
                                    offset: const Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'متطوع',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    Text(
                                      '  ${rest.chosenRestaurant!.needNumberVols} ',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    Text(
                                      'نحتاج',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  launchMap({String lat = "47.6", String long = "-122.3"}) async {
    var mapSchema = 'geo:$lat,$long';
    if (await canLaunch(mapSchema)) {
      await launch(mapSchema);
    } else {
      throw 'Could not launch $mapSchema';
    }
  }
}
