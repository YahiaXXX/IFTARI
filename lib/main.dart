// import 'dart:js';

import 'package:abir_sabil/Providers/DzData.dart';
import 'package:abir_sabil/Providers/restaurant.dart';
import 'package:abir_sabil/Screens/Auth/Signin.dart';
import 'package:abir_sabil/Screens/Auth/UserType.dart';
import 'package:abir_sabil/Screens/accueil.dart';
import 'package:abir_sabil/Screens/accueil_resto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'Providers/auth.dart';
import 'Screens/Auth/forgotPassword.dart';
import 'Screens/profile.dart';
import 'Screens/restaurant_details.dart';

bool nu = false;
void main() async {
  Color primaryColor = Color(0xffbd7344);
  Color secondlyColor = Color(0xffa8293c);
  Color thirdlyColor = Color(0xff582e44);
  Color fourthColor = Color(0xff8e7a3d);
  Color fivethcolor = Color(0xffd7b957);

  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  User? auth = FirebaseAuth.instance.currentUser;
  // print(user!.uid);

  var user = await FirebaseFirestore.instance.collection('restaurants').get();
  bool check(String id) {
    for (int i = 0; i < user.docs.length; i++) {
      if (id == user.docs[i].id) {
        return true;
      }
    }
    return false;
  }

  runApp(MultiProvider(
    providers: [
      ListenableProvider<AuthService>(
        create: (_) => AuthService(),
      ),
      ListenableProvider<DataDz>(
        create: (_) => DataDz(),
      ),
      ListenableProvider<Restaurants>(
        create: (_) => Restaurants(),
      ),
    ],
    child: MaterialApp(
        theme: ThemeData(fontFamily: 'Hacen'),
        debugShowCheckedModeBanner: false,
        debugShowMaterialGrid: false,
        home:
            //  Builder(builder: (_) {
            //   if (auth == null) {
            //     return const UserType();
            //   } else {
            //     var id = FirebaseAuth.instance.currentUser!.uid;
            //     // print(id);
            //     nu = !check(id);
            //     if (nu) {
            //       return const accueil();
            //     } else {
            //       return const accueil_resto();
            //     }
            //   }
            // })

            StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              var id = FirebaseAuth.instance.currentUser!.uid;
              print(id);
              nu = !check(id);
              if (nu) {
                return const accueil();
              } else {
                return const accueil_resto();
              }
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('error'),
              );
            } else {
              return const UserType();
            }
          },
        )
        //  user == null ? UserType() : accueil() // signin()
        ),
  ));
}
