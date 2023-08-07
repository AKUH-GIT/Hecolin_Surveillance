import 'package:sqflite/sqflite.dart';

import '../DBOperations/DBProvider.dart';

class HEVInformationController {
  Future<List<Map<String, dynamic>>> GetHEVInformation(
      Duration a_durGestationalAge) async {
    final Database db = await DBProvider().initDb();
    int noOfGesAgeDay = 0;

    if (a_durGestationalAge != null) {
      noOfGesAgeDay = a_durGestationalAge.inDays;
    }

    //   final List<Map<String, dynamic>> hevInformation =
    //       await db.query('HEVInformation');
    //
    //   final List<Map<String, dynamic>> queryResult = await db.rawQuery('''
    //   SELECT *
    //   FROM HEVInformation
    //   WHERE ? BETWEEN column1 AND column3
    // ''', [noOfGesAgeDay]);

    List<Map<String, dynamic>> hevInformation = await db.query('HEVInformation'
        // /,
        // where: "? BETWEEN GestationalAgeLL AND GestationalAgeUL",
        // whereArgs: [noOfGesAgeDay],
        );
    await db.close();

    return hevInformation;
  }
}
