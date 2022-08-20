import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:fluttertoast/fluttertoast.dart';

class menu extends StatefulWidget {
  const menu({Key? key}) : super(key: key);

  @override
  State<menu> createState() => _menuState();
}

class _menuState extends State<menu> {
  bool _isLoading = false;
  bool _isLoading2 = false;
  Future<void> menu() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final auth = FirebaseAuth.instance.currentUser;
      Map<String, dynamic> data = {
        'soupe': soupe ? _soupeController.text : '',
        'plat_principal': plat1 ? _plat1Controller.text : '',
        'plat_sec': plat2 ? _plat2Controller.text : '',
        'entree': entree ? _entreeController.text : '',
        'dessert': dessert ? _dessertController.text : '',
        'autre': autre ? _autreController.text : '',
        'repas_dispo': int.parse(_repasDispoController.text),
      };
      await FirebaseFirestore.instance
          .collection('menus')
          .doc(auth!.uid)
          .set(data)
          .then((value) async {
        await FirebaseFirestore.instance
            .collection('restaurants')
            .doc(auth.uid)
            .update({'hasMenu': true});
      });
    } catch (e) {
      print(e.toString());
    }
    setState(() {
      _isLoading = false;
    });
  }

  final _soupeController = TextEditingController();
  final _plat1Controller = TextEditingController();
  final _plat2Controller = TextEditingController();
  final _entreeController = TextEditingController();
  final _dessertController = TextEditingController();
  final _autreController = TextEditingController();
  final _repasDispoController = TextEditingController();

  bool soupe = true;
  bool plat1 = true;
  bool plat2 = true;
  bool entree = true;
  bool dessert = true;
  bool autre = true;
  bool repas = true;
  final _formKey = GlobalKey<FormState>();

  Future<void> getMenu() async {
    setState(() {
      _isLoading2 = true;
    });
    try {
      final auth = FirebaseAuth.instance.currentUser;

      final user = await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(auth!.uid)
          .get();

      final data = user.data();

      if (data!['hasMenu']) {
        final data = await FirebaseFirestore.instance
            .collection('menus')
            .doc(auth.uid)
            .get();

        final menu = data.data();
        _autreController.text = menu!['autre'];
        _dessertController.text = menu['dessert'];
        _entreeController.text = menu['entree'];
        _plat1Controller.text = menu['plat_principal'];
        _plat2Controller.text = menu['plat_sec'];
        _soupeController.text = menu['soupe'];
        _repasDispoController.text = menu['repas_dispo'].toString();

        if (menu['autre'].isEmpty) {
          autre = false;
        }
        if (menu['dessert'].isEmpty) {
          dessert = false;
        }
        if (menu['entree'].isEmpty) {
          entree = false;
        }
        if (menu['plat_principal'].isEmpty) {
          plat1 = false;
        }
        if (menu['plat_sec'].isEmpty) {
          plat2 = false;
        }
        if (menu['soupe'].isEmpty) {
          soupe = false;
        }
      }
    } catch (e) {
      print('getMenu error' + e.toString());
    }
    setState(() {
      _isLoading2 = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getMenu();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final WidthSize = MediaQuery.of(context).size.width;
    final HeightSize = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top +
            MediaQuery.of(context).padding.bottom);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            Transform.rotate(
              angle: 180 * math.pi / 180,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_outlined,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            )
          ],
          backgroundColor: Color(0xffFAC358),
          title: Center(child: Text("وجبة اليوم")),
        ),
        body: _isLoading2
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Stack(
                  children: [
                    Container(
                      height: HeightSize,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: HeightSize * 0.7,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            fit: BoxFit.contain,
                            opacity: 0.5,
                            image: AssetImage(
                              "assets/hilel3.png",
                            ),
                          )),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: WidthSize * 0.05,
                          vertical: HeightSize * 0.05),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                height: HeightSize * 0.07,
                                padding:
                                    EdgeInsets.only(bottom: HeightSize * 0.015),
                                child: FilterChip(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  padding: EdgeInsets.only(
                                      bottom: HeightSize * 0.01332),
                                  selectedColor: const Color(0xffFAC358),
                                  showCheckmark: false,
                                  labelStyle: const TextStyle(),
                                  labelPadding: const EdgeInsets.all(7),
                                  label: Text(
                                    'الطبق الثاني  ',
                                    style: TextStyle(
                                        color: plat2
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                  selected: plat2,
                                  onSelected: (bool value) {
                                    setState(() {
                                      plat2 = !plat2;
                                    });
                                  },
                                ),
                              ),
                              Container(
                                height: HeightSize * 0.07,
                                padding:
                                    EdgeInsets.only(bottom: HeightSize * 0.015),
                                child: FilterChip(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  padding: EdgeInsets.only(
                                      bottom: HeightSize * 0.01332),
                                  selectedColor: const Color(0xffFAC358),
                                  showCheckmark: false,
                                  labelStyle: const TextStyle(),
                                  labelPadding: const EdgeInsets.all(7),
                                  label: Text(
                                    'الطبق الأساسي',
                                    style: TextStyle(
                                        color: plat1
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                  selected: plat1,
                                  onSelected: (bool value) {
                                    setState(() {
                                      plat1 = !plat1;
                                    });
                                  },
                                ),
                              ),
                              Container(
                                height: HeightSize * 0.07,
                                padding:
                                    EdgeInsets.only(bottom: HeightSize * 0.015),
                                child: FilterChip(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  padding: EdgeInsets.only(
                                      bottom: HeightSize * 0.01332),
                                  selectedColor: const Color(0xffFAC358),
                                  showCheckmark: false,
                                  labelStyle: const TextStyle(),
                                  labelPadding: const EdgeInsets.all(7),
                                  label: Text(
                                    '  الحساء  ',
                                    style: TextStyle(
                                        color: soupe
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                  selected: soupe,
                                  onSelected: (bool value) {
                                    setState(() {
                                      soupe = !soupe;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                height: HeightSize * 0.07,
                                padding:
                                    EdgeInsets.only(bottom: HeightSize * 0.015),
                                child: FilterChip(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  padding: EdgeInsets.only(
                                      bottom: HeightSize * 0.01332),
                                  selectedColor: const Color(0xffFAC358),
                                  showCheckmark: false,
                                  labelStyle: const TextStyle(),
                                  labelPadding: const EdgeInsets.all(7),
                                  label: Text(
                                    ' اخرى  ',
                                    style: TextStyle(
                                        color: autre
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                  selected: autre,
                                  onSelected: (bool value) {
                                    setState(() {
                                      autre = !autre;
                                    });
                                  },
                                ),
                              ),
                              Container(
                                height: HeightSize * 0.07,
                                padding:
                                    EdgeInsets.only(bottom: HeightSize * 0.015),
                                child: FilterChip(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  padding: EdgeInsets.only(
                                      bottom: HeightSize * 0.01332),
                                  selectedColor: const Color(0xffFAC358),
                                  showCheckmark: false,
                                  labelStyle: const TextStyle(),
                                  labelPadding: const EdgeInsets.all(7),
                                  label: Text(
                                    'التحلية ',
                                    style: TextStyle(
                                        color: dessert
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                  selected: dessert,
                                  onSelected: (bool value) {
                                    setState(() {
                                      dessert = !dessert;
                                    });
                                  },
                                ),
                              ),
                              Container(
                                height: HeightSize * 0.07,
                                padding:
                                    EdgeInsets.only(bottom: HeightSize * 0.015),
                                child: FilterChip(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  padding: EdgeInsets.only(
                                      bottom: HeightSize * 0.01332),
                                  selectedColor: const Color(0xffFAC358),
                                  showCheckmark: false,
                                  labelStyle: const TextStyle(),
                                  labelPadding: const EdgeInsets.all(7),
                                  label: Text(
                                    '  المقبلة  ',
                                    style: TextStyle(
                                        color: entree
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                  selected: entree,
                                  onSelected: (bool value) {
                                    setState(() {
                                      entree = !entree;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          (soupe ||
                                  plat1 ||
                                  plat2 ||
                                  entree ||
                                  dessert ||
                                  autre)
                              ? Form(
                                  key: _formKey,
                                  child: SizedBox(
                                    height: HeightSize * 0.64,
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: HeightSize * 0.01,
                                        ),
                                        soupe
                                            ? SizedBox(
                                                height: HeightSize * 0.09,
                                                child: TextFormField(
                                                  textDirection:
                                                      TextDirection.rtl,
                                                  textAlign: TextAlign.right,
                                                  controller: _soupeController,
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.length < 3) {
                                                      return 'الرجاء إدخال الحساء';
                                                    }
                                                    return null;
                                                  },
                                                  onSaved: (value) {
                                                    //  _authData['email'] = value!;
                                                  },
                                                  keyboardType:
                                                      TextInputType.name,
                                                  cursorColor:
                                                      Color(0xff582e44),
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.fromLTRB(
                                                            0,
                                                            0,
                                                            WidthSize * 0.05,
                                                            0),
                                                    errorStyle: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                    errorBorder:
                                                        OutlineInputBorder(
                                                            borderSide:
                                                                const BorderSide(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5.0)),
                                                    hoverColor: Colors.black,
                                                    focusColor:
                                                        Color(0xff582e44),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                            borderSide:
                                                                const BorderSide(
                                                              color: Color(
                                                                  0xff582e44),
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5.0)),
                                                    fillColor: Colors.white,
                                                    filled: true,
                                                    //          contentPadding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                                                    hintText: 'الحساء',
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0)),
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                        plat1
                                            ? SizedBox(
                                                height: HeightSize * 0.09,
                                                child: TextFormField(
                                                  textDirection:
                                                      TextDirection.rtl,
                                                  textAlign: TextAlign.right,
                                                  controller: _plat1Controller,
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.length < 3) {
                                                      return 'الرجاء إدخال الطبق الأساسي';
                                                    }
                                                    return null;
                                                  },
                                                  onSaved: (value) {
                                                    //  _authData['email'] = value!;
                                                  },
                                                  keyboardType:
                                                      TextInputType.name,
                                                  cursorColor:
                                                      Color(0xff582e44),
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.fromLTRB(
                                                            0,
                                                            0,
                                                            WidthSize * 0.05,
                                                            0),
                                                    errorStyle: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                    errorBorder:
                                                        OutlineInputBorder(
                                                            borderSide:
                                                                const BorderSide(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5.0)),
                                                    hoverColor: Colors.black,
                                                    focusColor:
                                                        Color(0xff582e44),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                            borderSide:
                                                                const BorderSide(
                                                              color: Color(
                                                                  0xff582e44),
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5.0)),
                                                    fillColor: Colors.white,
                                                    filled: true,
                                                    //          contentPadding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                                                    hintText: 'الطبق الأساسي',
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0)),
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                        plat2
                                            ? SizedBox(
                                                height: HeightSize * 0.09,
                                                child: TextFormField(
                                                  textDirection:
                                                      TextDirection.rtl,
                                                  textAlign: TextAlign.right,
                                                  controller: _plat2Controller,
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.length < 3) {
                                                      return 'الرجاء إدخال الطبق الثاني';
                                                    }
                                                    return null;
                                                  },
                                                  onSaved: (value) {
                                                    //  _authData['email'] = value!;
                                                  },
                                                  keyboardType:
                                                      TextInputType.name,
                                                  cursorColor:
                                                      Color(0xff582e44),
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.fromLTRB(
                                                            0,
                                                            0,
                                                            WidthSize * 0.05,
                                                            0),
                                                    errorStyle: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                    errorBorder:
                                                        OutlineInputBorder(
                                                            borderSide:
                                                                const BorderSide(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5.0)),
                                                    hoverColor: Colors.black,
                                                    focusColor:
                                                        Color(0xff582e44),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                            borderSide:
                                                                const BorderSide(
                                                              color: Color(
                                                                  0xff582e44),
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5.0)),
                                                    fillColor: Colors.white,
                                                    filled: true,
                                                    //          contentPadding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                                                    hintText: 'الطبق الثاني',
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0)),
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                        entree
                                            ? SizedBox(
                                                height: HeightSize * 0.09,
                                                child: TextFormField(
                                                  textDirection:
                                                      TextDirection.rtl,
                                                  textAlign: TextAlign.right,
                                                  controller: _entreeController,
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.length < 3) {
                                                      return 'الرجاء إدخال المقبلة';
                                                    }
                                                    return null;
                                                  },
                                                  onSaved: (value) {
                                                    //  _authData['email'] = value!;
                                                  },
                                                  keyboardType:
                                                      TextInputType.name,
                                                  cursorColor:
                                                      Color(0xff582e44),
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.fromLTRB(
                                                            0,
                                                            0,
                                                            WidthSize * 0.05,
                                                            0),
                                                    errorStyle: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                    errorBorder:
                                                        OutlineInputBorder(
                                                            borderSide:
                                                                const BorderSide(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5.0)),
                                                    hoverColor: Colors.black,
                                                    focusColor:
                                                        Color(0xff582e44),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                            borderSide:
                                                                const BorderSide(
                                                              color: Color(
                                                                  0xff582e44),
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5.0)),
                                                    fillColor: Colors.white,
                                                    filled: true,
                                                    //          contentPadding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                                                    hintText: 'المقبلة',
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0)),
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                        dessert
                                            ? SizedBox(
                                                height: HeightSize * 0.09,
                                                child: TextFormField(
                                                  textDirection:
                                                      TextDirection.rtl,
                                                  textAlign: TextAlign.right,
                                                  controller:
                                                      _dessertController,
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.length < 3) {
                                                      return 'الرجاء إدخال التحلية';
                                                    }
                                                    return null;
                                                  },
                                                  onSaved: (value) {
                                                    //  _authData['email'] = value!;
                                                  },
                                                  keyboardType:
                                                      TextInputType.name,
                                                  cursorColor:
                                                      Color(0xff582e44),
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.fromLTRB(
                                                            0,
                                                            0,
                                                            WidthSize * 0.05,
                                                            0),
                                                    errorStyle: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                    errorBorder:
                                                        OutlineInputBorder(
                                                            borderSide:
                                                                const BorderSide(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5.0)),
                                                    hoverColor: Colors.black,
                                                    focusColor:
                                                        Color(0xff582e44),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                            borderSide:
                                                                const BorderSide(
                                                              color: Color(
                                                                  0xff582e44),
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5.0)),
                                                    fillColor: Colors.white,
                                                    filled: true,
                                                    //          contentPadding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                                                    hintText: 'التحلية',
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0)),
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                        autre
                                            ? SizedBox(
                                                height: HeightSize * 0.09,
                                                child: TextFormField(
                                                  textDirection:
                                                      TextDirection.rtl,
                                                  textAlign: TextAlign.right,
                                                  controller: _autreController,
                                                  // validator: (value) {
                                                  //   if (value == null || value.length < 3) {
                                                  //     return 'Invalid a';
                                                  //   }
                                                  //   return null;
                                                  // },
                                                  onSaved: (value) {
                                                    //  _authData['email'] = value!;
                                                  },
                                                  keyboardType:
                                                      TextInputType.name,
                                                  cursorColor:
                                                      Color(0xff582e44),
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.fromLTRB(
                                                            0,
                                                            0,
                                                            WidthSize * 0.05,
                                                            0),
                                                    errorStyle: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                    errorBorder:
                                                        OutlineInputBorder(
                                                            borderSide:
                                                                const BorderSide(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5.0)),
                                                    hoverColor: Colors.black,
                                                    focusColor:
                                                        Color(0xff582e44),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                            borderSide:
                                                                const BorderSide(
                                                              color: Color(
                                                                  0xff582e44),
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5.0)),
                                                    fillColor: Colors.white,
                                                    filled: true,
                                                    //          contentPadding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                                                    hintText: 'أخرى',
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0)),
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                        repas
                                            ? SizedBox(
                                                height: HeightSize * 0.09,
                                                child: TextFormField(
                                                  textDirection:
                                                      TextDirection.rtl,
                                                  textAlign: TextAlign.right,
                                                  controller:
                                                      _repasDispoController,
                                                  validator: (value) {
                                                    if (value == null) {
                                                      return 'الرجاء إدخال العدد';
                                                    }
                                                    return null;
                                                  },
                                                  onSaved: (value) {
                                                    //  _authData['email'] = value!;
                                                  },
                                                  keyboardType:
                                                      TextInputType.number,
                                                  cursorColor:
                                                      Color(0xff582e44),
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.fromLTRB(
                                                            0,
                                                            0,
                                                            WidthSize * 0.05,
                                                            0),
                                                    errorStyle: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                    errorBorder:
                                                        OutlineInputBorder(
                                                            borderSide:
                                                                const BorderSide(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5.0)),
                                                    hoverColor: Colors.black,
                                                    focusColor:
                                                        Color(0xff582e44),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                            borderSide:
                                                                const BorderSide(
                                                              color: Color(
                                                                  0xff582e44),
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5.0)),
                                                    fillColor: Colors.white,
                                                    filled: true,
                                                    labelStyle: TextStyle(),
                                                    labelText:
                                                        'عدد الوجبات المتوفرة',
                                                    //          contentPadding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                                                    hintText:
                                                        'عدد الوجبات المتوفرة',
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0)),
                                                  ),
                                                ),
                                              )
                                            : Container()
                                      ],
                                    ),
                                  ),
                                )
                              : Container(
                                  height: HeightSize * 0.5,
                                  child: Center(
                                      child: Text('اختر طبقا على الأقل'))),
                          (soupe ||
                                  plat1 ||
                                  plat2 ||
                                  entree ||
                                  dessert ||
                                  autre)
                              ? _isLoading
                                  ? CircularProgressIndicator()
                                  : RaisedButton(
                                      onPressed: () async {
                                        Fluttertoast.showToast(
                                            msg: 'جاري تحميل الوجبة');
                                        await menu();
                                        Fluttertoast.showToast(
                                            msg: 'إنتهى التحميل');
                                      },
                                      textColor: Color(0xff582e44),
                                      padding: const EdgeInsets.all(0.0),
                                      shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              width: 0.5,
                                              color: Color(0xff582e44)),
                                          borderRadius:
                                              BorderRadius.circular(5.0)),
                                      child: Container(
                                        width: WidthSize * 0.5,
                                        height: HeightSize * 0.08,
                                        decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5.0))),
                                        child: Center(
                                          child: Text(
                                            "تأكيد",
                                            style: TextStyle(
                                              fontSize: WidthSize * (25 / 540),
                                              color: Color(0xff582e44),
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    )
                              : Container(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
