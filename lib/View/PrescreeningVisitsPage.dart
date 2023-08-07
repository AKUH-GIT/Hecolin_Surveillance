import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hecolin_surveillance/DBOperations/DBProvider.dart';
import 'package:hecolin_surveillance/View/HecolinTrialPreScreeningPage.dart';

import '../Widgets/RoundButton.dart';

class PrescreeningVisit extends StatefulWidget {
  const PrescreeningVisit({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _PrescreeningVisitState createState() => _PrescreeningVisitState();
}

class _PrescreeningVisitState extends State<PrescreeningVisit> {
  List<Map<String, dynamic>> prescreeningVisitData = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    final db = DBProvider().initDb();
    final prescreeningData = await db.getPrescreeningVisitsOnDateVRId();
    setState(() {
      prescreeningVisitData = prescreeningData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: prescreeningVisitData.length,
      itemBuilder: (context, index) {
        final row = prescreeningVisitData[index];
        return ListTile(
          title: Text(row['VRID']),
          subtitle: Text(row['TypeOfVisit']),
        );
      },
    );
  }
}
