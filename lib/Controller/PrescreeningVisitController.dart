import 'dart:io';
import 'package:hecolin_surveillance/DBOperations/DBProvider.dart';
import 'package:hecolin_surveillance/Model/PreScreeningVisits.dart';
import 'package:hecolin_surveillance/config.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../Utils/Message.dart';

class PrescreeningVisitController {
  final List<PrescreeningVisits> prescreeningVisits = [];

  Future<List<PrescreeningVisits>> retrievePrescreeningSchedule(
      String condition) async {
    final Database db = await DBProvider().initDb();
    final List<Map<String, Object?>> queryResult =
        await db.query('WomenPrescreeningVisitInformation');
    return queryResult.map((e) => PrescreeningVisits.fromMap(e)).toList();
  }

  Future<List<PrescreeningVisits>> getPrescreeningVisitsOnDateVRId(
      String s_VRID, String s_medidataScreeningID, String s_DateValue) async {
    try {
      final Database db = await DBProvider().initDb();

      // final List<Map<String, dynamic>> prescreeningMap = await db.query('WomenPrescreeningVisitInformation');
      // Fetch data from the table based on the WHERE clause with multiple parameters
      // final List<Map<String, dynamic>> prescreeningMap = await db.query(
      //   'WomenPrescreeningVisitInformation',
      //   where: 'VRID = ? AND MedidataScreeningID = ?', // WHERE clause with multiple parameters
      //   whereArgs: [s_VRID, s_medidataScreeningID], // Provide values for the parameter placeholders
      // );
      final List<Map<String, dynamic>> prescreeningMap = await db.query(
        'WomenPrescreeningVisitInformation',
        where:
            "(VRID = ? OR ? = 'VR-') AND ((strftime('%Y-%m-%d', VisitDate) = ?) OR(? = ''))",
        // WHERE clause with multiple parameters
        whereArgs: [
          s_VRID,
          s_VRID,
          s_DateValue,
          s_DateValue
        ], // Provide values for the parameter placeholders
      );
      prescreeningVisits.clear();

      prescreeningMap.forEach((map) {
        final date = DateTime.parse(map['VisitDate'] as String);
        String formattedDate = AppConfig.dateForApp.format(date);
        final visit = PrescreeningVisits.fromMap(map);
        visit.VisitDateString = formattedDate;
        prescreeningVisits.add(visit);
      });
    } catch (exception) {}
    return prescreeningVisits;
  }
}
