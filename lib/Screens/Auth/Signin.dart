import 'package:abir_sabil/Screens/accueil.dart';
import 'package:abir_sabil/Screens/accueil_resto.dart';
import 'package:abir_sabil/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../Providers/DzData.dart';
import '../../Providers/auth.dart';
import 'forgotPassword.dart';

class Signin extends StatefulWidget {
  const Signin({Key? key}) : super(key: key);

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  bool signin = true;

  bool _passwordVisible = true;

  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _email_upController = TextEditingController();
  final _password_upController = TextEditingController();
  bool _password_upVisible = true;

  final _numberController = TextEditingController();
  final _nomController = TextEditingController();
  final _boutiqueController = TextEditingController();

  bool isCheck = false;
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();
  final _formKeyUP = GlobalKey<FormState>();

  Future<bool> sign(String email, String password) async {
    setState(() {
      _isLoading = true;
    });
    try {
      var x = Provider.of<AuthService>(context, listen: false);

      if (await x.signIn(email, password)) {
        setState(() {
          _isLoading = false;
        });
        return true;
      }
      ;
    } catch (e) {
      print(e.toString());
    }
    setState(() {
      _isLoading = false;
    });
    return false;
  }

  Future<bool> submit(String email, String password) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<AuthService>(context, listen: false).signUp(
          _email_upController.text,
          _password_upController.text,
          _nomController.text,
          _numberController.text,
          _boutiqueController.text,
          WilayaTEC.text,
          CommuneTEC.text);

      setState(() {
        _isLoading = false;
      });

      return true;
    } catch (e) {
      print('ssamiir' + e.toString());
    }
    setState(() {
      _isLoading = false;
    });
    return false;
  }

  String wilaya = "";
  String Commune = "";

  TextEditingController WilayaTEC = TextEditingController();
  TextEditingController CommuneTEC = TextEditingController();

  getWilaya() {
    Provider.of<DataDz>(context, listen: false).getWilaya();
  }

  @override
  void initState() {
    super.initState();
    getWilaya();
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
        body: SingleChildScrollView(
          child: Container(
            // height: HeightSize,
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      opacity: 0.2,
                      fit: BoxFit.contain,
                      image: AssetImage("assets/hilal.png"),
                    ),
                    borderRadius:
                        BorderRadius.only(bottomLeft: Radius.circular(60)),
                    color: Colors.white,
                  ),
                  height: MediaQuery.of(context).size.height * 0.5,
                ),
                Container(
                  child: Column(
                    children: [
                      SizedBox(
                        height: (!signin &&
                                !Provider.of<AuthService>(context,
                                        listen: false)
                                    .isVisiteur)
                            ? HeightSize * 0.27
                            : HeightSize * 0.32,
                      ),
                      Expanded(
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0xffFAC358).withOpacity(0.7),
                                    Color(0xff3FB876).withOpacity(0.7),
                                  ],
                                ),
                                borderRadius: BorderRadius.only(
                                  topRight: signin
                                      ? Radius.circular(60)
                                      : Radius.circular(0),
                                  topLeft: signin
                                      ? Radius.circular(0)
                                      : Radius.circular(60),
                                  //  bottomLeft: Radius.circular(100),
                                ),
                              ),
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
                                  Column(
                                    children: [
                                      Container(
                                        height: HeightSize * 0.11,
                                        padding: EdgeInsets.symmetric(
                                            vertical: HeightSize * 0.02,
                                            horizontal: WidthSize * 0.07),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  signin = !signin;
                                                });
                                              },
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "تسجيل الدخول",
                                                    style: TextStyle(
                                                      fontFamily: 'Hacen',
                                                      fontSize: WidthSize *
                                                          (30 / 540),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  !signin
                                                      ? Container()
                                                      : AnimatedContainer(
                                                          duration: Duration(
                                                              milliseconds:
                                                                  300),
                                                          width:
                                                              WidthSize * 0.2,
                                                          height: HeightSize *
                                                              0.005,
                                                          color:
                                                              Color(0xff582e44),
                                                        )
                                                ],
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  signin = !signin;
                                                });
                                              },
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "فتح حساب",
                                                    style: TextStyle(
                                                      fontFamily: 'Hacen',
                                                      fontSize: WidthSize *
                                                          (30 / 540),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  signin
                                                      ? Container()
                                                      : AnimatedContainer(
                                                          duration: Duration(
                                                              milliseconds:
                                                                  300),
                                                          width:
                                                              WidthSize * 0.2,
                                                          height: HeightSize *
                                                              0.005,
                                                          color:
                                                              Color(0xff582e44),
                                                        )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: signin
                                            ? Form(
                                                key: _formKey,
                                                child: Container(
                                                  child: Container(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Container(
                                                          height:
                                                              HeightSize * 0.09,
                                                          child: TextFormField(
                                                            textDirection:
                                                                TextDirection
                                                                    .rtl,
                                                            textAlign:
                                                                TextAlign.right,
                                                            controller:
                                                                _emailController,
                                                            validator: (value) {
                                                              if (value ==
                                                                      null ||
                                                                  !value
                                                                      .contains(
                                                                          '@') ||
                                                                  !value
                                                                      .contains(
                                                                          '.')) {
                                                                return 'Invalid Email';
                                                              }
                                                              return null;
                                                            },
                                                            onSaved: (value) {
                                                              //  _authData['email'] = value!;
                                                            },
                                                            keyboardType:
                                                                TextInputType
                                                                    .emailAddress,
                                                            cursorColor: Color(
                                                                0xff582e44),
                                                            decoration:
                                                                InputDecoration(
                                                              errorStyle:
                                                                  TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                              errorBorder:
                                                                  OutlineInputBorder(
                                                                      borderSide:
                                                                          const BorderSide(
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5.0)),

                                                              hoverColor:
                                                                  Colors.black,
                                                              focusColor: Color(
                                                                  0xff582e44),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                      borderSide:
                                                                          const BorderSide(
                                                                        color: Color(
                                                                            0xff582e44),
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5.0)),
                                                              fillColor:
                                                                  Colors.white,
                                                              filled: true,
                                                              //          contentPadding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                                                              hintText:
                                                                  'البريد الالكتروني',
                                                              border: OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5.0)),
                                                              suffixIcon:
                                                                  const Icon(
                                                                Icons.email,
                                                                color: Color(
                                                                    0xffB1B0B0),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                            height: HeightSize *
                                                                0.005),
                                                        SizedBox(
                                                          height:
                                                              HeightSize * 0.09,
                                                          child: TextFormField(
                                                            textDirection:
                                                                TextDirection
                                                                    .rtl,
                                                            textAlign:
                                                                TextAlign.right,
                                                            controller:
                                                                _passwordController,
                                                            validator: (value) {
                                                              if (value ==
                                                                      null ||
                                                                  value.length <
                                                                      5) {
                                                                return 'Invalid Password';
                                                              }
                                                              return null;
                                                            },
                                                            onSaved: (value) {
                                                              //  _authData['password'] = value!;
                                                            },
                                                            keyboardType:
                                                                TextInputType
                                                                    .visiblePassword,
                                                            obscureText:
                                                                _passwordVisible,
                                                            cursorColor: Color(
                                                                0xff582e44),
                                                            decoration:
                                                                InputDecoration(
                                                              errorStyle:
                                                                  TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                              errorBorder:
                                                                  OutlineInputBorder(
                                                                      borderSide:
                                                                          const BorderSide(
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5.0)),
                                                              hoverColor:
                                                                  Colors.black,
                                                              focusColor: Color(
                                                                  0xff582e44),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                      borderSide:
                                                                          const BorderSide(
                                                                        color: Color(
                                                                            0xff582e44),
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5.0)),

                                                              fillColor:
                                                                  Colors.white,
                                                              filled: true,

                                                              //     contentPadding: const EdgeInsets.fromLTRB(10, 8, 10, 8),

                                                              hintText:
                                                                  'كلمة السر',
                                                              border: OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5.0)),
                                                              suffixIcon:
                                                                  const Icon(
                                                                Icons.password,
                                                                color: Color(
                                                                    0xffB1B0B0),
                                                              ),
                                                              prefixIcon:
                                                                  IconButton(
                                                                icon: Icon(
                                                                  // Based on passwordVisible state choose the icon
                                                                  _passwordVisible
                                                                      ? Icons
                                                                          .visibility
                                                                      : Icons
                                                                          .visibility_off,
                                                                  color: Color(
                                                                      0xffB1B0B0),
                                                                ),
                                                                onPressed: () {
                                                                  // Update the state i.e. toogle the state of passwordVisible variable
                                                                  setState(() {
                                                                    _passwordVisible =
                                                                        !_passwordVisible;
                                                                  });
                                                                },
                                                              ),

                                                              // icon:
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              SizedBox(
                                                                  child:
                                                                      GestureDetector(
                                                                onTap: () {
                                                                  Navigator
                                                                      .push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                forgot()),
                                                                  );
                                                                },
                                                                child: Text(
                                                                  "نسيت كلمة السر",
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'Hacen',
                                                                    fontSize:
                                                                        WidthSize *
                                                                            0.032,
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    decoration:
                                                                        TextDecoration
                                                                            .underline,
                                                                  ),
                                                                ),
                                                              )),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    "البقاء متصلا",
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          'Hacen',
                                                                      fontSize:
                                                                          WidthSize *
                                                                              0.032,
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                  Checkbox(
                                                                      checkColor:
                                                                          Color(
                                                                              0xff582e44),
                                                                      // color of tick Mark
                                                                      activeColor:
                                                                          Colors
                                                                              .white,
                                                                      value:
                                                                          isCheck,
                                                                      onChanged:
                                                                          (bool?
                                                                              value) {
                                                                        setState(
                                                                            () {
                                                                          isCheck =
                                                                              value!;
                                                                        });
                                                                      }),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                            height: HeightSize *
                                                                0.01),
                                                        _isLoading
                                                            ? CircularProgressIndicator(
                                                                color: Colors
                                                                    .white,
                                                              )
                                                            : RaisedButton(
                                                                onPressed:
                                                                    () async {
                                                                  if (_formKey
                                                                      .currentState!
                                                                      .validate()) {
                                                                    Fluttertoast
                                                                        .showToast(
                                                                            msg:
                                                                                'جاري تسجيل الدخول');
                                                                    if (await sign(
                                                                        _emailController
                                                                            .text,
                                                                        _passwordController
                                                                            .text)) {
                                                                      if (prov.isVisiteur &&
                                                                          prov.userType) {
                                                                        // Navigator.pop(
                                                                        //     context);
                                                                        Navigator.pushReplacement(
                                                                            context,
                                                                            MaterialPageRoute(builder: (_) => accueil()));
                                                                      } else if (prov
                                                                              .isVisiteur &&
                                                                          prov.isRest) {
                                                                        FirebaseAuth
                                                                            .instance
                                                                            .signOut();
                                                                        Fluttertoast.showToast(
                                                                            msg:
                                                                                'لايوجد بريد إلكتروني لهذا المستخدم');
                                                                      } else if (!prov
                                                                              .isVisiteur &&
                                                                          prov.isRest) {
                                                                        // Navigator.pop(
                                                                        //     context);
                                                                        Navigator.pushReplacement(
                                                                            context,
                                                                            MaterialPageRoute(builder: (_) => accueil_resto()));
                                                                      } else {
                                                                        FirebaseAuth
                                                                            .instance
                                                                            .signOut();
                                                                        Fluttertoast.showToast(
                                                                            msg:
                                                                                'لايوجد بريد إلكتروني لهذا المستخدم');
                                                                      }
                                                                    } else {
                                                                      Fluttertoast
                                                                          .showToast(
                                                                              msg: 'يُرجى التحقق من المعلومات المُدخلة');
                                                                    }
                                                                  }
                                                                },
                                                                textColor: Color(
                                                                    0xff582e44),
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        0.0),
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5.0)),
                                                                child:
                                                                    Container(
                                                                  width:
                                                                      WidthSize *
                                                                          0.9,
                                                                  height:
                                                                      HeightSize *
                                                                          0.08,
                                                                  decoration: const BoxDecoration(
                                                                      color: Colors
                                                                          .white,
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(5.0))),
                                                                  child: Center(
                                                                    child: Text(
                                                                      "تسجيل الدخول",
                                                                      style:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            'Hacen',
                                                                        fontSize:
                                                                            WidthSize *
                                                                                (25 / 540),
                                                                        color: const Color(
                                                                            0xff582e44),
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                        // SizedBox(
                                                        //     height: HeightSize * 0.005),
                                                        // RaisedButton(
                                                        //   onPressed: () async {
                                                        //     Fluttertoast.showToast(
                                                        //         msg:
                                                        //             'جاري تسجيل الدخول بجوجل');
                                                        //     await Provider.of<
                                                        //                 AuthService>(
                                                        //             context,
                                                        //             listen: false)
                                                        //         .googleLogIn()
                                                        //         .then((value) {
                                                        //       Navigator.pop(context);
                                                        //       Navigator.pushReplacement(
                                                        //           context,
                                                        //           MaterialPageRoute(
                                                        //               builder: (_) =>
                                                        //                   accueil()));
                                                        //     });
                                                        //   },
                                                        //   textColor: Color(0xff582e44),
                                                        //   padding:
                                                        //       const EdgeInsets.all(0.0),
                                                        //   shape: RoundedRectangleBorder(
                                                        //       borderRadius:
                                                        //           BorderRadius.circular(
                                                        //               5.0)),
                                                        //   child: Container(
                                                        //     width: WidthSize * 0.9,
                                                        //     height: HeightSize * 0.08,
                                                        //     decoration: const BoxDecoration(
                                                        //         color: Colors.white,
                                                        //         borderRadius:
                                                        //             BorderRadius.all(
                                                        //                 Radius.circular(
                                                        //                     20.0))),
                                                        //     child: Row(
                                                        //       mainAxisAlignment:
                                                        //           MainAxisAlignment
                                                        //               .center,
                                                        //       children: [
                                                        //         const SizedBox(
                                                        //           height: 40,
                                                        //           width: 40,
                                                        //           child: Image(
                                                        //               image: AssetImage(
                                                        //                   'assets/google.png')),
                                                        //         ),
                                                        //         SizedBox(
                                                        //           width: 10,
                                                        //         ),
                                                        //         Text(
                                                        //           "تسجيل الدخول بإستعمال ",
                                                        //           style: TextStyle(
                                                        //             fontSize:
                                                        //                 WidthSize *
                                                        //                     (25 / 540),
                                                        //             color: Color(
                                                        //                 0xff582e44),
                                                        //             fontWeight:
                                                        //                 FontWeight.bold,
                                                        //           ),
                                                        //           textAlign:
                                                        //               TextAlign.center,
                                                        //         ),
                                                        //       ],
                                                        //     ),
                                                        //   ),
                                                        // ),
                                                      ],
                                                    ),
                                                  ),
                                                  padding: EdgeInsets.symmetric(
                                                      vertical:
                                                          HeightSize * 0.08,
                                                      horizontal:
                                                          WidthSize * 0.1),
                                                ),
                                              )
                                            : Form(
                                                key: _formKeyUP,
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: !Provider.of<
                                                                      AuthService>(
                                                                  context,
                                                                  listen: false)
                                                              .isVisiteur
                                                          ? HeightSize * 0.01
                                                          : HeightSize * 0.05,
                                                      horizontal:
                                                          WidthSize * 0.1),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      SizedBox(
                                                        height: !Provider.of<
                                                                        AuthService>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .isVisiteur
                                                            ? HeightSize * 0.07
                                                            : HeightSize * 0.09,
                                                        child: TextFormField(
                                                          textDirection:
                                                              TextDirection.rtl,
                                                          textAlign:
                                                              TextAlign.right,
                                                          controller:
                                                              _nomController,
                                                          validator: (value) {
                                                            if (value == null ||
                                                                value.length <
                                                                    3) {
                                                              return 'Invalid name';
                                                            }
                                                            return null;
                                                          },
                                                          onSaved: (value) {
                                                            //  _authData['email'] = value!;
                                                          },
                                                          keyboardType:
                                                              TextInputType
                                                                  .name,
                                                          cursorColor:
                                                              Color(0xff582e44),
                                                          decoration:
                                                              InputDecoration(
                                                            contentPadding: EdgeInsets.fromLTRB(
                                                                0,
                                                                !Provider.of<AuthService>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .isVisiteur
                                                                    ? HeightSize *
                                                                        (15 /
                                                                            912)
                                                                    : 0,
                                                                0,
                                                                0),
                                                            errorStyle:
                                                                TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                            errorBorder:
                                                                OutlineInputBorder(
                                                                    borderSide:
                                                                        const BorderSide(
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5.0)),
                                                            hoverColor:
                                                                Colors.black,
                                                            focusColor: Color(
                                                                0xff582e44),
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                                    borderSide:
                                                                        const BorderSide(
                                                                      color: Color(
                                                                          0xff582e44),
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5.0)),
                                                            fillColor:
                                                                Colors.white,
                                                            filled: true,
                                                            //          contentPadding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                                                            hintText: 'الاسم',
                                                            border: OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0)),
                                                            suffixIcon:
                                                                const Icon(
                                                              Icons.person,
                                                              color: Color(
                                                                  0xffB1B0B0),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: !Provider.of<
                                                                        AuthService>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .isVisiteur
                                                            ? HeightSize * 0.07
                                                            : HeightSize * 0.09,
                                                        child: TextFormField(
                                                          textDirection:
                                                              TextDirection.rtl,
                                                          textAlign:
                                                              TextAlign.right,
                                                          controller:
                                                              _email_upController,
                                                          validator: (value) {
                                                            if (value == null ||
                                                                !value.contains(
                                                                    '@') ||
                                                                !value.contains(
                                                                    '.')) {
                                                              return 'Invalid Email';
                                                            }
                                                            return null;
                                                          },
                                                          onSaved: (value) {
                                                            //  _authData['email'] = value!;
                                                          },
                                                          keyboardType:
                                                              TextInputType
                                                                  .emailAddress,
                                                          cursorColor:
                                                              Color(0xff582e44),
                                                          decoration:
                                                              InputDecoration(
                                                            contentPadding: EdgeInsets.fromLTRB(
                                                                0,
                                                                !Provider.of<AuthService>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .isVisiteur
                                                                    ? HeightSize *
                                                                        (15 /
                                                                            912)
                                                                    : 0,
                                                                0,
                                                                0),
                                                            errorStyle:
                                                                TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                            errorBorder:
                                                                OutlineInputBorder(
                                                                    borderSide:
                                                                        const BorderSide(
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5.0)),
                                                            hoverColor:
                                                                Colors.black,
                                                            focusColor: Color(
                                                                0xff582e44),
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                                    borderSide:
                                                                        const BorderSide(
                                                                      color: Color(
                                                                          0xff582e44),
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5.0)),
                                                            fillColor:
                                                                Colors.white,
                                                            filled: true,
                                                            //          contentPadding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                                                            hintText:
                                                                'البريد الالكتروني',
                                                            border: OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0)),
                                                            suffixIcon:
                                                                const Icon(
                                                              Icons.email,
                                                              color: Color(
                                                                  0xffB1B0B0),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: !Provider.of<
                                                                        AuthService>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .isVisiteur
                                                            ? HeightSize * 0.07
                                                            : HeightSize * 0.09,
                                                        child: TextFormField(
                                                          textDirection:
                                                              TextDirection.rtl,
                                                          textAlign:
                                                              TextAlign.right,
                                                          controller:
                                                              _numberController,
                                                          validator: (value) {
                                                            if (value == null ||
                                                                value.length !=
                                                                    10) {
                                                              return 'Invalid number';
                                                            }
                                                            return null;
                                                          },
                                                          onSaved: (value) {
                                                            //  _authData['email'] = value!;
                                                          },
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          cursorColor:
                                                              Color(0xff582e44),
                                                          decoration:
                                                              InputDecoration(
                                                            contentPadding: EdgeInsets.fromLTRB(
                                                                0,
                                                                !Provider.of<AuthService>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .isVisiteur
                                                                    ? HeightSize *
                                                                        (15 /
                                                                            912)
                                                                    : 0,
                                                                0,
                                                                0),
                                                            errorStyle:
                                                                TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                            errorBorder:
                                                                OutlineInputBorder(
                                                                    borderSide:
                                                                        const BorderSide(
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5.0)),
                                                            hoverColor:
                                                                Colors.black,
                                                            focusColor: Color(
                                                                0xff582e44),
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                                    borderSide:
                                                                        const BorderSide(
                                                                      color: Color(
                                                                          0xff582e44),
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5.0)),
                                                            fillColor:
                                                                Colors.white,
                                                            filled: true,
                                                            //          contentPadding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                                                            hintText:
                                                                'رقم الهاتف',
                                                            border: OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0)),
                                                            suffixIcon:
                                                                const Icon(
                                                              Icons.phone,
                                                              color: Color(
                                                                  0xffB1B0B0),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      !Provider.of<AuthService>(
                                                                  context,
                                                                  listen: false)
                                                              .isVisiteur
                                                          ? SizedBox(
                                                              height: !Provider.of<
                                                                              AuthService>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .isVisiteur
                                                                  ? HeightSize *
                                                                      0.07
                                                                  : HeightSize *
                                                                      0.09,
                                                              child:
                                                                  TextFormField(
                                                                textDirection:
                                                                    TextDirection
                                                                        .rtl,
                                                                textAlign:
                                                                    TextAlign
                                                                        .right,
                                                                controller:
                                                                    _boutiqueController,
                                                                validator:
                                                                    (value) {
                                                                  if (value ==
                                                                          null ||
                                                                      value.length <
                                                                          2) {
                                                                    return 'Invalid boutique';
                                                                  }
                                                                  return null;
                                                                },
                                                                onSaved:
                                                                    (value) {
                                                                  //  _authData['email'] = value!;
                                                                },
                                                                keyboardType:
                                                                    TextInputType
                                                                        .name,
                                                                cursorColor: Color(
                                                                    0xff582e44),
                                                                decoration:
                                                                    InputDecoration(
                                                                  contentPadding: EdgeInsets.fromLTRB(
                                                                      0,
                                                                      !Provider.of<AuthService>(context, listen: false)
                                                                              .isVisiteur
                                                                          ? HeightSize *
                                                                              (15 / 912)
                                                                          : 0,
                                                                      0,
                                                                      0),
                                                                  errorStyle:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                  ),
                                                                  errorBorder:
                                                                      OutlineInputBorder(
                                                                          borderSide:
                                                                              const BorderSide(
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                          borderRadius:
                                                                              BorderRadius.circular(5.0)),
                                                                  hoverColor:
                                                                      Colors
                                                                          .black,
                                                                  focusColor: Color(
                                                                      0xff582e44),
                                                                  focusedBorder:
                                                                      OutlineInputBorder(
                                                                          borderSide:
                                                                              const BorderSide(
                                                                            color:
                                                                                Color(0xff582e44),
                                                                          ),
                                                                          borderRadius:
                                                                              BorderRadius.circular(5.0)),
                                                                  fillColor:
                                                                      Colors
                                                                          .white,
                                                                  filled: true,
                                                                  //          contentPadding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                                                                  hintText:
                                                                      'اسم المطعم',
                                                                  border: OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5.0)),
                                                                  suffixIcon:
                                                                      const Icon(
                                                                    Icons
                                                                        .storefront_outlined,
                                                                    color: Color(
                                                                        0xffB1B0B0),
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          : Container(),
                                                      (!Provider.of<AuthService>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .isVisiteur &&
                                                              !signin)
                                                          ? Container(
                                                              margin: EdgeInsets.only(
                                                                  bottom: sizee
                                                                          .height *
                                                                      0.005),
                                                              //         height: sizee.height * 0.07,
                                                              width:
                                                                  sizee.width *
                                                                      0.95,
                                                              height:
                                                                  sizee.height *
                                                                      0.07,

                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Container(
                                                                    width: sizee
                                                                            .width *
                                                                        (210 /
                                                                            540),
                                                                    height: sizee
                                                                            .height *
                                                                        (65 /
                                                                            912),
                                                                    child:
                                                                        TypeAheadField(
                                                                      direction:
                                                                          AxisDirection
                                                                              .up,
                                                                      textFieldConfiguration:
                                                                          TextFieldConfiguration(
                                                                        textDirection:
                                                                            TextDirection.rtl,
                                                                        textAlign:
                                                                            TextAlign.right,
                                                                        cursorColor:
                                                                            Colors.black,
                                                                        controller:
                                                                            CommuneTEC,
                                                                        decoration:
                                                                            InputDecoration(
                                                                          floatingLabelStyle:
                                                                              const TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                          ),
                                                                          hoverColor:
                                                                              Colors.black,
                                                                          focusColor:
                                                                              Colors.black,
                                                                          focusedBorder: OutlineInputBorder(
                                                                              borderSide: BorderSide(
                                                                                color: Colors.black,
                                                                              ),
                                                                              borderRadius: BorderRadius.circular(5.0)),
                                                                          fillColor:
                                                                              Colors.white,
                                                                          filled:
                                                                              true,
                                                                          labelText:
                                                                              'البلدية',
                                                                          border:
                                                                              OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                                                                        ),
                                                                      ),
                                                                      suggestionsCallback:
                                                                          (pattern) {
                                                                        if (pattern
                                                                            .isEmpty) {
                                                                          return [];
                                                                        }
                                                                        // The logic to find out which ones should appear
                                                                        return Provider.of<DataDz>(context,
                                                                                listen: false)
                                                                            .getCommuneByWilaya(wilaya)
                                                                            .where((suggestion) => suggestion.toLowerCase().contains(pattern.toString()));
                                                                      },
                                                                      itemBuilder:
                                                                          (context,
                                                                              suggestion) {
                                                                        return ListTile(
                                                                          title:
                                                                              Text(
                                                                            suggestion.toString(),
                                                                            style:
                                                                                TextStyle(
                                                                              fontFamily: 'Hacen',
                                                                            ),
                                                                          ),
                                                                        );
                                                                      },
                                                                      onSuggestionSelected:
                                                                          (suggestion) {
                                                                        setState(
                                                                            () {
                                                                          Commune =
                                                                              suggestion.toString();
                                                                          CommuneTEC =
                                                                              TextEditingController(text: Commune);
                                                                        });
                                                                      },
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    width: sizee
                                                                            .width *
                                                                        (210 /
                                                                            540),
                                                                    height: sizee
                                                                            .height *
                                                                        (65 /
                                                                            912),
                                                                    child:
                                                                        TypeAheadField(
                                                                      direction:
                                                                          AxisDirection
                                                                              .up,
                                                                      textFieldConfiguration:
                                                                          TextFieldConfiguration(
                                                                        textDirection:
                                                                            TextDirection.rtl,
                                                                        textAlign:
                                                                            TextAlign.right,
                                                                        cursorColor:
                                                                            Colors.black,
                                                                        controller:
                                                                            WilayaTEC,
                                                                        decoration:
                                                                            InputDecoration(
                                                                          floatingLabelStyle:
                                                                              const TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                          ),
                                                                          hoverColor:
                                                                              Colors.black,
                                                                          focusColor:
                                                                              Colors.black,
                                                                          focusedBorder: OutlineInputBorder(
                                                                              borderSide: const BorderSide(
                                                                                color: Colors.black,
                                                                              ),
                                                                              borderRadius: BorderRadius.circular(5.0)),
                                                                          fillColor:
                                                                              Colors.white,
                                                                          filled:
                                                                              true,
                                                                          labelText:
                                                                              'الولاية',
                                                                          border:
                                                                              OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                                                                        ),
                                                                      ),
                                                                      suggestionsCallback:
                                                                          (pattern) {
                                                                        if (pattern
                                                                            .isEmpty) {
                                                                          return [];
                                                                        }
                                                                        // The logic to find out which ones should appear
                                                                        return Provider.of<DataDz>(context,
                                                                                listen: false)
                                                                            .wilayaa
                                                                            .where((suggestion) => suggestion.toLowerCase().contains(pattern.toString()));
                                                                      },
                                                                      itemBuilder:
                                                                          (context,
                                                                              suggestion) {
                                                                        return ListTile(
                                                                            title:
                                                                                Text(
                                                                          suggestion
                                                                              .toString(),
                                                                          style:
                                                                              TextStyle(
                                                                            fontFamily:
                                                                                'Hacen',
                                                                          ),
                                                                        ));
                                                                      },
                                                                      onSuggestionSelected:
                                                                          (suggestion) {
                                                                        setState(
                                                                            () {
                                                                          wilaya =
                                                                              suggestion.toString();
                                                                          WilayaTEC =
                                                                              TextEditingController(text: wilaya);
                                                                        });
                                                                      },
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          : Container(),
                                                      SizedBox(
                                                        height: !Provider.of<
                                                                        AuthService>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .isVisiteur
                                                            ? HeightSize * 0.07
                                                            : HeightSize * 0.09,
                                                        child: TextFormField(
                                                          textDirection:
                                                              TextDirection.rtl,
                                                          textAlign:
                                                              TextAlign.right,
                                                          controller:
                                                              _password_upController,
                                                          validator: (value) {
                                                            if (value == null ||
                                                                value.length <
                                                                    5) {
                                                              return 'Invalid Password';
                                                            }
                                                            return null;
                                                          },
                                                          onSaved: (value) {
                                                            //  _authData['password'] = value!;
                                                          },
                                                          keyboardType:
                                                              TextInputType
                                                                  .visiblePassword,
                                                          obscureText:
                                                              _password_upVisible,
                                                          cursorColor:
                                                              Color(0xff582e44),
                                                          decoration:
                                                              InputDecoration(
                                                            contentPadding: EdgeInsets.fromLTRB(
                                                                0,
                                                                !Provider.of<AuthService>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .isVisiteur
                                                                    ? HeightSize *
                                                                        (15 /
                                                                            912)
                                                                    : 0,
                                                                0,
                                                                0),
                                                            hoverColor:
                                                                Colors.black,
                                                            errorStyle:
                                                                TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                            errorBorder:
                                                                OutlineInputBorder(
                                                                    borderSide:
                                                                        const BorderSide(
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5.0)),
                                                            focusColor: Color(
                                                                0xff582e44),
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                                    borderSide:
                                                                        const BorderSide(
                                                                      color: Color(
                                                                          0xff582e44),
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5.0)),

                                                            fillColor:
                                                                Colors.white,
                                                            filled: true,

                                                            //     contentPadding: const EdgeInsets.fromLTRB(10, 8, 10, 8),

                                                            hintText:
                                                                'كلمة السر',
                                                            border: OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0)),
                                                            suffixIcon:
                                                                const Icon(
                                                              Icons.password,
                                                              color: Color(
                                                                  0xffB1B0B0),
                                                            ),
                                                            prefixIcon:
                                                                IconButton(
                                                              icon: Icon(
                                                                // Based on passwordVisible state choose the icon
                                                                _password_upVisible
                                                                    ? Icons
                                                                        .visibility
                                                                    : Icons
                                                                        .visibility_off,
                                                                color: Color(
                                                                    0xffB1B0B0),
                                                              ),
                                                              onPressed: () {
                                                                // Update the state i.e. toogle the state of passwordVisible variable
                                                                setState(() {
                                                                  _password_upVisible =
                                                                      !_password_upVisible;
                                                                });
                                                              },
                                                            ),

                                                            // icon:
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: !Provider.of<
                                                                        AuthService>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .isVisiteur
                                                            ? HeightSize * 0.015
                                                            : HeightSize * 0.02,
                                                      ),
                                                      _isLoading
                                                          ? const CircularProgressIndicator(
                                                              color:
                                                                  Colors.white,
                                                            )
                                                          : RaisedButton(
                                                              onPressed:
                                                                  () async {
                                                                if (_formKeyUP
                                                                    .currentState!
                                                                    .validate()) {
                                                                  Fluttertoast
                                                                      .showToast(
                                                                          msg:
                                                                              'جاري إنشاء حسابك');
                                                                  if (await submit(
                                                                      _email_upController
                                                                          .text,
                                                                      _password_upController
                                                                          .text)) {
                                                                    if (nu) {
                                                                      // Navigator.pop(
                                                                      //     context);
                                                                      Navigator.pushReplacement(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (_) => accueil()));
                                                                      Fluttertoast
                                                                          .showToast(
                                                                              msg: 'مرحبا بك');
                                                                    } else {
                                                                      // Navigator.pop(
                                                                      //     context);
                                                                      Navigator.pushReplacement(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (_) => accueil_resto()));
                                                                      Fluttertoast
                                                                          .showToast(
                                                                              msg: 'مرحبا بك');
                                                                    }
                                                                  }
                                                                  //     .then(
                                                                  //         (value) async {
                                                                  //   await createNormalUser(
                                                                  //       _nomController
                                                                  //           .text,
                                                                  //       _email_upController
                                                                  //           .text,
                                                                  //       _numberController
                                                                  //           .text);
                                                                  // });
                                                                }
                                                              },
                                                              textColor: Color(
                                                                  0xff582e44),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(0.0),
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5.0)),
                                                              child: Container(
                                                                width:
                                                                    WidthSize *
                                                                        0.9,
                                                                height: !Provider.of<AuthService>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .isVisiteur
                                                                    ? HeightSize *
                                                                        0.08
                                                                    : HeightSize *
                                                                        0.08,
                                                                decoration: const BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(5.0))),
                                                                child: Center(
                                                                  child: Text(
                                                                    "فتح حساب",
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          'Hacen',
                                                                      fontSize:
                                                                          WidthSize *
                                                                              (25 / 540),
                                                                      color: Color(
                                                                          0xff582e44),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      vertical:
                          (!Provider.of<AuthService>(context, listen: false)
                                      .isVisiteur &&
                                  !signin)
                              ? HeightSize * 0.06
                              : HeightSize * 0.09,
                    ),
                    height: WidthSize * 0.3,
                    width: WidthSize * 0.3,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(80)),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage("assets/aber_sabel.png"),
                        )),
                  ),
                ),
                Container(
                  height: WidthSize * 0.12,
                  width: WidthSize * 0.12,
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top,
                      left: WidthSize * 0.01),
                  child: InkWell(
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Color(0xff582e44),
                        size: WidthSize * (40.0 / 540),
                      ),
                      onTap: () async {
                        Navigator.pop(context);
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
