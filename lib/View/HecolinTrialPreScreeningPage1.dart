import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:hecolin_surveillance/Service/NotificationService.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

import '../DBOperations/DBProvider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'PRE-SCREENING LOG SHEET – HECOLIN TRIAL';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: const MyStatefulWidget(),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => new _MyStatefulWidgetState();
}

class SecondRoute extends StatelessWidget {
  const SecondRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register User'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            Database? db = await DBProvider.internal().db;
            db?.rawInsert(
                "INSERT INTO users (userid, passwd) VALUES('user1', 'user1')");

            Navigator.pop(context);
          },
          child: const Text('Go back!'),
        ),
      ),
    );
  }
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  TextEditingController fullNameOfWomen = TextEditingController();
  TextEditingController idVR = TextEditingController();
  TextEditingController medidataScreeningID = TextEditingController();


  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  String btnText = "";

  var focusNode = FocusNode();

  List<String> lst_users = ["User", "Admin"];

  @override
  void initState() {
    super.initState();
  }

  _showUsers() async {
    // get a reference to the database
    // because this is an expensive operation we use async and await
    Database db = await DBProvider().initDb();

    // show the results: print all rows in the db
    print(await db.query("users"));
  }



  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: ListView(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
          ),
          Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: const Text(
                'BASELINE INFORMATION ',
                style: TextStyle(fontSize: 20),
              )),
          Container(
            padding: const EdgeInsets.all(10),
            child: TextFormField(
              controller: fullNameOfWomen,
              autofocus: true,
              focusNode: focusNode,
              validator: (value) {
                if (value!.isEmpty)
                  return "Women Name required";
                else
                  return null;
              },
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Full name of woman'),
              style: new TextStyle(fontSize: 20),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 15),
            child: TextFormField(
              controller: medidataScreeningID,
              validator: (value) {
                if (value!.isEmpty)
                  return "Medidata Screening ID required";
                else
                  return null;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Medidata Screening ID',
              ),
              style: new TextStyle(fontSize: 20),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 15),
            child: TextFormField(
              controller: idVR,
              validator: (value) {
                if (value!.isEmpty)
                  return "VR Id required";
                else
                  return null;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'VR ID',
              ),
              style: new TextStyle(fontSize: 20),
            ),
          ),
          // Container(
          //   padding: const EdgeInsets.fromLTRB(10, 10, 10, 15),
          //   child: DropdownSearch<String>(
          //     items: lst_users,
          //     mode: Mode.DIALOG,
          //     validator: (value) {
          //       if (value == null) {
          //         return "User Role required";
          //       }
          //     },
          //     showSearchBox: true,
          //   ),
          // ),
          Container(
            height: 60,
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: ElevatedButton(
              child: Text(
                'Submit',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                //_showUsers();
                SaveWomenInformation();
              },
            ),
          ),
          // Container(
          //   height: 60,
          //   padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          //   child: ElevatedButton(
          //     child: const Text(
          //       'Cancel',
          //       style: TextStyle(fontSize: 20),
          //     ),
          //     onPressed: _clearField,
          //   ),
          // ),
          // Container(
          //   height: 60,
          //   padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          //   child: ElevatedButton(
          //     child: Text(
          //       'Register',
          //       style: TextStyle(fontSize: 20),
          //     ),
          //     onPressed: () {
          //       //_submit();
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }





  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alert Dialog"),
      content: Text("User id does not exist or user status is inactive"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _clearField() {
    fullNameOfWomen.text = "";
    idVR.text = "";
    formKey.currentState!.reset();
  }

  Future<void> SaveWomenInformation() async {
    // Database? db = await DBProvider.internal().db;
    // db?.rawInsert(
    //     "INSERT INTO BaselineInformation (VRID, MedidataScreeningID,FullName) VALUES('234', 'MD123','Reda')");
    //
    // Navigator.pop(context);
    _insert();
  }



  changeText(String txt) {
    txt = "werwe";
  }
  _insert() async {
    // get a reference to the database
    // because this is an expensive operation we use async and await
    Database db = await DBProvider().initDb();

    // row to insert
    Map<String, dynamic> row = {
      "VRID": idVR.text,
      "MedidataScreeningID": medidataScreeningID.text,
      "FullName": fullNameOfWomen.text
    };

    // do the insert and get the id of the inserted row
    int id = await db.insert("BaselineInformation", row);

    // show the results: print all rows in the db
    print(await db.query("BaselineInformation"));
    WidgetsFlutterBinding.ensureInitialized();
    NotificationService().initNotification();
    scheduleNotifications();


    //showAlertDialog(context, "Record saved successfully");
  }

  Future<void> scheduleNotifications() async {
    // Define your list of appointment times
    List<DateTime> appointmentTimes = [
      DateTime.now().add(Duration(seconds: 10)),
      DateTime.now().add(Duration(seconds: 20)),
      DateTime.now().add(Duration(seconds: 30)),
    ];

    // Schedule notifications for each appointment time
    for (int i = 0; i < appointmentTimes.length; i++) {
      DateTime appointmentTime = appointmentTimes[i];
      String formattedTime =
          '${appointmentTime.hour}:${appointmentTime.minute}';

      String title = 'Appointment Reminder';
      String body = 'You have an appointment today at $formattedTime';

      await NotificationService().showNotification(
        id: i,
        title: title,
        body: body,
      );

      await Future.delayed(Duration(seconds: 10));

      Database? db = await DBProvider.internal().db;
      db?.rawInsert(
          "INSERT INTO BaselineInformation (VRID, MedidataScreeningID,FullName) VALUES('445', 'MD123','Reda')");

    }
  }

}
