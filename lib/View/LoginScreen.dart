import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hecolin_surveillance/Controller/UserController.dart';
import 'package:hecolin_surveillance/Model/UserInformation.dart';
import 'package:hecolin_surveillance/View/HecolinTrialPreScreeningPage.dart';

import '../Model/DeviceInformation.dart';
import '../Utils/GeneralInformation.dart';
import '../Utils/Message.dart';
import '../WebApi/SendReceiveData.dart';
import '../WebApi/webapiconfig.dart';
import '../Widgets/Layer1.dart';
import '../Widgets/Layer2.dart';
import '../Widgets/RoundButton.dart';
import '../config.dart';
import 'Login.dart';
import 'NavigationPage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final UserController userController = UserController();
  String userName = "";
  String userPassword = "";

  @override
  void initState() {
    super.initState();
    // Call your method here
    // GetUserByDeviceInformation();
  }

  void login() {
    try {
      setState(() {
        loading = true;
      });

      if (nameController.text == 'admin' &&
          passwordController.text == 'admin') {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    NavigationPage(title: AppConfig.applicationName)));
      }
    } catch (exception) {
      Utils().toastMessage(exception.toString());
    }
  }

  void GetUserByDeviceInformation() async {
    String apiUrl = WebApiConfig.webApplicationURL +
        WebApiConfig.loginByDeviceURL; // Replace with your API endpoint URL

    try {
      final deviceInformation = await getUniqueDeviceId();

      if (deviceInformation != null) {
        apiUrl = apiUrl + deviceInformation.toString();
      }

      final response = await http.get(Uri.parse(apiUrl));
      // print(response.statusCode);
      if (response.statusCode == 200)
      //if (true)
      {
        // Request succeeded, parse and process the response data
        final jsonData = json.decode(response.body);
        //String responseBody = '{"userId":2,"userName":"reda","userPassword":"234","isActive":true,"deviceId":"f0cb75ccff5cf700","createdBy":1,"createdDate":"2023-07-14T05:56:55.083","updatedBy":0,"updateDate":"2023-07-14T05:56:55.083"}';
        //dynamic jsonData = json.decode(responseBody);

        if (jsonData != null) {
          final user = UserInformation.fromJson(jsonData);

          if (user != null) {
            userName = user.UserName;
            nameController.text = user.UserName;
            userPassword = user.UserPassword;
            passwordController.text = user.UserPassword;
          }
        }

        setState(() {
          loading = true;
        });
      }
    } catch (exception) {
      Utils().toastMessage(exception.toString());
    }
  }

  void LoginAfterDeviceVerification() {
    try {
      if (nameController.text == userName &&
          passwordController.text == userPassword) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    NavigationPage(title: AppConfig.applicationName)));
      }
    } catch (exception) {}
  }

  List<UserInformation> parseJsonUserData(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    return parsed
        .map<UserInformation>((json) => UserInformation.fromJson(json))
        .toList();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    nameController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return WillPopScope(
    //     onWillPop: () async{
    //       SystemNavigator.pop();
    //       return true;
    //     },
    //     child:Scaffold(
    //         appBar:AppBar(
    //             automaticallyImplyLeading: false,
    //             title: Text('Login'),
    //            backgroundColor: Colors.deepPurpleAccent,
    //
    //         ),
    //         body:Padding(
    //           padding:const EdgeInsets.symmetric(horizontal: 20),
    //           child: Column
    //             (
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               crossAxisAlignment: CrossAxisAlignment.center,
    //               children:[
    //                 Form(
    //                     key:_formKey,
    //                     child:Column(
    //                       children: [
    //                         TextFormField(
    //                           keyboardType: TextInputType.text,
    //                           controller: nameController,
    //                           decoration:const InputDecoration
    //                             (
    //                               hintText: 'Username',
    //                               // helperText: 'Enter email for eg reda@aku.edu',
    //                               prefixIcon: Icon(Icons.alternate_email)
    //                           ),
    //                           validator: (value)
    //                           {
    //                             if(value!.isEmpty)
    //                             {
    //                               return 'Enter Username';
    //                             }
    //                             return null;
    //                           },
    //
    //                         ),
    //                         const SizedBox(height:10 ,),
    //                         TextFormField(
    //                           keyboardType: TextInputType.text,
    //
    //                           controller: passwordController,
    //                           obscureText: true,
    //                           decoration:const InputDecoration
    //                             (
    //                               hintText: 'Password',
    //                               prefixIcon: Icon(Icons.lock_open)
    //                           ),
    //                           validator: (value)
    //                           {
    //                             if(value!.isEmpty)
    //                             {
    //                               return 'Enter Password';
    //                             }
    //                             return null;
    //                           },
    //                         ),
    //                       ],
    //                     )
    //                 ),
    //                 const SizedBox(height:50),
    //                 RoundButton(
    //                   title:'Login',
    //                   loading:false
    //                   ,onTap:(){
    //                   if(_formKey.currentState!.validate())
    //                   {
    //                     //login();
    //                     //LoginUsingDeviceInformation();
    //                     LoginAfterDeviceVerification();
    //                   }
    //                 },
    //                 ),
    //                 const SizedBox(height:30),
    //               ]
    //           ),
    //         )
    //     ));
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          //image: AssetImage('images/primaryBg.png'),
          image: AssetImage('images/bckgrnd.jpg'),

          fit: BoxFit.cover,
        )),
        child: Stack(
          children: <Widget>[
            Positioned(
                top: 200,
                left: 59,
                child: Container(
                  child: Text(
                    'Login',
                    style: TextStyle(
                        fontSize: 48,
                        fontFamily: 'Poppins-Medium',
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                )),
            Positioned(top: 290, right: 0, bottom: 0, child: LayerOne()),
            Positioned(top: 318, right: 0, bottom: 28, child: LayerTwo()),
            Positioned(
                top: 320, right: 0, bottom: 48, child: LoginScreenTheme()),
          ],
        ),
      ),
    );
  }
}
