import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hecolin_surveillance/Utils/GestationCalculations.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

import '../DBOperations/DBProvider.dart';
import '../Model/PreScreeningVisits.dart';
import '../Service/NotificationService.dart';
import '../Widgets/RoundButton.dart';

class HecolinTrialPreScreening extends StatefulWidget {
  const HecolinTrialPreScreening({Key? key,required this.title}) : super(key: key);
  final String title;

  @override
  State<HecolinTrialPreScreening> createState() => _HecolinTrialPreScreeningState();

}

class _HecolinTrialPreScreeningState extends State<HecolinTrialPreScreening> {

  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final fullName = TextEditingController();
  final agreeParticipation = TextEditingController();
  final idVR = TextEditingController();
  final medidataScreeningID = TextEditingController();
  final age = TextEditingController();
  final completeAddress = TextEditingController();
  final phoneNumber = TextEditingController();
  final prismaStudyEnrolDate = TextEditingController();
  final ctu1VisitDate = TextEditingController();
  final ultraSoundDate = TextEditingController();
  final dateOfLabResults = TextEditingController();
  final prescreeningVisitDate = TextEditingController();
  final fifthAppointmentDate = TextEditingController();
  final tenthAppointmentDate = TextEditingController();
  final consentReason = TextEditingController(); // Variable to track the selected value
  final consentFifthDayReason = TextEditingController(); // Variable to track the selected value
  final consentTenthDayReason = TextEditingController(); // Variable to track the selected value


  final eDD = TextEditingController();
  final lMPDate = TextEditingController();
  final weeks = TextEditingController();
  final days = TextEditingController();
  final nextUltrasoundDate = TextEditingController();
  int ageNumber = 0;
  bool labSamplesCollected = true;
  bool pregnantWomenEnrolled = true;
  bool counselingAtCenter = true;

  bool ultrasoundDone = true;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime selectedDate = DateTime.now();
  String formattedDate = "";

  int participationWomenSelectedValue = 0; // Variable to track the selected value
  int consentWomenSelectedValue = 0; // Variable to track the selected value
  int consentFifthWomenSelectedValue = 0; // Variable to track the selected value
  int consentTenthWomenSelectedValue = 0;


  @override
  void initState() {
    super.initState();
    // Call your method here
    schedulePrescreeningNotifications();
  }


  clearFields() {
    _formKey.currentState!.reset();
    fullName.text = "";
    idVR.text = "";
    medidataScreeningID.text = "";
    age.text = "";
    completeAddress.text = "";
    phoneNumber.text = "";
  }

  // logOut() {
  //   Navigator.push(context, MaterialPageRoute(builder: (context) => login()));
  // }

  Future<void> _selectDate(BuildContext context,
      TextEditingController aDatetimecontroller) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));

    if (picked != null && picked != selectedDate) {
      setState(() {
        formattedDate = DateFormat('yyyy-MM-dd').format(picked);
        aDatetimecontroller.text = formattedDate;
      });
    }
  }

  Future<void> _selectLMPDate(BuildContext context,
      TextEditingController aDatetimecontroller) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime.now());

    if (picked != null && picked != selectedDate) {
      setState(() {
        formattedDate = DateFormat('yyyy-MM-dd').format(picked);
        aDatetimecontroller.text = formattedDate;
        SetGestationalWeeksAndDays();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('PRE-SCREENING LOG SHEET – HECOLIN TRIAL'),
          backgroundColor: Colors.deepPurpleAccent,
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(

          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                ),

                const Text(
                  'BASELINE INFORMATION ',
                  style: TextStyle(
                    //fontWeight: FontWeight.bold,
                      fontSize: 25.0,
                      color: Colors.white,
                      backgroundColor: Colors.deepPurpleAccent

                  ),
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                ),

                TextFormField(
                  controller: fullName,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter full woman name";
                    }
                    else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                      hintText: "Full Name",
                      labelText: "Full Name",
                      labelStyle: const TextStyle(fontSize: 20),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5))),
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                ),

                TextFormField(
                  controller: age,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  validator: (value) {
                    if (value!.isEmpty)
                      return "Please enter age (years)";
                    else
                      return null;
                  },
                  decoration: InputDecoration(
                    hintText: "Age (Years)",
                    labelText: "Age (Years)",
                    labelStyle: const TextStyle(fontSize: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                ),

                TextFormField(
                  controller: idVR,
                  validator: (value) {
                    if (value!.isEmpty)
                      return "Please enter VRID";
                    else
                      return null;
                  },
                  decoration: InputDecoration(
                    hintText: "VRID",
                    labelText: "VRID",
                    labelStyle: const TextStyle(fontSize: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                ),

                TextFormField(
                  controller: medidataScreeningID,
                  validator: (value) {
                    if (value!.isEmpty)
                      return "Please enter Medidata Screening ID";
                    else
                      return null;
                  },
                  decoration: InputDecoration(
                    labelText: "Medidata Screening ID",
                    hintText: "Medidata Screening ID",
                    labelStyle: const TextStyle(fontSize: 20),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)),
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                ),

                TextFormField(
                  controller: completeAddress,
                  validator: (value) {
                    if (value!.isEmpty)
                      return "Please enter complete address";
                    else
                      return null;
                  },
                  decoration: InputDecoration(
                    hintText: "Complete Address",
                    labelText: "Complete Address",
                    labelStyle: const TextStyle(fontSize: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                ),

                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty)
                      return "Phone Number required";
                    else
                      return null;
                  },
                  controller: phoneNumber,
                  decoration: InputDecoration(
                    hintText: "Phone Number",
                    labelText: "Phone Number",
                    labelStyle: const TextStyle(fontSize: 20),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)),
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                ),
                const Text(
                  'VERBAL CONSENT INFORMATION',
                  style: TextStyle(
                    //fontWeight: FontWeight.bold,
                      fontSize: 25.0,
                      color: Colors.white,
                      backgroundColor: Colors.deepPurpleAccent

                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                ),
                Row(
                  children: [
                    SizedBox(width: 10), // give it width

                    const Text(
                      "Counseling for Hecolin Trial is done at the center?",
                      style: TextStyle(fontSize: 20),

                    ),
                    SizedBox(width: 10), // give it width

                    Checkbox(
                      value: counselingAtCenter,
                      onChanged: (value) {
                        setState(() {
                          counselingAtCenter = !counselingAtCenter;
                        });
                      },
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                ),
                Row(
                  children: [
                    SizedBox(width: 10), // give it width
                    const Text(
                      "Did the woman agree to participate?",
                      style: TextStyle(fontSize: 20),

                    ),
                    SizedBox(width: 90),

                  ],
                ),
                Row(
                  children: [
                    Radio(
                      value: 1,
                      groupValue: participationWomenSelectedValue,
                      onChanged: (value) {
                        setState(() {
                          participationWomenSelectedValue = value as int;
                        });
                      },
                    ),
                    Text('Yes', style: TextStyle(fontSize: 18),),
                    SizedBox(width: 20),
                    Radio(
                      value: 2,
                      groupValue: participationWomenSelectedValue,
                      onChanged: (value) {
                        setState(() {
                          participationWomenSelectedValue = value as int;
                        });
                      },
                    ),
                    Text('No', style: TextStyle(fontSize: 18)),
                    SizedBox(width: 20),
                    Radio(
                      value: 3,
                      groupValue: participationWomenSelectedValue,
                      onChanged: (value) {
                        setState(() {
                          participationWomenSelectedValue = value as int;
                        });
                      },
                    ),
                    Text(
                        'Need time to confirm', style: TextStyle(fontSize: 18)),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                ),

                TextFormField(
                  controller: agreeParticipation,
                  validator: (value) {
                    if (value!.isEmpty)
                      return "";
                    else
                      return null;
                  },
                  decoration: InputDecoration(
                      hintText: "Reason",
                      labelText: "Reason",
                      labelStyle: const TextStyle(fontSize: 20),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5))),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                ),
                Row(
                  children: [
                    SizedBox(width: 10), // give it width
                    const Text(
                      "Did the woman provide consent?",
                      style: TextStyle(fontSize: 20),

                    ),
                    SizedBox(width: 90),

                  ],
                ),
                Row(
                  children: [
                    Radio(
                      value: 1,
                      groupValue: consentWomenSelectedValue,
                      onChanged: (value) {
                        setState(() {
                          consentWomenSelectedValue = value as int;
                        });
                      },
                    ),
                    Text('Yes,consented', style: TextStyle(fontSize: 18),),
                    Radio(
                      value: 2,
                      groupValue: consentWomenSelectedValue,
                      onChanged: (value) {
                        setState(() {
                          consentWomenSelectedValue = value as int;
                        });
                      },
                    ),
                    Text('Consent not provided yet',
                        style: TextStyle(fontSize: 18)),
                    Radio(
                      value: 3,
                      groupValue: consentWomenSelectedValue,
                      onChanged: (value) {
                        setState(() {
                          consentWomenSelectedValue = value as int;
                        });
                      },
                    ),
                    Text('Refused', style: TextStyle(fontSize: 18)),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                ),
                TextFormField(
                  controller: consentReason,
                  validator: (value) {
                    if (value!.isEmpty)
                      return "";
                    else
                      return null;
                  },
                  decoration: InputDecoration(
                      hintText: "Reason",
                      labelText: "Reason",
                      labelStyle: const TextStyle(fontSize: 20),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5))),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty)
                      return "Date of Appointment (5th Day) required";
                    else
                      return null;
                  },
                  controller: fifthAppointmentDate,
                  readOnly: true,
                  onTap: () => _selectDate(context, fifthAppointmentDate),

                  decoration: InputDecoration(
                    hintText: "Date of Appointment (5th Day)",
                    labelText: "Date of Appointment (5th Day)",
                    labelStyle: const TextStyle(fontSize: 20),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                ),

                Row(
                  children: [
                    SizedBox(width: 10), // give it width
                    const Text(
                      "Did the woman provide consent on the 5th day?",
                      style: TextStyle(fontSize: 20),

                    ),
                    SizedBox(width: 90),

                  ],
                ),
                Row(
                  children: [
                    Radio(
                      value: 1,
                      groupValue: consentFifthWomenSelectedValue,
                      onChanged: (value) {
                        setState(() {
                          consentFifthWomenSelectedValue = value as int;
                        });
                      },
                    ),
                    Text('Yes,consented', style: TextStyle(fontSize: 18),),
                    Radio(
                      value: 2,
                      groupValue: consentFifthWomenSelectedValue,
                      onChanged: (value) {
                        setState(() {
                          consentFifthWomenSelectedValue = value as int;
                        });
                      },
                    ),
                    Text('Consent not provided yet',
                        style: TextStyle(fontSize: 18)),
                    Radio(
                      value: 3,
                      groupValue: consentFifthWomenSelectedValue,
                      onChanged: (value) {
                        setState(() {
                          consentFifthWomenSelectedValue = value as int;
                        });
                      },
                    ),
                    Text('Refused', style: TextStyle(fontSize: 18)),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                ),
                TextFormField(
                  controller: consentFifthDayReason,
                  validator: (value) {
                    if (value!.isEmpty)
                      return "";
                    else
                      return null;
                  },
                  decoration: InputDecoration(
                      hintText: "Reason",
                      labelText: "Reason",
                      labelStyle: const TextStyle(fontSize: 20),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5))),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty)
                      return "Date of Appointment (10th Day) required";
                    else
                      return null;
                  },
                  controller: tenthAppointmentDate,
                  readOnly: true,
                  onTap: () => _selectDate(context, tenthAppointmentDate),

                  decoration: InputDecoration(
                    hintText: "Date of Appointment (10th Day)",
                    labelText: "Date of Appointment (10th Day)",
                    labelStyle: const TextStyle(fontSize: 20),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                ),
                Row(
                  children: [
                    SizedBox(width: 10), // give it width
                    const Text(
                      "Did the woman provide consent on the 10th day?",
                      style: TextStyle(fontSize: 20),

                    ),
                    SizedBox(width: 90),

                  ],
                ),
                Row(
                  children: [
                    Radio(
                      value: 1,
                      groupValue: consentTenthWomenSelectedValue,
                      onChanged: (value) {
                        setState(() {
                          consentTenthWomenSelectedValue = value as int;
                        });
                      },
                    ),
                    Text('Yes,consented', style: TextStyle(fontSize: 18),),
                    Radio(
                      value: 2,
                      groupValue: consentTenthWomenSelectedValue,
                      onChanged: (value) {
                        setState(() {
                          consentTenthWomenSelectedValue = value as int;
                        });
                      },
                    ),
                    Text('Consent not provided yet',
                        style: TextStyle(fontSize: 18)),
                    Radio(
                      value: 3,
                      groupValue: consentTenthWomenSelectedValue,
                      onChanged: (value) {
                        setState(() {
                          consentTenthWomenSelectedValue = value as int;
                        });
                      },
                    ),
                    Text('Refused', style: TextStyle(fontSize: 18)),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                ),
                TextFormField(
                  controller: consentTenthDayReason,
                  validator: (value) {
                    if (value!.isEmpty)
                      return "Provide reason";
                    else
                      return null;
                  },
                  decoration: InputDecoration(
                      hintText: "Reason",
                      labelText: "Reason",
                      labelStyle: const TextStyle(fontSize: 20),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5))),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                ),
                const Text(
                  'PREGNANCY INFORMATION',
                  style: TextStyle(
                    //fontWeight: FontWeight.bold,
                      fontSize: 25.0,
                      color: Colors.white,
                      backgroundColor: Colors.deepPurpleAccent

                  ),
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                ),

                Row(
                  children: [
                    SizedBox(width: 10), // give it width

                    const Text(
                      "Is the pregnant women enrolled in PRISMA Study?",
                      style: TextStyle(fontSize: 20),

                    ),
                    SizedBox(width: 10), // give it width

                    Checkbox(
                      value: pregnantWomenEnrolled,
                      onChanged: (value) {
                        setState(() {
                          pregnantWomenEnrolled = !pregnantWomenEnrolled;
                        });
                      },
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty)
                      return "PRISMA Study Enroll Date required";
                    else
                      return null;
                  },
                  controller: prismaStudyEnrolDate,
                  readOnly: true,
                  onTap: () => _selectDate(context, prismaStudyEnrolDate),

                  decoration: InputDecoration(
                    hintText: "PRISMA Study Enroll Date",
                    labelText: "PRISMA Study Enroll Date",
                    labelStyle: const TextStyle(fontSize: 20),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)),
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                ),

                Row(
                  children: [
                    SizedBox(width: 10), // give it width

                    const Text(
                      "Have the lab samples been collected?",
                      style: TextStyle(fontSize: 20),

                    ),
                    SizedBox(width: 10), // give it width

                    Checkbox(
                      value: labSamplesCollected,
                      onChanged: (value) {
                        setState(() {
                          labSamplesCollected = !labSamplesCollected;
                        });
                      },
                    ),
                  ],
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                ),

                Row(
                  children: [
                    SizedBox(width: 10), // give it width

                    const Text(
                      "Has the ultrasound been done?",
                      style: TextStyle(fontSize: 20),

                    ),
                    SizedBox(width: 70), // give it width

                    Checkbox(
                      value: ultrasoundDone,
                      onChanged: (value) {
                        setState(() {
                          ultrasoundDone = !ultrasoundDone;
                        });
                      },
                    ),
                  ],
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                ),

                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty)
                      return "Ultrasound Date required";
                    else
                      return null;
                  },
                  controller: ultraSoundDate,
                  readOnly: true,
                  onTap: () => _selectDate(context, ultraSoundDate),

                  decoration: InputDecoration(
                    hintText: "Ultrasound Date",
                    labelText: "Ultrasound Date",
                    labelStyle: const TextStyle(fontSize: 20),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)),
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                ),

                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty)
                      return "LMP Date is required";
                    else
                      return null;
                  },
                  controller: lMPDate,
                  readOnly: true,
                  onTap: () => _selectLMPDate(context, lMPDate),

                  decoration: InputDecoration(
                    hintText: "LMP Date",
                    labelText: "LMP Date",
                    labelStyle: const TextStyle(fontSize: 20),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)),
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                ),

                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty)
                      return "EDD is required";
                    else
                      return null;
                  },
                  controller: eDD,
                  readOnly: true,
                  onTap: () => _selectDate(context, eDD),

                  decoration: InputDecoration(
                    hintText: "EDD",
                    labelText: "EDD",
                    labelStyle: const TextStyle(fontSize: 20),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)),
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                ),

                Row(
                  children: [
                    SizedBox(width: 10), // give it width

                    const Text(
                      "(If yes) Gestational week according to ultrasound",
                      style: TextStyle(fontSize: 20),

                    ),

                  ],
                ),

                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 0, 5),
                            child: Text(
                              "",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            controller: weeks,
                            decoration: const InputDecoration(
                              hintText: "Weeks",
                              labelText: "Weeks",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(8))),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 0, 5),
                            child: Text(
                              "",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            controller: days,
                            decoration: const InputDecoration(
                              hintText: "Days",
                              labelText: "Days",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(8))),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                ),

                Row(
                  children: const [
                    SizedBox(width: 10), // give it width

                    Text(
                      "If ultrasound is not done due to any reason, next scheduled ",
                      style: TextStyle(fontSize: 20),
                      softWrap: false,
                      maxLines: 1,
                    ),
                  ],
                ),

                Row(
                  children: const [
                    SizedBox(width: 10), // give it width

                    Text(
                      "ultrasound date? ",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                ),

                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty)
                      return "Next Visit Ultrasound Date is required";
                    else
                      return null;
                  },
                  controller: nextUltrasoundDate,
                  readOnly: true,
                  onTap: () => _selectDate(context, nextUltrasoundDate),

                  decoration: InputDecoration(
                    hintText: "Next Ultrasound Date",
                    labelText: "Next Ultrasound Date",
                    labelStyle: const TextStyle(fontSize: 20),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                ),

                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty)
                      return "CTU 1 Visit Date is required";
                    else
                      return null;
                  },
                  controller: ctu1VisitDate,
                  readOnly: true,
                  onTap: () => _selectDate(context, ctu1VisitDate),

                  decoration: InputDecoration(
                    hintText: "CTU 1 Visit Date",
                    labelText: "CTU 1 Visit Date",
                    labelStyle: const TextStyle(fontSize: 20),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)),
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                ),
                Row(
                  children: const [
                    SizedBox(width: 10), // give it width

                    Text(
                      "Note: Lab must be done at time of visit or in 7days time.",
                      style: TextStyle(fontSize: 20),
                      softWrap: false,
                      maxLines: 1,
                    ),
                  ],
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                ),

                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty)
                      return "Date of Lab results is required";
                    else
                      return null;
                  },
                  controller: dateOfLabResults,
                  readOnly: true,
                  onTap: () => _selectDate(context, dateOfLabResults),

                  decoration: InputDecoration(
                    hintText: "Date of Lab results",
                    labelText: "Date of Lab results",
                    labelStyle: const TextStyle(fontSize: 20),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                ),

                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty)
                      return "Prescreening Visit Date is required";
                    else
                      return null;
                  },
                  controller: prescreeningVisitDate,
                  readOnly: true,
                  onTap: () => _selectDate(context, prescreeningVisitDate),

                  decoration: InputDecoration(
                    hintText: "Prescreening Visit Date",
                    labelText: "Prescreening Visit Date",
                    labelStyle: const TextStyle(fontSize: 20),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                ),

                RoundButton(
                  loading: loading,

                  title: "Submit",
                  onTap: () async {
                    // if (_formKey.currentState!.validate()) {
                    //   setState(() {
                    //     loading = true;
                    //   });
                    SaveWomenInformation();

                    //}


                  },
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                ),

                // RoundButton(
                //   title: "Logout",
                //   onTap: () {
                //    // logOut();
                //   },
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SaveBaselineInformation() async
  {
    try {
      Database db = await DBProvider().initDb();
      ageNumber = int.parse(age.text);

      Map<String, dynamic> row = {
        "VRID": idVR.text,
        "MedidataScreeningID": medidataScreeningID.text,
        "FullName": fullName.text,
        "CompleteAddress": completeAddress.text,
        "PhoneNumber": phoneNumber.text,
        "Age": ageNumber
      };

      await db.insert("WomenBaselineInformation", row);
      print(await db.query("WomenBaselineInformation"));
    }
    catch (exception) {
      print(exception);
    }
  }

  SavePregnancyInformation() async
  {
    try {
      Database db = await DBProvider().initDb();

      // row to insert
      Map<String, dynamic> row =
      {
        "VRID": idVR.text,
        "PRISMAEnrol": pregnantWomenEnrolled,
        "PRISMAEnrolDate": prismaStudyEnrolDate.text,
        "LabSamplesCollected": labSamplesCollected,
        "UltrasoundDone": ultrasoundDone,
        "UltrasoundDate": ultraSoundDate.text,
        "EDD": eDD.text,
        "LMPDate": lMPDate.text,
        "GestationalWeek": int.parse(weeks.text),
        "GestationalDays": int.parse(days.text),
        "NextUltrasoundDate": nextUltrasoundDate.text,
        "CTU1VisitDate": ctu1VisitDate.text,
        "LabResultsDate": dateOfLabResults.text,
        "PrescreeningVisitDate": prescreeningVisitDate.text
      };

      await db.insert("WomenPregnancyInformation", row);
      print(await db.query("WomenPregnancyInformation"));
    }
    catch (exception) {
      print(exception);
    }
  }

  SaveConsentInformation() async
  {
    try {
      Database db = await DBProvider().initDb();

      // row to insert
      Map<String, dynamic> row =
      {
        "VRID": idVR.text,
        "IsCounseled": counselingAtCenter,
        "HasAgreed": participationWomenSelectedValue,
        "AgreementReason": agreeParticipation.text,
        "HasConsented": consentWomenSelectedValue,
        "ConsentReason": consentReason.text,
        "FifthAppointmentDate": fifthAppointmentDate.text,
        "HasConsentedFifthDay": consentFifthWomenSelectedValue,
        "ConsentReasonFifthDay": consentFifthDayReason.text,
        "TenthAppointmentDate": tenthAppointmentDate.text,
        "HasConsentedTenthDay": consentTenthWomenSelectedValue,
        "ConsentReasonTenthDay": consentTenthDayReason.text
      };

      await db.insert("WomenVerbalConsentInformation", row);
      print(await db.query("WomenVerbalConsentInformation"));
    }
    catch (exception) {
      print(exception);
    }
  }

  SetGestationalWeeksAndDays()
  {
    Duration gestationAgeDuration = GestationCalculations
        .GestationalAgeCalculation(lMPDate.text);
    int totalDays=0;
    int gestationWeeks=0;
    int gestationDays=0;

    if(gestationAgeDuration!=null)
    {
      totalDays=gestationAgeDuration.inDays;
      print(totalDays);
      gestationWeeks = (totalDays~/7) as int;
      gestationDays  = totalDays%7;

      weeks.text = gestationWeeks.toString();
      days.text  = gestationDays.toString();


    }
  }

  Future<void> SaveWomenInformation() async
  {
    try {
      await SaveBaselineInformation();
      await SaveConsentInformation();
      await SavePregnancyInformation();

      CalculateWomenPrescreening();
      schedulePrescreeningNotifications();
    }
    catch (exception) {

    }
  }

  void CalculateWomenPrescreening() {
    bool isEligibleForScreening = false;

    try {
      Duration gestationAgeDuration = GestationCalculations
          .GestationalAgeCalculation(lMPDate.text);

      if (gestationAgeDuration != null) {
        isEligibleForScreening =
            GestationCalculations.IsEligibleForPreScreening(
                gestationAgeDuration);

        if (isEligibleForScreening) {
          List<
              PrescreeningVisits> prescreeningVisitsList = GestationCalculations
              .CalculatePrescreeningVisits(gestationAgeDuration, idVR.text);
          SavePrescreeningVisits(prescreeningVisitsList);
        }
      }
    }
    catch (exception) {
      print((exception));
    }
  }

  SavePrescreeningVisits(
      List<PrescreeningVisits> a_lstPrescreeningVisitsList) async
  {
    try {
      Database db = await DBProvider().initDb();

      // row to insert
      for (var prescreeningModel in a_lstPrescreeningVisitsList) {
        Map<String, dynamic> row =
        {
          "VRID": prescreeningModel.VRID,
          "TypeOfVisit": prescreeningModel.TypeOfVisit,
          "VisitDate": prescreeningModel.VisitDate.toString(),
          "VisitDone": false
        };

        await db.insert("WomenPrescreeningVisitInformation", row);
        print(await db.query("WomenPrescreeningVisitInformation"));
      }
    }
    catch (exception) {
      print(exception);
    }
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
    }
  }

  Future<void> schedulePrescreeningNotifications() async {
    final List<Map<String, Object?>> queryResult = await DBProvider()
        .getPrescreeningDataForToday();
    List<PrescreeningVisits> listPrescreening = [];
    String title = 'Appointment Reminder';
    String body = 'There is an appointment today for VRID:';
    int i = 1;

    for (var map in queryResult)
    {
      listPrescreening.add(PrescreeningVisits.fromMap(map));
      print(map);
    }

    for (var visitModel in listPrescreening)
    {
       await NotificationService().showNotification(
        id: i,
        title: title,
        body: body+ visitModel.VRID+" for Visit "+visitModel.TypeOfVisit,
      );
       await Future.delayed(Duration(seconds: 10));
       i++;
    }
  }

}
