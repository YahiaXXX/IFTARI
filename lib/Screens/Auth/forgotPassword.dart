import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../Providers/auth.dart';

class forgot extends StatefulWidget {
  const forgot({Key? key}) : super(key: key);

  @override
  State<forgot> createState() => _forgotState();
}

class _forgotState extends State<forgot> {
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final HeightSize = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top +
            MediaQuery.of(context).padding.bottom);
    final sizee = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: sizee.height,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        opacity: 0.2,
                        fit: BoxFit.contain,
                        image: AssetImage("assets/hilal.png"),
                      ),
                    ),
                    height: sizee.height * 0.6,
                  ),
                ),
                Container(
                  height: HeightSize * 0.55,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xffFAC358).withOpacity(0.8),
                        Color(0xff3FB876).withOpacity(0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(60),
                      //  bottomLeft: Radius.circular(100),
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(sizee.width * 0.0185),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                Navigator.pop(context);
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).padding.top),
                              child: Icon(
                                Icons.arrow_back_ios_outlined,
                                color: Colors.white,
                                size: sizee.width * 0.0592,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: HeightSize * 0.07,
                      ),
                      Container(
                        width: sizee.width * 0.9,
                        height: HeightSize * 0.09,
                        child: TextFormField(
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.right,
                          controller: _emailController,
                          validator: (value) {
                            if (value == null || !value.contains('@')) {
                              return 'Invalid Email';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            //  _authData['email'] = value!;
                          },
                          keyboardType: TextInputType.emailAddress,
                          cursorColor: Color(0xff582e44),
                          decoration: InputDecoration(
                            hoverColor: Colors.black,
                            focusColor: Color(0xff582e44),
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Color(0xff582e44),
                                ),
                                borderRadius: BorderRadius.circular(5.0)),
                            fillColor: Colors.white,
                            filled: true,
                            //          contentPadding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                            hintText: 'بريدك الالكتروني',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            suffixIcon: const Icon(
                              Icons.email,
                              color: Color(0xffB1B0B0),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: HeightSize * 0.036,
                      ),
                      RaisedButton(
                        onPressed: () async {
                          Fluttertoast.showToast(
                                  msg: 'البريد الإلكتروني يجب أن يكون مؤكد')
                              .then((value) => Fluttertoast.showToast(
                                  msg: 'ليست في الخدمة الآن'));

                          // showDialog(
                          //     context: context,
                          //     barrierDismissible: false,
                          //     builder: (context) => Center(
                          //         child: CircularProgressIndicator(
                          //           color: Colors.white,
                          //         )));
                          // try {
                          //   await authService
                          //       .forgotPassword(
                          //     _emailController.text,
                          //   )
                          //       .then((value) {
                          //     Fluttertoast.showToast(
                          //         msg: "Verifiez votre boite email ",
                          //         toastLength: Toast.LENGTH_SHORT,
                          //         gravity: ToastGravity.BOTTOM,
                          //         timeInSecForIosWeb: 1,
                          //         backgroundColor: Colors.white,
                          //         textColor: Colors.red,
                          //         fontSize: 16.0);
                          //     Navigator.of(context).pop();
                          //   });
                          // } catch (e) {
                          //   print(e.toString());
                          //   Navigator.pop(context);
                          // }
                        },
                        textColor: Color(0xff582e44),
                        padding: const EdgeInsets.all(0.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        child: Container(
                          width: sizee.width * 0.9,
                          height: HeightSize * 0.08,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0))),
                          child: Center(
                            child: Text(
                              "إستعادة كلمة المرور",
                              style: TextStyle(
                                fontSize: sizee.width * (25 / 540),
                                color: Color(0xff582e44),
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
      ),
    );
  }
}
