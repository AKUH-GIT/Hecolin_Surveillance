import 'package:sqflite/sqflite.dart';
import '../DBOperations/DBProvider.dart';
import '../Model/PreScreeningVisits.dart';
import '../Model/WomenInformation.dart';
import '../Service/NotificationService.dart';

class BaselineInformationController {
  final List<WomenInformation> womenInformation = [];

  // BaselineInformationController()
  // {
  //   schedulePrescreeningNotifications();
  // }

  Future<List<Map<String, dynamic>>> GetWomenInformation() async {
    final Database db = await DBProvider().initDb();

    final List<Map<String, dynamic>> baselineInformation =
        await db.query('WomenBaselineInformation');

    await db.close();
    return baselineInformation;
  }

  Future<bool?> CheckForExistingVRID(String s_VRID) async {
    try {
      final Database db = await DBProvider().initDb();

      // final List<Map<String, dynamic>> prescreeningMap = await db.query('WomenPrescreeningVisitInformation');
      // Fetch data from the table based on the WHERE clause with multiple parameters
      // final List<Map<String, dynamic>> prescreeningMap = await db.query(
      //   'WomenPrescreeningVisitInformation',
      //   where: 'VRID = ? AND MedidataScreeningID = ?', // WHERE clause with multiple parameters
      //   whereArgs: [s_VRID, s_medidataScreeningID], // Provide values for the parameter placeholders
      // );
      final List<Map<String, dynamic>> baselineMap = await db.query(
        'WomenBaselineInformation',
        where: 'VRID = ? ', // WHERE clause with multiple parameters
        whereArgs: [s_VRID], // Provide values for the parameter placeholders
      );

      if (baselineMap.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (exception) {
      return null;
    }
  }
}
