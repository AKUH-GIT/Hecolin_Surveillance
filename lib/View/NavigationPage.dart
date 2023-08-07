import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hecolin_surveillance/Model/PreScreeningVisits.dart';
import 'package:hecolin_surveillance/View/HecolinTrialPreScreeningPage.dart';

import '../Controller/BaselineInformationController.dart';
import '../Controller/PrescreeningVisitController.dart';
import '../DBOperations/DBProvider.dart';
import '../Model/WomenInformation.dart';
import '../Service/NotificationService.dart';
import '../Widgets/RoundButton.dart';
import '../config.dart';
import 'Login.dart';
import 'LoginScreen.dart';
import 'PrescreeningListViewPage.dart';

class NavigationPage extends StatefulWidget {
  final String title;

  const NavigationPage({Key? key, required this.title}) : super(key: key);

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  @override
  void initState() {
    super.initState();
    // Call your method here
    schedulePrescreeningNotifications();
  }

  Future<void> schedulePrescreeningNotifications() async {
    final List<Map<String, dynamic>>? queryResult =
        await DBProvider().getPrescreeningDataForToday();
    List<PrescreeningVisits> listPrescreening = [];
    String title = 'Appointment Reminder';
    String body = 'VR-ID: ';
    int i = 1;

    if (queryResult != null) {
      for (var map in queryResult!) {
        listPrescreening.add(PrescreeningVisits.fromMap(map));
        //print(map);
      }
    }

    for (var visitModel in listPrescreening) {
      String visitModelString = visitModel.TypeOfVisit;

      await NotificationService().showNotification(
        id: i,
        title: title,
        // body: body + visitModel.VRID + "is turning " + visitModelString.substring(visitModelString.length - 2)+" weeks today",
        body: body + visitModel.VRID + " Visit: " + visitModel.TypeOfVisit,
      );
      print(visitModel.VRID);
      await Future.delayed(Duration(seconds: 10));
      i++;
    }
  }

  @override
  Widget build(BuildContext context) {
    final PrescreeningVisitController prescreeningVisitController =
        PrescreeningVisitController();
    final BaselineInformationController baselineInformationController =
        BaselineInformationController();

    return Scaffold(
      appBar: AppBar(
        title: Text("Hecolin Trial"),
        actions: [
          IconButton(
            onPressed: () {
              //Navigator.of(context).pushNamed('/screen2');

              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            },
            icon: Icon(Icons.logout_outlined),
          ),
          //SizedBox(width:10)
        ],
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 15),

            SizedBox(
              height: 500,
              child:
                  // Card(
                  //   shadowColor: Colors.red,elevation: 0.0,clipBehavior: Clip.antiAlias,
                  //child:
                  StreamBuilder<List<Map<String, dynamic>>>(
                stream: baselineInformationController.GetWomenInformation()
                    .asStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    final items = snapshot.data ?? [];

                    return ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        // return InkWell(
                        //     onTap: () {
                        //   // Handle tap event for the item at the given index
                        //   print('Tapped on item: ${items[index]}');
                        //   Navigator.push(
                        //     context,
                        //       MaterialPageRoute(builder: (context)=>HecolinTrialPreScreening
                        //         (title: AppConfig.applicationName))
                        //
                        //   );
                        // },
                        //  child: ListTile(
                        //   title: Text(item['VRID'].toString()),
                        //   // title: Text(itemName),
                        //   //title: Text(data['studyID'].toString()),
                        //   subtitle: Text('added on: ' + ' by ' + item['FullName'].toString()),
                        // ),
                        // );
                        return Container(
                          width: 100,
                          // Set the width of each item in the horizontal ListView
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          // Add some horizontal spacing
                          // Bac: Colors.blue,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors
                                  .purple, // Set the border color to white
                              width: 1, // Set the border width to 2
                            ),
                          ),
                          child: InkWell(
                            onTap: () {
                              // Handle tap event for the item at the given index
                              print('Tapped on item: ${items[index]}');
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          HecolinTrialPreScreening(
                                              title:
                                                  AppConfig.applicationName)));
                            },
                            child: ListTile(
                              title: Text(item['VRID'].toString()),
                              // title: Text(itemName),
                              //title: Text(data['studyID'].toString()),
                              subtitle: Text('added on: ' +
                                  ' by ' +
                                  item['FullName'].toString()),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),

            //),
            SizedBox(height: 200),

            RoundButton(
              title: 'Fill Women Prescreening Information',
              loading: false,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HecolinTrialPreScreening(
                            title: AppConfig.applicationName)));
              },
            ),
            SizedBox(height: 30),
            RoundButton(
              title: 'View Prescreening Visits',
              loading: false,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PrescreeningListView(title: "")));
                // prescreeningVisitController.getPrescreeningVisitsOnDateVRId().then((_) {
                //   Navigator.push(context,
                //       MaterialPageRoute(builder: (context)=>PrescreeningListView(visits: prescreeningVisitController.prescreeningVisits))
                //   );
                //
                // }).catchError((error) {
                //   print('Error: $error');
                // });
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context)=>PrescreeningVisit(title: 'PRE-SCREENING LOG SHEET – HECOLIN TRIAL-V1'))
                // );
              },
            ),
          ],
        ),
      ),
    );
  }
}
