import 'dart:convert';

import 'package:abir_sabil/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// class Menu {
//   String? soupe;
//   String? plat_princip;
//   String? plat_sec;
//   String? ;

// }
// class Menus extends ChangeNotifier{}

class AuthService extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  bool googleSignedIn = false;
  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;

  String? _token;
  String? _uId;
  DateTime? _expiryDate;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_token != null &&
        _expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now())) {
      return _token;
    }
    return null;
  }

  String? get uId {
    return _uId;
  }

  Future<void> googleLogIn() async {
    try {
      final googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        return;
      }
      _user = googleUser;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      await FirebaseAuth.instance.signInWithCredential(credential);
      googleSignedIn = true;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signUp(String email, String password, String name, String phone,
      String restName, String city, String commune) async {
    String where = isVisiteur ? 'volounteers' : 'restaurants';
    var dataa = isVisiteur
        ? {
            'name': name,
            'email': email,
            'phone': phone,
            'isVolounteer': false,
            'whereVolunter': '',
            'isReserved': false,
            'whereReserved': ''
          }
        : {
            'name': name,
            'email': email,
            'phone': phone,
            'restaurantName': restName,
            'photo': '',
            'city': city,
            'commune': commune,
            'location': [],
            'hasMenu': false,
            'need_vol': false,
            'vols_number': 0,
            'need_number_vol': 0,
          };
    try {
      String id;
      CollectionReference collectionReference =
          FirebaseFirestore.instance.collection(where);
      final auth = FirebaseAuth.instance;
      await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        id = value.user!.uid;
        await collectionReference
            .doc(value.user!.uid)
            .set(dataa)
            .then((value) async {
          final infos =
              await FirebaseFirestore.instance.collection(where).doc(id).get();

          userInfo = infos.data()!;
          if (where == 'restaurants') {
            nu = false;
          } else {
            nu = true;
          }
        });
      });

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Map<String, dynamic> userInfo = {
    'name': '',
    'email': '',
    'phone': '',
    'isVlounteer': false,
    'location': [0.0, 0.0],
    'city': '',
    'commune': '',
    'hasMenu': false,
    'image': '',
  };
  // bool s = nu;

  Future<void> getUserInfos() async {
    try {
      final auth = FirebaseAuth.instance.currentUser;
      final where = nu ? 'volounteers' : 'restaurants';
      final user = await FirebaseFirestore.instance
          .collection(where)
          .doc(auth!.uid)
          .get();
      userInfo = user.data()!;
      // print(userInfo);
      // print(userInfo);
      // print(user.data());
      if (nu) {
      } else {}
    } catch (e) {
      rethrow;
    }
  }

  bool _userType = false;
  bool _isRest = false;

  bool get userType {
    return _userType;
  }

  bool get isRest {
    return _isRest;
  }

  Future<bool> signIn(String email, String password) async {
    bool retur = false;
    try {
      final auth = FirebaseAuth.instance;
      await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        await FirebaseFirestore.instance
            .collection('volounteers')
            .doc(value.user!.uid)
            .get()
            .then((value) {
          if (value.exists) {
            retur = true;
            _userType = true;
            notifyListeners();
          } else {
            retur = true;
            _isRest = true;
            notifyListeners();
          }
        });
        return true;
      });
      if (!retur) {
        FirebaseAuth.instance.signOut();
        return false;
      }
      return true;

      // final auth2 = FirebaseAuth.instance;

      // print('assured' + auth2.currentUser!.email!);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createUser(
      String email, String phone, String name, String restName) async {
    String where = isVisiteur ? 'volounteers' : 'restaurants';
    // final user = FirebaseAuth.instance.currentUser!;

    Map<String, dynamic> data = isVisiteur
        ? {
            'id': _uId,
            'name': name,
            'email': email,
            'phone': phone,
            'isVolounteer': false
          }
        : {
            'id': _uId,
            'name': name,
            'email': email,
            'phone': phone,
            'restaurantName': restName,
            'photo': '',
            'city': '',
            'location': '',
          };

    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection(where);
    try {
      await collectionReference.doc(_uId).set(data);
    } catch (e) {
      print(e.toString());
    }
  }

  bool isVisiteur = false;

  updateVisisteurOrVendeur(bool X) async {
    isVisiteur = X;
    notifyListeners();
  }
}
