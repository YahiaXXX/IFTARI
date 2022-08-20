import 'package:abir_sabil/Screens/Auth/Signin.dart';
import 'package:abir_sabil/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Providers/auth.dart';

class UserType extends StatefulWidget {
  const UserType({Key? key}) : super(key: key);

  @override
  State<UserType> createState() => _UserTypeState();
}

class _UserTypeState extends State<UserType> {
  @override
  Widget build(BuildContext context) {
    final authServicer = Provider.of<AuthService>(context);
    final WidthSize = MediaQuery.of(context).size.width;
    final HeightSize = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top +
            MediaQuery.of(context).padding.bottom);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Color(0xff582e44),
            width: WidthSize,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                SizedBox(
                  height: HeightSize * 0.5,
                ),
                Expanded(
                    child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xffFAC358).withOpacity(1),
                      Color(0xff3FB876).withOpacity(0.9),
                    ],
                  )),
                  width: WidthSize,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: HeightSize * 0.3,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            fit: BoxFit.cover,
                            opacity: 0.5,
                            image: AssetImage(
                              "assets/hilel2.png",
                            ),
                          )),
                        ),
                      ),
                      Center(
                        child: Column(
                          children: [
                            SizedBox(
                              height: HeightSize * 0.23,
                            ),
                            RaisedButton(
                              onPressed: () async {
                                nu = true;
                                await authServicer
                                    .updateVisisteurOrVendeur(true);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Signin()),
                                );
                              },
                              padding: const EdgeInsets.all(0.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                              child: Container(
                                width: WidthSize * 0.75,
                                height: HeightSize * 0.08,
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0))),
                                child: Center(
                                  child: Text(
                                    "عابر سبيل",
                                    style: TextStyle(
                                      color: Color(0xff582e44),
                                      fontFamily: 'Hacen',
                                      fontSize: WidthSize * (25 / 540),
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: HeightSize * 0.04,
                            ),
                            RaisedButton(
                              onPressed: () async {
                                nu = false;
                                await authServicer
                                    .updateVisisteurOrVendeur(false);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Signin()),
                                );
                              },
                              padding: const EdgeInsets.all(0.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                              child: Container(
                                width: WidthSize * 0.75,
                                height: HeightSize * 0.08,
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0))),
                                child: Center(
                                  child: Text(
                                    "مطعم رحمة",
                                    style: TextStyle(
                                      color: Color(0xff582e44),
                                      fontFamily: 'Hacen',
                                      fontSize: WidthSize * (25 / 540),
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
          Container(
            width: WidthSize,
            child: Column(
              children: [
                SizedBox(
                  height: HeightSize * 0.1,
                ),
                Text(
                  'مرحبا بك',
                  style: TextStyle(
                      color: Color(0xffF39508),
                      fontSize: WidthSize * (40 / 540),
                      fontFamily: 'Hacen',
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                    vertical: HeightSize * 0.01,
                  ),
                  height: WidthSize * 0.3,
                  width: WidthSize * 0.3,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(80)),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(
                          "assets/aber_sabel.png",
                        ),
                      )),
                ),
              ],
            ),
            height: MediaQuery.of(context).size.height * 0.6,
            decoration: const BoxDecoration(
              image: DecorationImage(
                opacity: 0.2,
                fit: BoxFit.contain,
                image: AssetImage("assets/hilal.png"),
              ),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(60)),
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
