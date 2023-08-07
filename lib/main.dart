import 'package:flutter/material.dart';
import 'package:hecolin_surveillance/SplashServices.dart';
import 'package:hecolin_surveillance/View/HecolinTrialPreScreeningPage.dart';
import 'package:hecolin_surveillance/View/SplashScreen.dart';
import 'Service/NotificationService.dart';

import 'Utils/GeneralInformation.dart';
import 'View/HomePage.dart';
import 'View/Login.dart';
import 'WebApi/SendReceiveData.dart';
import 'Widgets/Layer1.dart';
import 'Widgets/Layer2.dart';
import 'Widgets/Layer3.dart';

void main() {
  // fetchLoginData();
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  runApp(const MyApp());

/*New Code*/
  // runApp(
  //     MaterialApp(
  //   title: 'Login Demo',
  //   theme: ThemeData(
  //     fontFamily: 'Poppins',
  //   ),
  //   debugShowCheckedModeBanner: false,
  //   home: MyApp(),
  // ));
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     body: Container(
//       decoration: BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage('images/primaryBg.png'),
//             fit: BoxFit.cover,
//           )),
//       child: Stack(
//         children: <Widget>[
//           Positioned(
//               top: 200,
//               left: 59,
//               child: Container(
//                 child: Text(
//                   'Login',
//                   style: TextStyle(
//                       fontSize: 48,
//                       fontFamily: 'Poppins-Medium',
//                       fontWeight: FontWeight.w500,
//                       color: Colors.white),
//                 ),
//               )),
//           Positioned(top: 290, right: 0, bottom: 0, child: LayerOne()),
//           Positioned(top: 318, right: 0, bottom: 28, child: LayerTwo()),
//           Positioned(top: 320, right: 0, bottom: 48, child: LoginScreen()),
//         ],
//       ),
//     ),
//   );
// }
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Notifications',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: const HecolinTrialPreScreening(title: 'PRE-SCREENING LOG SHEET – HECOLIN TRIAL'),
      home: const SplashScreen(),
    );
  }
}
