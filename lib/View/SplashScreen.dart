import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hecolin_surveillance/SplashServices.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashServices _splashServivce = SplashServices();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _splashServivce.isLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child:
                Text('Hacoline Surveillance', style: TextStyle(fontSize: 30))));
  }
}
