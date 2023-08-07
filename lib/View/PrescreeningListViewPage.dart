import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hecolin_surveillance/Model/PreScreeningVisits.dart';
import 'package:hecolin_surveillance/View/HecolinTrialPreScreeningPage.dart';
import 'package:intl/intl.dart';

import '../Controller/PrescreeningVisitController.dart';
import '../Widgets/RoundButton.dart';
import '../config.dart';
import 'NavigationPage.dart';
import 'PrescreeningVisitsPage.dart';

class PrescreeningListView extends StatefulWidget {
  // PrescreeningListView({required this.visits});
  final String title;

  const PrescreeningListView({Key? key, required this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PrescreeningListViewState();
}

class PrescreeningListViewState extends State<PrescreeningListView> {
  List<PrescreeningVisits> visits = [];

  final prescreeningFormKey = GlobalKey<FormState>();
  final idVR = TextEditingController(text: 'VR-');
  final medidataScreeningID = TextEditingController();
  final dateOfVisit = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String formattedDate = "";
  bool loading = false;
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  bool dataRetrieved = false;

  Future<void> _selectRequiredDate(
      BuildContext context,
      TextEditingController aDatetimecontroller,
      int backDays,
      int futureDays) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now().subtract(Duration(days: backDays)),
        lastDate: DateTime.now().add(Duration(days: futureDays)));

    if (picked != null && picked != selectedDate) {
      setState(() {
        formattedDate = DateFormat('yyyy-MM-dd').format(picked);
        aDatetimecontroller.text = formattedDate;
      });
    } else if (picked == null) {
      setState(() {
        aDatetimecontroller.text = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final PrescreeningVisitController prescreeningVisitController =
        PrescreeningVisitController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Prescreening List'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          NavigationPage(title: AppConfig.applicationName)));
            },
            icon: Icon(Icons.logout_outlined),
          ),
          SizedBox(width: 10),
        ],
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Form(
              key: prescreeningFormKey,
              autovalidateMode: _autovalidateMode,
              child: ListView(
                padding: EdgeInsets.all(16),
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                  ),

                  TextFormField(
                    controller: idVR,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(8),
                    ],
                    validator: (value) {
                      // if (value!.isEmpty || !value.startsWith('VR-')) {
                      //   return "VR ID is required and should start with VR-";
                      // }
                      // else
                      if ((value!.isEmpty ||
                              value.length != 8 ||
                              !value.startsWith('VR-')) &&
                          (dateOfVisit.text == null ||
                              dateOfVisit.text == '')) {
                        return "Either Complete VR ID or Date is required";
                      } else {
                        return null;
                      }
                    },
                    onChanged: (value) {
                      if (value.isEmpty ||
                          (value.length == 1 && value != 'V')) {
                        idVR.value = const TextEditingValue(
                          text: 'VR-',
                          selection:
                              TextSelection.collapsed(offset: 'VR-'.length),
                        );
                      } else if (!value.startsWith('VR-')) {
                        idVR.value = TextEditingValue(
                          //text: 'VR-' + value.substring(2),
                          text: 'VR-${value.substring(2)}',
                          selection: TextSelection.collapsed(
                              offset: 'VR-'.length + value.length - 2),
                        );
                      }
                    },
                    decoration: InputDecoration(
                      hintText: "VRID (*)",
                      labelText: "VRID (*)",
                      labelStyle: const TextStyle(fontSize: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      //prefixText: 'VR-', // Set the fixed prefix
                      //prefixStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                  ),
                  // TextFormField(
                  //   controller: medidataScreeningID,
                  //   inputFormatters: [
                  //     FilteringTextInputFormatter.allow(
                  //         RegExp(r'^[a-zA-Z0-9-]+$')),
                  //     //FilteringTextInputFormatter.allow(RegExp(r'^[0-9]+$')),
                  //     //FilteringTextInputFormatter.digitsOnly,
                  //     // Restrict to 3 digits
                  //     LengthLimitingTextInputFormatter(7),
                  //   ],
                  //   validator: (value) {
                  //     if (value != null) {
                  //       String? message = digitValidator(value.toString());
                  //       if (message == "") {
                  //         return null;
                  //       } else {
                  //         return message;
                  //       }
                  //     }
                  //     return null; // Add a return statement for cases when value is null
                  //   },
                  //
                  //   onChanged: (value) {
                  //     String prefix = '';
                  //     //
                  //     // if (selectedValue == 'IH') {
                  //     //   prefix = 'S1-';
                  //     // } else if (selectedValue == 'AG') {
                  //     //   prefix = 'S2-';
                  //     // } else if (selectedValue == 'BH') {
                  //     //   prefix = 'S3-';
                  //     // } else if (selectedValue == 'RG') {
                  //     //   prefix = 'S4-';
                  //     // }
                  //
                  //     if (!value.startsWith(prefix)) {
                  //       if (value.length >= prefix.length) {
                  //         String updatedValue =
                  //             prefix + value.substring(prefix.length);
                  //         medidataScreeningID.value =
                  //             medidataScreeningID.value.copyWith(
                  //           text: updatedValue,
                  //           selection: TextSelection.collapsed(
                  //               offset: updatedValue.length),
                  //         );
                  //       } else {
                  //         medidataScreeningID.value =
                  //             medidataScreeningID.value.copyWith(
                  //           text: prefix,
                  //           selection:
                  //               TextSelection.collapsed(offset: prefix.length),
                  //         );
                  //       }
                  //     }
                  //   },
                  //
                  //   // ** ** //
                  //   decoration: InputDecoration(
                  //     labelText: "Medidata Screening ID (*)",
                  //     hintText: "Medidata Screening ID (*)",
                  //     labelStyle: const TextStyle(fontSize: 20),
                  //     border: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(5),
                  //     ),
                  //   ),
                  // ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                  ),
                  TextFormField(
                    validator: (value) {
                      if ((idVR.text!.isEmpty ||
                              idVR.text.length != 8 ||
                              !idVR.text.startsWith('VR-')) &&
                          (value == null || value == '')) {
                        return "Either complete VR ID or Date is required";
                      } else
                        return null;
                    },
                    controller: dateOfVisit,
                    readOnly: true,
                    //onTap: () => _selectDate(context, dateOfEntry),
                    onTap: () =>
                        _selectRequiredDate(context, dateOfVisit, 0, 38 * 7),

                    decoration: InputDecoration(
                      hintText: "Date (*)",
                      labelText: "Date (*)",
                      labelStyle: const TextStyle(fontSize: 20),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5)),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                  ),
                  RoundButton(
                      loading: loading,
                      title: "Search",
                      onTap: () async {
                        setState(() {
                          //_autovalidateMode = AutovalidateMode.always;
                          loading = true;
                        });

                        if (prescreeningFormKey.currentState != null &&
                            prescreeningFormKey.currentState!.validate()) {
                          visits = await prescreeningVisitController
                              .getPrescreeningVisitsOnDateVRId(idVR.text,
                                  medidataScreeningID.text, dateOfVisit.text);
                          if (visits.isNotEmpty) {
                            dataRetrieved = true;
                          } else {
                            dataRetrieved = false;
                          }
                          setState(() {
                            //_autovalidateMode = AutovalidateMode.always;
                            loading = false;
                          });
                        } else {
                          setState(() {
                            _autovalidateMode = AutovalidateMode.always;
                            loading = false;
                          });
                        }
                      }
                      //},
                      ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 15),
          ),
          if ((idVR.text != "VR-" ||
                  (dateOfVisit.text != null && dateOfVisit.text != "")) &&
              visits.isNotEmpty)
            Text(
              'Visits Schedule',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.purple,
              ),
            ),
          // Expanded(
          // child:Row(
          //    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   children: [
          //     Text(
          //       'Visits Schedule',
          //       style: TextStyle(
          //         fontWeight: FontWeight.bold,
          //         fontSize: 18,
          //         color: Colors.blue,
          //       ),
          //     ),
          //
          //     // Add more data row elements as needed
          //   ],
          // ),
          // ),
          if ((idVR.text != "VR-") ||
              (dateOfVisit.text != null && dateOfVisit.text != ""))
            Expanded(
              flex: 3,
              child: visits.isEmpty
                  ? Center(
                      child: Text(
                        'No Data ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.purple,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: visits.length,
                      itemBuilder: (context, index) {
                        final visit = visits[index];
                        return ListTile(
                          // tileColor: Colors.lightBlue, // Background color when not selected
                          // selectedTileColor: Colors.yellow, // Background color when selected
                          // focusColor: Colors.red, // Background color when focused
                          title: Text(
                            visit.VRID.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.purple,
                            ),
                          ),

                          // subtitle: Text('This is the subtitle of List Tile 1'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 5),
                              ),
                              Text(
                                "Medidata Screening ID: " +
                                    visit.MedidataScreeningID.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purpleAccent,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 5),
                              ),
                              Text(
                                "Type Of Visit: " +
                                    visit.TypeOfVisit.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purpleAccent,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 5),
                              ),
                              Text(
                                "Visit Date: " +
                                    visit.VisitDateString.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purpleAccent,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                              ),
                            ],
                          ),
                          leading: Icon(Icons.star),
                          // trailing: Icon(Icons.arrow_forward),
                          // onTap: () {
                          //   // Add onTap action here
                          //   print('List Tile 1 tapped');
                          // },
                        );
                        // return ListTile(
                        //   title: Text(visit.VRID),
                        //   // subtitle: Text(visit.VisitDate.toString()),
                        //   subtitle: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: [
                        //       const Padding(
                        //         padding: EdgeInsets.symmetric(vertical: 5),
                        //       ),
                        //       Text(visit.TypeOfVisit.toString()),
                        //       const Padding(
                        //         padding: EdgeInsets.symmetric(vertical: 5),
                        //       ),
                        //       Text(visit.VisitDateString.toString()),
                        //
                        //       const Padding(
                        //         padding: EdgeInsets.symmetric(vertical: 10),
                        //       ),
                        //
                        //     ],
                        //   ),
                        //   // subtitle: Text(visit.TypeOfVisit),
                        // );

                        // if (index == 0) {
                        //   return DataTable(
                        //     decoration: BoxDecoration(
                        //       border: Border.all(color: Colors.grey),
                        //     ),
                        //     // columnSpacing: 20.0,
                        //     // dataRowHeight: 60.0,
                        //     // headingRowHeight: 80.0,
                        //     columns: [
                        //       DataColumn(
                        //           label: Text(
                        //         'Date',
                        //         style: TextStyle(
                        //           fontWeight: FontWeight.bold,
                        //           fontSize: 18,
                        //           color: Colors.blue,
                        //         ),
                        //       )),
                        //       DataColumn(
                        //           label: Text(
                        //         'Type Of Visit',
                        //         style: TextStyle(
                        //           fontWeight: FontWeight.bold,
                        //           fontSize: 18,
                        //           color: Colors.blue,
                        //         ),
                        //       )),
                        //     ],
                        //     rows: [],
                        //   );
                        // }
                        //
                        // // Data rows
                        // final visit = visits[index - 1];
                        // return DataTable(
                        //   decoration: BoxDecoration(
                        //     border: Border(bottom: BorderSide(color: Colors.grey)),
                        //   ),
                        //   columns: [
                        //     DataColumn(label: Text(visit.VisitDate.toString(), style: TextStyle(
                        //       color: Colors.blue,
                        //     ),)),
                        //     DataColumn(label: Text(visit.TypeOfVisit.toString(),style: TextStyle(
                        // color: Colors.blue,
                        // ),)),
                        //   ],
                        //   rows: [],
                        // );
                      },
                    ),
            ),
        ],
      ),
    );
    // body: ListView.builder(
    //   itemCount: visits.length,
    //   itemBuilder: (context, index) {
    //     final visit = visits[index];
    //     return ListTile(
    //       title: Text(visit.VRID),
    //       subtitle: Text(visit.TypeOfVisit),
    //     );
    //   },
    // ),
    // );
  }

  String digitValidator(String value) {
    if (value.isEmpty) {
      return 'Medidata Screening ID is required';
    }
    if (value.length <= 3) {
      return ""; // Allow any input before the fourth character
    }

    String digits = value.substring(3);
    if (digits.isEmpty || !RegExp(r'^[0-9]+$').hasMatch(digits)) {
      return 'Please enter only digits after the third character';
    }

    return ""; // Validation passed
  }
}
