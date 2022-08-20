import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Restaurant {
  String? id;
  String? name;
  String? restName;
  String? imgUrl;
  String? city;
  String? phone;
  String? commune;
  double? latitude;
  double? longitude;
  int? needNumberVols;
  // Map<String, dynamic>? menu;
  bool? needVol;
  int? volsNumber;
  bool? hasMenu;

  Restaurant(
      {required this.id,
      required this.name,
      required this.restName,
      required this.imgUrl,
      required this.city,
      required this.phone,
      required this.commune,
      required this.latitude,
      required this.longitude,
      required this.needNumberVols,
      // required this.menu,
      required this.needVol,
      required this.volsNumber,
      required this.hasMenu});
}

class Restaurants extends ChangeNotifier {
  List<Restaurant> rests = [];
  Restaurant? chosenRestaurant;
  void restoById(String id) {
    for (int i = 0; i < rests.length; i++) {
      if (id == rests[i].id) {
        chosenRestaurant = rests[i];
        notifyListeners();
      }
    }
  }

  List<Restaurant> loadedList = [];
  void filterListWC(String city, String commune) {
    for (int i = 0; i < rests.length; i++) {
      if (city == rests[i].city && commune == rests[i].commune) {
        loadedList.add(rests[i]);
      }
    }
    notifyListeners();
  }

  void filterList(String name) {
    for (int i = 0; i < rests.length; i++) {
      if (name == rests[i].city) {
        loadedList.add(rests[i]);
      }
    }
    notifyListeners();
  }

  Future<void> getRestaurants() async {
    try {
      final data =
          await FirebaseFirestore.instance.collection('restaurants').get();

      final docs = data.docs;

      Map<String, dynamic> holder;
      rests.clear();
      for (var element in docs) {
        var id = element.id;
        holder = element.data();
        if (holder['hasMenu']) {
          // print(id);
          rests.add(Restaurant(
              id: id,
              name: holder['name'],
              restName: holder['restaurantName'],
              imgUrl: holder['photo'],
              city: holder['city'],
              phone: holder['phone'],
              commune: holder['commune'],
              latitude:
                  holder['location'].isEmpty ? 0.0 : holder['location'][0],
              longitude:
                  holder['location'].isEmpty ? 0.0 : holder['location'][1],
              needNumberVols: holder['need_number_vol'],
              //  menu: menu,
              needVol: holder['need_vol'],
              volsNumber: holder['vols_number'],
              hasMenu: holder['hasMenu']));
        }
      }

      // print(docs[2].data());
    } catch (e) {
      rethrow;
    }
  }
}
