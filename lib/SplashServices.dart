import 'dart:async';
import 'package:hecolin_surveillance/View/LoginScreen.dart';
import 'package:hecolin_surveillance/View/login.dart';
import 'package:flutter/material.dart';
import 'package:hecolin_surveillance/main.dart';

class SplashServices {
  void isLogin(BuildContext context) {
    Timer(
        const Duration(seconds: 3),
        () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginScreen())));

    /*if (user != null) {
      Timer(
          const Duration(seconds: 3),
          () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => SampleEntry())));
    } else {
      Timer(
          const Duration(seconds: 3),
          () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginScreen())));
    }*/
  }
}
